resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  auto_init              = var.auto_init
  archive_on_destroy     = var.archive_on_destroy
  delete_branch_on_merge = var.delete_branch_on_merge

  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  has_discussions  = var.has_discussions

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  allow_auto_merge   = var.allow_auto_merge

  vulnerability_alerts = var.vulnerability_alerts

  topics       = var.topics
  homepage_url = var.homepage_url

  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  dynamic "template" {
    for_each = var.template != null ? [var.template] : []
    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }
}

# --- Default branch ---

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

# --- Branch protection ---

resource "github_branch_protection_v3" "default" {
  count = var.branch_protection != null ? 1 : 0

  repository     = github_repository.this.name
  branch         = var.default_branch
  enforce_admins = var.branch_protection.enforce_admins

  require_conversation_resolution = var.branch_protection.require_conversation_resolution
  require_signed_commits          = var.branch_protection.require_signed_commits

  required_pull_request_reviews {
    required_approving_review_count = var.branch_protection.required_approving_review_count
    dismiss_stale_reviews           = var.branch_protection.dismiss_stale_reviews
    require_code_owner_reviews      = var.branch_protection.require_code_owner_reviews
  }

  dynamic "required_status_checks" {
    for_each = length(var.branch_protection.required_status_checks) > 0 ? [1] : []
    content {
      strict = var.branch_protection.strict_status_checks
      checks = var.branch_protection.required_status_checks
    }
  }

  depends_on = [github_branch_default.this]
}

# --- Team access ---

resource "github_team_repository" "this" {
  for_each = var.teams

  team_id    = each.key
  repository = github_repository.this.name
  permission = each.value
}

# --- Collaborator access ---

resource "github_repository_collaborator" "this" {
  for_each = var.collaborators

  repository = github_repository.this.name
  username   = each.key
  permission = each.value
}
