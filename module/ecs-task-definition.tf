resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.module_id}"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.module_id
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = var.module_id
    image     = var.image
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
    command = ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]

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
