
output "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Aurora master credentials"
  value       = aws_rds_cluster.capstone-aurora-cluster.master_user_secret[0].secret_arn
}

output "capstone_aurora_cluster_ep" {
  description = "Capstone aurora cluster endpoint"
  value       = aws_rds_cluster.capstone-aurora-cluster.endpoint
}

output "capstone_aurora_cluster_identifier" {
  description = "Capstone aurora cluster identifier"
  value       = aws_rds_cluster.capstone-aurora-cluster.cluster_identifier
}
