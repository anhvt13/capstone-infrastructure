
# ===============================
# VPC
# ===============================
resource "aws_vpc" "capstone-vpc" {
  cidr_block           = var.capstone_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.network_tags,
    {
      Name = "capstone-vpc"
    }
  )
}

# ===============================
# Subnet
# ===============================
resource "aws_subnet" "capstone-public-subnet-1" {
  vpc_id                  = aws_vpc.capstone-vpc.id
  cidr_block              = var.capstone_public_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-subnet-1"
    },
    var.network_tags
  )
}

resource "aws_subnet" "capstone-public-subnet-2" {
  vpc_id                  = aws_vpc.capstone-vpc.id
  cidr_block              = var.capstone_public_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-subnet-2"
    },
    var.network_tags
  )
}

resource "aws_subnet" "capstone-private-subnet-1" {
  vpc_id            = aws_vpc.capstone-vpc.id
  cidr_block        = var.capstone_private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = merge(
    {
      Name = "private-subnet-1"
    },
    var.network_tags
  )
}

resource "aws_subnet" "capstone-private-subnet-2" {
  vpc_id            = aws_vpc.capstone-vpc.id
  cidr_block        = var.capstone_private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = merge(
    {
      Name = "private-subnet-2"
    },
    var.network_tags
  )
}

resource "aws_subnet" "capstone-db-subnet-1" {
  vpc_id            = aws_vpc.capstone-vpc.id
  cidr_block        = var.capstone_db_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = merge(
    {
      Name = "db-subnet-1"
    },
    var.network_tags
  )
}

resource "aws_subnet" "capstone-db_subnet_2" {
  vpc_id            = aws_vpc.capstone-vpc.id
  cidr_block        = var.capstone_db_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = merge(
    {
      Name = "db-subnet-2"
    },
    var.network_tags
  )
}

# ===============================
# Internet Gateway
# ================================
resource "aws_internet_gateway" "capstone-igw" {
  vpc_id = aws_vpc.capstone-vpc.id

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
  allocation_id     = aws_eip.capstone-nat-eip.id
  subnet_id         = aws_subnet.capstone-public-subnet-1.id
  depends_on        = [aws_internet_gateway.capstone-igw]

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
  vpc_id       = aws_vpc.capstone-vpc.id

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
  vpc_id           = aws_vpc.capstone-vpc.id

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
  vpc_id = aws_vpc.capstone-vpc.id

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
  subnet_id      = aws_subnet.capstone-public-subnet-1.id
  route_table_id = aws_route_table.capstone-public-rt.id
}

resource "aws_route_table_association" "capstone-public-rt-associate-2" {
  subnet_id      = aws_subnet.capstone-public-subnet-2.id
  route_table_id = aws_route_table.capstone-public-rt.id
}

resource "aws_route_table_association" "capstone-private-rt-associate-1" {
  subnet_id      = aws_subnet.capstone-private-subnet-1.id
  route_table_id = aws_route_table.capstone-private-rt.id
}

resource "aws_route_table_association" "capstone-private-rt-associate-2" {
  subnet_id      = aws_subnet.capstone-private-subnet-2.id
  route_table_id = aws_route_table.capstone-private-rt.id
}

resource "aws_route_table_association" "capstone-db-rt-associate-1" {
  subnet_id      = aws_subnet.capstone-db-subnet-1.id
  route_table_id = aws_route_table.capstone-db-rt.id
}

resource "aws_route_table_association" "capstone-db-rt-associate-2" {
  subnet_id      = aws_subnet.capstone-db_subnet_2.id
  route_table_id = aws_route_table.capstone-db-rt.id
}

# ===============================
# S3 Endpoint
# ================================
resource "aws_vpc_endpoint" "capstone-s3-gw-ep" {
  vpc_id            = aws_vpc.capstone-vpc.id
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
# ECR Endpoint
# ================================
resource "aws_vpc_endpoint" "ecr-ep" {
  vpc_id              = aws_vpc.capstone-vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids = [
    aws_subnet.capstone-private-subnet-1.id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-ecr-api-endpoint"
    },
    var.network_tags
  )
}

# ======================================
# Docker Endpoint (Docker layer in ECR)
# =======================================
resource "aws_vpc_endpoint" "ecr-dkr-ep" {
  vpc_id              = aws_vpc.capstone-vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids = [
    aws_subnet.capstone-private-subnet-1.id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-ecr-dkr-endpoint"
    },
    var.network_tags
  )
}

# ======================================
# Secrets Manager Endpoint
# =======================================
resource "aws_vpc_endpoint" "secrets-manager-ep" {
  vpc_id            = aws_vpc.capstone-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.capstone-private-subnet-1.id
  ]
  security_group_ids = [
    var.capstone_vpc_endpoint_sg_id
  ]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "capstone-secrets-managet-endpoint"
    },
    var.network_tags
  )
}


