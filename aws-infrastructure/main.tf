# =========================
# CAPSTONE INFRASTRUCTURE
# =========================

# ====================
# Local variables
# ====================
locals {
  network_outputs = var.enabled_dr ? {
    capstone_vpc_id               = data.terraform_remote_state.legacy_network.outputs.dr_capstone_vpc_id
    capstone_vpc_cidr_block       = data.terraform_remote_state.legacy_network.outputs.dr_capstone_vpc_cidr_block
    capstone_public_subnet_1_id   = data.terraform_remote_state.legacy_network.outputs.dr_capstone_public_subnet_1_id
    capstone_public_subnet_2_id   = data.terraform_remote_state.legacy_network.outputs.dr_capstone_public_subnet_2_id
    capstone_private_subnet_1_id  = data.terraform_remote_state.legacy_network.outputs.dr_capstone_private_subnet_1_id
    capstone_private_subnet_2_id  = data.terraform_remote_state.legacy_network.outputs.dr_capstone_private_subnet_2_id
    capstone_db_subnet_1_id       = data.terraform_remote_state.legacy_network.outputs.dr_capstone_db_subnet_1_id
    capstone_db_subnet_2_id       = data.terraform_remote_state.legacy_network.outputs.dr_capstone_db_subnet_2_id
    capstone_public_subnet_ids    = data.terraform_remote_state.legacy_network.outputs.dr_capstone_public_subnet_ids
    capstone_private_subnet_ids   = data.terraform_remote_state.legacy_network.outputs.dr_capstone_private_subnet_ids
    capstone_db_subnet_ids        = data.terraform_remote_state.legacy_network.outputs.dr_capstone_db_subnet_ids
    capstone_db_security_group_id = data.terraform_remote_state.legacy_network.outputs.dr_capstone_db_sg_id
    } : {
    capstone_vpc_id               = data.terraform_remote_state.legacy_network.outputs.capstone_vpc_id
    capstone_vpc_cidr_block       = data.terraform_remote_state.legacy_network.outputs.capstone_vpc_cidr_block
    capstone_public_subnet_1_id   = data.terraform_remote_state.legacy_network.outputs.capstone_public_subnet_1_id
    capstone_public_subnet_2_id   = data.terraform_remote_state.legacy_network.outputs.capstone_public_subnet_2_id
    capstone_private_subnet_1_id  = data.terraform_remote_state.legacy_network.outputs.capstone_private_subnet_1_id
    capstone_private_subnet_2_id  = data.terraform_remote_state.legacy_network.outputs.capstone_private_subnet_2_id
    capstone_db_subnet_1_id       = data.terraform_remote_state.legacy_network.outputs.capstone_db_subnet_1_id
    capstone_db_subnet_2_id       = data.terraform_remote_state.legacy_network.outputs.capstone_db_subnet_2_id
    capstone_public_subnet_ids    = data.terraform_remote_state.legacy_network.outputs.capstone_public_subnet_ids
    capstone_private_subnet_ids   = data.terraform_remote_state.legacy_network.outputs.capstone_private_subnet_ids
    capstone_db_subnet_ids        = data.terraform_remote_state.legacy_network.outputs.capstone_db_subnet_ids
    capstone_db_security_group_id = data.terraform_remote_state.legacy_network.outputs.capstone_db_sg_id
  }

  capstone_aurora_cluster_identifier         = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.dr_capstone_aurora_cluster_identifier[0] : one(module.database[*].capstone_aurora_cluster_identifier)
  rds_proxy_role_arn                         = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.rds_proxy_role_arn[0] : one(module.database[*].rds_proxy_role_arn)
  bastion_instance_profile_name              = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.bastion_instance_profile_name[0] : one(module.iam[*].bastion_instance_profile_name)
  driver_blue_green_hook_ecs_assume_role_id  = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.driver_blue_green_hook_ecs_assume_role_id[0] : one(module.iam[*].driver_blue_green_hook_ecs_assume_role_id)
  driver_blue_green_hook_execution_role_arn  = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.driver_blue_green_hook_execution_role_arn[0] : one(module.iam[*].driver_blue_green_hook_execution_role_arn)
  cognito-jwt-edge-auth-execution-role_arn   = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.cognito-jwt-edge-auth-execution-role_arn[0] : one(module.iam[*].cognito-jwt-edge-auth-execution-role_arn)
  driver_blue_green_hook_ecs_assume_role_arn = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.driver_blue_green_hook_ecs_assume_role_arn[0] : one(module.iam[*].driver_blue_green_hook_ecs_assume_role_arn)
  ecs_invoke_alb_infras_role_arn             = var.enabled_dr ? data.terraform_remote_state.primary_infrastructure[0].outputs.ecs_invoke_alb_infras_role_arn[0] : one(module.iam[*].ecs_invoke_alb_infras_role_arn)
}

# =================
# Network module
# =================
module "network" {
  source = "./modules/network"

