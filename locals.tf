locals {
  policy_name_prefix = var.policy_name_prefix != "" ? replace(var.policy_name_prefix, "/[a-z0-9]$/", "$0-") : lower(replace(var.policy_assignment_display_name, "/\\W+/", "-"))
  policy_name        = "${local.policy_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-policy"
}
