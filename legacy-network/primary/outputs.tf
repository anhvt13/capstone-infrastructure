output "capstone_vpc_id" {
  description = "ID of the capstone vpc"
  value       = aws_vpc.capstone-vpc.id
}

output "capstone_vpc_cidr_block" {
  description = "CIDR block of the capstone vpc"
  value       = aws_vpc.capstone-vpc.cidr_block
}

output "capstone_public_subnet_ids" {
  description = "IDs of the capstone public subnets"
  value = [
    aws_subnet.capstone-public-subnet-1.id,
    aws_subnet.capstone-public-subnet-2.id
  ]
}

output "capstone_public_subnet_1_id" {
  description = "ID of the capstone public subnet 1"
  value       = aws_subnet.capstone-public-subnet-1.id
}

output "capstone_public_subnet_2_id" {
  description = "ID of the capstone public subnet 2"
  value       = aws_subnet.capstone-public-subnet-2.id
}

output "capstone_private_subnet_ids" {
  description = "IDs of the capstone private subnets"
  value = [
    aws_subnet.capstone-private-subnet-1.id,
    aws_subnet.capstone-private-subnet-2.id
  ]
}

output "capstone_private_subnet_1_id" {
  description = "ID of the capstone private subnet 1"
  value       = aws_subnet.capstone-private-subnet-1.id
}

output "capstone_private_subnet_2_id" {
  description = "ID of the capstone private subnet 2"
  value       = aws_subnet.capstone-private-subnet-2.id
}

output "capstone_db_subnet_ids" {
  description = "IDs of the database subnets"
  value = [
    aws_subnet.capstone-db-subnet-1.id,
    aws_subnet.capstone-db-subnet-2.id
  ]
}

output "capstone_db_subnet_1_id" {
  description = "ID of the database subnet 1"
  value       = aws_subnet.capstone-db-subnet-1.id
}

output "capstone_db_subnet_2_id" {
  description = "ID of the database subnet 2"
  value       = aws_subnet.capstone-db-subnet-2.id
}