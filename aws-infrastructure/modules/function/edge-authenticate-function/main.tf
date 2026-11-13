resource "aws_lambda_function" "cognito-jwt-edge-auth-function" {
  provider         = aws.us_east_1
  function_name    = "cognito-jwt-edge-auth-function"
  description      = "Validate Amazon Cognito access tokens before CloudFront cache lookup"
  role             = var.cognito-jwt-edge-auth-execution-role_arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  filename         = "${path.module}/cognito-jwt-edge-auth-function.zip"
  source_code_hash = filebase64sha256("${path.module}/cognito-jwt-edge-auth-function.zip")
  memory_size      = 128
  timeout          = 5

  # Required for Lambda@Edge association.
  publish = true
}