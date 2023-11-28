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

resource "azurerm_storage_account" "sa" {
  name                     = "${var.name}${random_integer.ri.result}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container_main" {
  name                  = "main"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.container_access_type
}

resource "azurerm_storage_container" "container_dev" {
  name                  = "dev"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.container_access_type
}
