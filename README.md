# ecs-terraform-template
ECS terraform deployment


# Handy References:
https://awsteele.com/blog/2022/10/15/cheap-serverless-containers-using-api-gateway.html

https://medium.com/@mr.mornesnyman/streamline-dns-record-management-for-ecs-services-with-terraform-aws-service-discovery-and-aws-a5fa32b3b8a4

https://aws.amazon.com/blogs/architecture/field-notes-integrating-http-apis-with-aws-cloud-map-and-amazon-ecs-services/

https://aws.amazon.com/blogs/architecture/field-notes-serverless-container-based-apis-with-amazon-ecs-and-amazon-api-gateway/

# ToDos

- add api gateway
- move to private subnets
- add vpce for ECR
- add task role
- check security group rules for inbound traffic

# Example Deployment

```
provider "aws" {
  profile = <aws-profile>
  region  = <aws-region>
}

module "ecs_deployment" {
  source = "./module"

  hosted_zone = "dev.shibboleth.co.uk"
  image     = "124387271761.dkr.ecr.eu-west-1.amazonaws.com/kube-demo-app"
  image_tag = "main"
}
```