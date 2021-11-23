# v4.0.2 - 2021-11-23

Changed
  * AZ-572: Revamp examples and improve CI

# v4.0.1 - 2021-08-27

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-530: Cleanup module, fix linter errors

# v4.0.0 - 2021-04-02

Changed
  * AZ-398: Force lowercase on default generated name
  * AZ-273: Module compatible terraform `v0.13+` and `v0.14+`
  
Breaking 
  * AZ-206: AzureRM 2.0 compatibility - variable `policy_mgmt_group_id` changed to `policy_mgmt_group_name`
  * AZ-447: rework naming generation (will cause policies recreation)

# v2.1.0 - 2020-07-31

Added
  * AZ-247: Add management group support

# v2.0.0 - 2012-02-13

Breaking
  * AZ-94: Bump to terraform 0.12
  * AZ-154: Allow to assign the policy multiple times
  
# v1.0.0 - 2019-11-15

Added
  * AZ-114: First Release
