output "cloudfront_domain_name" {
  description = "CloudFront HTTPS domain for the Capstone API"
  value       = aws_cloudfront_distribution.capstone-cloudfront.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.capstone-cloudfront.id
}
