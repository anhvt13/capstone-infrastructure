output "capstone_bff_blue_tg_arn" {
  description = "ARN of capstone bff BLUE target group"
  value       = aws_lb_target_group.capstone-bff-blue-tg.arn
}

output "capstone_bff_green_tg_arn" {
  description = "ARN of capstone bff GREEN target group"
  value       = aws_lb_target_group.capstone-bff-green-tg.arn
}

output "capstone_alb_dns" {
  description = "Capstone application load balancer dns"
  value       = aws_lb.capstone-alb.dns_name
}

output "ecs_invoke_alb_infras_role_arn" {
  description = "ECS assume role on ALB infrastructure"
  value       = aws_iam_role.ecs-invoke-alb-infras-role.arn
}

output "alb_production_listener_rule_arn" {
  description = "ARN of production listener rule ALB"
  value       = aws_lb_listener_rule.alb_production_listener_rule.arn
}
