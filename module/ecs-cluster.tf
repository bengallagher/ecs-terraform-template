resource "aws_ecs_cluster" "this" {
  name = local.service_id

  depends_on = [module.vpc]
}
