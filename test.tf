# data "aws_availability_zones" "available" {}

# locals {
#     # Set VPC CIDR
#   vpc_cidr = "10.0.0.0/16"

#   # Set number of Availability Zones ("1")
#   azs      = slice(data.aws_availability_zones.available.names, 0, 1)
# }

# output "azs" {
#     value = local.azs
# }

# output "public" {
#     value = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 12, k + 2)]
# }

# output "private" {
#     value = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
# }
# #   public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 12, k)]
# #   private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]