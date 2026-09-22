output "driver_service_secret_arn" {
  description = "The ARN of driver service secret"
  value       = aws_secretsmanager_secret.driver-service-secret.arn
}

output "bff_client_secret_arn" {
  description = "The ARN of bff client secret"
  value       = aws_secretsmanager_secret.bff-secret.arn
}

output "bff_oauth2_secret_arn" {
  description = "The ARN of bff OAuth2 secret"
  value       = aws_secretsmanager_secret.bff-oauth2-credential.arn
}
