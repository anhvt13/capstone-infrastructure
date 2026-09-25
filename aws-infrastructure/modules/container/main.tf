#====================
# ECS cluster
#====================
resource "aws_ecs_cluster" "capstone-ecs-cluster" {
  name = "capstone-ecs-cluster"
  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.capstone-service-connect-namespace.arn
  }
  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  tags = merge(
    {
      Name = "capstone-ecs-cluster"
    },
    var.container_tags
  )
}

#========================
# ECS Task Execution Role
#========================
resource "aws_iam_role" "capstone-ecs-task-execution-role" {
  name = "capstone-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "capstone-ecs-task-execution-role-attach-policy" {
  role       = aws_iam_role.capstone-ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs-iam-access-policy-doc" {
  statement {
    sid    = "ListObjectsInBucket"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.driver_service_secret_arn,
      var.rds_secret_arn,
      var.bff_secret_arn,
      var.bff_oauth2_secret_arn
    ]
  }
}

resource "aws_iam_policy" "capstone-ecs-execution-role-secret-access-policy" {
  name        = "capstone-ecs-execution-role-secret-access-policy"
  description = "ECS secret access policy"
  policy      = data.aws_iam_policy_document.ecs-iam-access-policy-doc.json
}

resource "aws_iam_role_policy_attachment" "capstone-ecs-execution-role-secret-access" {
  role       = aws_iam_role.capstone-ecs-task-execution-role.name
  policy_arn = aws_iam_policy.capstone-ecs-execution-role-secret-access-policy.arn
}

