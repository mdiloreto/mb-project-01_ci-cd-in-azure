
output "client_id" {
  value = azuread_application.aad_app.client_id
}

output "principal_id" {
  value = azuread_service_principal.aad_app_sp.id
}

output "azure_client_secret" {
  description = "The Azure AD service principal's client secret value."
  value       = azuread_service_principal_password.secret.value
}