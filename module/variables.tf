variable "module_id" {
  type        = string
  description = "Deployment Identifier (used for resource naming)"
  default     = "my-ecs"
}

variable "image" {
  type        = string
  description = "Container Image Address (plus tag)"
}

variable "env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of Environment Variables"
  default = [
    { name = "LOG_LEVEL", value = "info" }
  ]
}