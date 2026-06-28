# resource-name

Generic Terraform module that constructs standardised resource names from default tags.

## Pattern

```
${prefix}-${name}-${purpose}-${type}-${suffix}-${env}
```

The module reads `name` and `env` from `data.aws_default_tags.current.tags` automatically — no need to pass tags explicitly. Just ensure your AWS provider has `default_tags` configured.

## Usage

### Basic

```hcl
module "name" {
  source = "../resource-name"
  type   = "sqs"
}

# name.result => "my-app-sqs-prod"
```

### With purpose (multiple resources)

```hcl
module "name" {
  source  = "../resource-name"
  type    = "sqs"
  purpose = "orders"
}

# name.result => "my-app-orders-sqs-prod"
```

### Dead-letter queue

```hcl
module "dlq_name" {
  source  = "../resource-name"
  type    = "sqs"
  purpose = "orders"
  suffix  = "dlq"
}

# dlq_name.result => "my-app-orders-sqs-dlq-prod"
```

### Custom tag keys

```hcl
module "name" {
  source       = "../resource-name"
  type         = "rds"
  name_tag_key = "project"
  env_tag_key  = "environment"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `type` | Resource type identifier (e.g. `sqs`, `rds`) | `string` | — | yes |
| `purpose` | Disambiguator for multiple resources | `string` | `""` | no |
| `prefix` | Name prefix | `string` | `""` | no |
| `suffix` | Name suffix (e.g. `dlq`) | `string` | `""` | no |
| `name_tag_key` | Tag key for the resource name | `string` | `"name"` | no |
| `env_tag_key` | Tag key for the environment | `string` | `"env"` | no |
| `separator` | Separator between parts | `string` | `"-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `result` | The constructed resource name |
