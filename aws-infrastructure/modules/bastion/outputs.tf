output "bastion_host_instance_id" {
  description = "Bastion host instance ID"
  value       = aws_instance.bastion-host.id
}

output "bastion_host_ssm_role_arn" {
  description = "ARN of bastion role"
  value       = aws_iam_role.capstone-bastion-ssm-role.arn
}

output "bastion_host_private_ip" {
  description = "Private IP address of the bastion"
  value       = aws_instance.bastion-host.private_ip
}

output "bastion_host_security_group_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.capstone-bastion-sg.id
}