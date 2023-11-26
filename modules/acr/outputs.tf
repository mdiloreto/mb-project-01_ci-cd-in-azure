output "resource_group_name" {
  description = "The name of the resource group created."
  value       = azurerm_resource_group.rg.*.name
  depends_on  = [azurerm_resource_group.rg]
}

output "container_registry_name" {
  description = "The name of the container registry created."
  value       = azurerm_container_registry.acr.name
}

output "container_registry_login_server" {
  description = "The login server for the container registry."
  value       = azurerm_container_registry.acr.login_server
}