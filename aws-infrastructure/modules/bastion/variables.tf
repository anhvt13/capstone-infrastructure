variable "capstone_vpc_id" {
  description = "Capstone VPC ID where the bastion will run"
  type        = string
}

variable "capstone_private_subnet_id" {
  description = "Private subnet ID where the bastion will run"
  type        = string
}

variable "bastion_tags" {
  description = "Tags applied to bastion resources"
  type        = map(string)
}

variable "security_tags" {
  description = "Tags applied to security resources"
  type        = map(string)
}

variable "instance_type" {
  description = "EC2 instance type for the bastion"
  type        = string
}

variable "capstone_db_sg_id" {
  description = "ID of database security group"
  type        = string
}

variable "ami-id" {
  description = "Latest AWS Linux AMI support ARM identity"
  type        = string
}

variable "bastion_instance_profile_name" {
  description = "Bastion instance profile name"
  type        = string
}