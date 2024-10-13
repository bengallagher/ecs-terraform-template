
resource "aws_ecs_cluster" "this" {
  name = var.module_id

  depends_on = [ module.vpc ]
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/my-task-logs"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.module_id
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

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

resource "aws_ecs_service" "this" {
  name                 = var.module_id
  cluster              = aws_ecs_cluster.this.id
  task_definition      = aws_ecs_task_definition.this.arn
  launch_type          = "FARGATE"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [module.vpc.default_security_group_id]
    assign_public_ip = true
  }
}


