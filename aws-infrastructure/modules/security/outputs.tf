output "capstone_db_security_group_id" {
  description = "Id of DB security group"
  value       = aws_security_group.capstone-db-sg.id
}

output "capstone_vpc_endpoint_sg_id" {
  description = "Id of vpc interface endpoint security group"
  value       = aws_security_group.capstone-vpc-endpoint-sg.id
}

output "capstone_private_security_group_id" {
  description = "Id of private security group"
  value       = aws_security_group.capstone-private-sg.id
}

output "capstone_alb_security_group_id" {
  description = "Id of alb security group"
  value       = aws_security_group.capstone-alb-sg.id
}

