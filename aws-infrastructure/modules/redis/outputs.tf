output "capstone_valkey_host" {
  description = "ElastiCache Serverless Valkey host"
  value       = aws_elasticache_serverless_cache.capstone-valkey-cache.endpoint[0].address
}

output "capstone_valkey_port" {
  description = "ElastiCache Serverless Valkey port"
  value       = aws_elasticache_serverless_cache.capstone-valkey-cache.endpoint[0].port
}