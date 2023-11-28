resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

module "github_repos" {
  source = "./modules/github_repo"
}

resource "azurerm_resource_group" "cicd-demo_rg" {
  name = "${var.rg_name}${random_integer.ri.result}"
  location = var.location
}

module "WebApp" {
  source = "./modules/app_service_web_app"
  webapp_name = var.webapp_name
  rg_name = azurerm_resource_group.cicd-demo_rg.name

}

module "StorageAccount" {
  source = "./modules/storage_account"
  rg_name = azurerm_resource_group.cicd-demo_rg.name
  name = var.sa_name
}

module "acr" {
  source = "./modules/acr"
  rg_name = azurerm_resource_group.cicd-demo_rg.name
  name = "${var.acr_name}${random_integer.ri.result}"
}

module "service_principal" {
  source = "./modules/service_principal_app"
  app_name = "webapp_github_sp"
}

module "role_assign" {
  source = "./modules/role_assignment"
  scope = azurerm_resource_group.cicd-demo_rg.id
  principal_id = module.service_principal.principal_id
  role = var.role_assing_role
  }