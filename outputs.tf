output "container_definition" {
  description = "Container definition as a Terraform object"
  value       = local.container_definition
}

output "container_definition_json" {
  description = "Container definition as a JSON object string (single container)"
  value       = jsonencode(local.container_definition)
}

output "container_definition_json_list" {
  description = "Container definition as a JSON array string (pass directly to ecs-task container_definitions)"
  value       = jsonencode([local.container_definition])
}
