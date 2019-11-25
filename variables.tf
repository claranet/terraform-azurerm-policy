# Generic paramters
variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "policy_name_prefix" {
  description = "Optional prefix for subnet names"
  type        = string
  default     = ""
}

# Azure Policy specific parameters

variable "policy_custom_name" {
  description = "Optional custom name override for Azure policy"
  type        = string
  default     = ""
}

variable "policy_description" {
  description = "The description of the policy definition."
  type        = string
  default     = ""
}

variable "policy_rule_content" {
  description = "The policy rule for the policy definition. This is a json object representing the rule that contains an if and a then block."
}

variable "policy_parameters_content" {
  description = "Parameters for the policy definition. This field is a json object that allows you to parameterize your policy definition."
}

variable "policy_mode" {
  description = "The policy mode that allows you to specify which resource types will be evaluated. The value can be `All`, `Indexed` or `NotSpecified`."
  default     = "All"
  type        = string
}

variable "policy_assignment_scopes" {
  description = "List of Scope at which the Policy Assignment should be applied, which must be a Resource ID (such as Subscription e.g. `/subscriptions/00000000-0000-0000-000000000000` or a Resource Group e.g.`/subscriptions/00000000-0000-0000-000000000000/resourceGroups/myResourceGroup`)."
  type        = list(string)
}

variable "policy_assignment_scopes_length" {
  description = "List length."
  type        = string
  default     = "1"
}

variable "policy_assignment_display_name" {
  description = "A friendly display name to use for this Policy Assignment."
  type        = string
}

variable "policy_assignment_description" {
  description = "A description to use for this Policy Assignment."
  type        = string
  default     = ""
}

variable "policy_assignment_parameters_values" {
  description = "Parameters for the policy definition. This field is a JSON object that maps to the Parameters field from the Policy Definition."
}

