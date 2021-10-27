resource "aws_s3_bucket" "nuxt-spa-dev" {
  bucket = "${var.service_name}-${var.env_prefix}-bucket"
  acl    = "public-read"

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
            "s3:GetObject",
            "s3:PutObject"
          ]
          Effect    = "Allow"
          Principal = "*"
          Resource  = "${aws_s3_bucket.nuxt-spa-dev.arn}/*"
          Sid       = "PublicReadForGetBucketObjects"
        },
      ]
      Version = "2012-10-17"
    }
  )
}