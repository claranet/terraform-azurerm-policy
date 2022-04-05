resource "azurecaf_name" "policy" {
  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = compact([local.name_prefix, var.use_caf_naming ? "policy" : ""])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "policy"])
  use_slug      = false # to update when naming for policy is available
  clean_input   = true
  separator     = "-"
}
