variable "dr_aws_region" {
  description = "AWS disaster recovery region"
  type        = string
  default     = "ap-northeast-1"
}

variable "network_tags" {
  type        = map(string)
  description = "Common tags applied to all network resources"
}

variable "availability_zones" {
  description = "List of all availability zones from current region"
  type        = list(string)
}

variable "dr_capstone_vpc_cidr" {
  description = "CIDR block for the DR VPC"
  type        = string
}

variable "dr_capstone_public_subnet_1_cidr" {
  description = "CIDR block for the DR public-subnet-1"
  type        = string
}

variable "dr_capstone_public_subnet_2_cidr" {
  description = "CIDR block for the DR public-subnet-2"
  type        = string
}

variable "dr_capstone_private_subnet_1_cidr" {
  description = "CIDR block for the DR private-subnet-1"
  type        = string
}

variable "dr_capstone_private_subnet_2_cidr" {
  description = "CIDR block for the DR private-subnet-2"
  type        = string
}

variable "dr_capstone_db_subnet_1_cidr" {
  description = "CIDR block for the DR db-subnet-1"
  type        = string
}

variable "dr_capstone_db_subnet_2_cidr" {
  description = "CIDR block for the DR db-subnet-2"
  type        = string
}