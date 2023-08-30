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

variable "dns_servers" {
  description = "List of IP addresses of DNS servers"
  type        = list(string)
}

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

variable "service_endpoint_policy_ids" {
  description = "The list of IDs of Service Endpoint Policies to associate with the subnet."
  type        = list(string)
}

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

