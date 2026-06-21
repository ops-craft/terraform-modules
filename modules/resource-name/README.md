# resource-name

Generic Terraform module that constructs standardised resource names from default tags.

## Pattern

```
${prefix}-${name}-${purpose}-${type}-${suffix}-${env}
```

Optional segments (`prefix`, `purpose`, `suffix`) are omitted when empty.
`env` is always the last segment.

## Usage

### Basic

```hcl
module "name" {
  source       = "../resource-name"
  type         = "sqs"
  default_tags = data.aws_default_tags.this.tags
}

# name.result => "my-app-sqs-prod"
```

### With purpose (multiple resources)

```hcl
module "name" {
  source       = "../resource-name"
  type         = "sqs"
  purpose      = "orders"
  default_tags = data.aws_default_tags.this.tags
}

# name.result => "my-app-orders-sqs-prod"
```

### Dead-letter queue

```hcl
module "dlq_name" {
  source       = "../resource-name"
  type         = "sqs"
  purpose      = "orders"
  suffix       = "dlq"
  default_tags = data.aws_default_tags.this.tags
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
  default_tags = data.aws_default_tags.this.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `type` | Resource type identifier (e.g. `sqs`, `rds`) | `string` | — | yes |
| `default_tags` | Tags map to read name and env from | `map(string)` | — | yes |
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
