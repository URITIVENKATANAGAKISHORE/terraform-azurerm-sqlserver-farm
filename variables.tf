variable "subscription_id" {
  description = "The ID of the Subscription. Changing this forces a new Subscription to be created."
  type        = string
}

variable "create_resource_group" {
  description = "Specifies that wheather you want to create new resource group or not"
  type        = string
  default     = "false"
}
variable "resource_group_name" {
  description = "The name of the resource group in which the MSSQL Server is created. Changing this forces a new resource to be created."
  type        = string
}
variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "sql_server_name" {
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure. Changing this forces a new resource to be created."
  type        = string
}

variable "version" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created."
  type        = string
}
variable "administrator_login" {
  description = "The administrator login name for the new server. Changing this forces a new resource to be created."
  type        = string
}

variable "connection_policy" {
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default."
  type        = string
}
variable "identity" {
  description = "An identity block as defined below."
  type        = string
}
variable "threat_detection_policy" {
  description = "Threat detection policy configuration. The threat_detection_policy block supports fields documented below."
  type        = string
}

variable "disabled_alerts" {
  description = "Specifies a list of alerts which should be disabled. Possible values include Access_Anomaly, Data_Exfiltration, Sql_Injection, Sql_Injection_Vulnerability and Unsafe_Action"
  type        = string
}
variable "email_account_admins" {
  description = "Should the account administrators be emailed when this alert is triggered?"
  type        = string
}
variable "email_addresses" {
  description = "A list of email addresses which alerts should be sent to."
  type        = string
}
variable "retention_days" {
  description = "Specifies the number of days to keep in the Threat Detection audit logs."
  type        = number
}
variable "storage_account_access_key" {
  description = "Specifies the identifier key of the Threat Detection audit storage account. Required if state is Enabled."
  type        = string
}
variable "storage_endpoint" {
  description = "Specifies the blob storage endpoint (e.g. https://example.blob.core.windows.net). This blob storage will hold all Threat Detection audit logs. Required if state is Enabled."
  type        = string
}



variable "create_network_watcher_resource_group" {
  description = "Controls if Network Watcher resources should be created for the Azure subscription"
  type        = bool
  default     = true
}

variable "network_watcher_resource_group" {
  description = "The name of the resource group in which the network watcher is created. Changing this forces a new resource to be created."
  type        = string
}

variable "network_watcher_name" {
  description = "The name of the Network Watcher. Changing this forces a new resource to be created."
  type        = string
}

variable "create_virtual_network" {
  description = "create create virtual network"
  type        = bool
  default     = true
}
variable "virtual_network_name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "address_space" {
  description = "The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
}

# variable "dns_servers" {
#   description = "List of IP addresses of DNS servers"
#   type = list(string)
# }

variable "create_subnet" {
  description = "Create subnet or not"
  type        = bool
  default     = true
}
variable "subnet_name" {
  description = "For each subnet, create an object that contain fields"
  type        = string
}

variable "subnet_address_prefix" {
  description = "The address prefixes to use for the subnet."
  type        = string
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web."
  type        = list(string)
}

# variable "service_endpoint_policy_ids" {
#   description = "The list of IDs of Service Endpoint Policies to associate with the subnet."
#   type = list(string)
# }

variable "private_endpoint_network_policies_enabled" {
  description = "Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  type        = bool
  default     = true
}

variable "private_link_service_network_policies_enabled" {
  description = "Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  type        = bool
  default     = true
}

variable "delegation" {
  description = "A name for this delegation. A service_delegation block as defined below."
  type        = map(string)
  default = {
    "name" = string
    "service_delegation" = {
      "name"    = string
      "actions" = string
    }
  }
}

variable "network_security_group_name" {
  description = "Specifies the name of the network security group. Changing this forces a new resource to be created."
  type        = string
}

variable "security_rule" {
  description = "List of objects representing security rules, as defined below."
  type        = map(string)
  default = {
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    description                = string
  }
}

variable "enable_private_endpoint" {
  description = "To enable private endpoint to connect mssqldatabase"
  type        = bool
  default     = true
}

variable "mssql_private_endpoint_name" {
  description = "Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

variable "existing_vnet_id" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "existing_subnet_id" {
  description = "For each subnet, create an object that contain fields"
  type        = string
}

variable "existing_private_dns_zone" {
  description = "Private dns zone information"
  type        = string
}

variable "deploy_log_analytics_workspace" {

}

variable "log_analytics_ws_name" {

}

variable "deploy_key_vault" {

}

variable "keyvault_name" {

}

variable "enable_mssql_server_extended_auditing_policy" {

}

variable "enable_mssql_server_microsoft_support_auditing_policy" {

}

variable "enable_mssql_server_security_auditing_policy" {

}

variable "enable_database_extended_auditing_policy" {

}

variable "enable_vulnerability_assessment" {

}

variable "enable_log_monitoring" {

}

variable "storage_account_name" {

}

variable "storage_account_kind" {

}

variable "storage_account_tier" {

}

variable "storage_account_replication_type" {

}

variable "enable_https_traffic_only" {

}

variable "min_tls_version" {

}

variable "storage_container_name" {

}

variable "container_access_type" {

}

variable "mssql_server_name" {

}

variable "mssql_server_version" {

}

variable "administrator_login" {

}

variable "mssql_server_minimum_tls_version" {

}

variable "public_network_access_enabled" {

}

variable "mssql_server_connection_policy" {

}

variable "outbound_network_restriction_enabled" {

}

variable "identity" {

}

variable "retention_in_days" {

}

variable "storage_account_access_key_is_secondary" {

}

variable "enable_threat_detection_policy" {

}

variable "policy_state" {

}

variable "disabled_alerts" {

}

variable "email_account_admins" {

}

variable "email_addresses" {

}

variable "retention_days" {

}

variable "auto_rotation_enabled" {

}

variable "enable_server_vulnerability_assessment" {

}

variable "enable_email_subscription_admins" {

}

variable "emails" {

}

variable "mssql_server_dns_alias" {

}

variable "sql_database_name" {

}

variable "sku_name" {

}

variable "collation" {

}

variable "maintenance_configuration_name" {

}

variable "license_type" {

}

variable "transparent_data_encryption_enabled" {

}

variable "mandatory_tags" {

}

variable "additional_tags" {

}

variable "enable_private_endpoint" {

}

variable "existing_private_dns_zone" {
  default = ""
}