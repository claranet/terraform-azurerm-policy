# Generic paramters
variable "location" {
  description = "Location of the assignment"
  type        = string
}

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

variable "policy_assignment_display_name" {
  description = "A friendly display name to use for this Policy Assignment."
  type        = string
}

variable "policy_assignment_description" {
  description = "A description to use for this Policy Assignment."
  type        = string
  default     = ""
}

variable "policy_assignments" {
  description = "Map with maps to configure assignments. Map key is the name of the assignment."
  type = map(object({
    display_name  = string,
    description   = string,
    scope         = string,
    parameters    = string,
    identity_type = string,
  }))
}
