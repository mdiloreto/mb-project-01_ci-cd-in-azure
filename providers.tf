terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.42.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "github" {
  # token = var.token
  # app_auth {

  #   # id              = ar.github_app_id  # or `GITHUB_APP_ID`
  #   # installation_id = var.github_installation_id # or `GITHUB_APP_INSTALLATION_ID`
  #   # pem_file        = file("C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/mb-terraform.2023-11-26.private-key.pem")
  # }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
