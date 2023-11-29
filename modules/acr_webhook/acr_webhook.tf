resource "azurerm_container_registry_webhook" "webhook" {
  name                = var.name
  resource_group_name = var.rg_name
  registry_name       = var.acr_name
  location            = var.location

  service_uri = var.service_uri
  status      = var.status
  scope       = var.scope
  actions     = [var.action]
  custom_headers = {
    "Content-Type" = "application/json"
  }
}