
output "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Aurora credentials"
  value       = aws_rds_cluster.capstone-cluster.master_user_secret[0].secret_arn
}

output "capstone_aurora_cluster_ep" {
  description = "Capstone aurora cluster endpoint"
  value       = aws_rds_cluster.capstone-cluster.endpoint
}

output "capstone_aurora_cluster_identifier" {
  description = "Capstone aurora cluster identifier"
  value       = aws_rds_cluster.capstone-cluster.cluster_identifier
}

output "dr_rds_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the DR Aurora credentials"
  value       = aws_rds_cluster.dr-capstone-cluster.master_user_secret[0].secret_arn
}


output "dr_capstone_aurora_cluster_ep" {
  description = "DR Capstone aurora cluster endpoint"
  value       = aws_rds_cluster.dr-capstone-cluster.endpoint
}

output "dr_capstone_aurora_cluster_identifier" {
  description = "DR Capstone aurora cluster identifier"
  value       = aws_rds_cluster.dr-capstone-cluster.cluster_identifier
}