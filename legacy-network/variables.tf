variable "network_tags" {
  type        = map(string)
  description = "Common tags applied to all network resources"
  default = {
    Layer     = "network"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "capstone_vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "capstone_public_subnet_1_cidr" {
  description = "CIDR block for the public-subnet-1"
  type        = string
  default     = "10.1.1.0/24"
}

variable "capstone_public_subnet_2_cidr" {
  description = "CIDR block for the public-subnet-2"
  type        = string
  default     = "10.1.2.0/24"
}

variable "capstone_private_subnet_1_cidr" {
  description = "CIDR block for the private-subnet-1"
  type        = string
  default     = "10.1.3.0/24"
}

variable "capstone_private_subnet_2_cidr" {
  description = "CIDR block for the private-subnet-2"
  type        = string
  default     = "10.1.4.0/24"
}

variable "capstone_db_subnet_1_cidr" {
  description = "CIDR block for the db-subnet-1"
  type        = string
  default     = "10.1.5.0/24"
}

variable "capstone_db_subnet_2_cidr" {
  description = "CIDR block for the db-subnet-2"
  type        = string
  default     = "10.1.6.0/24"
}

variable "dr_capstone_vpc_cidr" {
  description = "CIDR block for the DR VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dr_capstone_public_subnet_1_cidr" {
  description = "CIDR block for the DR public-subnet-1"
  type        = string
  default     = "10.1.1.0/24"
}

variable "dr_capstone_public_subnet_2_cidr" {
  description = "CIDR block for the DR public-subnet-2"
  type        = string
  default     = "10.1.2.0/24"
}

variable "dr_capstone_private_subnet_1_cidr" {
  description = "CIDR block for the DR private-subnet-1"
  type        = string
  default     = "10.1.3.0/24"
}

variable "dr_capstone_private_subnet_2_cidr" {
  description = "CIDR block for the DR private-subnet-2"
  type        = string
  default     = "10.1.4.0/24"
}

variable "dr_capstone_db_subnet_1_cidr" {
  description = "CIDR block for the DR db-subnet-1"
  type        = string
  default     = "10.1.5.0/24"
}

variable "dr_capstone_db_subnet_2_cidr" {
  description = "CIDR block for the DR db-subnet-2"
  type        = string
  default     = "10.1.6.0/24"
}