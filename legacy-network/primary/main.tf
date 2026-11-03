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
# Subnets
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

resource "aws_subnet" "capstone-db-subnet-2" {
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
