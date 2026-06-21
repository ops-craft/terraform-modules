variable "type" {
  description = "Resource type identifier (e.g. sqs, rds, ec2)."
  type        = string

  validation {
    condition     = length(var.type) > 0
    error_message = "Type must not be empty."
  }
}

variable "purpose" {
  description = "Optional disambiguator when multiple resources share the same name (e.g. orders, payments)."
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Optional prefix prepended to the resource name."
  type        = string
  default     = ""
}

variable "suffix" {
  description = "Optional suffix appended after the type (e.g. dlq for dead-letter queues)."
  type        = string
  default     = ""
}

variable "name_tag_key" {
  description = "Key in default tags that holds the resource name."
  type        = string
  default     = "name"
}

variable "env_tag_key" {
  description = "Key in default tags that holds the environment."
  type        = string
  default     = "env"
}

variable "separator" {
  description = "Separator between name parts."
  type        = string
  default     = "-"
}
