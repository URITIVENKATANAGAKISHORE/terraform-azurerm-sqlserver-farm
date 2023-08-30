#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

#---------------------------------------------------------
# Random Password 
#----------------------------------------------------------

resource "random_password" "mssqlserver_admin_password" {
  length           = 16
  lower            = true
  min_lower        = 3
  upper            = true
  min_upper        = 3
  numeric          = true
  min_numeric      = 3
  special          = true
  min_special      = 3
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
#---------------------------------------------------------
# Storage Account to keep Audit logs - Default is "false"
#----------------------------------------------------------
resource "azurerm_storage_account" "database_db_storage" {
  count                     = var.enable_mssql_server_extended_auditing_policy || var.enable_mssql_server_microsoft_support_auditing_policy || var.enable_mssql_server_security_auditing_policy || var.enable_database_extended_auditing_policy || var.enable_vulnerability_assessment || var.enable_log_monitoring == true ? 1 : 0
  name                      = var.storage_account_name
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = var.storage_account_kind             #"StorageV2"
  account_tier              = var.storage_account_tier             #"Standard"
  account_replication_type  = var.storage_account_replication_type #"GRS"
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  tags                      = local.tags
}

resource "azurerm_storage_container" "database_db_storage_container" {
  count                 = var.enable_vulnerability_assessment ? 1 : 0
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.database_db_storage.0.name
  container_access_type = var.container_access_type #"private"
}

#----------------------------------------------------------------
# Adding  MsSQL Server creation and settings - Default is "True"
#-----------------------------------------------------------------

resource "azurerm_mssql_server" "mssql_server" {
  name                                 = var.mssql_server_name
  resource_group_name                  = local.resource_group_name
  location                             = local.location
  version                              = var.mssql_server_version
  administrator_login                  = var.administrator_login
  administrator_login_password         = azurerm_key_vault_secret.mssqlserver_admin_password.value
  minimum_tls_version                  = var.mssql_server_minimum_tls_version
  public_network_access_enabled        = var.public_network_access_enabled
  connection_policy                    = var.mssql_server_connection_policy
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  dynamic "identity" {
    for_each = var.identity == true ? [1] : [0]
    content {
      type = "SystemAssigned"
    }
  }
  tags = local.tags
}

resource "azurerm_mssql_server_extended_auditing_policy" "extended_audit_sqlserver" {
  count                                   = var.enable_mssql_server_extended_auditing_policy ? 1 : 0
  server_id                               = azurerm_mssql_server.sql_server.id
  enabled                                 = var.enable_mssql_server_extended_auditing_policy
  storage_endpoint                        = azurerm_storage_account.database_db_storage.0.primary_blob_endpoint
  retention_in_days                       = var.retention_in_days
  storage_account_access_key              = azurerm_storage_account.database_db_storage.0.primary_access_key
  storage_account_access_key_is_secondary = var.storage_account_access_key_is_secondary
  log_monitoring_enabled                  = var.enable_log_monitoring == true && var.log_analytics_workspace_id != null ? true : false
  storage_account_subscription_id         = var.subscription_id
}

resource "azurerm_mssql_server_microsoft_support_auditing_policy" "ms_audit_sqlserver" {
  count                           = var.enable_mssql_server_microsoft_support_auditing_policy ? 1 : 0
  server_id                       = azurerm_mssql_server.sql_server.id
  enabled                         = var.enable_mssql_server_microsoft_support_auditing_policy
  blob_storage_endpoint           = azurerm_storage_account.database_db_storage.0.primary_blob_endpoint
  storage_account_access_key      = azurerm_storage_account.database_db_storage.0.primary_access_key
  log_monitoring_enabled          = var.enable_log_monitoring == true && var.log_analytics_workspace_id != null ? true : false
  storage_account_subscription_id = var.subscription_id

}

resource "azurerm_mssql_server_security_alert_policy" "sa_audit_sqlserver" {
  count                      = var.enable_mssql_server_security_auditing_policy ? 1 : 0
  resource_group_name        = local.resource_group_name
  server_name                = azurerm_mssql_server.mssql_server.name
  state                      = var.policy_state
  disabled_alerts            = var.disabled_alerts
  email_account_admins       = var.email_account_admins
  email_addresses            = var.email_addresses
  retention_days             = var.retention_days
  storage_account_access_key = azurerm_storage_account.database_db_storage.0.primary_blob_endpoint
  storage_endpoint           = azurerm_storage_account.database_db_storage.0.primary_access_key
}

resource "azurerm_mssql_server_transparent_data_encryption" "mssql_server_tde" {
  server_id             = azurerm_mssql_server.mssql_server.id
  key_vault_key_id      = azurerm_key_vault.key_vault.id
  auto_rotation_enabled = var.auto_rotation_enabled
}

resource "azurerm_mssql_server_vulnerability_assessment" "mssql_server_vulnerability" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.sa_audit_sqlserver.id
  storage_container_path          = "${azurerm_storage_account.database_db_storage.0.primary_blob_endpoint}${azurerm_storage_container.database_db_storage_container.name}/"
  storage_account_access_key      = azurerm_storage_account.database_db_storage.0.primary_access_key
  recurring_scans {
    enabled                   = var.enable_server_vulnerability_assessment
    email_subscription_admins = var.enable_email_subscription_admins
    emails                    = var.emails
  }
}