  aws_region                   = var.aws_region
  network_tags                 = var.network_tags
  capstone_vpc_endpoint_sg_id  = module.security.capstone_vpc_endpoint_sg_id
  capstone_vpc_id              = local.network_outputs.capstone_vpc_id
  capstone_public_subnet_1_id  = local.network_outputs.capstone_public_subnet_1_id
  capstone_public_subnet_2_id  = local.network_outputs.capstone_public_subnet_2_id
  capstone_private_subnet_1_id = local.network_outputs.capstone_private_subnet_1_id
  capstone_private_subnet_2_id = local.network_outputs.capstone_private_subnet_2_id
  capstone_db_subnet_1_id      = local.network_outputs.capstone_db_subnet_1_id
  capstone_db_subnet_2_id      = local.network_outputs.capstone_db_subnet_2_id
}

# =====================
# Security module
# =====================
module "security" {
  source = "./modules/security"

  capstone_vpc_id                = local.network_outputs.capstone_vpc_id
  capstone_vpc_cidr_block        = local.network_outputs.capstone_vpc_cidr_block
  capstone_db_subnet_ids         = local.network_outputs.capstone_db_subnet_ids
  capstone_private_subnet_ids    = local.network_outputs.capstone_private_subnet_ids
  capstone_public_subnet_ids     = local.network_outputs.capstone_public_subnet_ids
  bastion_host_security_group_id = module.bastion.bastion_host_security_group_id
  capstone_db_sg_id              = local.network_outputs.capstone_db_security_group_id
  security_tags                  = var.security_tags
}

# ===============================================================================
# Initial ONLY ONCE on PRIMARY site deployment - Shared across multi-regions
# Database module
# ===============================================================================
module "database" {
  count  = !var.enabled_dr ? 1 : 0
  source = "./modules/database"
  providers = {
    aws.dr_site = aws.dr_site
  }

  aurora_engine_version            = var.aurora_engine_version
  capstone_database_name           = var.capstone_database_name
  aurora_credential_secret_arn     = data.terraform_remote_state.secrets.outputs.aurora_credential_secret_arn
  aurora_master_username           = var.aurora_master_username
  capstone_db_security_group_id    = data.terraform_remote_state.legacy_network.outputs.capstone_db_sg_id
  capstone_db_subnet_ids           = data.terraform_remote_state.legacy_network.outputs.capstone_db_subnet_ids
  dr_capstone_db_security_group_id = data.terraform_remote_state.legacy_network.outputs.dr_capstone_db_sg_id
  dr_capstone_db_subnet_ids        = data.terraform_remote_state.legacy_network.outputs.dr_capstone_db_subnet_ids
  aws_region                       = var.aws_region
  database_tags                    = var.database_tags
}

# ======================
# Bastion host module
# ======================
module "bastion" {
  source = "./modules/bastion"

  #db_secret_arn                 = data.terraform_remote_state.secrets.outputs.aurora_credential_secret_arn
  capstone_vpc_id               = local.network_outputs.capstone_vpc_id
  capstone_private_subnet_id    = local.network_outputs.capstone_private_subnet_1_id
  capstone_db_sg_id             = local.network_outputs.capstone_db_security_group_id
  ami-id                        = data.aws_ssm_parameter.al2023_arm64.value
  instance_type                 = var.capstone_ec2_instance_type
  bastion_tags                  = var.bastion_tags
  security_tags                 = var.security_tags
  bastion_instance_profile_name = local.bastion_instance_profile_name

  depends_on = [module.iam]
}

# ================================================================================
# Initial ONLY ONCE on PRIMARY site deployment - Shared across multi-regions
# DB schema storage module
# ================================================================================
# module "storage" {
#   count  = !var.enabled_dr ? 1 : 0
#   source = "./modules/storage"
#
#   capstone_db_schema_bucket_name = var.capstone_db_schema_bucket_name
#   bastion-host-role-arn          = one(module.iam[*].bastion_host_ssm_role_name)
#   storage_tags                   = var.storage_tags
#
#   depends_on = [module.iam]
# }

# =========================================
# Driver blue green hook function module
# =========================================
module "driver_blue_green_hook" {
  source = "./modules/function/driver-blue-green-hook-function"

  capstone_private_subnet_ids                    = local.network_outputs.capstone_private_subnet_ids
  capstone_driver_blue_green_hook_function_sg_id = module.security.capstone_driver_blue_green_hook_function_sg_id
  driver_bg_validator_secret_arn                 = data.terraform_remote_state.secrets.outputs.driver_bg_validator_secret_arn
  driver_blue_green_hook_ecs_assume_role_id      = local.driver_blue_green_hook_ecs_assume_role_id
  driver_blue_green_hook_execution_role_arn      = local.driver_blue_green_hook_execution_role_arn

  depends_on = [module.iam]
}

# =====================
# Container module
# =====================
module "container" {
  source = "./modules/container"

