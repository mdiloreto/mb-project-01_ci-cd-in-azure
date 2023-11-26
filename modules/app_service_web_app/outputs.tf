output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "webapp_name" {
  value = azurerm_linux_web_app.webapp.name
}

output "slot_dev" {
  value = azurerm_linux_web_app_slot.slot_dev.name
}

output "slot_staging" {
  value = azurerm_linux_web_app_slot.slot_staging.name
}

output "asp_name" {
  value = azurerm_service_plan.appserviceplan.name
}