data "azurerm_resource_group" "existing_resource_group" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

data "azurerm_virtual_network" "existing_virtual_network" {
  count               = var.create_virtual_network ? 0 : 1
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "existing_subnet" {
  count                = var.create_subnet ? 0 : 1
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "existing_log_ws" {
  count               = var.deploy_log_analytics_workspace ? 0 : 1
  name                = var.log_analytics_ws_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "existing_key_vault" {
  count               = var.deploy_key_vault ? 0 : 1
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_client_config" "current" {

}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

data "azurerm_private_endpoint_connection" "private_endpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_private_endpoint.mssql_private_endpoint.0.name
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_mssql_server.mssql_server]
}

