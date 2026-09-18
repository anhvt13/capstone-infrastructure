variable "capstone_vpc_id" {
  description = "Id of capstone vpc"
  type        = string
}

variable "capstone_vpc_cidr_block" {
  description = "Cidr block of capstone vpc"
  type        = string
}

variable "capstone_public_subnet_ids" {
  description = "IDs of the capstone public subnets"
  type        = list(string)
}

variable "capstone_private_subnet_ids" {
  description = "IDs of the capstone private subnets"
  type        = list(string)
}

variable "capstone_db_subnet_ids" {
  description = "IDs of the capstone db subnets"
  type        = list(string)
}

variable "security_tags" {
  description = "Common tags applied to all security resources"
  type        = map(string)
}

variable "bastion_host_security_group_id" {
  description = "Bastion host security group Id"
  type        = string
}