output "capstone_bff_blue_tg_arn" {
  description = "ARN of capstone bff BLUE target group"
  value       = aws_lb_target_group.capstone-bff-blue-tg.arn
}

output "capstone_bff_green_tg_arn" {
  description = "ARN of capstone bff GREEN target group"
  value       = aws_lb_target_group.capstone-bff-green-tg.arn
}

output "capstone_alb_dns" {
  description = "Capstone application load balancer DNS"
  value       = aws_lb.capstone-alb.dns_name
}

output "alb_production_listener_rule_arn" {
  description = "ARN of production listener rule ALB"
  value       = aws_lb_listener_rule.alb_production_listener_rule.arn
}
