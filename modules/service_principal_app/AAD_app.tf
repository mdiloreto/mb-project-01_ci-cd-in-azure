
data "azuread_client_config" "current" {}

resource "azuread_application" "aad_app" {
  display_name     = var.app_name
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "aad_app_sp" {
  client_id      = azuread_application.aad_app.client_id
  use_existing   = true
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "secret" {
  service_principal_id = azuread_service_principal.aad_app_sp.id
}