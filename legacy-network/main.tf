# ==========================
# Primary Site Network module
# ==========================
module "primary-network" {
  source = "primary"
  providers = {
    aws = aws.primary
  }

  availability_zones             = data.aws_availability_zones.primary_availability_zones.names
  capstone_db_subnet_1_cidr      = var.capstone_db_subnet_1_cidr
  capstone_db_subnet_2_cidr      = var.capstone_db_subnet_2_cidr
  capstone_private_subnet_1_cidr = var.capstone_private_subnet_1_cidr
  capstone_private_subnet_2_cidr = var.capstone_private_subnet_2_cidr
  capstone_public_subnet_1_cidr  = var.capstone_public_subnet_1_cidr
  capstone_public_subnet_2_cidr  = var.capstone_public_subnet_2_cidr
  capstone_vpc_cidr              = var.capstone_vpc_cidr
  network_tags                   = var.network_tags
  security_tags                  = var.security_tags
}


# ==========================================
# Disaster Recovery (DR) Site Network module
# ==========================================
module "dr-network" {
  source = "dr"
  providers = {
    aws = aws.dr
  }

  availability_zones                = data.aws_availability_zones.dr_availability_zones.names
  dr_capstone_db_subnet_1_cidr      = var.dr_capstone_db_subnet_1_cidr
  dr_capstone_db_subnet_2_cidr      = var.dr_capstone_db_subnet_2_cidr
  dr_capstone_private_subnet_1_cidr = var.dr_capstone_private_subnet_1_cidr
  dr_capstone_private_subnet_2_cidr = var.dr_capstone_private_subnet_2_cidr
  dr_capstone_public_subnet_1_cidr  = var.dr_capstone_public_subnet_1_cidr
  dr_capstone_public_subnet_2_cidr  = var.dr_capstone_public_subnet_2_cidr
  dr_capstone_vpc_cidr              = var.dr_capstone_vpc_cidr
  network_tags                      = var.network_tags
  security_tags                     = var.security_tags
}