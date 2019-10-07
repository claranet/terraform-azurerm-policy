# Azure Policy

This module creates an Azure Policy and assign it to a list of scopes (Azure Susbcriptions or Resource Groups).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_name | Client name/account used in naming | string | n/a | yes |
| environment | Project environment | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| name\_prefix | Optional prefix for subnet names | string | `""` | no |
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
