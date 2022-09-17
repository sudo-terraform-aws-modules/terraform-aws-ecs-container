output "container_definition" {
  description = "The coantiner defintion template"
  value       = local.container_definition
}

output "container_definition_json" {
  description = "The coantiner defintion template"
  value       = jsonencode(local.container_definition)
}