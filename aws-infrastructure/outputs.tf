output "dr_capstone_aurora_cluster_identifier" {
  description = "DR Capstone aurora cluster identifier"
  value       = module.database[*].dr_capstone_aurora_cluster_identifier
}

output "rds_proxy_role_arn" {
  description = "RDS Proxy IAM role"
  value       = module.database[*].rds_proxy_role_arn
}

output "ecs_invoke_alb_infras_role_arn" {
  description = "ECS assume role on ALB infrastructure"
  value       = module.iam[*].ecs_invoke_alb_infras_role_arn
}

output "bastion_host_ssm_role_arn" {
  description = "ARN of bastion role"
  value       = module.iam[*].bastion_host_ssm_role_arn
}

output "bastion_host_ssm_role_name" {
  description = "Name of bastion role"
  value       = module.iam[*].bastion_host_ssm_role_name
}

output "bastion_instance_profile_name" {
  description = "Bastion instance profile name"
  value       = module.iam[*].bastion_instance_profile_name
}

output "driver_blue_green_hook_ecs_assume_role_id" {
  description = "ID of ecs assume role on driver blue green hook function"
  value       = module.iam[*].driver_blue_green_hook_ecs_assume_role_id
}

output "driver_blue_green_hook_execution_role_arn" {
  description = "ARN of driver blue green hook execution role"
  value       = module.iam[*].driver_blue_green_hook_execution_role_arn
}

output "driver_blue_green_hook_ecs_assume_role_arn" {
  description = "ARN of the Driver blue green hook ecs assume role"
  value       = module.iam[*].driver_blue_green_hook_ecs_assume_role_arn
}

output "cognito-jwt-edge-auth-execution-role_arn" {
  description = "ARN of jwt authenticate lambda@edge execution role"
  value       = module.iam[*].cognito-jwt-edge-auth-execution-role_arn
}
