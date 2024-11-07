output "url" {
    value = aws_route53_record.this.fqdn
}

# output "invoke_url" {
#     value = aws_api_gateway_deployment.this.invoke_url
# }