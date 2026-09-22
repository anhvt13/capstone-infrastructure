#=========================================
# Secrets of driver service certificate
#========================================
resource "aws_secretsmanager_secret" "driver-service-secret" {
  name                    = "capstone/driver/tls"
  description             = "Driver service TLS secrets"
  recovery_window_in_days = 0

  tags = merge(
    {
      Name = "capstone-driver-service-secret"
    },
    var.secret_tags
  )
}

#=========================================
# Secrets of bff certificate
#========================================
resource "aws_secretsmanager_secret" "bff-secret" {
  name                    = "capstone/bff/tls"
  description             = "BFF client TLS secrets"
  recovery_window_in_days = 0

  tags = merge(
    {
      Name = "capstone-bff-client-secret"
    },
    var.secret_tags
  )
}

#=========================================
# Secrets of bff OAuth2 credentials
#========================================
resource "aws_secretsmanager_secret" "bff-oauth2-credential" {
  name                    = "capstone/bff/oauth2"
  description             = "BFF client OAuth2 credentials"
  recovery_window_in_days = 0

  tags = merge(
    {
      Name = "capstone-bff-client-oauth2"
    },
    var.secret_tags
  )
}