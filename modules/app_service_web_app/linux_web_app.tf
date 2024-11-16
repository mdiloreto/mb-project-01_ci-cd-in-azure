resource "random_integer" "ri" {
  min = 10000
  max = 99999
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
  name                  = "${var.webapp_name}${random_integer.ri.result}"
  location              = var.location
  resource_group_name   = var.rg_name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true

  site_config {
    container_registry_use_managed_identity = true
    always_on = true  
    minimum_tls_version = "1.2"
        cors {
      allowed_origins = [
        "https://portal.azure.com",
      ]
      }
    application_stack {
      docker_image_name     = "${var.acr_url}/${var.docker_image_main}:${var.docker_image_main_tag}"
      docker_registry_url   = "https://${var.acr_url}"
    }
  }
    identity {
    type = "SystemAssigned"
  }

  storage_account {
    account_name = var.webapp_sa_acc_name
    access_key = var.webapp_sa_access_key
    name = var.webapp_sa_name
    share_name = var.webapp_sa_share_name_main
    type = var.webapp_sa_type
    mount_path = var.webapp_sa_mount_path
  }

}

resource "azurerm_linux_web_app_slot" "slot_dev" {

  name           = "dev"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    container_registry_use_managed_identity = true ## authenticaiton to container registry with SMI
    always_on = true  
    minimum_tls_version = "1.2"
    application_stack {
      docker_image_name     = "${var.acr_url}/${var.docker_image_dev}:${var.docker_image_dev_tag}"
      docker_registry_url   = "https://${var.acr_url}"
    }
  }
  
  identity {
    type = "SystemAssigned"
  }

    storage_account {
    account_name = var.webapp_sa_acc_name
    access_key = var.webapp_sa_access_key
    name = var.webapp_sa_name
    share_name = var.webapp_sa_share_name_dev
    type = var.webapp_sa_type
    mount_path = var.webapp_sa_mount_path
  }

  depends_on = [ azurerm_linux_web_app.webapp ]
}
