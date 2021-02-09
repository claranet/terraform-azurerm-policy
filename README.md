# Azure Policy
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/policy/azurerm/)

This module creates an Azure Policy and assign it to a list of scopes IDs (Azure Susbcriptions or Resource Groups).

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------| --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
locals {
  policy_tags_rule = <<RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Compute/virtualMachineScaleSets"
      },
      {
        "not": {
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "equals": "[parameters('tagValue')]"
        }
      }
    ]
  },
  "then": {
    "effect": "modify",
    "details": {
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
      ],
      "operations": [
        {
          "operation": "addOrReplace",
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "value": "[parameters('tagValue')]"
        }
      ]
    }
  }
}
RULE

  policy_tags_parameters = <<PARAMETERS
{
  "tagName": {
    "type": "String",
    "metadata": {
      "displayName": "Tag Name",
      "description": "Name of the tag, such as 'environment'"
    }
  },
  "tagValue": {
    "type": "String",
    "metadata": {
      "displayName": "Tag Value",
      "description": "Value of the tag, such as 'production'"
    }
  }
}
PARAMETERS

policy_assignments = {
    assign_name = {
      display_name = "The assignment display name"
      description  = "A good description"
      scope        = "/xxxxxx/xxxxx/zzzzz",
      parameters   = jsonencode({
        tagName    = {
          value = "TagName value"
        },
        tagValue   = {
          value = "tagValue value"
        }
      })
      identity_type = "SystemAssigned"
    },
    assign_name2 = {
      display_name = "Another display name"
      description  = "Another description"
      scope        = "/xxxxxx/yyyyyyy/zzzzzzz",
      parameters   = jsonencode({
        tagName    = {
          value = "2nd tagName value"
        },
        tagValue   = {
          value = "2nd tagValue value"
        }
      })
      identity_type   = "None"
    }
}


}
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "policy-tags" {
  source  = "claranet/policy/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  stack          = var.stack

  policy_name_prefix = "tags"

  policy_rule_content       = local.policy_tags_rule
  policy_parameters_content = local.policy_tags_parameters
  policy_mode               = "Indexed"

  policy_assignment_display_name = "Tags to update"
  policy_assignments = local.policy_assignments
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| location | Location of the assignment | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| policy\_assignment\_description | A description to use for this Policy Assignment. | `string` | `""` | no |
| policy\_assignment\_display\_name | A friendly display name to use for this Policy Assignment. | `string` | n/a | yes |
| policy\_assignments | Map with maps to configure assignments. Map key is the name of the assignment. | <pre>map(object({<br>    display_name  = string,<br>    description   = string,<br>    scope         = string,<br>    parameters    = string,<br>    identity_type = string,<br>  }))</pre> | n/a | yes |
| policy\_custom\_name | Optional custom name override for Azure policy | `string` | `""` | no |
| policy\_description | The description of the policy definition. | `string` | `""` | no |
| policy\_mgmt\_group\_name | Create the Policy Definition at the Management Group level | `string` | `null` | no |
| policy\_mode | The policy mode that allows you to specify which resource types will be evaluated. The value can be `All`, `Indexed` or `NotSpecified`. | `string` | `"All"` | no |
| policy\_name\_prefix | Optional prefix for subnet names | `string` | `""` | no |
| policy\_parameters\_content | Parameters for the policy definition. This field is a json object that allows you to parameterize your policy definition. | `string` | n/a | yes |
| policy\_rule\_content | The policy rule for the policy definition. This is a json object representing the rule that contains an if and a then block. | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_assignment | Azure policy assignments map |
| policy\_definition\_id | Azure policy ID |

## Related documentation

Terraform resource documentation:
  * [azurerm_policy_definition](https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html)
  * [azurerm_policy_assignment](https://www.terraform.io/docs/providers/azurerm/r/policy_assignment.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create](https://docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create)
