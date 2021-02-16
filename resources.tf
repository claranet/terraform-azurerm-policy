resource "azurerm_policy_definition" "main-policy" {
  name         = local.policy_name
  display_name = var.policy_display_name
  description  = coalesce(var.policy_description, var.policy_display_name)

  policy_type           = "Custom"
  mode                  = var.policy_mode
  management_group_name = var.policy_mgmt_group_name

  policy_rule = var.policy_rule_content
  parameters  = var.policy_parameters_content
}

resource "azurerm_policy_assignment" "assign-policy" {
  for_each             = var.policy_assignments
  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main-policy.id
  scope                = each.value.scope

  location     = each.value.location
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = each.value.parameters

  identity {
    type = each.value.identity_type
  }
}
