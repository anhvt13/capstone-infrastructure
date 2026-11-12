output "capstone_aurora_cluster_ep" {
  description = "Capstone aurora cluster endpoint"
  value       = aws_rds_cluster.capstone-cluster.endpoint
}

output "capstone_aurora_cluster_identifier" {
  description = "Capstone aurora cluster identifier"
  value       = aws_rds_cluster.capstone-cluster.cluster_identifier
}


output "dr_capstone_aurora_cluster_ep" {
  description = "DR Capstone aurora cluster endpoint"
  value       = aws_rds_cluster.dr-capstone-cluster.endpoint
}

output "dr_capstone_aurora_cluster_identifier" {
  description = "DR Capstone aurora cluster identifier"
  value       = aws_rds_cluster.dr-capstone-cluster.cluster_identifier
}

output "rds_proxy_role_arn" {
  description = "RDS Proxy IAM role"
  value       = aws_iam_role.rds-proxy-role.arn
}