locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  policy_name = coalesce(var.policy_name, substr(lower(var.use_caf_naming ? azurecaf_name.policy.result : replace(var.policy_display_name, "/\\W+/", "-")), 0, 24))
}
