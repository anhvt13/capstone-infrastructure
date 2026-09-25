variable "primary_aws_region" {
  description = "AWS primary region"
  type        = string
  default     = "ap-southeast-1"
}

variable "network_tags" {
  type        = map(string)
  description = "Common tags applied to all network resources"
  default = {
    Layer     = "network"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "security_tags" {
  type        = map(string)
  description = "Common tags applied to all security resources"
  default = {
    Layer     = "security"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "database_tags" {
  type        = map(string)
  description = "Common tags applied to all database resources"
  default = {
    Layer     = "db"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "bastion_tags" {
  type        = map(string)
  description = "Common tags applied to all bastion resources"
  default = {
    Layer     = "bastion"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "storage_tags" {
  type        = map(string)
  description = "Common tags applied to all storage resources"
  default = {
    Layer     = "storage"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "secret_tags" {
  type        = map(string)
  description = "Common tags applied to all secret resources"
  default = {
    Layer     = "secret"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "container_tags" {
  type        = map(string)
  description = "Common tags applied to all container resources"
  default = {
    Layer     = "ecs"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "alb_tags" {
  type        = map(string)
  description = "Common tags applied to all alb resources"
  default = {
    Layer     = "alb"
    Project   = "capstone"
    ManagedBy = "terraform"
  }
}

variable "redis_tags" {
  type        = map(string)
  description = "Common tags applied to all redis resources"
  default = {
    Layer     = "redis"
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

variable "capstone_database_name" {
  description = "Initial database name"
  type        = string
  default     = "capstone"
}

variable "capstone_master_username" {
  description = "Aurora master username"
  type        = string
  default     = "master"
}

variable "capstone_ec2_instance_type" {
  description = "EC2 instance type for capstone workload"
  type        = string
  default     = "t4g.micro"
}

variable "capstone_db_schema_bucket_name" {
  description = "Capstone database schema storage bucket name"
  type        = string
  default     = "capstone-db-schema-bucket-249899229305-ap-southeast-1-an"
}

variable "driver_service_ecr_uri" {
  description = "Driver service image URI from ECR"
  type        = string
  default     = "249899229305.dkr.ecr.ap-southeast-1.amazonaws.com/capstone/driver-service:v1"
}

variable "bff_client_ecr_uri" {
  description = "BFF client image URI from ECR"
  type        = string
  default     = "249899229305.dkr.ecr.ap-southeast-1.amazonaws.com/capstone/bff-client:v1"
}

variable "database_port" {
  description = "Database port number"
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "capstone"
}

variable "ecs_desired_task" {
  description = "Number of ecs desired task to run"
  type        = number
  default     = 0
}