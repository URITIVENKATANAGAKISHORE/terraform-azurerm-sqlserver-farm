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
  description = "The name of the resource group in which the CosmosDB Account is created. Changing this forces a new resource to be created."
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