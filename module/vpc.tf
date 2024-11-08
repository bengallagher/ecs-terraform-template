
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

  name = local.service_id
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 12, k + 2)]

  enable_dns_hostnames = true
  enable_dns_support   = true
}
