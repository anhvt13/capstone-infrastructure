# ===============================
# DR VPC
# ===============================
resource "aws_vpc" "dr-capstone-vpc" {
  cidr_block           = var.dr_capstone_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.network_tags,
    {
      Name = "dr-capstone-vpc"
    }
  )
}

# ===============================
# DR Subnets
# ===============================
resource "aws_subnet" "dr-capstone-public-subnet-1" {
  vpc_id                  = aws_vpc.dr-capstone-vpc.id
  cidr_block              = var.dr_capstone_public_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "dr-public-subnet-1"
    },
    var.network_tags
  )
}

resource "aws_subnet" "dr-capstone-public-subnet-2" {
  vpc_id                  = aws_vpc.dr-capstone-vpc.id
  cidr_block              = var.dr_capstone_public_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "dr-public-subnet-2"
    },
    var.network_tags
  )
}

resource "aws_subnet" "dr-capstone-private-subnet-1" {
  vpc_id            = aws_vpc.dr-capstone-vpc.id
  cidr_block        = var.dr_capstone_private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = merge(
    {
      Name = "dr-private-subnet-1"
    },
    var.network_tags
  )
}

resource "aws_subnet" "dr-capstone-private-subnet-2" {
  vpc_id            = aws_vpc.dr-capstone-vpc.id
  cidr_block        = var.dr_capstone_private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = merge(
    {
      Name = "dr-private-subnet-2"
    },
    var.network_tags
  )
}

resource "aws_subnet" "dr-capstone-db-subnet-1" {
  vpc_id            = aws_vpc.dr-capstone-vpc.id
  cidr_block        = var.dr_capstone_db_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = merge(
    {
      Name = "dr-db-subnet-1"
    },
    var.network_tags
  )
}

resource "aws_subnet" "dr-capstone-db-subnet-2" {
  vpc_id            = aws_vpc.dr-capstone-vpc.id
  cidr_block        = var.dr_capstone_db_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = merge(
    {
      Name = "dr-db-subnet-2"
    },
    var.network_tags
  )
}

