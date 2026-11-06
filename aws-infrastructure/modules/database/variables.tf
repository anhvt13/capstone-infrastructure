variable "database_tags" {
  description = "Common tags applied to all database resources"
  type        = map(string)
}

variable "capstone_db_subnet_ids" {
  description = "IDs of the capstone database subnets"
  type        = list(string)
}

variable "capstone_db_security_group_id" {
  description = "Security group ID for Aurora database"
  type        = string
}

variable "capstone_database_name" {
  description = "Initial database name"
  type        = string
}

variable "aurora_credential_secret_arn" {
  description = "Aurora credential secret ARN"
  type        = string
}

variable "aurora_master_username" {
  description = "Aurora database master username"
  type        = string
}

variable "aurora_engine_version" {
  description = "Aurora engine version"
  type        = string
}

variable "dr_capstone_db_security_group_id" {
  description = "Security group ID for DR Aurora database"
  type        = string
}

variable "dr_capstone_db_subnet_ids" {
  description = "IDs of the DR capstone database subnets"
  type        = list(string)
}


