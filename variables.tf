variable "policy_display_name" {
  description = "The display name of the policy definition."
  type        = string
}

variable "policy_description" {
  description = "The description of the policy definition."
  type        = string
  default     = ""
}

variable "policy_rule_content" {
  description = "The policy rule for the policy definition. This is a json object representing the rule that contains an if and a then block."
  type        = string
}

variable "policy_parameters_content" {
  description = "Parameters for the policy definition. This field is a json object that allows you to parameterize your policy definition."
  type        = string
}

variable "policy_mode" {
  description = "The policy mode that allows you to specify which resource types will be evaluated. The value can be `All`, `Indexed` or `NotSpecified`."
  type        = string
  default     = "All"
}

variable "policy_assignments" {
  description = "Map with maps to configure assignments. Map key is the name of the assignment."
  type = map(object({
    display_name  = string,
    description   = string,
    scope_id      = string,
    scope_type    = string,
    parameters    = string,
    identity_type = string,
    location      = string,
    enforce       = bool,
  }))

  validation {
    condition     = can([for p in var.policy_assignments : contains(["subscription", "management-group", "resource-group", "resource"], lower(p.scope_type))])
    error_message = "The `policy_assignments[*].scope_type` value must be valid. Possible values are `subscription`, `management-group`, `resource-group` or `resource`."
  }
}

variable "policy_mgmt_group_name" {
  description = "Create the Policy Definition at the Management Group level"
  type        = string
  default     = null
}
