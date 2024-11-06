resource "aws_ecs_service" "this" {
  name            = random_pet.this.id
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

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

  # Integrate with service discovery
  # Ports and Container values should be set in the task definition
  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
    port         = 80
  }

  # service_connect_configuration {
  #   enabled = true
  #   namespace = aws_service_discovery_private_dns_namespace.this.arn
  # }
}
