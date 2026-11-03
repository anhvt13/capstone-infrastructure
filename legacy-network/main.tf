# ==========================
# Primary Site Network module
# ==========================
module "primary-network" {
  source = "./primary"

  availability_zones             = data.aws_availability_zones.available.names
  capstone_db_subnet_1_cidr      = var.capstone_db_subnet_1_cidr
  capstone_db_subnet_2_cidr      = var.capstone_db_subnet_2_cidr
  capstone_private_subnet_1_cidr = var.capstone_private_subnet_1_cidr
  capstone_private_subnet_2_cidr = var.capstone_private_subnet_2_cidr
  capstone_public_subnet_1_cidr  = var.capstone_public_subnet_1_cidr
  capstone_public_subnet_2_cidr  = var.capstone_public_subnet_2_cidr
  capstone_vpc_cidr              = var.capstone_vpc_cidr
  network_tags                   = var.network_tags
}


# ==========================================
# Disaster Recovery (DR) Site Network module
# ==========================================
module "dr-network" {
  source = "./dr"

  availability_zones                = data.aws_availability_zones.available.names
  dr_capstone_db_subnet_1_cidr      = var.dr_capstone_db_subnet_1_cidr
  dr_capstone_db_subnet_2_cidr      = var.dr_capstone_db_subnet_2_cidr
  dr_capstone_private_subnet_1_cidr = var.dr_capstone_private_subnet_1_cidr
  dr_capstone_private_subnet_2_cidr = var.dr_capstone_private_subnet_2_cidr
  dr_capstone_public_subnet_1_cidr  = var.dr_capstone_public_subnet_1_cidr
  dr_capstone_public_subnet_2_cidr  = var.dr_capstone_public_subnet_2_cidr
  dr_capstone_vpc_cidr              = var.dr_capstone_vpc_cidr
  network_tags                      = var.network_tags
}