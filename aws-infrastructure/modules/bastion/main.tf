# =========================
# Bastion host security group
# ==========================
resource "aws_security_group" "capstone-bastion-sg" {
  name        = "capstone-bastion-sg"
  description = "Bastion host security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-bastion-sg"
    },
    var.bastion_tags
  )
}

# =================================
# Bastion host security group rules
# =================================
resource "aws_vpc_security_group_egress_rule" "bastion-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-bastion-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db-sg-inbound-rule" {
  security_group_id            = var.capstone_db_sg_id
  referenced_security_group_id = aws_security_group.capstone-bastion-sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

# =========================
# Bastion host ec2 instance
# ==========================
resource "aws_instance" "bastion-host" {
  ami                         = var.ami-id
  instance_type               = var.instance_type
  subnet_id                   = var.capstone_private_subnet_id
  associate_public_ip_address = false
  iam_instance_profile        = var.bastion_instance_profile_name
  vpc_security_group_ids      = [aws_security_group.capstone-bastion-sg.id]
  user_data                   = <<-EOF
                              #!/bin/bash
                              dnf update -y
                              dnf install -y postgresql17
                              dnf install -y valkey
                              EOF
  user_data_replace_on_change = true

  # depends_on = [
  #   aws_iam_role_policy_attachment.ssm,
  #   aws_iam_role_policy_attachment.bastion-iam-read-schema-bucket-policy-attach
  # ]

  tags = merge(
    {
      Name = "capstone-bastion"
    },
    var.bastion_tags
  )
}




