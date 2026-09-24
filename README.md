# SUDO AWS Terraform Module for ECS Container Definition

A helper module that builds a typed, validated ECS container definition. Creates no AWS resources — outputs a container definition object and JSON strings for use with the `ecs-task` module.

## Usage

### Single Container (Fargate)

```hcl
module "container" {
  source  = "sudo-terraform-aws-modules/ecs-container/aws"
  version = "1.0.0"

  name            = "app"
  image           = "nginx:latest"
  cpu             = 256
  memory          = 512
  container_ports = [80]
}

module "task" {
  source = "sudo-terraform-aws-modules/ecs-task/aws"

  name                  = "my-task"
  cpu                   = 256
  memory                = 512
  container_definitions = module.container.container_definition_json_list
}
```

### Multi-Container Task

```hcl
module "app" {
  source = "sudo-terraform-aws-modules/ecs-container/aws"

  name            = "app"
  image           = "myapp:latest"
  cpu             = 512
  memory          = 1024
  container_ports = [8080]
  environment     = [{ name = "ENV", value = "prod" }]
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = "/ecs/my-task"
      awslogs-region        = "us-east-1"
      awslogs-stream-prefix = "app"
    }
  }
}

module "sidecar" {
  source = "sudo-terraform-aws-modules/ecs-container/aws"

  name      = "datadog-agent"
  image     = "datadog/agent:latest"
  cpu       = 128
  memory    = 256
  essential = false
  environment = [{ name = "DD_API_KEY", value = "abc123" }]
}

module "task" {
  source = "sudo-terraform-aws-modules/ecs-task/aws"

  name   = "my-task"
  cpu    = 640
  memory = 1280

  container_definitions = jsonencode([
    module.app.container_definition,
    module.sidecar.container_definition,
  ])
}
```

### Container with Health Check and Secrets

```hcl
module "container" {
  source = "sudo-terraform-aws-modules/ecs-container/aws"

  name            = "api"
  image           = "myapi:latest"
  cpu             = 256
  memory          = 512
  container_ports = [3000]

  secrets = [
    { name = "DB_PASSWORD", value_from = "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-password" }
  ]

  health_check = {
    command  = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
    interval = 30
    timeout  = 5
    retries  = 3
  }

  stop_timeout             = 30
  readonly_root_filesystem = true
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Resources

This module creates no AWS resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Container name | `string` | `"default"` | no |
| <a name="input_image"></a> [image](#input\_image) | Container image | `string` | `"nginx:latest"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the container | `number` | `256` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Hard memory limit in MiB | `number` | `512` | no |
| <a name="input_memory_reservation"></a> [memory\_reservation](#input\_memory\_reservation) | Soft memory limit in MiB | `number` | `null` | no |
| <a name="input_container_ports"></a> [container\_ports](#input\_container\_ports) | Container ports (no host port binding). Default: [] | `list(number)` | `[]` | no |
| <a name="input_port_mappings"></a> [port\_mappings](#input\_port\_mappings) | Explicit host-to-container port mappings | `list(object({container\_port=number, host\_port=number, protocol=string}))` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables | `list(object({name=string, value=string}))` | `[]` | no |
| <a name="input_environment_files"></a> [environment\_files](#input\_environment\_files) | S3 environment files | `list(object({value=string, type=string}))` | `[]` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets from SSM/Secrets Manager | `list(object({name=string, value\_from=string}))` | `[]` | no |
| <a name="input_essential"></a> [essential](#input\_essential) | Whether the container is essential | `bool` | `true` | no |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | Custom entrypoint | `list(string)` | `null` | no |
| <a name="input_command"></a> [command](#input\_command) | Custom command (list form, takes precedence over command\_str) | `list(string)` | `null` | no |
| <a name="input_command_str"></a> [command\_str](#input\_command\_str) | Custom command as a string (split on spaces) | `string` | `null` | no |
| <a name="input_working_directory"></a> [working\_directory](#input\_working\_directory) | Working directory | `string` | `null` | no |
| <a name="input_privileged"></a> [privileged](#input\_privileged) | Run container in privileged mode | `bool` | `false` | no |
| <a name="input_readonly_root_filesystem"></a> [readonly\_root\_filesystem](#input\_readonly\_root\_filesystem) | Mount root filesystem as read-only | `bool` | `true` | no |
| <a name="input_log_configuration"></a> [log\_configuration](#input\_log\_configuration) | Log driver configuration | `any` | `null` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | Volume mount points (source\_volume must match a volume in the task definition) | `list(object({source\_volume=string, container\_path=string, read\_only=bool}))` | `[]` | no |
| <a name="input_stop_timeout"></a> [stop\_timeout](#input\_stop\_timeout) | Seconds to wait before forcefully killing the container (Docker default: 30s) | `number` | `null` | no |
| <a name="input_docker_labels"></a> [docker\_labels](#input\_docker\_labels) | Docker labels to add to the container | `map(string)` | `null` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Container health check configuration | `object({command=list(string), interval=number, timeout=number, retries=number, startPeriod=number})` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_definition"></a> [container\_definition](#output\_container\_definition) | Container definition as a Terraform object (use for multi-container tasks) |
| <a name="output_container_definition_json"></a> [container\_definition\_json](#output\_container\_definition\_json) | Container definition as a JSON object string |
| <a name="output_container_definition_json_list"></a> [container\_definition\_json\_list](#output\_container\_definition\_json\_list) | Container definition as a JSON array string (pass directly to ecs-task `container_definitions`) |
<!-- END_TF_DOCS -->
