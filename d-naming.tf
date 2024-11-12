data "azurecaf_name" "policy" {
  name          = var.display_name
  resource_type = "azurerm_resource_group"
  prefixes      = compact([local.name_prefix, "policy"])
  suffixes      = compact([local.name_suffix])
  use_slug      = false # to update when naming for policy is available
  clean_input   = true
  separator     = "-"
}
