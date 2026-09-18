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

output "capstone_private_subnet_ids" {
  description = "IDs of the capstone private subnets"
  value = [
    aws_subnet.capstone-private-subnet-1.id,
    aws_subnet.capstone-private-subnet-2.id
  ]
}

output "capstone_db_subnet_ids" {
  description = "IDs of the database subnets"
  value = [
    aws_subnet.capstone-db-subnet-1.id,
    aws_subnet.capstone-db_subnet_2.id
  ]
}

output "capstone_nat_gateway_id" {
  description = "ID of the Regional NAT Gateway"
  value       = aws_nat_gateway.capstone-nat-gw.id
}

output "capstone_internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.capstone-igw.id
}