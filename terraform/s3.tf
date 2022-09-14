resource "aws_s3_bucket" "nuxt-spa-dev" {
  bucket = "${var.service_name}-${var.env_prefix}-bucket"
  acl    = "private"

  website_domain   = "s3-website-ap-northeast-1.amazonaws.com"
  website_endpoint = "${var.service_name}-${var.env_prefix}-bucket.s3-website-ap-northeast-1.amazonaws.com"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "nuxt-spa-dev" {
  bucket = aws_s3_bucket.nuxt-spa-dev.id

  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "s3:GetObject"
          ]
          Effect    = "Allow"
          Principal = {
            AWS = [aws_cloudfront_origin_access_identity.nuxt-spa-dev.iam_arn]
          }
          Resource  = "${aws_s3_bucket.nuxt-spa-dev.arn}/*"
          Sid       = "PolicyForCloudFrontPrivateContent"
        },
      ]
      Version = "2012-10-17"
    }
  )
}