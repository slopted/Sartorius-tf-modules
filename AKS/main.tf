module "aks_production" {
    source  = "Azure/terraform-azurerm-avm-ptn-aks-production"
    version = "0.5.0" # Update to the latest release as needed

    # Required variables
    name                = local.name
    location            = var.location
    resource_group_name = var.resource_group_name
    tags                = local.tags

    # Azure Container Registry (ACR) configuration
    acr = var.create_acr == true ? {
        name                          = local.acr_name
        private_dns_zone_resource_ids = var.acr.private_dns_zone_resource_ids
        subnet_resource_id            = var.acr.subnet_resource_id
        zone_redundancy_enabled       = var.acr.zone_redundancy_enabled
    } : null

    # Example: Minimal configuration
    kubernetes_version = "1.28.3"
    agent_pool_profiles = [
        {
            name       = "nodepool1"
            count      = 3
            vm_size    = "Standard_DS2_v2"
            os_type    = "Linux"
            mode       = "System"
            os_disk_size_gb = 128
        }
    ]

    # Add other variables as needed for your scenario.
    # See https://github.com/Azure/terraform-azurerm-avm-ptn-aks-production/tree/main for all available options.
}