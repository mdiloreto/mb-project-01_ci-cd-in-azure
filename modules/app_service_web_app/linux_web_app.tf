resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
# Create Resource Group (you need to use the create_rg cara)
resource "azurerm_resource_group" "rg" {
  count    = var.create_rg ? 1 : 0  # Create RG if var.create_rg is true
  name     = "${var.rg_name}${random_interger.ri.result}"
  location = var.location
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp${random_integer.ri.result}"
  location            = var.location
  resource_group_name = var.create_rg
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "${var.webapp_name}${random_integer.ri.result}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    always_on = false  
    minimum_tls_version = "1.2"

        cors {
      allowed_origins = [
        "https://portal.azure.com",
      ]
      }
  }
}

resource "azurerm_linux_web_app_slot" "slot_dev" {
  name           = "dev"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    always_on = false  
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_linux_web_app_slot" "slot_staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    always_on = false  
    minimum_tls_version = "1.2"
  }
}