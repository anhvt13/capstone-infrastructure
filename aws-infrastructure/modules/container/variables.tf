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

variable "capstone_bff_blue_tg_arn" {
  description = "ARN of capstone bff BLUE target group"
  type        = string
}

variable "ecs_desired_task" {
  description = "Number of ecs task desired to run"
  type        = number
}

variable "driver_blue_green_hook_function_arn" {
  description = "The ARN of the Driver blue green hook lambda function"
  type        = string
}

variable "driver_blue_green_hook_ecs_assume_role_arn" {
  description = "The ARN of the Driver blue green hook ecs assume role"
  type        = string
}

variable "driver_health_url" {
  description = "URL of Driver service health check"
  type        = string
}

variable "driver_health_path" {
  description = "Driver service health check path"
  type        = string
}

variable "capstone_bff_green_tg_arn" {
  description = "ARN of capstone bff GREEN target group"
  type        = string
}

variable "ecs_invoke_alb_infras_role_arn" {
  description = "ARN of ECS assume role on ALB infrastructure"
  type        = string
}

variable "alb_production_listener_rule_arn" {
  description = "ARN of production listener rule ALB"
  type        = string
}

variable "bff_min_capacity" {
  description = "Minimum number of BFF ECS tasks"
  type        = number
}

variable "bff_max_capacity" {
  description = "Maximum number of BFF ECS tasks"
  type        = number
}

variable "bff_cpu_target" {
  description = "Target average BFF CPU utilization percentage"
  type        = number
}

variable "driver_min_capacity" {
  description = "Minimum number of Driver ECS tasks"
  type        = number
}

variable "driver_max_capacity" {
  description = "Maximum number of Driver ECS tasks"
  type        = number
}

variable "driver_cpu_target" {
  description = "Target average Driver CPU utilization percentage"
  type        = number
}