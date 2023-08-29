locals {
  resource_group_name = var.create_resource_group ? data.azurerm_resource_group.existing_resource_group.*.name : azurerm_resource_group.postgresql_resource_group.*.name
  location = var.create_resource_group ? data.azurerm_resource_group.existing_resource_group.*.location : azurerm_resource_group.postgresql_resource_group.*.location 
  tags            = merge(var.mandatory_tags, var.additional_tags)
}