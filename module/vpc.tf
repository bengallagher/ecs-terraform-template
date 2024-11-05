
data "aws_availability_zones" "available" {}

locals {
  # Set VPC CIDR
  vpc_cidr = "10.0.0.0/16"

  # Set number of Availability Zones ("1")
  azs = slice(data.aws_availability_zones.available.names, 0, 1)
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.module_id
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 12, k + 2)]

  enable_dns_hostnames = true
  enable_dns_support   = true
}


################################################################################
# Custom Security Group

resource "aws_security_group" "this" {
  name        = var.module_id
  description = "Allow traffic to/from ECS"
  vpc_id      = module.vpc.default_vpc_id

  depends_on = [ module.vpc ]
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "all"

  depends_on = [ module.vpc ]
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "all"

  depends_on = [ module.vpc ]
}