#====================
# ECS task role
#====================
resource "aws_iam_role" "capstone-ecs-task-role" {
  name = "capstone-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#===================================================
# ECS task role assign SSM Messages permissions
#===================================================
data "aws_iam_policy_document" "ecs-ssm-message-exec-policy-doc" {
  statement {
    sid    = "ExecSSMMessage"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "capstone-ecs-execution-role-ssm-message-exec-policy" {
  name        = "capstone-ecs-execution-role-ssm-message-exec-policy"
  description = "ECS execute ssm message policy"
  policy      = data.aws_iam_policy_document.ecs-ssm-message-exec-policy-doc.json
}

resource "aws_iam_role_policy_attachment" "capstone-ecs-execution-ssm-message-role" {
  role       = aws_iam_role.capstone-ecs-task-role.name
  policy_arn = aws_iam_policy.capstone-ecs-execution-role-ssm-message-exec-policy.arn
}

#==========================================
# Driver-service task definition
#==========================================
resource "aws_ecs_task_definition" "capstone-driver-service-fargate-td" {
  family                   = "driver-service-fargate-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"  # 0.5 vCPU
  memory                   = "1024" # 1 GiB
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  execution_role_arn = aws_iam_role.capstone-ecs-task-execution-role.arn
  task_role_arn      = aws_iam_role.capstone-ecs-task-role.arn
  container_definitions = jsonencode([
    {
      name      = "driver-service"
      image     = var.driver_service_ecr_uri
      essential = true
      portMappings = [
        {
          containerPort = 8082
          hostPort      = 8082
          protocol      = "tcp"
          name          = "driver-service"
        }
      ]
      environment = [
        {
          name  = "DB_URL"
          value = "jdbc:postgresql://${var.capstone_aurora_cluster_ep}:${var.database_port}/${var.database_name}?sslmode=require"
        },
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "ecs"
        },
        {
          name  = "JAVA_TOOL_OPTIONS"
          value = "-Djava.net.preferIPv4Stack=true"
        }
      ]
      secrets = [
        {
          name      = "DRIVER_KEYSTORE_BASE64"
          valueFrom = "${var.driver_service_secret_arn}:driver_keystore_base64::"
        },
        {
          name      = "DRIVER_SERVER_KEYSTORE_PASSWORD"
          valueFrom = "${var.driver_service_secret_arn}:driver_keystore_password::"
        },
        {
          name      = "DRIVER_TRUSTSTORE_BASE64"
          valueFrom = "${var.driver_service_secret_arn}:driver_truststore_base64::"
        },
        {
          name      = "DRIVER_TRUSTSTORE_PASSWORD"
          valueFrom = "${var.driver_service_secret_arn}:driver_truststore_password::"
        },
        {
          name      = "DB_USERNAME"
          valueFrom = "${var.rds_secret_arn}:username::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.rds_secret_arn}:password::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.ecs_capstone_app_log_group
          "awslogs-region"        = var.primary_aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

#====================
# Driver ECS service
#====================
resource "aws_ecs_service" "ecs-capstone-driver-service" {
  name            = "driver-service"
  cluster         = aws_ecs_cluster.capstone-ecs-cluster.id
  task_definition = aws_ecs_task_definition.capstone-driver-service-fargate-td.arn
  desired_count   = var.ecs_desired_task
  launch_type     = "FARGATE"
  network_configuration {
    subnets = var.capstone_private_subnet_ids
    security_groups = [
      var.capstone_private_sg_id
    ]
    assign_public_ip = false
  }

  # Service Connect provider enabled + service definition to be discoverable from other consumer services
  service_connect_configuration {
    enabled = true
    service {
      port_name      = "driver-service"
      discovery_name = "driver-service"
      client_alias {
        dns_name = "driver-service"
        port     = 8082
      }
    }
  }
  enable_execute_command = true

  // Give the ECS service a startup grace period. ALB health failures don't force ECS to replace task
  health_check_grace_period_seconds = 60
}

#===============================
# BFF-client task definition
#===============================
resource "aws_ecs_task_definition" "capstone-bff-client-fargate-td" {
  family                   = "bff-client-fargate-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"  # 0.5 vCPU
  memory                   = "1024" # 1 GiB
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  execution_role_arn = aws_iam_role.capstone-ecs-task-execution-role.arn
  task_role_arn      = aws_iam_role.capstone-ecs-task-role.arn
  container_definitions = jsonencode([
    {
      name      = "bff-client"
      image     = var.bff_client_ecr_uri
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "ecs"
        },
        {
          name  = "JAVA_TOOL_OPTIONS"
          value = "-Djava.net.preferIPv4Stack=true"
        }
      ]
      secrets = [
        {
          name      = "BFF_CLIENT_KEYSTORE_BASE64"
          valueFrom = "${var.bff_secret_arn}:bff_client_keystore_base64::"
        },
        {
          name      = "BFF_SERVER_KEYSTORE_BASE64"
          valueFrom = "${var.bff_secret_arn}:bff_server_keystore_base64::"
        },
        {
          name      = "BFF_CLIENT_KEYSTORE_PASSWORD"
          valueFrom = "${var.bff_secret_arn}:bff_client_keystore_password::"
        },
        {
          name      = "BFF_SERVER_KEYSTORE_PASSWORD"
          valueFrom = "${var.bff_secret_arn}:bff_server_keystore_password::"
        },
        {
          name      = "BFF_TRUSTSTORE_BASE64"
          valueFrom = "${var.bff_secret_arn}:bff_truststore_base64::"
        },
        {
          name      = "BFF_TRUSTSTORE_PASSWORD"
          valueFrom = "${var.bff_secret_arn}:bff_truststore_password::"
        },
        {
          name      = "DRIVER_M2M_CLIENT_ID"
          valueFrom = "${var.bff_oauth2_secret_arn}:driver_m2m_client_id::"
        },
        {
          name      = "DRIVER_M2M_CLIENT_SECRET"
          valueFrom = "${var.bff_oauth2_secret_arn}:driver_m2m_client_secret::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.ecs_capstone_app_log_group
          "awslogs-region"        = var.primary_aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

#==========================
# BFF-client ECS service
#==========================
resource "aws_ecs_service" "ecs-capstone-bff-client" {
  name            = "bff-client"
  cluster         = aws_ecs_cluster.capstone-ecs-cluster.id
  task_definition = aws_ecs_task_definition.capstone-bff-client-fargate-td.arn
  desired_count   = var.ecs_desired_task
  launch_type     = "FARGATE"
  network_configuration {
    subnets = var.capstone_private_subnet_ids
    security_groups = [
      var.capstone_private_sg_id
    ]
    assign_public_ip = false
  }

  // Service Connect consumer enabled, does NOT have to be discovered by other Service Connect clients
  service_connect_configuration {
    enabled = true
  }

  // Registered this container with defined target group
  load_balancer {
    target_group_arn = var.capstone_bff_tg_arn
    container_name   = "bff-client"
    container_port   = 8080
  }
  enable_execute_command = true

  // Give the ECS service a startup grace period. ALB health failures don't force ECS to replace task
  health_check_grace_period_seconds = 60

}

#===============================
# ECS service connect namespace
#===============================
resource "aws_service_discovery_private_dns_namespace" "capstone-service-connect-namespace" {
  description = "Service Connect namespace for capstone's services"
  name        = "capstone.local"
  vpc         = var.capstone_vpc_id
}



