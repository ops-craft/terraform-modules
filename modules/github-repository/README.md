# github-repository

Terraform module to create and manage GitHub repositories with branch protection and access controls.

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

  branch_protection = {
    enforce_admins                  = true
    required_approving_review_count = 2
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    require_conversation_resolution = true
    required_status_checks          = ["ci/build", "ci/test"]
    strict_status_checks            = true
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
| `branch_protection` | Branch protection config (see below) | `object` | `null` | no |
| `teams` | Map of team slug → permission | `map(string)` | `{}` | no |
| `collaborators` | Map of username → permission | `map(string)` | `{}` | no |

### Branch protection object

| Field | Type | Default |
|-------|------|---------|
| `enforce_admins` | `bool` | `true` |
| `required_approving_review_count` | `number` | `1` |
| `dismiss_stale_reviews` | `bool` | `true` |
| `require_code_owner_reviews` | `bool` | `false` |
| `require_conversation_resolution` | `bool` | `true` |
| `required_status_checks` | `list(string)` | `[]` |
| `strict_status_checks` | `bool` | `true` |
| `require_signed_commits` | `bool` | `false` |
| `allow_force_pushes` | `bool` | `false` |
| `allow_deletions` | `bool` | `false` |

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
