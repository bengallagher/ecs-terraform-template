resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${local.service_id}/task"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.service_id
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_exec_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = local.service_id
    image     = join(":", [var.image, var.image_tag])
    essential = true
    portMappings = [
      {
        name          = local.service_id
        containerPort = var.container_port
      }
    ]
    command = split(" ", var.container_startup_command)
    healthcheck = {
      command = [
        "CMD-SHELL",
        "curl --fail http://localhost/health || exit 1"
      ]
      interval = 30
      timeout  = 5
      retries  = 3
    }
    environment = var.env_vars

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
        "awslogs-region"        = "eu-west-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}
