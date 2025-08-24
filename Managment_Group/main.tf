resource "azurerm_management_group" "example_parent" {
  display_name = var.display_name
  parent_management_group_id = var.parent_management_group_id != null && var.parent_management_group_id != "" ? var.parent_management_group_id : null
}