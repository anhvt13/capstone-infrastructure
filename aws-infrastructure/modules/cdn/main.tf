# ===============================
# CloudFront Distribution
# ===============================
resource "aws_cloudfront_distribution" "capstone-cloudfront" {
  enabled         = true
  is_ipv6_enabled = false
  comment         = "Capstone Cloudfront Distribution"
  price_class     = "PriceClass_200"

  # Existing internet-facing ALB
  origin {
    domain_name = var.capstone_alb_dns
    origin_id   = "capstone-alb-origin"
    custom_origin_config {
      http_port  = 80
      https_port = 443

      # Connecting to ALB over HTTP protocol
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Use the AWS-managed default certificate on domain *.cloudfront.net
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Caching behavior
  default_cache_behavior {
    target_origin_id = "capstone-alb-origin"

    # Cloudfront redirect any HTTP requests from viewer to HTTPS
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    # AWS-managed CachingOptimized policy
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # AllViewerAndCloudFrontHeaders-2022-06 policy
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(
    {
      Name = "capstone-cdn"
    },
    var.cdn_tags
  )
}
