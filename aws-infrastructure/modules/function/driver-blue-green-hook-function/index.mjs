
export const handler = async (event) => {
    console.log("ECS lifecycle hook event:", JSON.stringify(event, null, 2));
    const hookDetails = event.hookDetails ?? {};
    const healthUrl = hookDetails.health_url;
    const healthPath = hookDetails.health_path;

    if (!healthUrl) {
        console.error("Missing health Url");

        return {
            hookStatus: "FAILED",
            hookDetails: {
                reason: "Missing health Url"
            }
        };
    }

    if (!healthPath) {
        console.error("Missing health Path");

        return {
            hookStatus: "FAILED",
            hookDetails: {
                reason: "Missing health Path"
            }
        };
    }

    const url = `${healthUrl}${healthPath}`;
    console.log(`Running smoke test against ${url}`);

    try {
        const response = await fetch(url, {
            method: "GET"
        });

        const responseText = await response.text();
        console.log("Smoke test response:", {
            status: response.status,
            body: responseText
        });

        if (!response.ok) {
            return {
                hookStatus: "FAILED",
                hookDetails: {
                    reason: "Health endpoint returned non-success status",
                    statusCode: response.status
                }
            };
        }

        let body;

        try {
            body = JSON.parse(responseText);
        } catch {
            return {
                hookStatus: "FAILED",
                hookDetails: {
                    reason: "Health endpoint returned invalid JSON"
                }
            };
        }

        if (body.status !== "UP") {
            return {
                hookStatus: "FAILED",
                hookDetails: {
                    reason: "Driver health status is not UP",
                    status: body.status
                }
            };
        }

        console.log("Smoke test PASSED");

        return {
            hookStatus: "SUCCEEDED",
            hookDetails: {
                smokeTest: "PASSED",
                statusCode: response.status
            }
        };

    } catch (error) {
        console.error("Smoke test failed:", error);

        return {
            hookStatus: "FAILED",
            hookDetails: {
                reason: "Unable to reach health endpoint",
                error: error.message
            }
        };
    }
};