variable "secret_tags" {
  description = "Common tags applied to all secret resources"
  type        = map(string)
}

variable "driver_keystore_password" {
  description = "Password for the driver service keystore"
  type        = string
  sensitive   = true
}

variable "driver_truststore_password" {
  description = "Password for the driver service truststore"
  type        = string
  sensitive   = true
}

variable "bff_client_keystore_password" {
  description = "Password for the bff client keystore"
  type        = string
  sensitive   = true
}

variable "bff_server_keystore_password" {
  description = "Password for the bff server keystore"
  type        = string
  sensitive   = true
}

variable "bff_truststore_password" {
  description = "Password for the bff client truststore"
  type        = string
  sensitive   = true
}

variable "driver_m2m_client_id" {
  description = "Client id of OAuth2 m2m to driver service"
  type        = string
  sensitive   = true
}

variable "driver_m2m_client_secret" {
  description = "Client secret of OAuth2 m2m to driver service"
  type        = string
  sensitive   = true
}