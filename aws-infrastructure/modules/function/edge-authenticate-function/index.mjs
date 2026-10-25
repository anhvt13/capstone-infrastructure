const { CognitoJwtVerifier } = require("aws-jwt-verify");

// Configure the verifier outside the handler so the JWKS is cached across warm invocations
const verifier = CognitoJwtVerifier.create({
    userPoolId: "ap-southeast-1_hLZj5IXWc",
    tokenUse: "access",
    clientId: "5rem71h307toj04fc39tjn1r52",
});

exports.handler = async (event) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  // 1. Check for Authorization header
  if (!headers.authorization || headers.authorization.length === 0) {
    return getUnauthorizedResponse("Missing Authorization Header");
  }

  try {
    // 2. Extract the raw token from "Bearer <token>"
    const authHeader = headers.authorization[0].value;
    if (!authHeader.startsWith("Bearer ")) {
      return getUnauthorizedResponse("Invalid Authorization Format");
    }
    const token = authHeader.substring(7);

    // 3. Verify the token using the AWS library
    const payload = await verifier.verify(token);
    console.log("Token is valid. User:", payload.username);

    return request;

  } catch (err) {
    console.error("Token validation failed:", err.message);
    return getUnauthorizedResponse("Invalid or Expired Token");
  }
};

// Helper function to return a structured 401 response directly from the Edge
function getUnauthorizedResponse(message) {
  return {
    status: "401",
    statusDescription: "Unauthorized",
    headers: {
      "content-type": [{ key: "Content-Type", value: "application/json" }],
      "cache-control": [{key: "Cache-Control", value: "no-store" }]
    },
    body: JSON.stringify({ error: message }),
  };
}
