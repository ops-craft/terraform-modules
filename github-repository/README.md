# github-repository

Terraform module to create and manage GitHub repositories with rulesets and access controls.

## Usage

### Minimal

```hcl
module "my_repo" {
  source = "../github-repository"
  name   = "my-service"
}
```

### Full-featured

```hcl
module "my_repo" {
  source = "../github-repository"

  name        = "my-service"
  description = "Backend service for orders"
  visibility  = "private"
  topics      = ["terraform", "backend"]

  has_issues     = true
  has_wiki       = false
  has_projects   = false

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = true

  rulesets = {
    default-branch = {
      target      = "branch"
      enforcement = "active"

      pull_request = {
        required_approving_review_count   = 2
        dismiss_stale_reviews_on_push     = true
        require_code_owner_review         = true
        required_review_thread_resolution = true
      }

      required_status_checks = [
        { context = "ci/build" },
        { context = "ci/test" },
      ]

      deletion                = true
      non_fast_forward        = true
      required_linear_history = true
    }
  }

  teams = {
    backend-team = "push"
    devops-team  = "admin"
  }

  collaborators = {
    external-contributor = "pull"
  }
}
```

### From template

```hcl
module "my_repo" {
  source = "../github-repository"

  name = "new-service"
  template = {
    owner      = "my-org"
    repository = "service-template"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Repository name | `string` | — | yes |
| `description` | Repository description | `string` | `""` | no |
| `visibility` | `public`, `private`, or `internal` | `string` | `"private"` | no |
| `default_branch` | Default branch name | `string` | `"main"` | no |
| `auto_init` | Create initial commit with README | `bool` | `true` | no |
| `archive_on_destroy` | Archive instead of delete on destroy | `bool` | `true` | no |
| `delete_branch_on_merge` | Auto-delete head branch after merge | `bool` | `true` | no |
| `has_issues` | Enable Issues | `bool` | `true` | no |
| `has_projects` | Enable Projects | `bool` | `false` | no |
| `has_wiki` | Enable Wiki | `bool` | `false` | no |
| `has_discussions` | Enable Discussions | `bool` | `false` | no |
| `allow_merge_commit` | Allow merge commits | `bool` | `false` | no |
| `allow_squash_merge` | Allow squash merging | `bool` | `true` | no |
| `allow_rebase_merge` | Allow rebase merging | `bool` | `true` | no |
| `allow_auto_merge` | Allow auto-merge | `bool` | `false` | no |
| `vulnerability_alerts` | Enable Dependabot alerts | `bool` | `true` | no |
| `topics` | Repository topics | `list(string)` | `[]` | no |
| `homepage_url` | Project homepage URL | `string` | `""` | no |
| `template` | Template repo (`{owner, repository}`) | `object` | `null` | no |
| `gitignore_template` | Gitignore template name | `string` | `null` | no |
| `license_template` | License template name | `string` | `null` | no |
| `rulesets` | Map of ruleset name → config (see below) | `map(object)` | `{}` | no |
| `teams` | Map of team slug → permission | `map(string)` | `{}` | no |
| `collaborators` | Map of username → permission | `map(string)` | `{}` | no |

### Ruleset object

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `target` | `string` | `"branch"` | `branch`, `tag`, or `push` |
| `enforcement` | `string` | `"active"` | `active`, `evaluate`, or `disabled` |
| `include_refs` | `list(string)` | `["~DEFAULT_BRANCH"]` | Ref patterns to include |
| `exclude_refs` | `list(string)` | `[]` | Ref patterns to exclude |
| `bypass_actors` | `list(object)` | `[]` | Actors that bypass rules |
| `creation` | `bool` | `false` | Restrict ref creation |
| `update` | `bool` | `false` | Restrict ref updates |
| `deletion` | `bool` | `false` | Restrict ref deletion |
| `required_linear_history` | `bool` | `false` | Require linear history |
| `required_signatures` | `bool` | `false` | Require signed commits |
| `non_fast_forward` | `bool` | `true` | Prevent non-fast-forward pushes |
| `pull_request` | `object` | `null` | PR review requirements (see below) |
| `required_status_checks` | `list(object)` | `[]` | Required status checks |
| `strict_required_status_checks` | `bool` | `true` | Require branches to be up to date |

### Pull request object

| Field | Type | Default |
|-------|------|---------|
| `required_approving_review_count` | `number` | `1` |
| `dismiss_stale_reviews_on_push` | `bool` | `true` |
| `require_code_owner_review` | `bool` | `false` |
| `require_last_push_approval` | `bool` | `false` |
| `required_review_thread_resolution` | `bool` | `true` |

## Outputs

| Name | Description |
|------|-------------|
| `repository` | Full `github_repository` resource |
| `name` | Repository name |
| `full_name` | Full name (`owner/repo`) |
| `html_url` | GitHub URL |
| `ssh_clone_url` | SSH clone URL |
| `http_clone_url` | HTTPS clone URL |
| `default_branch` | Default branch name |
| `repo_id` | GitHub repository ID |
