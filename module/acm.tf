resource "aws_acm_certificate" "this" {
  domain_name               = var.hosted_zone
  subject_alternative_names = ["*.${var.hosted_zone}"]
  validation_method         = "DNS"

  tags = {
    Name  = random_pet.this.id,
    Owner = "Terraform"
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.verify : record.fqdn]
}

resource "aws_route53_record" "verify" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}
