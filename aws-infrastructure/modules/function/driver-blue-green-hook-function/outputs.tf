output "driver_blue_green_hook_function_arn" {
  description = "The ARN of the Driver blue green hook lambda function"
  value       = aws_lambda_function.driver-blue-green-hook-function.arn
}

output "driver_blue_green_hook_ecs_assume_role_arn" {
  description = "The ARN of the Driver blue green hook ecs assume role"
  value       = aws_iam_role.driver-blue-green-hook-ecs-assume-role.arn
}

