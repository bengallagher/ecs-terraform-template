resource "aws_security_group" "ecs" {
  name_prefix = "${local.service_id}-"
  description = "Allow traffic to/from ECS"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "ECS Service ${local.service_id}"
  }

  depends_on = [module.vpc]
}

# Allow all in-bound traffic from the VPC Link
resource "aws_vpc_security_group_ingress_rule" "from_vpc_link" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.vpc_link.id
  ip_protocol                  = "all"
}

# Allow all in-bound traffic.
# This also allows pulling images from ECR
resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.ecs.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "all"

  depends_on = [aws_acm_certificate.this]
}
