variable "container_tags" {
  description = "Common tags applied to all container resources"
  type        = map(string)
}

variable "driver_service_ecr_uri" {
  description = "Driver service image URI from ECR"
  type        = string
}

variable "bff_client_ecr_uri" {
  description = "BFF client image URI from ECR"
  type        = string
}

variable "capstone_private_sg_id" {
  description = "Private security group ID"
  type        = string
}

variable "capstone_private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_capstone_app_log_group" {
  description = "ECS capstone app log group name"
  type        = string
}

variable "primary_aws_region" {
  description = "Primary AWS region"
  type        = string
}

variable "driver_service_secret_arn" {
  description = "ARN of driver service secret"
  type        = string
}

variable "capstone_aurora_cluster_ep" {
  description = "Capstone aurora cluster endpoint"
  type        = string
}

variable "database_port" {
  description = "Database port number"
  type        = number
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "bff_secret_arn" {
  description = "ARN of bff secret"
  type        = string
}

variable "bff_oauth2_secret_arn" {
  description = "ARN of bff OAuth2 secret manager"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of rds secret manager"
  type        = string
}

variable "capstone_vpc_id" {
  description = "ID of capstone application vpc"
  type        = string
}

variable "capstone_bff_tg_arn" {
  description = "ARN of capstone bff target group"
  type        = string
}