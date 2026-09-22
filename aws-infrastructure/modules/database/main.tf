
# =====================
# DB subnet groups
# =====================
resource "aws_db_subnet_group" "aurora" {
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
resource "aws_rds_cluster" "aurora" {
  cluster_identifier          = "capstone-aurora-cluster"
  engine                      = "aurora-postgresql"
  database_name               = var.capstone_database_name
  master_username             = var.capstone_master_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.aurora.name
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
# Aurora instance
# =====================
resource "aws_rds_cluster_instance" "aurora" {
  identifier          = "capstone-aurora-instance"
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.aurora.engine
  publicly_accessible = false

  tags = merge(
    {
      Name = "capstone-aurora-instance"
    },
    var.database_tags
  )
}





