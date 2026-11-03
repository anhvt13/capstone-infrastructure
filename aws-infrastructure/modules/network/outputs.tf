output "capstone_nat_gateway_id" {
  description = "ID of the Regional NAT Gateway"
  value       = aws_nat_gateway.capstone-nat-gw.id
}

output "capstone_internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.capstone-igw.id
}