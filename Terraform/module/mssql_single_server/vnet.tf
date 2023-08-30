
#-------------------------------------
# Network Watcher - Default is "true"
#-------------------------------------
resource "azurerm_resource_group" "nwatcher_resource_group_name" {
  count    = var.create_network_watcher_resource_group ? 1 : 0
  name     = var.network_watcher_resource_group
  location = local.location
  tags     = local.tags
}

resource "azurerm_network_watcher" "nwatcher" {
  count               = var.create_network_watcher_resource_group ? 1 : 0
  name                = var.network_watcher_name
  location            = local.location
  resource_group_name = local.nwatcher_resource_group_name
  tags                = local.tags
}

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "databases_virtual_network" {
  count               = var.create_virtual_network ? 1 : 0
  name                = var.virtual_network_name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = var.address_space #["10.0.0.0/16"]
  #dns_servers         = var.dns_servers #["10.0.0.4", "10.0.0.5"]
  tags = local.tags
}

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/servie network policies, service endpoints and Deligation.
#--------------------------------------------------------------------------------------------------------

resource "azurerm_subnet" "databases_subnet" {
  count                = var.create_subnet ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.databases_virtual_network.name
  address_prefixes     = var.subnet_address_prefix
  service_endpoints    = var.service_endpoints
  #service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
  private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled

  dynamic "delegation" {
    content {
      name = var.delegation.name
      service_delegation {
        name    = var.delegation.service_delegation.name
        actions = var.delegation.service_delegation.actions
      }
    }
  }
}

#-----------------------------------------------
# Network security group - Default is "false"
#-----------------------------------------------
resource "azurerm_network_security_group" "database_nsg" {
  count               = var.create_virtual_network ? 1 : 0
  name                = var.network_security_group_name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  dynamic "security_rule" {
    for_each = concat(lookup(var.security_rule.nsg_inbound_rules, "nsg_inbound_rules", []))
    content {
      name                       = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = "*"
      destination_port_range     = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix      = security_rule.value[6] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[6]
      destination_address_prefix = security_rule.value[7] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[7]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
  dynamic "security_rule" {
    for_each = concat(lookup(var.security_rule.nsg_inbound_rules, "nsg_outbound_rules", []))
    content {
      name                       = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      destination_port_range     = security_rule.value[6] == "" ? "*" : security_rule.value[6]
      source_address_prefix      = security_rule.value[7] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[7]
      destination_address_prefix = security_rule.value[8] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[8]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "database_nsg_assoc" {
  count                     = var.create_virtual_network ? 1 : 0
  subnet_id                 = azurerm_subnet.databases_subnet.0.id
  network_security_group_id = azurerm_network_security_group.database_nsg.0.id
}

#------------------------------------------------------------------
# DNS zone & records for SQL Private endpoints - Default is "false" 
#------------------------------------------------------------------

resource "azurerm_private_endpoint" "mssql_private_endpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = var.mssql_private_endpoint_name
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.existing_subnet_id == null ? azurerm_subnet.databases_subnet.0.id : var.existing_subnet_id
  tags                = local.tags

  private_service_connection {
    name                           = "${var.sql_database_name}-sqldbprivatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    subresource_names              = ["sqlServer"]
  }
  private_dns_zone_group {
    name                 = "${var.sql_database_name}-mssql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.mssql_dns_zone.id]
  }
}


resource "azurerm_private_dns_zone" "mssql_dns_zone" {
  count               = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = "${var.sql_database_name}-privatelink.database.windows.net"
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mssql_vent_link" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "${var.sql_database_name}-vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.mssql_dns_zone.0.name : var.existing_private_dns_zone
  virtual_network_id    = var.existing_vnet_id == null ? azurerm_virtual_network.databases_virtual_network.0.id : var.existing_vnet_id
  registration_enabled  = true
  tags                  = local.tags
}

resource "azurerm_private_dns_a_record" "mssql_dns_record" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_mssql_server.mssql_server.name
  zone_name           = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.mssql_dns_zone.0.name : var.existing_private_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.private_endpoint.0.private_service_connection.0.private_ip_address]
}


