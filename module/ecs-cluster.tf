resource "aws_cloudwatch_log_group" "ecs_cluster_logs" {
  name              = "/ecs/${local.service_id}/cluster"
  retention_in_days = 1
}

resource "aws_ecs_cluster" "this" {
  name = local.service_id

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster_logs.name
      }
    }
  }

  depends_on = [module.vpc]
}
