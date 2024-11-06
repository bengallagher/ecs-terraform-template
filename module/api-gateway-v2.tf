resource "aws_security_group" "vpclink" {
  name_prefix = "${random_pet.this.id}-"
  description = "VPC API Gateway Link"
  vpc_id      = module.vpc.vpc_id

  depends_on = [module.vpc]
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = random_pet.this.id
  security_group_ids = [aws_security_group.vpclink.id]
  subnet_ids         = module.vpc.public_subnets
}

resource "aws_apigatewayv2_api" "this" {
  name          = random_pet.this.id
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
  api_id    = aws_apigatewayv2_api.this.id
  # route_key = "$default"
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = "${random_pet.this.id}.${var.hosted_zone}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate.this]
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = aws_apigatewayv2_stage.this.id
}
