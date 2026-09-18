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

variable "capstone-db-sg-id" {
  description = "DB security group ID"
  type        = string
}

variable "ami-id" {
  description = "Latest AWS Linux AMI support ARM identity"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Aurora master credentials"
  type        = string
}

variable "capstone-db-schema-bucket-arn" {
  description = "ARN of capstone db schema bucket"
  type        = string
}
