output "capstone_rds_proxy_endpoint" {
  description = "RDS Proxy endpoint for Spring Boot applications"
  value       = aws_db_proxy.capstone_rds_proxy.endpoint
}