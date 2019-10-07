output "policy_definition_id" {
  value       = "${azurerm_policy_definition.main-policy.id}"
  description = "Azure policy ID"
}

output "policy_assignment_ids" {
  value       = "${azurerm_policy_assignment.assign-policy.*.id}"
  description = "Azure policy assignment IDs"
}
