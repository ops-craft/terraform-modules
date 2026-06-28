output "repository" {
  description = "The github_repository resource."
  value       = github_repository.this
}

output "name" {
  description = "Repository name."
  value       = github_repository.this.name
}

output "full_name" {
  description = "Full repository name (owner/repo)."
  value       = github_repository.this.full_name
}

output "html_url" {
  description = "URL to the repository on GitHub."
  value       = github_repository.this.html_url
}

output "ssh_clone_url" {
  description = "SSH clone URL."
  value       = github_repository.this.ssh_clone_url
}

output "http_clone_url" {
  description = "HTTPS clone URL."
  value       = github_repository.this.http_clone_url
}

output "default_branch" {
  description = "The default branch name."
  value       = github_branch_default.this.branch
}

output "repo_id" {
  description = "GitHub repository ID."
  value       = github_repository.this.repo_id
}
