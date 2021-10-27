resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.service_short_name}.${var.main_domain}"
  validation_method = "DNS"
  provider          = aws.northern-virginia

  lifecycle {
    create_before_destroy = true
  }
}

# ACM
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options: dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = "${var.zone_id}"
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [for record in aws_route53_record.cert_validation: record.fqdn]
  provider                = aws.northern-virginia
}

# Route53-CloudFrontにトラフィックをルーティングするためのAレコード
resource "aws_route53_record" "www" {
  zone_id = "${var.zone_id}"
  name    = "${var.service_short_name}.${var.main_domain}"
  type    = "A"

  alias {
    # CloudFrontのディストリビューションドメイン名
    name                   = replace(aws_cloudfront_distribution.s3_distribution.domain_name, "/[.]$/", "")
    # Route53のzone_id
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    # 正常性の評価
    evaluate_target_health = true
  }

  # CloudFront distribution が作成された後実行
  depends_on = [aws_cloudfront_distribution.s3_distribution]
}