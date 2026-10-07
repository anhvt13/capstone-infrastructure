resource "aws_lambda_function" "driver-blue-green-hook-function" {
  function_name    = "driver-blue-green-hook-function"
  description      = "Driver blue/green lifecycle deployment function hook"
  role             = aws_iam_role.driver-blue-green-hook-execution-role.arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  filename         = "${path.module}/driver-blue-green-hook-function.zip"
  source_code_hash = filebase64sha256("${path.module}/driver-blue-green-hook-function.zip")
  timeout          = 30
  vpc_config {
    subnet_ids         = var.capstone_private_subnet_ids
    security_group_ids = [var.capstone_driver_blue_green_hook_function_sg_id]
  }
  environment {
    variables = {
      DRIVER_BG_VALIDATOR_SECRET_ARN = var.driver_bg_validator_secret_arn
      DRIVER_PORT                    = "8082"
      DRIVER_HOSTNAME                = "driver-service"
      DRIVER_HEALTH_PATH             = "/actuator/health"
    }
  }
}

resource "aws_iam_role" "driver-blue-green-hook-ecs-assume-role" {
  name = "driver-blue-green-hook-ecs-assume-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "driver-blue-green-hook-ecs-assume-role-policy" {
  role = aws_iam_role.driver-blue-green-hook-ecs-assume-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = aws_lambda_function.driver-blue-green-hook-function.arn
      }
    ]
  })
}

resource "aws_iam_role" "driver-blue-green-hook-execution-role" {
  name = "driver-blue-green-hook-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "driver-blue-green-hook-execution-basic-policy" {
  role       = aws_iam_role.driver-blue-green-hook-execution-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "driver-blue-green-hook-execution-vpc-policy" {
  role       = aws_iam_role.driver-blue-green-hook-execution-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "driver-blue-green-hook-execution-ecs-policy" {
  role = aws_iam_role.driver-blue-green-hook-execution-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServiceRevisions",
          "ecs:ListTasks",
          "ecs:DescribeTasks"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "driver-blue-green-hook-execution-secret-role-policy" {
  role = aws_iam_role.driver-blue-green-hook-execution-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]

        // Least privilege on driver blue green validator secrets
        Resource = var.driver_bg_validator_secret_arn
      }
    ]
  })
}

