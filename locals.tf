locals {
  policy_name = coalesce(var.policy_name, substr(lower(replace(var.policy_display_name, "/\\W+/", "-")), 0, 24))
}
