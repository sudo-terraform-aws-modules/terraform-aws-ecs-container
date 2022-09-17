variable "name" {
  type        = string
  description = "(optional) Container Name. Default: randomly generated name"
  default     = "default"
}

variable "image" {
  type        = string
  description = "(optional) Container Image. Default: nginx"
  default     = "nginx:latest"
}

variable "memory" {
  type        = number
  description = "The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, the container is killed. Default: 512"
  default     = 512
}

variable "cpu" {
  type        = number
  description = "(optional) Specify the number of CPUs for the container. Default: 512"
  default     = 256
}
variable "memory_reservation" {
  type        = number
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit."
  default     = null
}

variable "container_ports" {
  type        = list(number)
  description = "(optional) Container ports, use this if you don't want to specify host ports."
  default     = [8080]
}
variable "port_mappings" {
  type = list(object({
    container_port = number
    host_port      = number
    protocol       = string
  }))

  description = "(optional) Use container_ports unless you want to explicitly specify host ports which is not recommended. Default: []"

  default = []
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "(optional) Environment variables"
  default     = []
}

variable "entry_point" {
  type        = string
  description = "(optional) Specify the custom entry point for the container. Default uses the ENTRYPOINT specified in container image."
  default     = null
}

variable "working_directory" {
  type        = string
  description = "(optional) Specify the working directory for the container. Default uses the WORKDIR specified in the container image."
  default     = null
}

variable "command" {
  type        = string
  description = "(optional) Specify the custom command for the container. Default uses the CMD specified in the container image."
  default     = null
}

variable "environment_files" {
  type = list(object({
    value = string
    type  = string
  }))
  description = "(optional) Environment files"
  default     = []
  validation {
    condition = alltrue([
      for item in var.environment_files : item.type == "s3"
    ])
    error_message = "Only s3 type is supported for now."
  }
}

variable "secrets" {
  type = list(object({
    name       = string
    value_from = string
  }))
  description = "(optional) describe your variable"
  default     = []
}

variable "privileged" {
  type        = bool
  description = "(optional) The containers should run in privileged mode? Default: false"
  default     = false
}

variable "log_configuration" {
  type        = any
  description = "The log configuration specification for the container."
  default     = null
}
