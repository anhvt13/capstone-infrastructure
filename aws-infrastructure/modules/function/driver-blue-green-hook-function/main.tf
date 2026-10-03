
resource "aws_lambda_function" "driver-blue-green-hook-function" {
  function_name    = "driver-blue-green-hook-function"
  description      = "Driver blue/green lifecycle deployment function hook"
  role             = aws_iam_role.driver-blue-green-hook-execution-role.arn
  runtime          = "nodejs22.x"
  handler          = "index.handler"
  filename         = "${path.module}/driver-blue-green-hook-function.zip"
  source_code_hash = filebase64sha256("${path.module}/driver-blue-green-hook-function.zip")
  timeout          = 30
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

resource "aws_iam_role_policy_attachment" "driver-blue-green-hook-basic-execution-policy" {
  role       = aws_iam_role.driver-blue-green-hook-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


