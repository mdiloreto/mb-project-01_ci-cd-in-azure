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
  # auto_init = true

  security_and_analysis {
    # advanced_security {
    #   status = "enabled"
    # }
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

    # Vulnerability alerts and other settings
  vulnerability_alerts = true
  topics                = ["terraform", "security", "example"]
  
}

resource "null_resource" "init_repo" {
  triggers = {
    always_run = "${timestamp()}"
  }

 # >>>>>>>>>> Init the repo <<<<<<<<<<<<<<

provisioner "local-exec" {
    command = <<EOT
    if (-not (Test-Path -Path "C:\tmp")) {
        New-Item -Path "C:\tmp" -ItemType Directory
        Write-Host "Directory 'C:\tmp' created."
    } else {
        Write-Host "Directory 'C:\tmp' already exists."
    }

    $currentPath = "C:\\tmp"

    # Check if the /app directory exists
    if (Test-Path -Path "$currentPath\\app") {
        Write-Host "The /app directory exists in the current path."
    } else {
        # Define repository paths
        $mbNgnixDockerImagePath = "$currentPath\\mb-ngnix-docker-image"
        $appRepoPath = "$currentPath\\app"

        # Clone the mb-ngnix-docker-image repo
        git clone "https://github.com/mdiloreto/mb-ngnix-docker-image" "$mbNgnixDockerImagePath"
        # Clone the app repo
        git clone "https://github.com/mdiloreto/app" "$appRepoPath"
        
        # Copy files from mb-ngnix-docker-image to app
        Write-Host "Copying files from /mb-ngnix-docker-image to /app" -ForegroundColor Yellow
        Copy-Item -Path "$mbNgnixDockerImagePath\\*" -Destination "$appRepoPath" -Recurse
        
        # Commit and push changes to the app repo
        cd $appRepoPath
        git add .
        git commit -m "Copy content from mb-ngnix-docker-image repo"
        git push

        # Change directory back to a safe location before removing directories
        cd $currentPath

        # Remove cloned repositories from the current path
        Remove-Item -Path $mbNgnixDockerImagePath -Recurse -Force
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