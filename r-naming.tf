data "azurecaf_name" "policy" {
  name          = var.policy_display_name
  resource_type = "azurerm_resource_group"
  prefixes      = compact([local.name_prefix, var.use_caf_naming ? "policy" : ""])
  suffixes      = compact([local.name_suffix, var.use_caf_naming ? "" : "policy"])
  use_slug      = false # to update when naming for policy is available
  clean_input   = true
  separator     = "-"
}
