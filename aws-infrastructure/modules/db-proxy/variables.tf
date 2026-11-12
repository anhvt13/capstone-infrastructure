variable "aurora_credential_secret_arn" {
  description = "Aurora credentials secret ARN"
  type        = string
}

variable "database_tags" {
  description = "Common tags applied to all database resources"
  type        = map(string)
}

variable "capstone_db_subnet_ids" {
  description = "IDs of the capstone database subnets"
  type        = list(string)
}

variable "capstone_rds_proxy_security_group_id" {
  description = "ID of rds proxy security group"
  type        = string
}

variable "capstone_aurora_cluster_identifier" {
  description = "Capstone aurora cluster identifier"
  type        = string
}

variable "rds_proxy_role_arn" {
  description = "RDS Proxy IAM role"
  type        = string
}
