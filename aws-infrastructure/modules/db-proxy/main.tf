data "aws_iam_policy_document" "rds_proxy_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "rds_proxy_access_secrets" {
  statement {
    sid    = "AccessRDSecretCredentials"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.rds_secret_arn,
    ]
  }
}

resource "aws_iam_policy" "capstone-rds-secret-access-policy" {
  name        = "capstone-rds-secret-access-policy"
  description = "Capstone RDS secret credentials access policy"
  policy      = data.aws_iam_policy_document.rds_proxy_access_secrets.json
}

#====================
# RDS Proxy role
#====================
resource "aws_iam_role" "rds-proxy-role" {
  name               = "rds-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "rds-proxy-role-secret-access-policy-attachment" {
  role       = aws_iam_role.rds-proxy-role.name
  policy_arn = aws_iam_policy.capstone-rds-secret-access-policy.arn
}

#====================
# RDS Proxy
#====================
resource "aws_db_proxy" "capstone_rds_proxy" {
  name                = "capstone-rds-proxy"
  engine_family       = "POSTGRESQL"
  idle_client_timeout = 1800
  require_tls         = true
  debug_logging       = false
  role_arn            = aws_iam_role.rds-proxy-role.arn
  vpc_subnet_ids      = var.capstone_db_subnet_ids
  vpc_security_group_ids = [
    var.capstone_rds_proxy_security_group_id
  ]
  auth {
    auth_scheme = "SECRETS"
    description = "Aurora PostgreSQL database credentials"
    iam_auth    = "DISABLED"
    secret_arn  = var.rds_secret_arn
  }
  depends_on = [
    aws_iam_role.rds-proxy-role
  ]

  tags = merge(
    {
      Name = "capstone-rds-proxy"
    },
    var.database_tags
  )
}

#===============================
# Connection pool configuration
#===============================
resource "aws_db_proxy_default_target_group" "capstone_proxy_target_group" {
  db_proxy_name = aws_db_proxy.capstone_rds_proxy.name
  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 80
    max_idle_connections_percent = 40
  }
  lifecycle {
    replace_triggered_by = [
      aws_db_proxy.capstone_rds_proxy.id
    ]
  }
}

#==============================
# Register with Aurora cluster
#==============================
resource "aws_db_proxy_target" "capstone_proxy_target" {
  db_proxy_name         = aws_db_proxy.capstone_rds_proxy.name
  target_group_name     = aws_db_proxy_default_target_group.capstone_proxy_target_group.name
  db_cluster_identifier = var.capstone_aurora_cluster_identifier
  lifecycle {
    replace_triggered_by = [
      aws_db_proxy.capstone_rds_proxy.id
    ]
  }
}

