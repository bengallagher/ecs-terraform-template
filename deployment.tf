locals {
  account = "development"
  region  = "eu-west-1"
}

provider "aws" {
  profile = local.account
  region  = local.region
}

module "ecs_deployment" {
  source = "./module"

  module_id = "ecs-demo"
  image     = "124387271761.dkr.ecr.eu-west-1.amazonaws.com/kube-demo-app:latest"
}