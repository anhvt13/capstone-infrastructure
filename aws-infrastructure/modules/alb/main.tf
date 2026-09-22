# ===============================
# Target group
# ===============================
resource "aws_lb_target_group" "capstone-bff-tg" {
  name        = "capstone-bff-tg"
  port        = 8080
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.capstone_vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTPS"
    path                = "/home"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
  }

  tags = merge(
    {
      Name = "capstone-bff-tg"
    },
    var.alb_tags
  )
}

# ===============================
# Application Load Balancer
# ===============================
resource "aws_lb" "capstone-alb" {
  name               = "capstone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.capstone_alb_security_group_id
  ]
  subnets = var.capstone_public_subnet_ids

  tags = merge(
    {
      Name = "capstone-alb"
    },
    var.alb_tags
  )
}

resource "aws_lb_listener" "bff_http" {
  load_balancer_arn = aws_lb.capstone-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone-bff-tg.arn
  }
}