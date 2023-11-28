resource "azurerm_role_assignment" "add_role" {
  scope                = var.scope
  role_definition_name = var.role # Example role
  principal_id         = var.principal_id
}
