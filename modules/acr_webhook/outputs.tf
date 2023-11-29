output "webhook_id" {
  description = "The ID of the ACR webhook."
  value       = azurerm_container_registry_webhook.webhook.id
}
