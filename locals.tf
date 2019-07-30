locals {
  name_prefix = "${var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""}"
  policy_name = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-policy"
}
