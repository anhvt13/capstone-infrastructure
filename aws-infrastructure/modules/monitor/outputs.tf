output "ecs_capstone_app_log_group" {
  description = "ecs capstone app log group"
  value       = aws_cloudwatch_log_group.ecs-capstone-app.name
}
