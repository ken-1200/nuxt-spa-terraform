resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.nuxt-spa-dev.bucket_regional_domain_name
    origin_id   = "S3-${var.service_name}-${var.env_prefix}-bucket"
    # 追加
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.nuxt-spa-dev.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Nuxt SPA Terraform Test"
  default_root_object = "index.html"

  #   logging_config {
  #     include_cookies = false
  #     bucket          = "${var.service_name}-${var.env_prefix}-bucket.s3-website-ap-northeast-1.amazonaws.com"
  #     prefix          = "cloudfront_logs"
  #   }

  aliases = ["${var.service_short_name}.${var.main_domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.service_name}-${var.env_prefix}-bucket"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }


  depends_on = [aws_acm_certificate.cert]
}
## CloudFront OAI 作成
resource "aws_cloudfront_origin_access_identity" "nuxt-spa-dev" {
  comment = "Origin Access Identity for s3 ${aws_s3_bucket.nuxt-spa-dev.id}"
}