  container_tags                             = var.container_tags
  driver_service_ecr_uri                     = var.driver_service_ecr_uri
  bff_client_ecr_uri                         = var.bff_client_ecr_uri
  capstone_private_sg_id                     = module.security.capstone_private_security_group_id
  capstone_private_subnet_ids                = local.network_outputs.capstone_private_subnet_ids
  ecs_capstone_app_log_group                 = module.monitor.ecs_capstone_app_log_group
  primary_aws_region                         = var.aws_region
  database_name                              = var.database_name
  database_port                              = var.database_port
  rds_secret_arn                             = data.terraform_remote_state.secrets.outputs.aurora_credential_secret_arn
  bff_secret_arn                             = data.terraform_remote_state.secrets.outputs.bff_client_secret_arn
  driver_service_secret_arn                  = data.terraform_remote_state.secrets.outputs.driver_service_secret_arn
  capstone_vpc_id                            = local.network_outputs.capstone_vpc_id
  bff_oauth2_secret_arn                      = data.terraform_remote_state.secrets.outputs.bff_oauth2_secret_arn
  ecs_desired_task                           = var.ecs_desired_task
  driver_blue_green_hook_function_arn        = module.driver_blue_green_hook.driver_blue_green_hook_function_arn
  driver_blue_green_hook_ecs_assume_role_arn = local.driver_blue_green_hook_ecs_assume_role_arn
  driver_health_path                         = var.driver_health_path
  driver_health_url                          = module.alb.capstone_alb_dns
  capstone_bff_blue_tg_arn                   = module.alb.capstone_bff_blue_tg_arn
  capstone_bff_green_tg_arn                  = module.alb.capstone_bff_green_tg_arn
  alb_production_listener_rule_arn           = module.alb.alb_production_listener_rule_arn
  ecs_invoke_alb_infras_role_arn             = local.ecs_invoke_alb_infras_role_arn
  bff_cpu_target                             = var.bff_cpu_target
  bff_max_capacity                           = var.bff_max_capacity
  bff_min_capacity                           = var.bff_min_capacity
  driver_cpu_target                          = var.driver_cpu_target
  driver_max_capacity                        = var.driver_max_capacity
  driver_min_capacity                        = var.driver_min_capacity
  capstone_rds_proxy_endpoint                = module.db-proxy.capstone_rds_proxy_endpoint

  depends_on = [module.database, module.redis, module.driver_blue_green_hook, module.db-proxy, module.iam]
}

# ===================
# Monitor module
# ===================
module "monitor" {
  source = "./modules/monitor"
}

# ===================================
# Application Load Balancer module
# ===================================
module "alb" {
  source = "./modules/alb"

  alb_tags                       = var.alb_tags
  capstone_vpc_id                = local.network_outputs.capstone_vpc_id
  capstone_alb_security_group_id = module.security.capstone_alb_security_group_id
  capstone_public_subnet_ids     = local.network_outputs.capstone_public_subnet_ids
}

# =================
# Redis module
# =================
module "redis" {
  source = "./modules/redis"

  redis_tags                         = var.redis_tags
  capstone_private_security_group_id = module.security.capstone_private_security_group_id
  capstone_vpc_id                    = local.network_outputs.capstone_vpc_id
  capstone_private_subnet_ids        = local.network_outputs.capstone_private_subnet_ids
  bastion_host_security_group_id     = module.bastion.bastion_host_security_group_id
}

# =====================
# Cloudfront module
# =====================
module "cloudfront" {
  source = "./modules/cdn"

  capstone_alb_dns                             = module.alb.capstone_alb_dns
  target_origin_id                             = var.target_origin_id
  cdn_tags                                     = var.cdn_tags
  cognito_jwt_edge_auth_function_qualified_arn = module.edge_authenticate_function.cognito_jwt_edge_auth_function_qualified_arn
}

# =====================================================
# Cognito JWT token authenticate edge function module
# =====================================================
module "edge_authenticate_function" {
  source = "./modules/function/edge-authenticate-function"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  cognito-jwt-edge-auth-execution-role_arn = local.cognito-jwt-edge-auth-execution-role_arn
}

# ====================
# RDS Proxy module
# ====================
module "db-proxy" {
  source = "./modules/db-proxy"

  database_tags                        = var.database_tags
  capstone_db_subnet_ids               = local.network_outputs.capstone_db_subnet_ids
  capstone_rds_proxy_security_group_id = module.security.capstone_rds_proxy_security_group_id
  capstone_aurora_cluster_identifier   = local.capstone_aurora_cluster_identifier
  aurora_credential_secret_arn         = data.terraform_remote_state.secrets.outputs.aurora_credential_secret_arn
  rds_proxy_role_arn                   = local.rds_proxy_role_arn

  depends_on = [module.database]
}

# ==============================================================================
# Initial ONLY ONCE on PRIMARY site deployment - Shared across multi-regions
# IAM resources + DB schema bucket storage
# ==============================================================================
module "iam" {
  count  = !var.enabled_dr ? 1 : 0
  source = "./modules/iam"
  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  capstone_db_schema_bucket_name = var.capstone_db_schema_bucket_name
  storage_tags                   = var.storage_tags
  driver_bg_validator_secret_arn = data.terraform_remote_state.secrets.outputs.driver_bg_validator_secret_arn
}