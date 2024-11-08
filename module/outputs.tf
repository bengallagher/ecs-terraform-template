output "service_url" {
  value = "https://${aws_route53_record.this.fqdn}"
}
