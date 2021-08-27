output "policy_definition_id" {
  value       = azurerm_policy_definition.main_policy.id
  description = "Azure policy ID"
}

output "policy_assignment" {
  value       = azurerm_policy_assignment.assign_policy
  description = "Azure policy assignments map"
}
