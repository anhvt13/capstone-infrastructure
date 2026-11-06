# =================================================================
#  Ephemeral resource reads a database credential secret
# =================================================================
ephemeral "aws_secretsmanager_secret_version" "aurora_master" {
  secret_id = var.aurora_credential_secret_arn
}

# =================================================================
# Filter AZs from particular region - Exclude "Local Zone" option
# =================================================================
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

# ============================
# KMS Key for RDS on DR site
# ============================
data "aws_kms_key" "dr_rds" {
  provider = aws.dr_site
  key_id   = "alias/aws/rds"
}


# ===================================
# DB subnet groups - Primary Site
# ===================================
resource "aws_db_subnet_group" "capstone-db-subnet-group" {
  name       = "capstone-db-subnet-group"
  subnet_ids = var.capstone_db_subnet_ids

  tags = merge(
    {
      Name = "capstone-aurora-subnet-group"
    },
    var.database_tags
  )
}

# ===================================
# DB subnet groups - DR Site
# ===================================
resource "aws_db_subnet_group" "dr-capstone-db-subnet-group" {
  provider   = aws.dr_site
  name       = "dr-capstone-db-subnet-group"
  subnet_ids = var.dr_capstone_db_subnet_ids

  tags = merge(
    {
      Name = "dr-capstone-db-subnet-group"
    },
    var.database_tags
  )
}

# ===================================
# Aurora Global Database
# ===================================
resource "aws_rds_global_cluster" "capstone-global-cluster" {
  global_cluster_identifier = "capstone-global-cluster"
  engine                    = "aurora-postgresql"
  engine_version            = var.aurora_engine_version
  database_name             = var.capstone_database_name
  storage_encrypted         = true
  deletion_protection       = false
}

# ========================
# Primary Cluster
# ========================
resource "aws_rds_cluster" "capstone-cluster" {
  cluster_identifier         = "capstone-cluster"
  engine                     = aws_rds_global_cluster.capstone-global-cluster.engine
  engine_version             = aws_rds_global_cluster.capstone-global-cluster.engine_version
  global_cluster_identifier  = aws_rds_global_cluster.capstone-global-cluster.id
  database_name              = var.capstone_database_name
  master_username            = var.aurora_master_username
  master_password_wo         = jsondecode(ephemeral.aws_secretsmanager_secret_version.aurora_master.secret_string).password
  master_password_wo_version = 1
  db_subnet_group_name       = aws_db_subnet_group.capstone-db-subnet-group.name
  vpc_security_group_ids     = [var.capstone_db_security_group_id]
  skip_final_snapshot        = true
  serverlessv2_scaling_configuration {
    max_capacity             = 2
    min_capacity             = 0.5
    seconds_until_auto_pause = 900
  }
  apply_immediately = true

  tags = merge(
    {
      Name = "capstone-cluster"
    },
    var.database_tags
  )
}

# =====================
# Primary instance
# =====================
resource "aws_rds_cluster_instance" "capstone-primary-instance" {
  identifier          = "capstone-primary-instance"
  cluster_identifier  = aws_rds_cluster.capstone-cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_global_cluster.capstone-global-cluster.engine
  engine_version      = aws_rds_global_cluster.capstone-global-cluster.engine_version
  publicly_accessible = false
  availability_zone   = data.aws_availability_zones.available.names[0]

  tags = merge(
    {
      Name = "capstone-primary-instance"
    },
    var.database_tags
  )
}

# ===============================
# (Primary site) Replica instance
# ===============================
resource "aws_rds_cluster_instance" "capstone-replica-instance" {
  identifier          = "capstone-replica-instance"
  cluster_identifier  = aws_rds_cluster.capstone-cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_global_cluster.capstone-global-cluster.engine
  engine_version      = aws_rds_global_cluster.capstone-global-cluster.engine_version
  publicly_accessible = false
  availability_zone   = data.aws_availability_zones.available.names[1]

  # Higher numbers mean lower priority. If the writer fails, AWS prefers lower tiers (1) to become the new primary.
  promotion_tier = 1

  tags = merge(
    {
      Name = "capstone-replica-instance"
    },
    var.database_tags
  )
}

# ========================
# DR Cluster
# ========================
resource "aws_rds_cluster" "dr-capstone-cluster" {
  provider                  = aws.dr_site
  cluster_identifier        = "capstone-dr-cluster"
  engine                    = aws_rds_global_cluster.capstone-global-cluster.engine
  engine_version            = aws_rds_global_cluster.capstone-global-cluster.engine_version
  global_cluster_identifier = aws_rds_global_cluster.capstone-global-cluster.id
  db_subnet_group_name      = aws_db_subnet_group.dr-capstone-db-subnet-group.name
  vpc_security_group_ids    = [var.dr_capstone_db_security_group_id]
  skip_final_snapshot       = true

  # Explicitly AWS-managed kms key for RDS in DR site
  storage_encrypted = true
  kms_key_id        = data.aws_kms_key.dr_rds.arn

  serverlessv2_scaling_configuration {
    max_capacity             = 2
    min_capacity             = 0.5
    seconds_until_auto_pause = 900
  }

  tags = merge(
    {
      Name = "dr-capstone-cluster"
    },
    var.database_tags
  )
}

# =====================
# (DR) Primary instance
# =====================
resource "aws_rds_cluster_instance" "dr-capstone-primary-instance" {
  identifier          = "dr-capstone-primary-instance"
  cluster_identifier  = aws_rds_cluster.dr-capstone-cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_global_cluster.capstone-global-cluster.engine
  engine_version      = aws_rds_global_cluster.capstone-global-cluster.engine_version
  publicly_accessible = false
  availability_zone   = data.aws_availability_zones.available.names[0]

  tags = merge(
    {
      Name = "dr-capstone-primary-instance"
    },
    var.database_tags
  )
}

# ===============================
# (DR) Replica instance
# ===============================
resource "aws_rds_cluster_instance" "dr-capstone-replica-instance" {
  identifier          = "dr-capstone-replica-instance"
  cluster_identifier  = aws_rds_cluster.dr-capstone-cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_global_cluster.capstone-global-cluster.engine
  engine_version      = aws_rds_global_cluster.capstone-global-cluster.engine_version
  publicly_accessible = false
  availability_zone   = data.aws_availability_zones.available.names[1]

  # Higher numbers mean lower priority. If the writer fails, AWS prefers lower tiers (1) to become the new primary.
  promotion_tier = 1

  tags = merge(
    {
      Name = "dr-capstone-replica-instance"
    },
    var.database_tags
  )
}




