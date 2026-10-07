import {
    ECSClient,
    DescribeServiceRevisionsCommand,
    ListTasksCommand,
    DescribeTasksCommand
} from "@aws-sdk/client-ecs";

import {
    SecretsManagerClient,
    GetSecretValueCommand
} from "@aws-sdk/client-secrets-manager";

import { X509Certificate } from "node:crypto";
import tls from "node:tls";
import net from "node:net";
import https from "node:https";

const ecs = new ECSClient({});
const secretsManager = new SecretsManagerClient({});

function parseServiceArn(serviceArn) {
    const match = serviceArn.match(/^arn:[^:]+:ecs:[^:]+:[^:]+:service\/([^/]+)\/(.+)$/);

    if (!match) {
        throw new Error(`Invalid ECS service ARN: ${serviceArn}`);
    }

    return {
        cluster: match[1],
        service: match[2]
    };
}

async function findGreenTasks(serviceArn, revisionArn) {
    const { cluster, service } = parseServiceArn(serviceArn);
    console.log("=== GREEN TASK DISCOVERY ===");
    console.log({
        cluster,
        service,
        revisionArn
    });


    const revisionResult = await ecs.send(
        new DescribeServiceRevisionsCommand({
            serviceRevisionArns: [revisionArn]
        })
    );
    const revision = revisionResult.serviceRevisions?.[0];

    if (!revision) {
        throw new Error(`Green revision not found: ${revisionArn}`);
    }

    const greenTaskDefinition = revision.taskDefinition;

    const listResult = await ecs.send(
        new ListTasksCommand({
            cluster,
            serviceName: service,
            desiredStatus: "RUNNING"
        })
    );

    if (!listResult.taskArns?.length) {
        throw new Error("No running tasks found");
    }

    const describeResult = await ecs.send(
        new DescribeTasksCommand({
            cluster,
            tasks: listResult.taskArns
        })
    );
    const greenTasks = describeResult.tasks?.filter(
        task => task.lastStatus === "RUNNING" &&
        task.taskDefinitionArn === greenTaskDefinition) ?? [];
        console.log("Found green tasks:", greenTasks.map(task => ({
            taskArn: task.taskArn,
            taskDefinitionArn: task.taskDefinitionArn,
            lastStatus: task.lastStatus,
            desiredStatus: task.desiredStatus
        })));

    if (greenTasks.length === 0) {
        throw new Error(`No running green tasks found for ${greenTaskDefinition}`);
    }

    return {
        cluster,
        service,
        greenTaskDefinition,
        tasks: greenTasks
    };
}

function getPrivateIp(task) {
    const eni = task.attachments?.find(
        attachment => attachment.type === "ElasticNetworkInterface"
    );
    const privateIp = eni?.details?.find(
        detail => detail.name === "privateIPv4Address"
    )?.value;

    if (!privateIp) {
        throw new Error(`Private IP not found for task ${task.taskArn}`);
    }

    console.log(`Green task privateIP : ${privateIp}`);
    return privateIp;
}

async function getTlsCredentials() {
    console.log("Start getting secret credentials");

    const result = await secretsManager.send(
        new GetSecretValueCommand({
            SecretId: process.env.DRIVER_BG_VALIDATOR_SECRET_ARN
        })
    );

    console.log("SECRET RECEIVED");

    if (!result.SecretString) {
        throw new Error("mTLS secret does not contain SecretString");
    }

    const secret = JSON.parse(result.SecretString);

    console.log("SECRET PARSED");

    const ca = Buffer.from(
        secret.driver_blue_green_hook_ca_cert_base64,
        "base64"
    ).toString("utf8");

    const certPem = Buffer.from(
        secret.driver_blue_green_hook_client_cert_base64,
        "base64"
    ).toString("utf8");

    const key = Buffer.from(
        secret.driver_blue_green_hook_client_key_base64,
        "base64"
    ).toString("utf8");

    console.log("CREDENTIALS DECODED");

    const cert = new X509Certificate(certPem);

    console.log("CLIENT CERTIFICATE");
    console.log({
        subject: cert.subject,
        issuer: cert.issuer,
        validFrom: cert.validFrom,
        validTo: cert.validTo,
        keyUsage: cert.keyUsage
    });

    return {
        ca,
        cert: certPem,
        key
    };
}

