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
    origin_id   = var.target_origin_id
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
  #===============================
  # Default cache behavior
  #===============================
  default_cache_behavior {
    target_origin_id = var.target_origin_id

    # Cloudfront redirect any HTTP requests from viewer to HTTPS
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    # AWS-managed UseOriginCacheControlHeaders-QueryStrings policy
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html?utm_source=chatgpt.com#managed-cache-policy-origin-cache-headers-query-strings
    cache_policy_id = "4cc15a8a-d715-48a4-82b8-cc0b614638fe"

    # AllViewerAndCloudFrontHeaders-2022-06 policy
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"

    compress = true
  }

  #====================================
  # BFF Health Check URL - Never Cache
  # ====================================
  ordered_cache_behavior {
    path_pattern           = "/actuator/health"
    target_origin_id       = var.target_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    # AWS-managed CachingDisabled policy
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    # AllViewerAndCloudFrontHeaders-2022-06 policy
    origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc"

    compress = true
  }

  #==============================================
  # Driver Health Check URL - Never Cache
  # ============================================
  ordered_cache_behavior {
    path_pattern           = "/driver/health"
    target_origin_id       = var.target_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    # AWS-managed CachingDisabled policy
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

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
