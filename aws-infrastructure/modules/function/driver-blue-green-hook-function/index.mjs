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

import https from "node:https";

const ecs = new ECSClient({});
const secretsManager = new SecretsManagerClient({});

async function getTlsCredentials() {
    const result = await secretsManager.send(
        new GetSecretValueCommand({
            SecretId: process.env.DRIVER_BG_VALIDATOR_SECRET_ARN
        })
    );

    if (!result.SecretString) {
        throw new Error("mTLS secret does not contain SecretString");
    }

    const secret = JSON.parse(result.SecretString);

    return {
        ca: Buffer.from(secret.driver_blue_green_hook_ca_cert_base64, "base64").toString("utf8"),
        cert: Buffer.from(secret.driver_blue_green_hook_client_cert_base64, "base64").toString("utf8"),
        key: Buffer.from(secret.driver_blue_green_hook_client_key_base64, "base64").toString("utf8")
    };
}

async function findGreenTasks(serviceArn, revisionArn) {
    const { cluster, service } = parseServiceArn(serviceArn);
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

function getPrivateIp(task) {
    const eni = task.attachments?.find(attachment => attachment.type === "ElasticNetworkInterface");
    const privateIp = eni?.details?.find(detail => detail.name === "privateIPv4Address")?.value;

    if (!privateIp) {
        throw new Error(`Private IP not found for task ${task.taskArn}`);
    }

    return privateIp;
}

function checkDriverHealth(privateIp, tls) {
    return new Promise((resolve, reject) => {
        const request = https.request({
            host: privateIp,
            port: Number(process.env.DRIVER_PORT || 8082),
            path: process.env.DRIVER_HEALTH_PATH || "/actuator/health",
            method: "GET",

            // TLS server identity
            servername: process.env.DRIVER_HOSTNAME || "driver-service",

            // mTLS
            cert: tls.cert,
            key: tls.key,
            ca: tls.ca,
            rejectUnauthorized: true,
            timeout: 10_000
        }, response => {
            let body = "";
            response.setEncoding("utf8");
            response.on("data", chunk => {
                body += chunk;
            });

            response.on("end", () => {
                resolve({
                    statusCode: response.statusCode,
                    body
                });
            });
        });

        request.on("timeout", () => {
            request.destroy(
                new Error("Driver health request timed out")
            );
        });
        request.on("error", reject);
        request.end();
    });
}

function validateHealthResponse(result) {
    if (result.statusCode !== 200) {
        throw new Error(
            `Driver returned HTTP ${result.statusCode}: ${result.body}`
        );
    }

    let health;

    try {
        health = JSON.parse(result.body);
    } catch {
        throw new Error(`Driver returned invalid health response: ${result.body}`);
    }

    if (health.status !== "UP") {
        throw new Error(`Driver health status is ${health.status}`);
    }
}

export const handler = async (event) => {
    console.log(
        "Lifecycle event:",
        JSON.stringify(event, null, 2)
    );

    try {
        const serviceArn = event.executionDetails?.serviceArn;
        const revisionArn = event.executionDetails?.targetServiceRevisionArn;

        if (!serviceArn || !revisionArn) {
            throw new Error("Missing serviceArn or targetServiceRevisionArn");
        }

        console.log(
            "Target revision:",
            revisionArn
        );

        const green = await findGreenTasks(serviceArn, revisionArn);
        console.log(
            "Green task count:",
            green.tasks.length
        );

        const tls = await getTlsCredentials();

        for (const task of green.tasks) {
            const privateIp = getPrivateIp(task);
            console.log(`Validating green task ${task.taskArn} at ${privateIp}:8082`);

            const result = await checkDriverHealth(privateIp, tls);
            console.log(`Driver response: HTTP ${result.statusCode}`);

            validateHealthResponse(result);
        }

        console.log("All green Driver tasks passed validation");

        return {
            hookStatus: "SUCCEEDED"
        };

    } catch (error) {
        console.error(
            "Green Driver validation failed:",
            error
        );

        return {
            hookStatus: "FAILED"
        };
    }
};
