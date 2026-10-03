output "capstone_bff_tg_arn" {
  description = "ARN of capstone bff target group"
  value       = aws_lb_target_group.capstone-bff-tg.arn
}

output "capstone_alb_dns" {
  description = "Capstone application load balancer dns"
  value       = aws_lb.capstone-alb.dns_name
}
