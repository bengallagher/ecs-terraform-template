resource "aws_ecs_service" "this" {
  name                 = var.module_id
  cluster              = aws_ecs_cluster.this.id
  task_definition      = aws_ecs_task_definition.this.arn
  launch_type          = "FARGATE"
  desired_count        = 1

  # force deployment update on any terraform plan (useful for testing)
  force_new_deployment = true
  triggers = {
    redeployment = plantimestamp()
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = true
  }
}
