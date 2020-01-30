resource "azurerm_policy_definition" "main-policy" {
  name        = coalesce(var.policy_custom_name, local.policy_name)
  description = coalesce(var.policy_description, local.policy_name)

  policy_type  = "Custom"
  mode         = var.policy_mode
  display_name = coalesce(var.policy_custom_name, local.policy_name)

  policy_rule = var.policy_rule_content
  parameters  = var.policy_parameters_content
}

#resource "azurerm_policy_assignment" "assign-policy" {
#  name = "${coalesce(var.policy_custom_name, local.policy_name)}-assignment${count.index}"
#
#  scope                = element(var.policy_assignment_scopes, count.index)
#  policy_definition_id = azurerm_policy_definition.main-policy.id
#
#  display_name = var.policy_assignment_display_name
#  description  = var.policy_assignment_description
#
#  parameters = var.policy_assignment_parameters_values
#
#  count = var.policy_assignment_scopes_length
#}

resource "azurerm_policy_assignment" "assign-policy" {
  for_each             = var.policy_assignments
  name                 = "${coalesce(var.policy_custom_name, local.policy_name)}-assignment-${each.key}"
  policy_definition_id = azurerm_policy_definition.main-policy.id
  scope                = each.value.scope

  location     = var.location
  display_name = "${var.policy_assignment_display_name}-${each.key}"
  description  = "${var.policy_description}\n${jsonencode(each.value)}"

  parameters = each.value.parameters

  identity {
    type = "SystemAssigned"
  }
}