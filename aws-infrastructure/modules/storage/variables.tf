variable "storage_tags" {
  description = "Tags applied to storage resources"
  type        = map(string)
}

variable "capstone_db_schema_bucket_name" {
  description = "Name of capstone db schema bucket"
  type        = string
}

variable "bastion-host-role-arn" {
  description = "ARN of bastion ssm role"
  type        = string
}


