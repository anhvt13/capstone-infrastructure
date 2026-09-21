# ===============================
# Database schema bucket
# ================================
resource "aws_s3_bucket" "capstone-db-schema-bucket" {
  bucket           = var.capstone_db_schema_bucket_name
  bucket_namespace = "account-regional"

  tags = merge(
    {
      Name = var.capstone_db_schema_bucket_name
    },
    var.storage_tags
  )
}

# ===============================
# BLocked public access
# ================================
resource "aws_s3_bucket_public_access_block" "capstone_storage" {
  bucket                  = aws_s3_bucket.capstone-db-schema-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ===============================
# Enable versioning
# ================================
resource "aws_s3_bucket_versioning" "capstone_storage" {
  bucket = aws_s3_bucket.capstone-db-schema-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ===============================
# Enable default server-side encryption
# ================================
resource "aws_s3_bucket_server_side_encryption_configuration" "capstone_storage" {
  bucket = aws_s3_bucket.capstone-db-schema-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ===============================
# Bucket policy definement
# ================================
data "aws_iam_policy_document" "allow-access-from-bastion-host" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        var.bastion-host-role-arn
      ]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.capstone-db-schema-bucket.arn,
      "${aws_s3_bucket.capstone-db-schema-bucket.arn}/*",
    ]
  }
}

# ===============================
# Bucket policy granted
# ================================
resource "aws_s3_bucket_policy" "allow-access-from-bastion-host" {
  bucket = aws_s3_bucket.capstone-db-schema-bucket.id
  policy = data.aws_iam_policy_document.allow-access-from-bastion-host.json
}