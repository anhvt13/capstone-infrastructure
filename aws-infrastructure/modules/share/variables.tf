variable "storage_tags" {
  description = "Tags applied to storage resources"
  type        = map(string)
}

variable "capstone_db_schema_bucket_name" {
  description = "Name of capstone db schema bucket"
  type        = string
}

variable "driver_bg_validator_secret_arn" {
  description = "The ARN of driver blue/green hook validator secret"
  type        = string
}

variable "driver_service_secret_arn" {
  description = "ARN of driver service secret"
  type        = string
}

variable "bff_secret_arn" {
  description = "ARN of bff secret"
  type        = string
}

variable "bff_oauth2_secret_arn" {
  description = "ARN of bff OAuth2 secret manager"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of rds secret manager"
  type        = string
}