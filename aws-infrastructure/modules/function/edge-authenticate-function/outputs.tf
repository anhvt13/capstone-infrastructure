output "cognito_jwt_edge_auth_function_arn" {
  description = "The ARN of lambda function use to validate jwt access token at cloudfront edge location"
  value       = aws_lambda_function.cognito-jwt-edge-auth-function.arn
}