variable "database_tags" {
  description = "Common tags applied to all database resources"
  type = map(string)
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

variable "capstone_master_username" {
  description = "Aurora master username"
  type        = string
}


