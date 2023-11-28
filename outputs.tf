output "client_id" {
  value = module.service_principal.client_id
}

output "name" {
  value = module.service_principal.azure_client_secret
  sensitive = true
}

output "acr_endpoint" {
  value = module.acr.container_registry_login_server
}