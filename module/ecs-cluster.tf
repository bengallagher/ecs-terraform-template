resource "aws_ecs_cluster" "this" {
  name = random_pet.this.id

  depends_on = [module.vpc]
}
