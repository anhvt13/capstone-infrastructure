provider "aws" {
  # Set the AWS region to US East (N. Virginia)
  region = "us-east-1"
}

resource "aws_iam_role" "cognito-jwt-edge-auth-execution-role" {
  provider = aws.us_east_1
  name     = "cognito-jwt-edge-auth-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cognito-jwt-edge-auth-role-policy" {
  provider   = aws.us_east_1
  role       = aws_iam_role.cognito-jwt-edge-auth-execution-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "cognito-jwt-edge-auth-function" {
  provider         = aws.us_east_1
  function_name    = "cognito-jwt-edge-auth-function"
  description      = "Validate Amazon Cognito access tokens before CloudFront cache lookup"
  role             = aws_iam_role.cognito-jwt-edge-auth-execution-role.arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  filename         = "${path.module}/cognito-jwt-edge-auth-function.zip"
  source_code_hash = filebase64sha256("${path.module}/cognito-jwt-edge-auth-function.zip")
  memory_size      = 128
  timeout          = 5
  environment {
    variables = {
      USER_POOL_ID = "ap-southeast-1_hLZj5IXWc"
      TOKEN_USE    = "access"
      CLIENT_ID    = "5rem71h307toj04fc39tjn1r52"
    }
  }

  # Required for Lambda@Edge association.
  publish = true
}