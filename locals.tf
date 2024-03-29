locals {
  container_port_mappings = [for container_port in var.container_ports : { "containerPort" : container_port }]
  task_definition_param_mappings = {
    "container_port" = "containerPort"
    "host_port"      = "hostPort"
    "protocol"       = "protocol"
    "value_from"     = "valueFrom"
    "name"           = "name"
    "mount_points"   = "mountPoints"
    "source_volume"  = "sourceVolume"
    "container_path" = "containerPath"
    "read_only"      = "readOnly"
  }
  port_mappings_synthesized = [
    for mapping in var.port_mappings : {
      for key, value in mapping : local.task_definition_param_mappings[key] => value
    }
  ]

  secrets_syntehsized = [
    for mapping in var.secrets : {
      for key, value in mapping : local.task_definition_param_mappings[key] => value
    }
  ]
  mount_points_syntehsized = [
    for mapping in var.mount_points : {
      for key, value in mapping : local.task_definition_param_mappings[key] => value
    }
  ]
  command_str_synthesized = var.command_str != null ? split(" ", var.command_str) : []
  command_synthesized     = var.command != null ? var.command : local.command_str_synthesized

  container_definition_template = {
    name                   = var.name
    image                  = var.image
    cpu                    = var.cpu
    memory                 = var.memory
    memoryReservation      = var.memory_reservation
    essential              = var.essential
    environment            = var.environment
    environmentFiles       = var.environment_files
    secrets                = local.secrets_syntehsized
    portMappings           = concat(local.container_port_mappings, local.port_mappings_synthesized)
    privileged             = var.privileged
    entryPoint             = var.entry_point
    command                = local.command_synthesized
    workingDirectory       = var.working_directory
    logConfiguration       = var.log_configuration
    readonlyRootFilesystem = var.readonly_root_filesystem
    mountPoints            = local.mount_points_syntehsized
  }

  container_definition_keys = compact([for key, value in local.container_definition_template : value != null ? key : ""])
  container_definition_obj  = { for key in local.container_definition_keys : key => lookup(local.container_definition_template, key) }

  container_definition = local.container_definition_obj
}
