output "dr_capstone_vpc_id" {
  description = "ID of the DR capstone vpc"
  value       = aws_vpc.dr-capstone-vpc.id
}

output "dr_capstone_vpc_cidr_block" {
  description = "CIDR block of the DR capstone vpc"
  value       = aws_vpc.dr-capstone-vpc.cidr_block
}

output "dr_capstone_public_subnet_ids" {
  description = "IDs of the DR capstone public subnets"
  value = [
    aws_subnet.dr-capstone-public-subnet-1.id,
    aws_subnet.dr-capstone-public-subnet-2.id
  ]
}

output "dr_capstone_public_subnet_1_id" {
  description = "ID of the DR capstone public subnet 1"
  value       = aws_subnet.dr-capstone-public-subnet-1.id
}

output "dr_capstone_public_subnet_2_id" {
  description = "ID of the DR capstone public subnet 2"
  value       = aws_subnet.dr-capstone-public-subnet-2.id
}

output "dr_capstone_private_subnet_ids" {
  description = "IDs of the DR capstone private subnets"
  value = [
    aws_subnet.dr-capstone-private-subnet-1.id,
    aws_subnet.dr-capstone-private-subnet-2.id
  ]
}

output "dr_capstone_private_subnet_1_id" {
  description = "ID of the DR capstone private subnet 1"
  value       = aws_subnet.dr-capstone-private-subnet-1.id
}

output "dr_capstone_private_subnet_2_id" {
  description = "ID of the DR capstone private subnet 2"
  value       = aws_subnet.dr-capstone-private-subnet-2.id
}

output "dr_capstone_db_subnet_ids" {
  description = "IDs of the DR database subnets"
  value = [
    aws_subnet.dr-capstone-db-subnet-1.id,
    aws_subnet.dr-capstone-db-subnet-2.id
  ]
}

output "dr_capstone_db_subnet_1_id" {
  description = "ID of the DR database subnet 1"
  value       = aws_subnet.dr-capstone-db-subnet-1.id
}

output "dr_capstone_db_subnet_2_id" {
  description = "ID of the DR database subnet 2"
  value       = aws_subnet.dr-capstone-db-subnet-2.id
}