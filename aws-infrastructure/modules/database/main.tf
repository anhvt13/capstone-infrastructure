# ================================================================
# Filter AZs from particular region - Exclude "Local Zone" option
# =================================================================
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

# =====================
# DB subnet groups
# =====================
resource "aws_db_subnet_group" "capstone-aurora-subnet-group" {
  name       = "capstone-aurora-subnet-group"
  subnet_ids = var.capstone_db_subnet_ids

  tags = merge(
    {
      Name = "capstone-aurora-subnet-group"
    },
    var.database_tags
  )
}

# =====================
# Aurora cluster
# =====================
resource "aws_rds_cluster" "capstone-aurora-cluster" {
  cluster_identifier          = "capstone-aurora-cluster"
  engine                      = "aurora-postgresql"
  database_name               = var.capstone_database_name
  master_username             = var.capstone_master_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.capstone-aurora-subnet-group.name
  vpc_security_group_ids      = [var.capstone_db_security_group_id]
  skip_final_snapshot         = true
  serverlessv2_scaling_configuration {
    max_capacity             = 2
    min_capacity             = 0.5
    seconds_until_auto_pause = 900
  }

  tags = merge(
    {
      Name = "capstone-aurora-cluster"
    },
    var.database_tags
  )
}

# =====================
# Primary instance
# =====================
resource "aws_rds_cluster_instance" "primary-instance" {
  identifier          = "capstone-aurora-primary-instance"
  cluster_identifier  = aws_rds_cluster.capstone-aurora-cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.capstone-aurora-cluster.engine
  publicly_accessible = false
  availability_zone   = data.aws_availability_zones.available.names[0]

  tags = merge(
    {
      Name = "capstone-aurora-instance"
    },
    var.database_tags
  )
}

# =====================
# Replica instance
# =====================
resource "aws_rds_cluster_instance" "replica-instance" {
  identifier          = "capstone-aurora-replica-instance"
  cluster_identifier  = aws_rds_cluster.capstone-aurora-cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.capstone-aurora-cluster.engine
  publicly_accessible = false
  availability_zone   = data.aws_availability_zones.available.names[1]

  # Higher numbers mean lower priority. If the writer fails, AWS prefers lower tiers (1) to become the new primary.
  promotion_tier = 1

  tags = merge(
    {
      Name = "capstone-aurora-instance"
    },
    var.database_tags
  )
}





