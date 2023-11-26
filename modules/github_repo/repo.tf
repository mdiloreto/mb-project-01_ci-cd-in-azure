resource "github_repository" "app_repo" {
  name        = "App"
  description = "Repository for the App"

  visibility = "public"

  template {
    owner                = "github"
    repository           = "terraform-template-module"
    include_all_branches = true
  }
}

resource "github_branch" "dev" {
  repository = github_repository.app_repo.name
  branch     = "dev"
}