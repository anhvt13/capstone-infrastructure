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