resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${random_pet.this.id}"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family                   = random_pet.this.id
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
    name      = random_pet.this.id
    image     = join(":", [var.image, var.image_tag])
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
    command = ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
    healthcheck = {
      command  = ["CMD-SHELL", "curl --fail http://127.0.0.1:80/health || exit 1"]
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
