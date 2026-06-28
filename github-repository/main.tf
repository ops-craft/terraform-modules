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
  has_discussions = var.has_discussions

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  allow_auto_merge   = var.allow_auto_merge

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

  lifecycle {
    ignore_changes = [
      archive_on_destroy,
    ]
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  repository = github_repository.this.name
  enabled    = var.vulnerability_alerts
}

# --- Default branch ---

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

# --- Rulesets ---

resource "github_repository_ruleset" "this" {
  for_each = var.rulesets

  name        = each.key
  repository  = github_repository.this.name
  target      = each.value.target
  enforcement = each.value.enforcement

  dynamic "conditions" {
    for_each = each.value.target != "push" ? [1] : []
    content {
      ref_name {
        include = each.value.include_refs
        exclude = each.value.exclude_refs
      }
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    creation                = each.value.creation
    update                  = each.value.update
    deletion                = each.value.deletion
    required_linear_history = each.value.required_linear_history
    required_signatures     = each.value.required_signatures
    non_fast_forward        = each.value.non_fast_forward

    dynamic "pull_request" {
      for_each = each.value.pull_request != null ? [each.value.pull_request] : []
      content {
        required_approving_review_count   = pull_request.value.required_approving_review_count
        dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews_on_push
        require_code_owner_review         = pull_request.value.require_code_owner_review
        require_last_push_approval        = pull_request.value.require_last_push_approval
        required_review_thread_resolution = pull_request.value.required_review_thread_resolution
      }
    }

    dynamic "required_status_checks" {
      for_each = length(each.value.required_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = each.value.strict_required_status_checks

        dynamic "required_check" {
          for_each = each.value.required_status_checks
          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }
  }

  depends_on = [github_branch_default.this]

  lifecycle {
    ignore_changes = [
      bypass_actors,
    ]
  }
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
