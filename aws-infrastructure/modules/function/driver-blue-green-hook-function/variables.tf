variable "capstone_private_subnet_ids" {
  description = "IDs of the capstone private subnets"
  type        = list(string)
}

variable "capstone_driver_blue_green_hook_function_sg_id" {
  description = "ID of driver blue green hook function security group"
  type        = string
}

variable "driver_bg_validator_secret_arn" {
  description = "The ARN of driver blue/green hook validator secret"
  type        = string
}

variable "driver_blue_green_hook_ecs_assume_role_id" {
  description = "ID of ecs assume role on driver blue green hook function"
  type        = string
}

variable "driver_blue_green_hook_execution_role_arn" {
  description = "ARN of driver blue green hook execution role"
  type        = string
}