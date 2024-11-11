resource "aws_cloudwatch_log_group" "ecs_service_logs" {
  name              = "/ecs/${local.service_id}/service"
  retention_in_days = 1
}

resource "aws_ecs_service" "this" {
  name            = local.service_id
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_capacity

  # force deployment update on any terraform plan (useful for testing)
  force_new_deployment = true
  # triggers = {
  #   redeployment = plantimestamp()
  # }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  # Integrate with service discovery
  # Ports and Container values should be set in the task definition
  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
    port         = var.container_port
  }
}
