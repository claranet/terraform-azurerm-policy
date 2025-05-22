output "definition_id" {
  description = "Azure policy definition ID."
  value       = azurerm_policy_definition.main.id
}

output "resource" {
  description = "Azure policy resource object."
  value       = azurerm_policy_definition.main.id
}

output "policy_assignments_identity_principal_id" {
  description = "The principal ID of the identity for policy assignments."
  value = {
    "management_group" = { for k, v in azurerm_management_group_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
    "subscription"     = { for k, v in azurerm_subscription_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
    "resource_group"   = { for k, v in azurerm_resource_group_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
    "resource"         = { for k, v in azurerm_resource_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
  }
}

output "policy_assignment_management_group_identity_principal_id" {
  description = "The principal ID of the identity for management group policy assignments."
  value       = { for k, v in azurerm_management_group_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
}

output "policy_assignment_subscription_identity_principal_id" {
  description = "The principal ID of the identity for subscription policy assignments."
  value       = { for k, v in azurerm_subscription_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
}

output "policy_assignment_resource_group_identity_principal_id" {
  description = "The principal ID of the identity for resource group policy assignments."
  value       = { for k, v in azurerm_resource_group_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
}

output "policy_assignment_resource_identity_principal_id" {
  description = "The principal ID of the identity for resource-level policy assignments."
  value       = { for k, v in azurerm_resource_policy_assignment.main : k => try(v.identity[0].principal_id, null) }
}
