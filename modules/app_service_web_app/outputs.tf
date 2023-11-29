output "webapp_name" {
  value = azurerm_linux_web_app.webapp.name
}

output "slot_dev" {
  value = azurerm_linux_web_app_slot.slot_dev.name
}

output "asp_name" {
  value = azurerm_service_plan.appserviceplan.name
}

output "managed_identity_ids" {
  value = azurerm_linux_web_app.webapp.identity[0].principal_id
}

output "managed_identity_ids_dev" {
  value = azurerm_linux_web_app_slot.slot_dev.identity[0].principal_id
}

