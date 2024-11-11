#####################################################
# Service Parameters
variable "service_name" {
  type        = string
  description = "Service Name"
  default = "demo"
}

variable "hosted_zone" {
  type        = string
  description = "Hosted Zone ID"
}



#####################################################
# Container Parameters
variable "image" {
  type        = string
  description = "Container Image Address"
}

variable "image_tag" {
  type        = string
  description = "Container Image Tag"
}

variable "container_port" {
  type        = number
  description = "Container Port"
}

variable "container_startup_command" {
  type        = string
  description = "Container Startup Command"
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

variable "container_insights" {
  type        = string
  description = "Enable Container Insights"
  default     = "disabled"
}

#####################################################
# Scaling Parameters
variable "min_capacity" {
  type        = number
  description = "Minimum Tasks"
  default     = 2
}

variable "max_capacity" {
  type        = number
  description = "Maximum Tasks"
  default     = 10
}

variable "desired_capacity" {
  type        = number
  description = "Desired Tasks"
  default     = 2
}

variable "scaling_threshold_cpu" {
  type        = number
  description = "% CPU scaling threshold"
  default     = 60
}

variable "scaling_threshold_memory" {
  type        = number
  description = "% Memory scaling threshold"
  default     = 60
}