
# ===============================
# Network Access Control List
# ================================
resource "aws_network_acl" "capstone-public-nacl" {
  vpc_id = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-public-nacl"
    },
    var.security_tags
  )
}

resource "aws_network_acl" "capstone-private-nacl" {
  vpc_id = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-private-nacl"
    },
    var.security_tags
  )
}

resource "aws_network_acl" "capstone-db-nacl" {
  vpc_id = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-db-nacl"
    },
    var.security_tags
  )
}

# ===============================
# NACL rule
# ===============================
resource "aws_network_acl_rule" "public-nacl-inbound-rule" {
  network_acl_id = aws_network_acl.capstone-public-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public-nacl-outbound-rule" {
  network_acl_id = aws_network_acl.capstone-public-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private-nacl-inbound-rule" {
  network_acl_id = aws_network_acl.capstone-private-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private-nacl-outbound-rule" {
  network_acl_id = aws_network_acl.capstone-private-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "db-nacl-inbound-rule" {
  network_acl_id = aws_network_acl.capstone-db-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = var.capstone_vpc_cidr_block
}

resource "aws_network_acl_rule" "db-nacl-outbound-rule" {
  network_acl_id = aws_network_acl.capstone-db-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = var.capstone_vpc_cidr_block
}

# ===============================
# NACL - Subnet association
# ===============================
resource "aws_network_acl_association" "public-nacl-subnet-1-associate" {
  network_acl_id = aws_network_acl.capstone-public-nacl.id
  subnet_id      = var.capstone_public_subnet_ids[0]
}

resource "aws_network_acl_association" "public-nacl-subnet-2-associate" {
  network_acl_id = aws_network_acl.capstone-public-nacl.id
  subnet_id      = var.capstone_public_subnet_ids[1]
}

resource "aws_network_acl_association" "private-nacl-subnet-1-associate" {
  network_acl_id = aws_network_acl.capstone-private-nacl.id
  subnet_id      = var.capstone_private_subnet_ids[0]
}

resource "aws_network_acl_association" "private-nacl-subnet-2-associate" {
  network_acl_id = aws_network_acl.capstone-private-nacl.id
  subnet_id      = var.capstone_private_subnet_ids[1]
}

resource "aws_network_acl_association" "db-nacl-subnet-1-associate" {
  network_acl_id = aws_network_acl.capstone-db-nacl.id
  subnet_id      = var.capstone_db_subnet_ids[0]
}

resource "aws_network_acl_association" "db-nacl-subnet-2-associate" {
  network_acl_id = aws_network_acl.capstone-db-nacl.id
  subnet_id      = var.capstone_db_subnet_ids[1]
}

# ===============================
# Security Group
# ===============================
resource "aws_security_group" "capstone-public-sg" {
  name        = "capstone-public-sg"
  description = "Public security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-public-sg"
    },
    var.security_tags
  )
}

resource "aws_security_group" "capstone-private-sg" {
  name        = "capstone-private-sg"
  description = "Private security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-private-sg"
    },
    var.security_tags
  )
}

resource "aws_security_group" "capstone-db-sg" {
  name        = "capstone-db-sg"
  description = "DB security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-db-sg"
    },
    var.security_tags
  )
}

resource "aws_security_group" "capstone-alb-sg" {
  name        = "capstone-alb-sg"
  description = "ALB security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-alb-sg"
    },
    var.security_tags
  )
}

# ============================
# Security Group Rule
# ============================
resource "aws_vpc_security_group_ingress_rule" "public-sg-inbound-rule" {
  security_group_id = aws_security_group.capstone-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "public-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "private-sg-inbound-rule" {
  security_group_id            = aws_security_group.capstone-private-sg.id
  referenced_security_group_id = aws_security_group.capstone-public-sg.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "private-sg-inbound-rule-for-bastion-host" {
  security_group_id            = aws_security_group.capstone-private-sg.id
  referenced_security_group_id = var.bastion_host_security_group_id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "private-sg-inbound-rule-for-alb-sg" {
  security_group_id            = aws_security_group.capstone-private-sg.id
  referenced_security_group_id = aws_security_group.capstone-alb-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_ingress_rule" "private-sg-inbound-rule-self-reference" {
  description                  = "Allow belong services can communicate to each others"
  security_group_id            = aws_security_group.capstone-private-sg.id
  referenced_security_group_id = aws_security_group.capstone-private-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8082
  to_port                      = 8082
}

resource "aws_vpc_security_group_egress_rule" "private-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-private-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db-sg-inbound-rule" {
  security_group_id            = aws_security_group.capstone-db-sg.id
  referenced_security_group_id = aws_security_group.capstone-private-sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-db-sg.id
  cidr_ipv4         = var.capstone_vpc_cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "alb-sg-inbound-rule" {
  security_group_id = aws_security_group.capstone-alb-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ==================================
# VPC interface endpoint security group
# ==================================
resource "aws_security_group" "capstone-vpc-endpoint-sg" {
  name        = "capstone-vpc-endpoint-sg"
  description = "VPC interface endpoint security group"
  vpc_id      = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-vpc-endpoint-sg"
    },
    var.security_tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "vpc-endpoint-sg-inbound-rule" {
  security_group_id            = aws_security_group.capstone-vpc-endpoint-sg.id
  referenced_security_group_id = aws_security_group.capstone-private-sg.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "vpc-endpoint-sg-inbound-bastion-sg-rule" {
  security_group_id            = aws_security_group.capstone-vpc-endpoint-sg.id
  referenced_security_group_id = var.bastion_host_security_group_id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "vpc-endpoint-sg-outbound-rule" {
  security_group_id = aws_security_group.capstone-vpc-endpoint-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
