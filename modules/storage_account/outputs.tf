output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.sa.name
}

output "storage_account_access_key" {
  description = "The primary access key for the storage account."
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
}

output "container_main_name" {
  description = "The name of the main storage container."
  value       = azurerm_storage_container.container_main.name
}

output "container_dev_name" {
  description = "The name of the development storage container."
  value       = azurerm_storage_container.container_dev.name
}

output "storage_account_type" {
  description = "The type of the storage account."
  value       = "AzureBlob" # This is typically 'AzureBlob' for Web Apps
}

output "storage_account_mount_path" {
  description = "The mount path for the storage account."
  value       = "/mnt/sa" # Specify the path where you want to mount the storage
}

output "storage_account_id" {
  value = azurerm_storage_account.sa.id
}
