resource "aws_security_group" "this" {
  name_prefix = "${random_pet.this.id}-"
  description = "Allow traffic to/from ECS"
  vpc_id      = module.vpc.vpc_id

  depends_on = [module.vpc]
}

resource "aws_vpc_security_group_ingress_rule" "vpclink" {
  security_group_id = aws_security_group.this.id

  referenced_security_group_id = aws_security_group.vpclink.id
  to_port                      = 80
  from_port                    = 80
  ip_protocol                  = "tcp"

  depends_on = [aws_security_group.this]
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "all"

  depends_on = [aws_security_group.this]
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "all"

  depends_on = [aws_acm_certificate.this]
}