function checkTcp(privateIp) {
    return new Promise((resolve, reject) => {
        const port = Number(process.env.DRIVER_PORT || 8082);
        console.log(`TCP Connection validate: ${privateIp}:${port}`);

        const socket = net.createConnection({
            host: privateIp,
            port,
            timeout: 5_000
        });

        socket.once("connect", () => {
            console.log("TCP CONNECTION SUCCESS");
            socket.destroy();
            resolve();
        });

        socket.once("timeout", () => {
            console.error("TCP CONNECTION TIMEOUT");
            socket.destroy();
            reject(new Error("TCP connection timed out"));
        });

        socket.once("error", error => {
            console.error("TCP CONNECTION FAILED");
            console.error({
                code: error.code,
                message: error.message
            });

            reject(error);
        });
    });
}

function checkDriverTls(privateIp, tlsCredentials) {
    return new Promise((resolve, reject) => {
        const port = Number(process.env.DRIVER_PORT || 8082);
        const hostname = process.env.DRIVER_HOSTNAME || "driver-service";

        console.log("=== TLS TEST ===");
        console.log({
            destination: `${privateIp}:${port}`,
            servername: hostname
        });

        const socket = tls.connect({
            host: privateIp,
            port,
            servername: hostname,
            cert: tlsCredentials.cert,
            key: tlsCredentials.key,
            ca: tlsCredentials.ca,
            rejectUnauthorized: true,
            minVersion: "TLSv1.2",
            maxVersion: "TLSv1.3",
            timeout: 10_000
        });

        let settled = false;

        const succeed = () => {
            if (settled) return;
            settled = true;

            console.log("=== TLS HANDSHAKE SUCCESS ===");
            console.log({
                authorized: socket.authorized,
                authorizationError: socket.authorizationError,
                protocol: socket.getProtocol(),
                cipher: socket.getCipher(),
                servername: socket.servername
            });

            socket.destroy();
            resolve();
        };

        const fail = (error) => {
            if (settled) return;
            settled = true;

            console.error("=== TLS HANDSHAKE FAILED ===");
            console.error({
                code: error?.code,
                message: error?.message,
                syscall: error?.syscall,
                address: error?.address,
                port: error?.port
            });

            socket.destroy();
            reject(error);
        };

        socket.once("connect", () => {
            console.log("=== TLS TCP CONNECTION ESTABLISHED ===");
        });

        socket.once("secureConnect", () => {
            if (!socket.authorized) {
                fail(
                    new Error(
                        `TLS certificate not authorized: ${socket.authorizationError}`
                    )
                );
                return;
            }

            succeed();
        });

        socket.once("error", fail);

        socket.once("timeout", () => {
            fail(new Error("TLS handshake timed out"));
        });
    });
}

