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

variable "cdn_tags" {
  type        = map(string)
  description = "Common tags applied to all cdn resources"
  default = {
    Layer     = "cdn"
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

  # Base version with just aurora auto scaling configure, NO cache on GET list endpoint
  default = "249899229305.dkr.ecr.ap-southeast-1.amazonaws.com/capstone/driver-service:cd7dc2bd77f2cee56356d44cb88fb87eb2146ada"
}

variable "bff_client_ecr_uri" {
  description = "BFF client image URI from ECR"
  type        = string
  default     = "249899229305.dkr.ecr.ap-southeast-1.amazonaws.com/capstone/bff-client:e5989857b0d8834006f91d2946c79f8989146e6a"
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
  description = "Number of ECS desired task to run"
  type        = number
  default     = 1
}

variable "driver_health_path" {
  description = "Driver service health check path"
  type        = string
  default     = "/driver/health"
}

variable "bff_min_capacity" {
  description = "Minimum number of BFF ECS tasks"
  type        = number
  default     = 1
}

variable "bff_max_capacity" {
  description = "Maximum number of BFF ECS tasks"
  type        = number
  default     = 100
}

variable "bff_cpu_target" {
  description = "Target average CPU utilization percentage of BFF tasks"
  type        = number
  default     = 60
}

variable "driver_min_capacity" {
  description = "Minimum number of Driver ECS tasks"
  type        = number
  default     = 1
}

variable "driver_max_capacity" {
  description = "Maximum number of Driver ECS tasks"
  type        = number
  default     = 100
}

variable "driver_cpu_target" {
  description = "Target average CPU utilization percentage of Driver tasks"
  type        = number
  default     = 60
}

variable "target_origin_id" {
  description = "ALB target origin ID"
  type        = string
  default     = "capstone-alb-origin"
}