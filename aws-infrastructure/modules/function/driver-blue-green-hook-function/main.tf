resource "aws_lambda_function" "driver-blue-green-hook-function" {
  function_name    = var.driver_blue_green_hook_function_name
  description      = "Driver blue/green lifecycle deployment function hook"
  role             = var.driver_blue_green_hook_execution_role_arn
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

resource "aws_iam_role_policy" "driver-blue-green-hook-ecs-assume-role-policy" {
  role = var.driver_blue_green_hook_ecs_assume_role_id
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

