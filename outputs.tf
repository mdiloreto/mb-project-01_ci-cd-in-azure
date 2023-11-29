output "AZURE_CLIENT_ID" {
  value = module.service_principal.client_id
}

output "AZURE_ACR_ENDPOINT" {
  value = module.acr.container_registry_login_server
}