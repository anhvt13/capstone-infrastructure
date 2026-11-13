# variable "db_secret_arn" {
#   description = "ARN of the Secrets Manager secret containing the Aurora master credentials"
#   type        = string
# }

# variable "capstone_db_schema_bucket_arn" {
#   description = "ARN of capstone db schema bucket"
#   type        = string
# }

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