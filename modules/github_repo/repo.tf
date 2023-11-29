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
      $sourceDir = "C:\nginx_app"
      $repoDir = "C:\Users\mdiloreto\app"
      $repoUrl = "https://github.com/mdiloreto/app"
    
      if(Test-Path -Path $repoDir) {
        Write-Host "The path exists."
      }
      else {
      # Clone the repo if it doesn't already exist
      if (-Not (Test-Path $repoDir)) {
        Write-Host "Cloning the repo from $repoUrl" -ForegroundColor Red
        git clone $repoUrl $repoDir
      } else {
        Write-Host "Repo already cloned at $repoDir" -ForegroundColor Green
      }

      # Change to the repository directory
      cd $repoDir

      # Pull the latest changes
      git pull

      # Check if there are any files to copy
      $filesToCopy = Get-ChildItem $sourceDir -Recurse
      if ($filesToCopy.Count -eq 0) {
        Write-Host "No new files to copy from $sourceDir" -ForegroundColor Green
      } else {
        # Copy all files from source directory to repository
        Write-Host "Copying files from $sourceDir to $repoDir" -ForegroundColor Yellow
        Copy-Item -Path "$sourceDir\\*" -Destination $repoDir -Recurse -Force

        # Add all files to git, commit, and push if there are changes
        git add .
        $status = git status --porcelain
        if ($status) {
          git commit -m "Copy nginx_app files"
          git push
        } else {
          Write-Host "No changes to commit" -ForegroundColor Green
        }
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
  source_branch = "main"
  depends_on = [
    null_resource.init_repo
  ]
}