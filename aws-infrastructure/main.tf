# ====================
# Network module
# ====================
module "network" {
  source = "./modules/network"

  availability_zones             = data.aws_availability_zones.available.names
  capstone_db_subnet_1_cidr      = var.capstone_db_subnet_1_cidr
  capstone_db_subnet_2_cidr      = var.capstone_db_subnet_2_cidr
  capstone_private_subnet_1_cidr = var.capstone_private_subnet_1_cidr
  capstone_private_subnet_2_cidr = var.capstone_private_subnet_2_cidr
  capstone_public_subnet_1_cidr  = var.capstone_public_subnet_1_cidr
  capstone_public_subnet_2_cidr  = var.capstone_public_subnet_2_cidr
  capstone_vpc_cidr              = var.capstone_vpc_cidr
  aws_region                     = var.primary_aws_region
  network_tags                   = var.network_tags
  capstone_vpc_endpoint_sg_id    = module.security.capstone_vpc_endpoint_sg_id
}

# =====================
# Security module
# =====================
module "security" {
  source = "./modules/security"

  capstone_vpc_id                = module.network.capstone_vpc_id
  capstone_vpc_cidr_block        = module.network.capstone_vpc_cidr_block
  capstone_db_subnet_ids         = module.network.capstone_db_subnet_ids
  capstone_private_subnet_ids    = module.network.capstone_private_subnet_ids
  capstone_public_subnet_ids     = module.network.capstone_public_subnet_ids
  security_tags                  = var.security_tags
  bastion_host_security_group_id = module.bastion.bastion_host_security_group_id
}

# =====================
# Database module
# =====================
module "database" {
  source = "./modules/database"

  capstone_database_name        = var.capstone_database_name
  capstone_master_username      = var.capstone_master_username
  capstone_db_security_group_id = module.security.capstone_db_security_group_id
  capstone_db_subnet_ids        = module.network.capstone_db_subnet_ids
  database_tags                 = var.database_tags
}

# =====================
# Bastion host module
# =====================
module "bastion" {
  source = "./modules/bastion"

  capstone_vpc_id               = module.network.capstone_vpc_id
  capstone_private_subnet_id    = module.network.capstone_private_subnet_ids[0]
  instance_type                 = var.capstone_ec2_instance_type
  capstone-db-sg-id             = module.security.capstone_db_security_group_id
  ami-id                        = data.aws_ssm_parameter.al2023_arm64.value
  db_secret_arn                 = module.database.rds_secret_arn
  bastion_tags                  = var.bastion_tags
  capstone-db-schema-bucket-arn = module.storage.capstone-db-schema-bucket-arn
  security_tags                 = var.security_tags
}

# =====================
# Storage module
# =====================
module "storage" {
  source = "./modules/storage"

  capstone_db_schema_bucket_name = var.capstone_db_schema_bucket_name
  bastion-host-role-arn          = module.bastion.bastion_host_ssm_role_arn
  storage_tags                   = var.storage_tags
}

# =====================
# Secret Manager module
# =====================
module "secret" {
  source = "./modules/secret"

  secret_tags                  = var.secret_tags
  driver_keystore_password     = var.driver_keystore_password
  driver_truststore_password   = var.driver_truststore_password
  bff_client_keystore_password = var.bff_client_keystore_password
  bff_server_keystore_password = var.bff_server_keystore_password
  bff_truststore_password      = var.bff_truststore_password
  driver_m2m_client_id         = var.driver_m2m_client_id
  driver_m2m_client_secret     = var.driver_m2m_client_secret
}

# =====================
# Container module
# =====================
module "container" {
  source = "./modules/container"

  container_tags              = var.container_tags
  driver_service_ecr_uri      = var.driver_service_ecr_uri
  bff_client_ecr_uri          = var.bff_client_ecr_uri
  capstone_private_sg_id      = module.security.capstone_private_security_group_id
  capstone_private_subnet_ids = module.network.capstone_private_subnet_ids
  ecs_capstone_app_log_group  = module.monitor.ecs_capstone_app_log_group
  primary_aws_region          = var.primary_aws_region
  capstone_aurora_cluster_ep  = module.database.capstone_aurora_cluster_ep
  database_name               = var.database_name
  database_port               = var.database_port
  rds_secret_arn              = module.database.rds_secret_arn
  bff_secret_arn              = module.secret.bff_client_secret_arn
  driver_service_secret_arn   = module.secret.driver_service_secret_arn
  capstone_vpc_id             = module.network.capstone_vpc_id
  capstone_bff_tg_arn         = module.alb.capstone_bff_tg_arn

  depends_on = [module.database, module.redis]
}

# =====================
# Monitor module
# =====================
module "monitor" {
  source = "./modules/monitor"
}

# ================================
# Application Load Balancer module
# ================================
module "alb" {
  source = "./modules/alb"

  alb_tags                       = var.alb_tags
  capstone_vpc_id                = module.network.capstone_vpc_id
  capstone_alb_security_group_id = module.security.capstone_alb_security_group_id
  capstone_public_subnet_ids     = module.network.capstone_public_subnet_ids
}

# =====================
# Redis module
# =====================
module "redis" {
  source = "./modules/redis"

  redis_tags                         = var.redis_tags
  capstone_private_security_group_id = module.security.capstone_private_security_group_id
  capstone_vpc_id                    = module.network.capstone_vpc_id
  capstone_private_subnet_ids        = module.network.capstone_private_subnet_ids
}
