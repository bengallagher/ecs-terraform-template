resource "aws_ecs_cluster" "this" {
  name = var.module_id

  depends_on = [module.vpc]
}
