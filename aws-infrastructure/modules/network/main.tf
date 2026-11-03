# ===============================
# Internet Gateway
# ================================
resource "aws_internet_gateway" "capstone-igw" {
  vpc_id = var.capstone_vpc_id

  tags = merge(
    {
      Name = "capstone-igw"
    },
    var.network_tags
  )
}

# =========================================================
# NAT Gateway (allows Private Subnets to reach the internet)
# =========================================================
resource "aws_eip" "capstone-nat-eip" {
  domain = "vpc"

  tags = merge(
    {
      Name = "capstone-nat-eip"
    },
    var.network_tags
  )
}

resource "aws_nat_gateway" "capstone-nat-gw" {
  allocation_id = aws_eip.capstone-nat-eip.id
  subnet_id     = var.capstone_public_subnet_1_id
  depends_on    = [aws_internet_gateway.capstone-igw]

  tags = merge(
    {
      Name = "capstone-nat-gateway"
    },
    var.network_tags
  )
}

# ===============================
# Route Table
# ================================
resource "aws_route_table" "capstone-public-rt" {
  vpc_id = var.capstone_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.capstone-igw.id
  }

  tags = merge(
    {
      Name = "public-route-table"
    },
    var.network_tags
  )
}

resource "aws_route_table" "capstone-private-rt" {
  vpc_id = var.capstone_vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.capstone-nat-gw.id
  }

  tags = merge(
    {
      Name = "private-route-table"
    },
    var.network_tags
  )
}

resource "aws_route_table" "capstone-db-rt" {
  vpc_id = var.capstone_vpc_id

  tags = merge(
    {
      Name = "db-route-table"
    },
    var.network_tags
  )
}

# ===============================
# Route Table - Subnet association
# ================================
resource "aws_route_table_association" "capstone-public-rt-associate-1" {
  subnet_id      = var.capstone_public_subnet_1_id
  route_table_id = aws_route_table.capstone-public-rt.id
}

resource "aws_route_table_association" "capstone-public-rt-associate-2" {
  subnet_id      = var.capstone_public_subnet_2_id
  route_table_id = aws_route_table.capstone-public-rt.id
}

resource "aws_route_table_association" "capstone-private-rt-associate-1" {
  subnet_id      = var.capstone_private_subnet_1_id
  route_table_id = aws_route_table.capstone-private-rt.id
}

resource "aws_route_table_association" "capstone-private-rt-associate-2" {
  subnet_id      = var.capstone_private_subnet_2_id
  route_table_id = aws_route_table.capstone-private-rt.id
}

resource "aws_route_table_association" "capstone-db-rt-associate-1" {
  subnet_id      = var.capstone_db_subnet_1_id
  route_table_id = aws_route_table.capstone-db-rt.id
}

resource "aws_route_table_association" "capstone-db-rt-associate-2" {
  subnet_id      = var.capstone_db_subnet_2_id
  route_table_id = aws_route_table.capstone-db-rt.id
}

# ===============================
# S3 Gateway Endpoint
# ================================
resource "aws_vpc_endpoint" "capstone-s3-gw-ep" {
  vpc_id            = var.capstone_vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.capstone-private-rt.id
  ]

  tags = merge(
    {
      Name = "capstone-s3-gateway-endpoint"
    },
    var.network_tags
  )
}

# ===============================
# ECR Interface Endpoint
# ================================
resource "aws_vpc_endpoint" "ecr-ep" {
  vpc_id            = var.capstone_vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.capstone_private_subnet_1_id,
    var.capstone_private_subnet_2_id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-ecr-interface-endpoint"
    },
    var.network_tags
  )
}

# ======================================
# Docker Interface Endpoint (Docker layer in ECR)
# =======================================
resource "aws_vpc_endpoint" "ecr-dkr-ep" {
  vpc_id            = var.capstone_vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.capstone_private_subnet_1_id,
    var.capstone_private_subnet_2_id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-ecr-dkr-interface-endpoint"
    },
    var.network_tags
  )
}

# ======================================
# Secrets Manager Interface Endpoint
# =======================================
resource "aws_vpc_endpoint" "secrets-manager-ep" {
  vpc_id            = var.capstone_vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.capstone_private_subnet_1_id,
    var.capstone_private_subnet_2_id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-secrets-manager-interface-endpoint"
    },
    var.network_tags
  )
}

# ======================================
# ECS Interface Endpoint
# =======================================
resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = var.capstone_vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.capstone_private_subnet_1_id,
    var.capstone_private_subnet_2_id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "casptone-ecs-interface-endpoint"
    },
    var.network_tags
  )
}

# =============================================
# AWS System Manager (SSM) Interface Endpoint
# =============================================
locals {
  ssm_interface_endpoints = {
    ssm = {
      service = "ssm"
    }
    ssmmessages = {
      service = "ssmmessages"
    }
    ec2messages = {
      service = "ec2messages"
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  for_each          = local.ssm_interface_endpoints
  vpc_id            = var.capstone_vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.${each.value.service}"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.capstone_private_subnet_1_id,
    var.capstone_private_subnet_2_id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-${each.key}-interface-endpoint"
    },
    var.network_tags
  )
}

