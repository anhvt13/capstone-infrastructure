output "capstone-db-schema-bucket-id" {
  description = "ID of the capstone db schema bucket"
  value       = aws_s3_bucket.capstone-db-schema-bucket.id
}

output "capstone-db-schema-bucket-arn" {
  description = "ARN of the capstone db schema bucket"
  value       = aws_s3_bucket.capstone-db-schema-bucket.arn
}

output "capstone-db-schema-bucket-name" {
  description = "Name of the capstone db schema bucket"
  value       = aws_s3_bucket.capstone-db-schema-bucket.bucket
}