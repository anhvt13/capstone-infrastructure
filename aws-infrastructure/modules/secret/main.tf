#=========================================
# Secrets of driver service certificate
#========================================
resource "aws_secretsmanager_secret" "driver-service-secret" {
  name                    = "capstone/driver-service-secret"
  description             = "Driver service secret"
  recovery_window_in_days = 0

  tags = merge(
    {
      Name = "capstone-driver-service-secret"
    },
    var.secret_tags
  )
}

#============================================
# Base64 secret value of driver service certs
#============================================
resource "aws_secretsmanager_secret_version" "driver-service-secret-string" {
  secret_id = aws_secretsmanager_secret.driver-service-secret.id
  secret_string = jsonencode({
    driver_keystore_base64 = filebase64(
      "${path.module}/../../../../certs/driver/driver-service-keystore.p12"
    )
    driver_keystore_password = var.driver_keystore_password
    driver_truststore_base64 = filebase64(
      "${path.module}/../../../../certs/driver/driver-service-truststore.p12"
    )
    driver_truststore_password = var.driver_truststore_password
  })
}

#=========================================
# Secrets of bff certificate
#========================================
resource "aws_secretsmanager_secret" "bff-secret" {
  name                    = "capstone/bff-client-secret"
  description             = "BFF client secret"
  recovery_window_in_days = 0

  tags = merge(
    {
      Name = "capstone-bff-client-secret"
    },
    var.secret_tags
  )
}

#=========================================
# Base64 secret value of bff certs
#========================================
resource "aws_secretsmanager_secret_version" "bff-secret-string" {
  secret_id = aws_secretsmanager_secret.bff-secret.id
  secret_string = jsonencode({
    bff_client_keystore_base64 = filebase64(
      "${path.module}/../../../../certs/bff/bff-client-keystore.p12"
    )
    bff_server_keystore_base64 = filebase64(
      "${path.module}/../../../../certs/bff/bff-server-keystore.p12"
    )
    bff_client_keystore_password = var.bff_client_keystore_password
    bff_server_keystore_password = var.bff_server_keystore_password
    bff_truststore_base64 = filebase64(
      "${path.module}/../../../../certs/bff/bff-truststore.p12"
    )
    bff_truststore_password  = var.bff_truststore_password
    driver_m2m_client_id     = var.driver_m2m_client_id
    driver_m2m_client_secret = var.driver_m2m_client_secret
  })
}
