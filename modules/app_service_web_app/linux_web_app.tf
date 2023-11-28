resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create Resource Group (you need to use the create_rg cara)
resource "azurerm_resource_group" "rg" {
  count    = var.create_rg ? 1 : 0  # Create RG if var.create_rg is true
  name     = "${var.rg_name}${random_integer.ri.result}"
  location = var.location
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.asp_name}${random_integer.ri.result}"
  location            = var.location
  resource_group_name = var.rg_name
  os_type             = "Linux"
  sku_name            = "S1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  count = var.webapp_count
  name                  = "${var.webapp_name}${random_integer.ri.result}"
  location              = var.location
  resource_group_name   = var.rg_name
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
  count = var.webapp_count

  name           = "dev"
  app_service_id = azurerm_linux_web_app.webapp[count.index].id

  site_config {
    always_on = false  
    minimum_tls_version = "1.2"
  }
  depends_on = [ azurerm_linux_web_app.webapp ]
}

resource "azurerm_linux_web_app_slot" "slot_staging" {
  count = var.webapp_count

  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp[count.index].id

  site_config {
    always_on = false  
    minimum_tls_version = "1.2"
  }
  depends_on = [ azurerm_linux_web_app.webapp ]
}