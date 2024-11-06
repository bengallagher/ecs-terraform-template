provider "aws" {
  profile = "development"
  region  = "eu-west-1"
}

module "ecs_deployment" {
  source = "../module"

  hosted_zone = "example.com"
  image       = "nginx"
  image_tag   = "v1"
}