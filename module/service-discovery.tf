resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = local.service_id
  description = "Private DNS Namespace"
  vpc         = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "this" {
  name = local.service_id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
