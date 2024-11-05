# resource "aws_apigatewayv2_api" "my_api" {
#   name          = "my-api"
#   protocol_type = "HTTP"
# }

# resource "aws_apigatewayv2_stage" "default_stage" {
#   api_id      = aws_apigatewayv2_api.my_api.id
#   name        = "$default"
#   auto_deploy = true
# }

# resource "aws_apigatewayv2_integration" "ecs_integration" {
#   api_id           = aws_apigatewayv2_api.my_api.id
#   integration_type = "HTTP_PROXY"
#   integration_uri  = aws_ecs_service.this.network_configuration[0].assign_public_ip
# }