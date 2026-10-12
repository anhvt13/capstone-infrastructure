# =============================================
# Target group - including blue/green group
# =============================================
resource "aws_lb_target_group" "capstone-bff-blue-tg" {
  name        = "capstone-bff-blue-tg"
  port        = 8080
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.capstone_vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTPS"
    path                = "/actuator/health" # Health check landing endpoint on BFF-client
    port                = "traffic-port"     # Inherits port 8080 from target group configure
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
  }

  tags = merge(
    {
      Name = "capstone-bff-blue-tg"
    },
    var.alb_tags
  )
}

resource "aws_lb_target_group" "capstone-bff-green-tg" {
  name        = "capstone-bff-green-tg"
  port        = 8080
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.capstone_vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTPS"
    path                = "/actuator/health" # Health check landing endpoint on BFF-client
    port                = "traffic-port"     # Inherits port 8080 from target group configure
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
  }

  tags = merge(
    {
      Name = "capstone-bff-green-tg"
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

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.capstone-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

// Explicit rule that forwards production traffic to the blue target group
resource "aws_lb_listener_rule" "alb_production_listener_rule" {
  listener_arn = aws_lb_listener.alb_http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone-bff-blue-tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# ===========================================
# ECS assume role on ALB management
# ===========================================

resource "aws_iam_role" "ecs-invoke-alb-infras-role" {
  name = "ecs-invoke-alb-infras-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-invoke-aln-infras-role-policy" {
  role       = aws_iam_role.ecs-invoke-alb-infras-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSInfrastructureRolePolicyForLoadBalancers"
}