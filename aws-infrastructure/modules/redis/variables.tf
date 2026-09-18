variable "redis_tags" {
  description = "Common tags applied to all redis resources"
  type        = map(string)
}

variable "capstone_vpc_id" {
  description = "ID of the capstone vpc"
  type        = string
}

variable "capstone_private_security_group_id" {
  description = "ID of private security group"
  type        = string
}

variable "capstone_private_subnet_ids" {
  description = "IDs of the capstone private subnets"
  type        = list(string)
}