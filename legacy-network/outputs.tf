output "capstone_vpc_id" {
  description = "ID of the capstone vpc"
  value       = module.primary-network.capstone_vpc_id
}

output "capstone_vpc_cidr_block" {
  description = "CIDR block of the capstone vpc"
  value       = module.primary-network.capstone_vpc_cidr_block
}

output "capstone_public_subnet_ids" {
  description = "IDs of the capstone public subnets"
  value       = module.primary-network.capstone_public_subnet_ids

}

output "capstone_public_subnet_1_id" {
  description = "ID of the capstone public subnet 1"
  value       = module.primary-network.capstone_public_subnet_1_id
}

output "capstone_public_subnet_2_id" {
  description = "ID of the capstone public subnet 2"
  value       = module.primary-network.capstone_public_subnet_2_id
}

output "capstone_private_subnet_ids" {
  description = "IDs of the capstone private subnets"
  value       = module.primary-network.capstone_private_subnet_ids
}

output "capstone_private_subnet_1_id" {
  description = "ID of the capstone private subnet 1"
  value       = module.primary-network.capstone_private_subnet_1_id
}

output "capstone_private_subnet_2_id" {
  description = "ID of the capstone private subnet 2"
  value       = module.primary-network.capstone_private_subnet_2_id
}

output "capstone_db_subnet_ids" {
  description = "IDs of the database subnets"
  value       = module.primary-network.capstone_db_subnet_ids
}

output "capstone_db_subnet_1_id" {
  description = "ID of the database subnet 1"
  value       = module.primary-network.capstone_db_subnet_1_id
}

output "capstone_db_subnet_2_id" {
  description = "ID of the database subnet 2"
  value       = module.primary-network.capstone_db_subnet_2_id
}

output "capstone_db_sg_id" {
  description = "ID of database security group"
  value       = module.primary-network.capstone_db_sg_id
}

output "dr_capstone_vpc_id" {
  description = "ID of the DR capstone vpc"
  value       = module.dr-network.dr_capstone_vpc_id
}

output "dr_capstone_vpc_cidr_block" {
  description = "CIDR block of the DR capstone vpc"
  value       = module.dr-network.dr_capstone_vpc_cidr_block
}

output "dr_capstone_public_subnet_ids" {
  description = "IDs of the DR capstone public subnets"
  value       = module.dr-network.dr_capstone_public_subnet_ids
}

output "dr_capstone_public_subnet_1_id" {
  description = "ID of the DR capstone public subnet 1"
  value       = module.dr-network.dr_capstone_public_subnet_1_id
}

output "dr_capstone_public_subnet_2_id" {
  description = "ID of the DR capstone public subnet 2"
  value       = module.dr-network.dr_capstone_public_subnet_2_id
}

output "dr_capstone_private_subnet_ids" {
  description = "IDs of the DR capstone private subnets"
  value       = module.dr-network.dr_capstone_private_subnet_ids
}

output "dr_capstone_private_subnet_1_id" {
  description = "ID of the DR capstone private subnet 1"
  value       = module.dr-network.dr_capstone_private_subnet_1_id
}

output "dr_capstone_private_subnet_2_id" {
  description = "ID of the DR capstone private subnet 2"
  value       = module.dr-network.dr_capstone_private_subnet_2_id
}

output "dr_capstone_db_subnet_ids" {
  description = "IDs of the DR database subnets"
  value       = module.dr-network.dr_capstone_db_subnet_ids
}

output "dr_capstone_db_subnet_1_id" {
  description = "ID of the DR database subnet 1"
  value       = module.dr-network.dr_capstone_db_subnet_1_id
}

output "dr_capstone_db_subnet_2_id" {
  description = "ID of the DR database subnet 2"
  value       = module.dr-network.dr_capstone_db_subnet_2_id
}

output "dr_capstone_db_sg_id" {
  description = "ID of DR database security group"
  value       = module.dr-network.dr_capstone_db_sg_id
}