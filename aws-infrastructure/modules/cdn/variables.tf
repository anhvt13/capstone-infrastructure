variable "capstone_alb_dns" {
  description = "Capstone application load balancer DNS"
  type        = string
}

variable "cdn_tags" {
  description = "Tags applied to cdn resources"
  type        = map(string)
}

variable "target_origin_id" {
  description = "ALB target origin ID"
  type        = string
}

variable "cognito_jwt_edge_auth_function_qualified_arn" {
  description = "Specific published version ARN of jwt authenticate lambda edge"
  type        = string
}