resource "azurerm_policy_definition" "main" {
  name         = local.name
  display_name = var.display_name
  description  = coalesce(var.description, var.display_name)

  policy_type         = "Custom"
  mode                = var.mode
  management_group_id = var.mgmt_group_name

  policy_rule = var.rule_content
  parameters  = var.parameters_content
}

moved {
  from = azurerm_policy_definition.main_policy
  to   = azurerm_policy_definition.main
}
