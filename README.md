# Azure Policy
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/policy/azurerm/)

This module creates an Azure Policy definition and assigns it to a list of scopes IDs (Azure Susbcriptions or Resource Groups).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

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
    production = {
      display_name = "VMSS tags checking for my production subscription"
      description  = "VMSS tags checking for my production subscription"
      scope_id     = "/subscriptions/xxxxx"
      scope_type   = "subscription"
      location     = module.azure_region.location
      parameters = jsonencode({
        environment = {
          value = "production"
        },
        managed_by = {
          value = "Claranet"
        }
      })
      identity_type = "SystemAssigned"
      enforce       = false
    },
    preproduction = {
      display_name = "VMSS tags checking for my Management group ABCD"
      description  = "VMSS tags checking for my Management group ABCD"
      scope_id     = "/providers/Microsoft.Management/managementGroups/group1"
      scope_type   = "management-group"
      location     = module.azure_region.location
      parameters = jsonencode({
        managed_by = {
          value = "Claranet"
        }
      })
      identity_type = "None"
      enforce       = true
    }
  }
}

module "policy_tags" {
  source  = "claranet/policy/azurerm"
  version = "x.x.x"

  display_name = "VMSS tagging policy"

  rule_content       = local.policy_tags_rule
  parameters_content = local.policy_tags_parameters

  assignments = local.policy_assignments
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | >= 1.2.28 |
| azurerm | ~> 4.31 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_policy_definition.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_resource_group_policy_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurecaf_name.policy](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assignments | Map with maps to configure assignments. Map key is the name of the assignment. | <pre>map(object({<br/>    display_name  = string<br/>    description   = string<br/>    scope_id      = string<br/>    scope_type    = string<br/>    parameters    = string<br/>    identity_type = string<br/>    location      = string<br/>    enforce       = bool<br/>  }))</pre> | n/a | yes |
| custom\_name | The name of the policy definition. Defaults generated. | `string` | `""` | no |
| description | The description of the policy definition. | `string` | `""` | no |
| display\_name | The display name of the policy definition. | `string` | n/a | yes |
| mgmt\_group\_name | Create the Policy Definition at the Management Group level. | `string` | `null` | no |
| mode | The policy mode that allows you to specify which resource types will be evaluated. The value can be `All`, `Indexed` or `NotSpecified`. | `string` | `"All"` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| parameters\_content | Parameters for the policy definition. This field is a json object that allows you to parameterize your policy definition. | `string` | n/a | yes |
| rule\_content | The policy rule for the policy definition. This is a json object representing the rule that contains an if and a then block. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| definition\_id | Azure policy definition ID. |
| policy\_assignment\_management\_group\_identity\_principal\_id | The principal ID of the identity for management group policy assignments. |
| policy\_assignment\_resource\_group\_identity\_principal\_id | The principal ID of the identity for resource group policy assignments. |
| policy\_assignment\_resource\_identity\_principal\_id | The principal ID of the identity for resource-level policy assignments. |
| policy\_assignment\_subscription\_identity\_principal\_id | The principal ID of the identity for subscription policy assignments. |
| policy\_assignments\_identity\_principal\_id | The principal ID of the identity for policy assignments. |
| resource | Azure policy resource object. |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create](https://docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create)
