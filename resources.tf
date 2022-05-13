resource "azurerm_policy_definition" "main_policy" {
  name         = local.policy_name
  display_name = var.policy_display_name
  description  = coalesce(var.policy_description, var.policy_display_name)

  policy_type         = "Custom"
  mode                = var.policy_mode
  management_group_id = var.policy_mgmt_group_name

  policy_rule = var.policy_rule_content
  parameters  = var.policy_parameters_content
}

resource "azurerm_management_group_policy_assignment" "assign_policy_mgmt" {
  for_each = { for p_name, p_def in var.policy_assignments : p_name => p_def if lower(p_def.scope_type) == "management-group" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main_policy.id
  management_group_id  = each.value.scope_id

  location     = each.value.location
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = each.value.parameters
  enforce      = each.value.enforce

  identity {
    type = each.value.identity_type
  }
}

resource "azurerm_subscription_policy_assignment" "assign_policy_sub" {
  for_each = { for p_name, p_def in var.policy_assignments : p_name => p_def if lower(p_def.scope_type) == "subscription" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main_policy.id
  subscription_id      = each.value.scope_id

  location     = each.value.location
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = each.value.parameters
  enforce      = each.value.enforce

  identity {
    type = each.value.identity_type
  }
}

resource "azurerm_resource_group_policy_assignment" "assign_policy_rg" {
  for_each = { for p_name, p_def in var.policy_assignments : p_name => p_def if lower(p_def.scope_type) == "resource-group" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main_policy.id
  resource_group_id    = each.value.scope_id

  location     = each.value.location
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = each.value.parameters
  enforce      = each.value.enforce

  identity {
    type = each.value.identity_type
  }
}

resource "azurerm_resource_policy_assignment" "assign_policy_res" {
  for_each = { for p_name, p_def in var.policy_assignments : p_name => p_def if lower(p_def.scope_type) == "resource" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main_policy.id
  resource_id          = each.value.scope_id

  location     = each.value.location
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = each.value.parameters
  enforce      = each.value.enforce

  identity {
    type = each.value.identity_type
  }
}
