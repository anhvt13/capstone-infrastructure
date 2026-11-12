#====================
# RDS Proxy
#====================
resource "aws_db_proxy" "capstone_rds_proxy" {
  name                   = "capstone-rds-proxy"
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 600
  require_tls            = true
  debug_logging          = false
  role_arn               = var.rds_proxy_role_arn
  vpc_subnet_ids         = var.capstone_db_subnet_ids
  vpc_security_group_ids = [var.capstone_rds_proxy_security_group_id]
  auth {
    auth_scheme = "SECRETS"
    description = "Aurora PostgreSQL database credentials"
    iam_auth    = "DISABLED"
    secret_arn  = var.aurora_credential_secret_arn
  }

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
    connection_borrow_timeout    = 30
    max_connections_percent      = 80
    max_idle_connections_percent = 40
  }
  lifecycle {
    replace_triggered_by = [
      aws_db_proxy.capstone_rds_proxy.id
    ]
  }
}

#===========================================
# Register RDS Proxy with Aurora cluster
#===========================================
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

