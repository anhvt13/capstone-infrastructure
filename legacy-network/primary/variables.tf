variable "primary_aws_region" {
  description = "AWS primary region"
  type        = string
  default     = "ap-southeast-1"
}

variable "network_tags" {
  type        = map(string)
  description = "Common tags applied to all network resources"
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