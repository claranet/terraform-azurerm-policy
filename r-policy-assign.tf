resource "azurerm_management_group_policy_assignment" "main" {
  for_each = { for p_name, p_def in var.assignments : p_name => p_def if lower(p_def.scope_type) == "management-group" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main.id
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

moved {
  from = azurerm_management_group_policy_assignment.assign_policy_mgmt
  to   = azurerm_management_group_policy_assignment.main
}

resource "azurerm_subscription_policy_assignment" "main" {
  for_each = { for p_name, p_def in var.assignments : p_name => p_def if lower(p_def.scope_type) == "subscription" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main.id
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

moved {
  from = azurerm_subscription_policy_assignment.assign_policy_sub
  to   = azurerm_subscription_policy_assignment.main
}

resource "azurerm_resource_group_policy_assignment" "main" {
  for_each = { for p_name, p_def in var.assignments : p_name => p_def if lower(p_def.scope_type) == "resource-group" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main.id
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

moved {
  from = azurerm_resource_group_policy_assignment.assign_policy_rg
  to   = azurerm_resource_group_policy_assignment.main
}

resource "azurerm_resource_policy_assignment" "main" {
  for_each = { for p_name, p_def in var.assignments : p_name => p_def if lower(p_def.scope_type) == "resource" }

  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main.id
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

moved {
  from = azurerm_resource_policy_assignment.assign_policy_res
  to   = azurerm_resource_policy_assignment.main
}
