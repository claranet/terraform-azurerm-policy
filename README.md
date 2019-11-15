# Azure Policy
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/policy/azurerm/)

This module creates an Azure Policy and assign it to a list of scopes IDs (Azure Susbcriptions or Resource Groups).

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.31

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| <  2.x.x       | 0.11.x            |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
locals {
  policy_tags_rule = <<POLICY_RULE
{
    "if": {
      "allof": [
        {
            "field": "[concat('tags.*')]",
            "in": "[parameters('listOfTagKeys')]"
        }
      ]
    },
    "then": {
      "effect": "audit"
    }
}
POLICY_RULE

  policy_tags_parameters = <<PARAMETERS
{
    "listOfTagKeys": {
        "type": "Array",
        "metadata": {
            "displayName": "Tag keys",
            "description": "Tag keys to check"
        }
    }
}
PARAMETERS

  policy_tags_parameters_assign = <<PARAMETERS
{
    "listOfTagKeys": {
        "value": ${jsonencode(local.tags_key_to_check)}
    }
}
PARAMETERS

  tags_key_to_check = ["env", "stack", "BU"]
}
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = "${module.azure-region.location}"
  client_name = "${var.client_name}"
  environment = "${var.environment}"
  stack       = "${var.stack}"
}

module "policy-tags" {
  source  = "claranet/policy/azurerm"
  version = "x.x.x"

  client_name = "${var.client_name}"
  environment = "${var.environment}"

  location_short = "${module.azure-region.location_short}"
  stack          = "${var.stack}"

  policy_name_prefix = "tags"

  policy_rule_content       = "${local.policy_tags_rule}"
  policy_parameters_content = "${local.policy_tags_parameters}"
  policy_mode               = "Indexed"

  policy_assignment_parameters_values = "${local.policy_tags_parameters_assign}"
  policy_assignment_display_name      = "Tags key audit check"
  policy_assignment_description       = "Tags key audit check for the assigned scopes (${join(",", local.tags_key_to_check)})"
  policy_assignment_scopes            = ["${module.rg.resource_group_id}"]
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_name | Client name/account used in naming | string | n/a | yes |
| environment | Project environment | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| policy\_name\_prefix | Optional prefix for subnet names | string | `""` | no |
| policy\_assignment\_description | A description to use for this Policy Assignment. | string | `""` | no |
| policy\_assignment\_display\_name | A friendly display name to use for this Policy Assignment. | string | n/a | yes |
| policy\_assignment\_parameters\_values | Parameters for the policy definition. This field is a JSON object that maps to the Parameters field from the Policy Definition. | string | n/a | yes |   
| policy\_assignment\_scopes | List of Scope at which the Policy Assignment should be applied, which must be a Resource ID (such as Subscription e.g. `/subscriptions/00000000-0000-0000-000000000000` or a Resource Group e.g.`/subscriptions/00000000-0000-0000-000000000000/resourceGroups/myResourceGroup`). | list | n/a | yes |
| policy\_assignment\_scopes\_length | List length. | string | `"1"` | no |
| policy\_custom\_name | Optional custom name override for Azure policy | string | `""` | no |
| policy\_description | The description of the policy definition. | string | `""` | no |
| policy\_mode | The policy mode that allows you to specify which resource types will be evaluated. The value can be `All`, `Indexed` or `NotSpecified`. | string | `"All"` | no |
| policy\_parameters\_content | Parameters for the policy definition. This field is a json object that allows you to parameterize your policy definition. | string | n/a | yes |
| policy\_rule\_content | The policy rule for the policy definition. This is a json object representing the rule that contains an if and a then block. | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_assignment\_ids | Azure policy assignment IDs |
| policy\_definition\_id | Azure policy ID |

## Related documentation

Terraform resource documentation:
  * [azurerm_policy_definition](https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html)
  * [azurerm_policy_assignment](https://www.terraform.io/docs/providers/azurerm/r/policy_assignment.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create](https://docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create)
