subscription_id = ""
create_resource_group = "false"
resource_group_name = ""
location = "eastus"

create_network_watcher_resource_group = true
network_watcher_resource_group = ""
network_watcher_name = ""

create_virtual_network = "false"
virtual_network_name = ""
address_space = ["10.1.0.0/16"]
existing_vnet_id = ""

create_subnet = "false"
subnet_name = "mssql-management"
existing_subnet_id = ""
subnet_address_prefix = ["10.1.2.0/24"]
service_endpoints = ["Microsoft.Storage"]
#service_endpoint_policy_ids
delegation = {
    name = "mssql-delegation"
    service_delegation = {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
}

network_security_group_name = "nsg-mssql-management"

security_rule = {
    nsg_inbound_rules = {
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        name = "weballow", 
        priority = "100", 
        direction = "Inbound", 
        access = "Allow", 
        protocol = "Tcp", 
        source_port_range = "*", 
        destination_port_range = "80", 
        source_address_prefix = "*", 
        destination_address_prefix = "0.0.0.0/0"
        # [name = "weballow1",priority =  "101", direction = "Inbound", access = "Allow", protocol ="", source_port_range ="*", destination_port_range = "443", source_address_prefix = "*", destination_address_prefix = ""] ,
        # [name = "weballow2", priority = "102", direction = "Inbound", access = "Allow", protocol ="Tcp", source_port_range ="*", destination_port_range = "8080-8090", source_address_prefix = "*", destination_address_prefix = ""]
    },

    nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        name = "ntp_out", 
        priority = "103",
        direction =  "Outbound", 
        access = "Allow", 
        protocol ="Udp", 
        source_port_range ="*", 
        destination_port_range = "123", 
        source_address_prefix = "", 
        destination_address_prefix = "0.0.0.0/0"]
    }
}

enable_private_endpoint = true
mssql_private_endpoint_name = "mssql-private-enpoint"



deploy_log_analytics_workspace ="true"
log_analytics_ws_name = ""

deploy_key_vault = "true"
keyvault_name = ""

enable_mssql_server_extended_auditing_policy = true
enable_mssql_server_microsoft_support_auditing_policy = true
enable_mssql_server_security_auditing_policy = true

enable_database_extended_auditing_policy = true
enable_vulnerability_assessment = true
enable_log_monitoring = true

storage_account_name = "auditingsa"
storage_account_kind = "StorageV2"
storage_account_tier = "Standard"
storage_account_replication_type = "GRS"
enable_https_traffic_only = true
min_tls_version = "TLS1_2"

storage_container_name = "vulnerability-assessment"
container_access_type = "private"

mssql_server_name = "ls-sqlserver"
mssql_server_version = "12.0"
administrator_login = "adminlogin"
mssql_server_minimum_tls_version = "1.2"
public_network_access_enabled = true
mssql_server_connection_policy = "Default"
outbound_network_restriction_enabled = "false"
identity = true

retention_in_days = "90"                
storage_account_access_key_is_secondary = false

enable_threat_detection_policy = true
policy_state = "Enabled"
disabled_alerts = ["Access_Anomaly","Sql_Injection","Sql_Injection_Vulnerability"]
email_account_admins = ""
email_addresses = ""
retention_days = "90"
auto_rotation_enabled = true
enable_server_vulnerability_assessment = true
enable_email_subscription_admins = true
emails = ""

mssql_server_dns_alias = ""

sql_database_name = ""
sku_name = "Basic" 
collation = "SQL_Latin1_General_CP1_CI_AS"
maintenance_configuration_name = ["SQL_Default"]
license_type = "BasePrice"
transparent_data_encryption_enabled = true
#zone_redundant = ""


mandatory_tags  = ""
additional_tags  = ""

enable_private_endpoint = true
existing_private_dns_zone = ""


