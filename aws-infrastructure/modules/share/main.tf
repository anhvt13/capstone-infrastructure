# ===============================
# Database schema bucket
# ================================
resource "aws_s3_bucket" "capstone-db-schema-bucket" {
  bucket           = var.capstone_db_schema_bucket_name
  bucket_namespace = "account-regional"

  tags = merge(
    {
      Name = var.capstone_db_schema_bucket_name
    },
    var.storage_tags
  )
}

# ===============================
# BLocked public access
# ================================
resource "aws_s3_bucket_public_access_block" "capstone_storage" {
  bucket                  = aws_s3_bucket.capstone-db-schema-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ===============================
# Enable versioning
# ================================
resource "aws_s3_bucket_versioning" "capstone_storage" {
  bucket = aws_s3_bucket.capstone-db-schema-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ===============================
# Enable default server-side encryption
# ================================
resource "aws_s3_bucket_server_side_encryption_configuration" "capstone_storage" {
  bucket = aws_s3_bucket.capstone-db-schema-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ===============================
# Bucket policy granted
# ================================
resource "aws_s3_bucket_policy" "allow-access-from-bastion-host" {
  bucket = aws_s3_bucket.capstone-db-schema-bucket.id
  policy = data.aws_iam_policy_document.allow-access-from-bastion-host.json
}

# ===============================
# Bucket policy definement
# ================================
data "aws_iam_policy_document" "allow-access-from-bastion-host" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.capstone-bastion-ssm-role.arn
      ]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.capstone-db-schema-bucket.arn,
      "${aws_s3_bucket.capstone-db-schema-bucket.arn}/*",
    ]
  }
}

# ================================
# ECS assumed IAM Role on ALB
# ================================
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

resource "aws_iam_role_policy_attachment" "ecs-invoke-alb-infras-role-policy" {
  role       = aws_iam_role.ecs-invoke-alb-infras-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForLoadBalancers"
}

# =========================
# IAM bastion-ssm role set up
# ==========================
resource "aws_iam_role" "capstone-bastion-ssm-role" {
  name = "capstone-bastion-ssm-instant-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.capstone-bastion-ssm-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ===========================================
# Bastion IAM base policy describe ecs task
# ===========================================
data "aws_iam_policy_document" "bastion-iam-describe-task-policy-doc" {
  statement {
    sid    = "ecsDescribeTasks"
    effect = "Allow"
    actions = [
      "ecs:DescribeTasks"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "bastion-identity-describe-task-policy" {
  name        = "bastion-identity-describe-task-access-policy"
  description = "Identity based policy to describe ECS task"
  policy      = data.aws_iam_policy_document.bastion-iam-describe-task-policy-doc.json
}

resource "aws_iam_role_policy_attachment" "bastion-iam-describe-task-policy-attach" {
  role       = aws_iam_role.capstone-bastion-ssm-role.name
  policy_arn = aws_iam_policy.bastion-identity-describe-task-policy.arn
}

# ==============================
# Define ec2 instance profile
# ==============================
resource "aws_iam_instance_profile" "bastion" {
  name = "capstone-bastion-instance-profile"
  role = aws_iam_role.capstone-bastion-ssm-role.name
}

# ===============================================
# Bastion IAM base policy access schema bucket
# ===============================================
data "aws_iam_policy_document" "bastion-iam-schema-bucket-access-policy-doc" {
  statement {
    sid    = "ListObjectsInBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.capstone-db-schema-bucket.arn
    ]
  }
  statement {
    sid    = "ReadObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.capstone-db-schema-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "bastion-identity-schema-bucket-access-policy" {
  name        = "bastion-identity-schema-bucket-access-policy"
  description = "Identity based policy giving read access to capstone db schema bucket"
  policy      = data.aws_iam_policy_document.bastion-iam-schema-bucket-access-policy-doc.json
}

resource "aws_iam_role_policy_attachment" "bastion-iam-read-schema-bucket-policy-attach" {
  role       = aws_iam_role.capstone-bastion-ssm-role.name
  policy_arn = aws_iam_policy.bastion-identity-schema-bucket-access-policy.arn
}

# =====================================================
# ECS assume role on driver blue green hook function
# =====================================================
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

# =========================================================
#  Lambda driver blue green hook function execution role
# =========================================================
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

# =========================================================
#  Lambda@Edge authenticate jwt execution role
# =========================================================
resource "aws_iam_role" "cognito-jwt-edge-auth-execution-role" {
  provider = aws.us_east_1
  name     = "cognito-jwt-edge-auth-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cognito-jwt-edge-auth-role-policy" {
  provider   = aws.us_east_1
  role       = aws_iam_role.cognito-jwt-edge-auth-execution-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}




