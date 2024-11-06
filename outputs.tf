output "definition_id" {
  value       = azurerm_policy_definition.main.id
  description = "Azure policy definition ID."
}

output "resource" {
  value       = azurerm_policy_definition.main.id
  description = "Azure policy resource object."
}
