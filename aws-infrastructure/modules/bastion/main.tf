# =========================
# IAM bastion-ssm role set up
# ==========================
resource "aws_iam_role" "capstone-bastion-ssm-role" {
  name                = "capstone-bastion-ssm-instant-role"
  assume_role_policy  = jsonencode({
    Version           = "2012-10-17"
    Statement     = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    {
      Name = "capstone-bastion-ssm-role"
    },
    var.bastion_tags
  )
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.capstone-bastion-ssm-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ===========================================
# Bastion IAM base policy access secret value
# ===========================================
data "aws_iam_policy_document" "bastion-iam-secret-value-access-policy-doc" {
  statement {
    sid       = "AccessSecretValue"
    effect    = "Allow"
    actions   = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.db_secret_arn
    ]
  }
}

resource "aws_iam_policy" "bastion-identity-secret-value-access-policy" {
  name        = "bastion-identity-secret-value-access-policy"
  description = "Identity based policy to access secret value from secret manager"
  policy      = data.aws_iam_policy_document.bastion-iam-secret-value-access-policy-doc.json
}

resource "aws_iam_role_policy_attachment" "bastion-iam-secret-value-access-policy-attach" {
  role       = aws_iam_role.capstone-bastion-ssm-role.name
  policy_arn = aws_iam_policy.bastion-identity-secret-value-access-policy.arn
}

# ===========================================
# Bastion IAM base policy describe ecs task
# ===========================================
data "aws_iam_policy_document" "bastion-iam-describe-task-policy-doc" {
  statement {
    sid       = "ecsDescribeTasks"
    effect    = "Allow"
    actions   = [
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
  role        = aws_iam_role.capstone-bastion-ssm-role.name
  policy_arn  = aws_iam_policy.bastion-identity-describe-task-policy.arn
}

# =========================
# Define ec2 instance profile
# ==========================
resource "aws_iam_instance_profile" "bastion" {
  name = "capstone-bastion-instance-profile"
  role = aws_iam_role.capstone-bastion-ssm-role.name

  tags = merge(
    {
      Name = "capstone-bastion-instance-profile"
    },
    var.bastion_tags
  )
}

# =========================
# Bastion host security group
# ==========================
resource "aws_security_group" "capstone-bastion-sg" {
  name        = "capstone-bastion-sg"
  description = "Bastion host security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-bastion-sg"
    },
    var.bastion_tags
  )
}

# =================================
# Bastion host security group rules
# =================================
resource "aws_vpc_security_group_egress_rule" "bastion-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-bastion-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db-sg-inbound-rule" {
  security_group_id             = var.capstone-db-sg-id
  referenced_security_group_id  = aws_security_group.capstone-bastion-sg.id
  from_port                     = 5432
  to_port                       = 5432
  ip_protocol                   = "tcp"
}

# =========================
# Bastion host ec2 instance
# ==========================
resource "aws_instance" "bastion-host" {
  ami                         = var.ami-id
  instance_type               = var.instance_type
  subnet_id                   = var.capstone_private_subnet_id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  vpc_security_group_ids      = [aws_security_group.capstone-bastion-sg.id]
  user_data                   = <<-EOF
                              #!/bin/bash
                              dnf update -y
                              dnf install -y postgresql17
                              EOF

  depends_on                  = [
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy_attachment.bastion-iam-read-schema-bucket-policy-attach
  ]

  tags = merge(
    {
      Name = "capstone-bastion"
    },
    var.bastion_tags
  )
}

# ===========================================
# Bastion IAM base policy access schema bucket
# =============================================
data "aws_iam_policy_document" "bastion-iam-schema-bucket-access-policy-doc" {
  statement {
    sid       = "ListObjectsInBucket"
    effect    = "Allow"
    actions   = [
      "s3:ListBucket"
    ]
    resources = [
      var.capstone-db-schema-bucket-arn
    ]
  }
  statement {
    sid       = "ReadObjects"
    effect    = "Allow"
    actions   = [
      "s3:GetObject"
    ]
    resources = [
      "${var.capstone-db-schema-bucket-arn}/*"
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




