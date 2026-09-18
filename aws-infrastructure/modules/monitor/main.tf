resource "aws_cloudwatch_log_group" "ecs-capstone-app" {
  name              = "/ecs/capstone-app"
  retention_in_days = 1
}