function checkDriverHealth(privateIp, tlsCredentials) {
    return new Promise((resolve, reject) => {

        const port = Number(process.env.DRIVER_PORT || 8082);
        const hostname = process.env.DRIVER_HOSTNAME || "driver-service";
        const healthPath = process.env.DRIVER_HEALTH_PATH || "/actuator/health";

        console.log("=== DRIVER HTTPS HEALTH TEST ===");
        console.log({
            destination: `${privateIp}:${port}`,
            hostname,
            path: healthPath
        });

        const request = https.request({
            // TCP destination
            host: privateIp,
            port,

            // TLS certificate hostname / SNI
            servername: hostname,

            // HTTP request
            method: "GET",
            path: healthPath,

            // mTLS
            cert: tlsCredentials.cert,
            key: tlsCredentials.key,
            ca: tlsCredentials.ca,

            rejectUnauthorized: true,

            timeout: 10_000,

            headers: {
                Host: hostname,
                Accept: "application/json"
            }
        }, response => {
            let body = "";

            console.log("=== HTTP RESPONSE ===");
            console.log({
                statusCode: response.statusCode,
                headers: response.headers
            });

            response.setEncoding("utf8");

            response.on("data", chunk => {
                body += chunk;
            });

            response.on("end", () => {
                console.log("=== DRIVER HEALTH BODY ===");
                console.log(body);

                if (response.statusCode !== 200) {
                    reject(
                        new Error(
                            `Driver returned HTTP ${response.statusCode}: ${body}`
                        )
                    );
                    return;
                }

                let health;

                try {
                    health = JSON.parse(body);
                } catch {
                    reject(
                        new Error(
                            `Driver returned invalid JSON: ${body}`
                        )
                    );
                    return;
                }

                if (health.status !== "UP") {
                    reject(
                        new Error(
                            `Driver health status is ${health.status}`
                        )
                    );
                    return;
                }

                console.log("=== DRIVER HEALTH CHECK PASSED ===");

                resolve({
                    statusCode: response.statusCode,
                    health
                });
            });
        });

        request.on("socket", socket => {
            console.log("=== HTTPS SOCKET ASSIGNED ===");

            socket.on("connect", () => {
                console.log("=== TCP CONNECTION ESTABLISHED ===");
            });

            socket.on("secureConnect", () => {
                console.log("=== TLS HANDSHAKE SUCCESS ===");

                console.log({
                    authorized: socket.authorized,
                    authorizationError: socket.authorizationError,
                    protocol: socket.getProtocol(),
                    cipher: socket.getCipher(),
                    servername: socket.servername
                });

                if (!socket.authorized) {
                    console.error(
                        "=== TLS CERTIFICATE NOT AUTHORIZED ===",
                        socket.authorizationError
                    );
                }
            });
        });

        request.on("error", error => {
            console.error("=== HTTPS REQUEST FAILED ===");

            console.error({
                code: error.code,
                message: error.message
            });

            reject(error);
        });

        request.on("timeout", () => {
            console.error("=== HTTPS REQUEST TIMEOUT ===");
            request.destroy();
            reject(
                new Error("HTTPS request timed out")
            );
        });

        request.end();
    });
}


export const handler = async (event) => {
    console.log("========================================");
    console.log("DRIVER BLUE/GREEN LIFECYCLE HOOK");
    console.log("========================================");
    console.log(
        "Lifecycle event:",
        JSON.stringify(event, null, 2)
    );

    const serviceArn = event.executionDetails?.serviceArn;
    const revisionArn = event.executionDetails?.targetServiceRevisionArn;

    if (!serviceArn) {
        throw new Error("Missing executionDetails.serviceArn");
    }

    if (!revisionArn) {
        throw new Error("Missing executionDetails.targetServiceRevisionArn");
    }

    console.log(
        "Target service revision:",
        revisionArn
    );

    try {
        const green = await findGreenTasks(serviceArn, revisionArn);
        const tlsCredentials = await getTlsCredentials();

        for (const task of green.tasks) {
            const privateIp = getPrivateIp(task);
            console.log(`Validating green task ${task.taskArn} at ${privateIp}:8082`);

            // --------------------------------------------------
            // 1. Validate raw TCP connectivity
            // --------------------------------------------------
            await checkTcp(privateIp);

            // --------------------------------------------------
            // 2. Validate TLS + mTLS handshake
            // --------------------------------------------------
            await checkDriverTls(privateIp, tlsCredentials);

            // --------------------------------------------------
            // 3. Validate Driver health check
            // --------------------------------------------------
            await checkDriverHealth(privateIp, tlsCredentials);

            console.log("========================================");
            console.log("DRIVER green task health check PASSED");
            console.log("TCP connectivity: SUCCESS");
            console.log("TLS handshake: SUCCESS");
            console.log("mTLS client authentication: SUCCESS");
            console.log("========================================");
        }

        return {
            hookStatus: "SUCCEEDED"
        };

    } catch (error) {
        console.error("========================================");
        console.error("DRIVER BLUE/GREEN HOOK VALIDATION FAILED");
        console.error("========================================");
        console.error({
            name: error?.name,
            code: error?.code,
            message: error?.message
        });
        return {
            hookStatus: "FAILED"
        };
    }
};