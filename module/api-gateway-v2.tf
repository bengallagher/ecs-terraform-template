resource "aws_security_group" "vpc_link" {
  name_prefix = "${local.service_id}-"
  description = "VPC API Gateway Link"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = " VPC Link ${local.service_id}"
  }

  depends_on = [module.vpc]
}

# Enable all port 80 ingress traffic
resource "aws_vpc_security_group_ingress_rule" "vpc_link_ingress" {
  security_group_id = aws_security_group.vpc_link.id

  cidr_ipv4   = "0.0.0.0/0"
  to_port     = 80
  from_port   = 80
  ip_protocol = "tcp"

  depends_on = [aws_security_group.vpc_link]
}

# Enable outbound traffic to ECS security group
resource "aws_vpc_security_group_egress_rule" "vpc_link_egress" {
  security_group_id            = aws_security_group.vpc_link.id
  referenced_security_group_id = aws_security_group.ecs.id
  ip_protocol                  = "all"

  depends_on = [aws_security_group.vpc_link]
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = local.service_id
  security_group_ids = [aws_security_group.vpc_link.id]
  subnet_ids         = module.vpc.public_subnets
}

resource "aws_apigatewayv2_api" "this" {
  name          = local.service_id
  protocol_type = "HTTP"

  depends_on = [aws_apigatewayv2_vpc_link.this]
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "this" {
  api_id                 = aws_apigatewayv2_api.this.id
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  connection_type        = "VPC_LINK"
  integration_method     = "ANY"
  integration_type       = "HTTP_PROXY"
  integration_uri        = aws_service_discovery_service.this.arn
  payload_format_version = "1.0"

  depends_on = [aws_service_discovery_service.this]
}

resource "aws_apigatewayv2_route" "this" {
  api_id = aws_apigatewayv2_api.this.id
  # route_key = "$default"
  route_key = "ANY /{proxy+}"
  target    = join("/", ["integrations", aws_apigatewayv2_integration.this.id])
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = "${local.service_id}.${var.hosted_zone}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [
    aws_acm_certificate.this,
    aws_acm_certificate_validation.this
  ]
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = aws_apigatewayv2_stage.this.id
}
