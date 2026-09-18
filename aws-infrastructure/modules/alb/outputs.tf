output "capstone_bff_tg_arn" {
  description     = "ARN of capstone bff target group"
  value           = aws_lb_target_group.capstone-bff-tg.arn
}
