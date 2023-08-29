# Azure SQL Database Terraform Module

Terraform module to create an MS SQL server with initial database, Azure AD login, Firewall rules, geo-replication using auto-failover groups, Private endpoints, and corresponding private DNS zone.

A single database is the quickest and simplest deployment option for Azure SQL Database. You manage a single database within a SQL Database server, which is inside an Azure resource group in a specified Azure region with this module.

You can also create a single database in the provisioned or serverless compute tier. A provisioned database is pre-allocated a fixed amount of computing resources, including CPU and memory, and uses one of two purchasing models. This module creates a provisioned database using the vCore-based purchasing model, but you can choose a DTU-based model as well.

## Resources supported

* [SQL Servers](https://www.terraform.io/docs/providers/azurerm/r/sql_server.html)
* [SQL Database](https://www.terraform.io/docs/providers/azurerm/r/mysql_database.html)
* [Storage account for diagnostics](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html)
* [Active Directory Administrator](https://www.terraform.io/docs/providers/azurerm/r/sql_active_directory_administrator.html)
* [Firewall rule for azure services, resources, and client IP](https://www.terraform.io/docs/providers/azurerm/r/sql_firewall_rule.html)
* [SQL Auto-Failover Group](https://www.terraform.io/docs/providers/azurerm/r/sql_failover_group.html)
* [Private Endpoints](https://www.terraform.io/docs/providers/azurerm/r/private_endpoint.html)
* [Private DNS zone for `privatelink` A records](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)
* [SQL Script execution to create Database](https://docs.microsoft.com/en-us/sql/ssms/scripting/sqlcmd-run-transact-sql-script-files?view=sql-server-ver15)
* [SQL Server and Database Extended Auditing Policy](https://docs.microsoft.com/en-us/azure/azure-sql/database/auditing-overview)
* [Azure Defender for SQL](https://docs.microsoft.com/en-us/azure/azure-sql/database/azure-defender-for-sql)
* [SQL Vulnerability Assessment](https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-vulnerability-assessment)
* [SQL Log Monitoring and Diagnostics](https://docs.microsoft.com/en-us/azure/azure-sql/database/metrics-diagnostic-telemetry-logging-streaming-export-configure?tabs=azure-portal)

## Module Usage

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| azurerm | >= 2.59.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.59.0 |
| random |>= 3.1.0 |
| null | >= 3.1.0 |

## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`create_resource_group` | Whether to create resource group and use it for all networking resources | string | `"false"`
`resource_group_name`|The name of an existing resource group.|string|`""`
`location`|The location for all resources while creating a new resource group.|string|`""`
`sql_server_name`|The name of the Microsoft SQL Server|string|`""`
`database_name`|The name of the SQL database|string|`""`
`admin_username`|The username of the local administrator used for the SQL Server|string|`"azureadmin"`
`admin_password`|The Password which should be used for the local-administrator on this SQL Server|string|`null`
`random_password_length`|The desired length of random password created by this module|number|`32`
`storage_account_name`|The name of the storage account|string|`null`
`sql_database_edition`|The edition of the database to be created. Valid values are: `Basic`, `Standard`, `Premium`, `DataWarehouse`, `Business`, `BusinessCritical`, `Free`, `GeneralPurpose`, `Hyperscale`, `Premium`, `PremiumRS`, `Standard`, `Stretch`, `System`, `System2`, or `Web`|string|`"Standard"`
`sqldb_service_objective_name`|The service objective name for the database. Valid values depend on edition and location and may include `S0`, `S1`, `S2`, `S3`, `P1`, `P2`, `P4`, `P6`, `P11`|string|`"S1"`
`enable_sql_server_extended_auditing_policy`|Manages Extended Audit policy for SQL servers|string|`"true"`
`enable_database_extended_auditing_policy`|Manages Extended Audit policy for SQL database|string|`"false"`
`enable_threat_detection_policy`|Threat detection policy configuration|string|`"false"`
`enable_log_monitoring`|Enable audit events to Azure Monitor?|string|`false`
`log_retention_days`|Specifies the number of days to retain logs for in the storage account|`number`|`30`
`email_addresses_for_alerts`|Account administrators email for alerts|`list(any)`|`""`
`ad_admin_login_name`|The login name of the principal to set as the server administrator|string|`null`
`enable_firewall_rules`|Manages a Firewall Rule for a MySQL Server|string|`"false"`
`firewall_rules`| list of firewall rules to add SQL servers| `list(object({}))`| `[]`
`enable_failover_group`|Create a failover group of databases on a collection of Azure SQL servers|string| `"false"`
`secondary_sql_server_location`|The location of the secondary SQL server (applicable if Failover groups enabled)|string|`"northeurope"`
`initialize_sql_script_execution`|enable sqlcmd tool to connect and create database schema|string| `"false"`
`sqldb_init_script_file`|SQL file to execute via sqlcmd utility to create required database schema |string|`""`
`enable_private_endpoint`|Manages a Private Endpoint to Azure Container Registry|string|`false`
`virtual_network_name`|The name of the virtual network for the private endpoint creation. conflicts with `existing_vnet_id`and shouldn't use both.|string|`""`
`private_subnet_address_prefix`|Address prefix of the subnet for private endpoint creation. conflicts with `existing_subnet_id` and shouldn't use both|list(string)|`null`
`existing_vnet_id`|The resoruce id of existing Virtual network for private endpoint creation. Conflicts with `virtual_network_name`and shouldn't use both|string|`null`
`existing_subnet_id`|The resource id of existing subnet for private endpoint creation. Conflicts with `private_subnet_address_prefix` and shouldn't use both|string|`null`
`existing_private_dns_zone`|The name of exisging private DNS zone|string|`null`
`log_analytics_workspace_id`|The id of log analytic workspace to send logs and metrics.|string|`"null"`
`storage_account_id`|The id of storage account to send logs and metrics|string|`"null"`
`Tags`|A map of tags to add to all resources|map|`{}`

## Outputs

Name | Description
---- | -----------
`resource_group_name` | The name of the resource group in which resources are created
`resource_group_location`| The location of the resource group in which resources are created
`storage_account_id`|The ID of the storage account
`storage_account_name`|The name of the storage account
`primary_sql_server_id`|The primary Microsoft SQL Server ID
`primary_sql_server_fqdn`|The fully qualified domain name of the primary Azure SQL Server
`secondary_sql_server_id`|The secondary Microsoft SQL Server ID
`secondary_sql_server_fqdn`|The fully qualified domain name of the secondary Azure SQL Server
`sql_server_admin_user`|SQL database administrator login id
`sql_server_admin_password`|SQL database administrator login password
`sql_database_id`|The SQL Database ID
`sql_database_name`|The SQL Database Name
`sql_failover_group_id`|A failover group of databases on a collection of Azure SQL servers
`primary_sql_server_private_endpoint`|id of the Primary SQL server Private Endpoint
`secondary_sql_server_private_endpoint`|id of the Primary SQL server Private Endpoint
`sql_server_private_dns_zone_domain`|DNS zone name of SQL server Private endpoints DNS name records
`primary_sql_server_private_endpoint_ip`|Primary SQL server private endpoint IPv4 Addresses
`primary_sql_server_private_endpoint_fqdn`|Primary SQL server private endpoint IPv4 Addresses
`secondary_sql_server_private_endpoint_ip`|Secondary SQL server private endpoint IPv4 Addresses
`secondary_sql_server_private_endpoint_fqdn`|Secondary SQL server private endpoint FQDN Addresses

## Other resources

* [Azure SQL Database documentation](https://docs.microsoft.com/en-us/azure/sql-database/)
* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)

## Authors

Originally created by [Uriti Venkata Naga Kishore](mailto:kishoreuriti@gmail.com)