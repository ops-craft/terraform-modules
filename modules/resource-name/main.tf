locals {
  name = var.default_tags[var.name_tag_key]
  env  = var.default_tags[var.env_tag_key]

  # Build ordered parts, filtering out empty segments.
  # Pattern: ${prefix}-${name}-${purpose}-${type}-${suffix}-${env}
  parts = [
    for part in [
      var.prefix,
      local.name,
      var.purpose,
      var.type,
      var.suffix,
      local.env,
    ] : part if length(part) > 0
  ]

  result = join(var.separator, local.parts)
}
