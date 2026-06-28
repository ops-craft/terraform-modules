variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  description = "Repository description."
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Repository visibility: public, private, or internal."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be public, private, or internal."
  }
}

variable "default_branch" {
  description = "Name of the default branch."
  type        = string
  default     = "main"
}

variable "auto_init" {
  description = "Whether to produce an initial commit with an empty README."
  type        = bool
  default     = true
}

variable "archive_on_destroy" {
  description = "Archive the repository instead of deleting on destroy."
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches after a PR merge."
  type        = bool
  default     = true
}

variable "has_issues" {
  description = "Enable the GitHub Issues feature."
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable the GitHub Projects feature."
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Enable the GitHub Wiki feature."
  type        = bool
  default     = false
}

variable "has_discussions" {
  description = "Enable the GitHub Discussions feature."
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits."
  type        = bool
  default     = false
}

variable "allow_squash_merge" {
  description = "Allow squash merging."
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging."
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merge on PRs."
  type        = bool
  default     = false
}

variable "vulnerability_alerts" {
  description = "Enable Dependabot vulnerability alerts."
  type        = bool
  default     = true
}

variable "topics" {
  description = "List of repository topics."
  type        = list(string)
  default     = []
}

variable "homepage_url" {
  description = "URL of a page describing the project."
  type        = string
  default     = ""
}

variable "template" {
  description = "Template repository to use. Set owner and repository name."
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "gitignore_template" {
  description = "Gitignore template (e.g. Terraform, Python, Go)."
  type        = string
  default     = null
}

variable "license_template" {
  description = "License template (e.g. mit, apache-2.0)."
  type        = string
  default     = null
}

# --- Rulesets ---

variable "rulesets" {
  description = "Map of repository rulesets. Key is the ruleset name."
  type = map(object({
    target      = optional(string, "branch")
    enforcement = optional(string, "active")

    # Ref targeting (required for branch/tag targets)
    include_refs = optional(list(string), ["~DEFAULT_BRANCH"])
    exclude_refs = optional(list(string), [])

    # Bypass actors
    bypass_actors = optional(list(object({
      actor_id    = number
      actor_type  = string
      bypass_mode = optional(string, "always")
    })), [])

    # Rules
    creation                = optional(bool, false)
    update                  = optional(bool, false)
    deletion                = optional(bool, false)
    required_linear_history = optional(bool, false)
    required_signatures     = optional(bool, false)
    non_fast_forward        = optional(bool, true)

    # Pull request rules
    pull_request = optional(object({
      required_approving_review_count   = optional(number, 1)
      dismiss_stale_reviews_on_push     = optional(bool, true)
      require_code_owner_review         = optional(bool, false)
      require_last_push_approval        = optional(bool, false)
      required_review_thread_resolution = optional(bool, true)
    }), null)

    # Required status checks
    required_status_checks = optional(list(object({
      context        = string
      integration_id = optional(number)
    })), [])
    strict_required_status_checks = optional(bool, true)
  }))
  default = {}
}

# --- Access ---

variable "teams" {
  description = "Map of team slug to permission (pull, triage, push, maintain, admin)."
  type        = map(string)
  default     = {}
}

variable "collaborators" {
  description = "Map of GitHub username to permission (pull, triage, push, maintain, admin)."
  type        = map(string)
  default     = {}
}
