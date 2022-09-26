# Terraform AWS ECS Container Definition

Terraform module to create container defintion for ECS Task definiton.

## Usage
```hcl
module "ecs-container-anycable" {
  source                   = "sudo-terraform-aws-modules/ecs-container/aws"
  version                  = "1.0.4"
  name                     = "container_name"
  image                    = "container_image:latest"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_command"></a> [command](#input\_command) | (optional) Specify the custom command for the container. Default uses the CMD specified in the container image. | `list(string)` | `null` | no |
| <a name="input_container_ports"></a> [container\_ports](#input\_container\_ports) | (optional) Container ports, use this if you don't want to specify host ports. | `list(number)` | <pre>[<br>  8080<br>]</pre> | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | (optional) Specify the number of CPUs for the container. Default: 512 | `number` | `256` | no |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | (optional) Specify the custom entry point for the container. Default uses the ENTRYPOINT specified in container image. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (optional) Environment variables | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_environment_files"></a> [environment\_files](#input\_environment\_files) | (optional) Environment files | <pre>list(object({<br>    value = string<br>    type  = string<br>  }))</pre> | `[]` | no |
| <a name="input_essential"></a> [essential](#input\_essential) | (optional) Specify if the container is essential | `bool` | `true` | no |
| <a name="input_image"></a> [image](#input\_image) | (optional) Container Image. Default: nginx | `string` | `"nginx:latest"` | no |
| <a name="input_log_configuration"></a> [log\_configuration](#input\_log\_configuration) | The log configuration specification for the container. | `any` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, the container is killed. Default: 512 | `number` | `512` | no |
| <a name="input_memory_reservation"></a> [memory\_reservation](#input\_memory\_reservation) | The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (optional) Container Name. Default: randomly generated name | `string` | `"default"` | no |
| <a name="input_port_mappings"></a> [port\_mappings](#input\_port\_mappings) | (optional) Use container\_ports unless you want to explicitly specify host ports which is not recommended. Default: [] | <pre>list(object({<br>    container_port = number<br>    host_port      = number<br>    protocol       = string<br>  }))</pre> | `[]` | no |
| <a name="input_privileged"></a> [privileged](#input\_privileged) | (optional) The containers should run in privileged mode? Default: false | `bool` | `false` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (optional) describe your variable | <pre>list(object({<br>    name       = string<br>    value_from = string<br>  }))</pre> | `[]` | no |
| <a name="input_working_directory"></a> [working\_directory](#input\_working\_directory) | (optional) Specify the working directory for the container. Default uses the WORKDIR specified in the container image. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_definition"></a> [container\_definition](#output\_container\_definition) | The coantiner defintion template |
| <a name="output_container_definition_json"></a> [container\_definition\_json](#output\_container\_definition\_json) | The coantiner defintion template |
<!-- END_TF_DOCS -->
