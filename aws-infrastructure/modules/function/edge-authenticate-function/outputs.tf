output "cognito_jwt_edge_auth_function_qualified_arn" {
  description = "Specific published version ARN of jwt authenticate lambda edge"
  value       = aws_lambda_function.cognito-jwt-edge-auth-function.qualified_arn
}