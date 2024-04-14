resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

module "github_repos" {
  source = "./modules/github_repo"
}

# >>>>>>>> Cloud Infra in Azure <<<<<<<<<<<<<<<<<

resource "azurerm_resource_group" "cicd-demo_rg" {
  name     = "${var.rg_name}${random_integer.ri.result}"
  location = var.location
}

module "acr" {
  source  = "./modules/acr"
  rg_name = azurerm_resource_group.cicd-demo_rg.name
  name    = "${var.acr_name}${random_integer.ri.result}"
}

module "service_principal" {
  source   = "./modules/service_principal_app"
  app_name = "webapp_github_sp"
}

module "role_assign_github-acr" {
  source       = "./modules/role_assignment"
  scope        = azurerm_resource_group.cicd-demo_rg.id
  principal_id = module.service_principal.principal_id
  role         = var.role_assing_role
}

module "WebApp" {
  source                    = "./modules/app_service_web_app"
  webapp_name               = var.webapp_name
  rg_name                   = azurerm_resource_group.cicd-demo_rg.name
  docker_image_main         = var.docker_image_main
  docker_image_dev          = var.docker_image_dev
  docker_image_main_tag     = var.docker_image_main_tag
  docker_image_dev_tag      = var.docker_image_dev_tag
  acr_url                   = module.acr.container_registry_login_server
  webapp_sa_acc_name        = module.StorageAccount.storage_account_name
  webapp_sa_access_key      = module.StorageAccount.storage_account_access_key
  webapp_sa_name            = module.StorageAccount.storage_account_name
  webapp_sa_share_name_main = module.StorageAccount.container_main_name
  webapp_sa_type            = module.StorageAccount.storage_account_type
  webapp_sa_mount_path      = var.webapp_sa_mount_path
  webapp_sa_share_name_dev  = module.StorageAccount.container_dev_name

}

module "role_assign_webapp-acr" {
  source       = "./modules/role_assignment"
  scope        = module.acr.acr_id
  principal_id = module.WebApp.managed_identity_ids     # For main web app
  role         = var.role_assing_acr

  depends_on = [module.WebApp]
}

module "role_assign_webapp_dev-acr" {
  source       = "./modules/role_assignment"

  scope        = module.acr.acr_id
  principal_id = module.WebApp.managed_identity_ids_dev # For dev slot
  role         = var.role_assing_acr

  depends_on = [module.WebApp]
}


module "role_assign_webapp-sa" {
  source       = "./modules/role_assignment"
  scope        = module.StorageAccount.storage_account_id
  principal_id = module.WebApp.managed_identity_ids # For main web app
  role         = var.role_assing_sa

  depends_on = [module.WebApp]
}

module "role_assign_webapp_dev-sa" {
  source       = "./modules/role_assignment"
  scope        = module.StorageAccount.storage_account_id
  principal_id = module.WebApp.managed_identity_ids_dev # For dev slot
  role         = var.role_assing_sa

  depends_on = [module.WebApp]
}


module "StorageAccount" {
  source  = "./modules/storage_account"
  rg_name = azurerm_resource_group.cicd-demo_rg.name
  name    = var.sa_name
}

# >>>>>>> Continous Deployment <<<<<<<<<<<

module "WebHook_main" {
  name = "${var.webhook_name}main"
  source = "./modules/acr_webhook"
  rg_name = azurerm_resource_group.cicd-demo_rg.name
  location = var.location
  service_uri = "https://${module.WebApp.webapp_credential_name}:${module.WebApp.webapp_credential_pass}@${module.WebApp.webapp_name}.scm.azurewebsites.net/api/registry/webhook"
  acr_name = module.acr.container_registry_name
  status = var.acr_webhook_status
  scope = var.acr_webhook_scope_main
  action = var.acr_webhook_action
}


module "WebHook_dev" {
  name = "${var.webhook_name}dev"
  source = "./modules/acr_webhook"
  rg_name = azurerm_resource_group.cicd-demo_rg.name
  location = var.location
  service_uri = "https://${module.WebApp.webapp_credential_name_dev}:${module.WebApp.webapp_credential_pass_dev}@${module.WebApp.webapp_name}-${module.WebApp.slot_dev}.scm.azurewebsites.net/api/registry/webhook"
  acr_name = module.acr.container_registry_name
  status = var.acr_webhook_status
  scope = var.acr_webhook_scope_dev
  action = var.acr_webhook_action
}