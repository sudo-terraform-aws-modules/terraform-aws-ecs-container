variable "name" {
  type = string
  description = "(optional) Container Name. Default: randomly generated name"
  default = "default"
}

variable "image" {
  type = string
  description = "(optional) Container Image. Default: nginx"
  default = "nginx:latest"
}

variable "memory" {
  type        = number
  description = "The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, the container is killed. Default: 512"
  default     = 512
}

variable "memory_reservation" {
  type        = number
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit."
  default     = null
}

variable "container_ports" {
  type = list(number)
  description = "(optional) Container ports, use this if you don't want to specify host ports."
  default = [ 8080 ]
}
variable "port_mappings" {
  type = list(object({
    container_port = number
    host_port      = number
    protocol      = string
  }))

  description = ""

  default = [
        {
      container_port = 8082
      host_port      = 8082
      protocol      = "tcp"
    },
    {
      container_port = 8081
      host_port      = 8081
      protocol      = "udp"
    }
  ]
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "(optional) Environment variables"
  default = []
}


variable "environment_files" {
  type = list(object({
    value  = string
    type = string
  }))
  description = "(optional) Environment files"
  default = []
 validation {
    condition = alltrue([
      for item in var.environment_files : item.type == "s3"
    ])
    error_message = "Only s3 type is supported for now."
  }
}

variable "secrets" {
  type = list(object({
    name  = string
    value_from = string
  }))
  description = "(optional) describe your variable"
  default = []
}

variable "privileged" {
  type = bool
  description = "(optional) The containers should run in privileged mode? Default: false"
  default = false
}