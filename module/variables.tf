variable "hosted_zone" {
  type        = string
  description = "Hosted Zone ID"
}

variable "image" {
  type        = string
  description = "Container Image Address"
}

variable "image_tag" {
  type        = string
  description = "Container Image Tag"
}

variable "min_capacity" {
  type        = number
  description = "Minimum Tasks"
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum Tasks"
  default     = 3
}

variable "scaling_threshold_cpu" {
  type        = number
  description = "% CPU scaling threshold"
  default     = 60
}

variable "scaling_threshold_memory" {
  type        = number
  description = "% Memory scaling threshold"
  default     = 80
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