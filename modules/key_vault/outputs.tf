
output "key_vault_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.main.name
}

output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_tenant_id" {
  description = "The tenant ID associated with the Key Vault."
  value       = azurerm_key_vault.main.tenant_id
}