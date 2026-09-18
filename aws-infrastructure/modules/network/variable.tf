variable "network_tags" {
  description = "Common tags applied to all network resources"
  type        = map(string)
}

variable "aws_region" {
  description = "Current AWS region resources deployed"
  type        = string
}

variable "availability_zones" {
  description = "List of all availability zones from current region"
  type        = list(string)
}

variable "capstone_vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "capstone_public_subnet_1_cidr" {
  description = "CIDR block for the public-subnet-1"
  type        = string
}

variable "capstone_public_subnet_2_cidr" {
  description = "CIDR block for the public-subnet-2"
  type        = string
}

variable "capstone_private_subnet_1_cidr" {
  description = "CIDR block for the private-subnet-1"
  type        = string
}

variable "capstone_private_subnet_2_cidr" {
  description = "CIDR block for the private-subnet-2"
  type        = string
}

variable "capstone_db_subnet_1_cidr" {
  description = "CIDR block for the db-subnet-1"
  type        = string
}

variable "capstone_db_subnet_2_cidr" {
  description = "CIDR block for the db-subnet-2"
  type        = string
}

variable "capstone_vpc_endpoint_sg_id" {
  description = "VPC interface endpoint security group ID"
  type        = string
}


