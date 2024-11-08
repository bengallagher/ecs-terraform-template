# load existing hosted zone
data "aws_route53_zone" "this" {
  name = var.hosted_zone
}

# create service record
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${local.service_id}.${var.hosted_zone}"
  type    = "A"
  alias {
    name                   = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}
