terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = ">= 5.42.0"
    }
  }
}
resource "github_repository" "app_repo" {
  name        = var.repo_name
  description = var.description
  visibility = "public"
  auto_init = true
}

resource "null_resource" "init_repo" {
  triggers = {
    always_run = "${timestamp()}"
  }

  # >>>>>>>>>> Init the repo <<<<<<<<<<<<<<

provisioner "local-exec" {
    command = <<EOT
      $repoDir = "c:/Users/mdiloreto"
      cd $repoDir
      # Clone the repo if it doesn't already exist
      if (-Not (Test-Path $repoDir/app)) {
        write-host "Cloning the repo" -ForegroundColor red
        git clone https://github.com/mdiloreto/app
      else {
        write-host "repo already created" -ForegroundColor green
      }
      }
      cd app
      # Check if README.md exists and if not, create and push it
      if (-Not (Test-Path "README.md")) {
        write-host "Creating Readme.md file" -ForegroundColor red
        "## App Repo!" | Out-File -FilePath "README.md"
        git add README.md
        git commit -m "Initial commit"
        git push
      else {
        write-host "README.md file already created" -ForegroundColor green
      }
      }
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [ github_repository.app_repo ]
}

# >>>>>>>>>>>>> Create Branch <<<<<<<<<<<<<<<<<<

resource "github_branch" "dev" {
  repository = github_repository.app_repo.name
  branch     = "dev"
  depends_on = [
    null_resource.init_repo
  ]
}