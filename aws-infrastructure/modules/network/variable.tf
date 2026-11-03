variable "network_tags" {
  description = "Common tags applied to all network resources"
  type        = map(string)
}

variable "aws_region" {
  description = "Current AWS region resources deployed"
  type        = string
}

variable "capstone_vpc_id" {
  description = "ID of the capstone vpc"
  type        = string
}

variable "capstone_public_subnet_1_id" {
  description = "ID of the capstone public subnet 1"
  type        = string
}

variable "capstone_public_subnet_2_id" {
  description = "ID of the capstone public subnet 2"
  type        = string
}

variable "capstone_private_subnet_1_id" {
  description = "ID of the capstone private subnet 1"
  type        = string
}

variable "capstone_private_subnet_2_id" {
  description = "ID of the capstone private subnet 2"
  type        = string
}

variable "capstone_db_subnet_1_id" {
  description = "ID of the database subnet 1"
  type        = string
}

variable "capstone_db_subnet_2_id" {
  description = "ID of the database subnet 2"
  type        = string
}

variable "capstone_vpc_endpoint_sg_id" {
  description = "VPC interface endpoint security group ID"
  type        = string
}


