output "dr_capstone_aurora_cluster_identifier" {
  description = "DR Capstone aurora cluster identifier"
  value       = module.database[*].dr_capstone_aurora_cluster_identifier
}

output "rds_proxy_role_arn" {
  description = "RDS Proxy IAM role"
  value       = module.database[*].rds_proxy_role_arn
}
