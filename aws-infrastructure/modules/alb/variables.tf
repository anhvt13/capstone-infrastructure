variable "alb_tags" {
  description = "Tags applied to alb resources"
  type        = map(string)
}

variable "capstone_vpc_id" {
  description = "ID of the capstone vpc"
  type        = string
}

variable "capstone_alb_security_group_id" {
  description = "ID of capstone alb security group"
  type        = string
}

variable "capstone_public_subnet_ids" {
  description = "IDs of the capstone public subnets"
  type        = list(string)
}
