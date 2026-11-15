output "ecs_invoke_alb_infras_role_arn" {
  description = "ECS assume role on ALB infrastructure"
  value       = aws_iam_role.ecs-invoke-alb-infras-role.arn
}

output "bastion_host_ssm_role_arn" {
  description = "ARN of bastion role"
  value       = aws_iam_role.capstone-bastion-ssm-role.arn
}

output "bastion_host_ssm_role_name" {
  description = "Name of bastion role"
  value       = aws_iam_role.capstone-bastion-ssm-role.name
}

output "bastion_instance_profile_name" {
  description = "Bastion instance profile name"
  value       = aws_iam_instance_profile.bastion.name
}

output "driver_blue_green_hook_ecs_assume_role_id" {
  description = "ID of ecs assume role on driver blue green hook function"
  value       = aws_iam_role.driver-blue-green-hook-ecs-assume-role.id
}

output "driver_blue_green_hook_execution_role_arn" {
  description = "ARN of driver blue green hook execution role"
  value       = aws_iam_role.driver-blue-green-hook-execution-role.arn
}

output "driver_blue_green_hook_ecs_assume_role_arn" {
  description = "ARN of the Driver blue green hook ecs assume role"
  value       = aws_iam_role.driver-blue-green-hook-ecs-assume-role.arn
}

output "cognito_jwt_edge_auth_execution_role_arn" {
  description = "ARN of jwt authenticate lambda@edge execution role"
  value       = aws_iam_role.cognito-jwt-edge-auth-execution-role.arn
}

output "capstone_ecs_task_execution_role_arn" {
  description = "ECS task execution role's ARN"
  value       = aws_iam_role.capstone-ecs-task-execution-role.arn
}

output "capstone_ecs_task_role_arn" {
  description = "ECS task role's ARN"
  value       = aws_iam_role.capstone-ecs-task-role.arn
}