resource "azurerm_mssql_server_dns_alias" "mssql_server_dns_alias" {
  name            = var.mssql_server_dns_alias
  mssql_server_id = azurerm_mssql_server.mssql_server.id
}

#----------------------------------------------------------------
# Adding  MsSQL DataBase creation and settings - Default is "True"
#-----------------------------------------------------------------
resource "azurerm_mssql_database" "single_sql_database" {
  name                                = var.sql_database_name
  server_id                           = azurerm_mssql_server.mssql_server.id
  sku_name                            = var.sku_name
  collation                           = var.collation
  maintenance_configuration_name      = var.maintenance_configuration_name
  license_type                        = var.license_type
  transparent_data_encryption_enabled = var.transparent_data_encryption_enabled
  #zone_redundant = var.zone_redundant
  dynamic "threat_detection_policy" {
    for_each = var.enable_threat_detection_policy == true ? [1] : []
    content {
      state                      = var.policy_state
      disabled_alerts            = var.disabled_alerts
      email_account_admins       = var.email_account_admins
      email_addresses            = var.email_addresses
      retention_days             = var.retention_days
      storage_account_access_key = azurerm_storage_account.database_db_storage.0.primary_blob_endpoint
      storage_endpoint           = azurerm_storage_account.database_db_storage.0.primary_access_key
    }
  }
  tags = local.tags
}

resource "azurerm_mssql_database_extended_auditing_policy" "extended_audit_sqldb" {
  count                                   = var.enable_mssql_database_extended_auditing_policy ? 1 : 0
  database_id                             = azurerm_mssql_database.single_sql_database.id
  enabled                                 = var.enable_mssql_database_extended_auditing_policy
  storage_endpoint                        = azurerm_storage_account.database_db_storage.0.primary_blob_endpoint
  retention_in_days                       = var.retention_in_days
  storage_account_access_key              = azurerm_storage_account.database_db_storage.0.primary_blob_endpoint
  storage_account_access_key_is_secondary = var.storage_account_access_key_is_secondary
  log_monitoring_enabled                  = var.enable_log_monitoring == true && var.log_analytics_workspace_id != null ? true : false
}

resource "azurerm_mssql_database_vulnerability_assessment_rule_baseline" "mssql_db_vulnerability" {
  server_vulnerability_assessment_id = azurerm_mssql_server_vulnerability_assessment.mssql_server_vulnerability.id
  database_name                      = azurerm_mssql_database.single_sql_database.name
  rule_id                            = var.database_vulnerability_rule_id
  baseline_name                      = var.database_vulnerability_baseline_name
  baseline_result                    = var.database_vulnerability_baseline_result
}
