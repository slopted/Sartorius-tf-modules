resource "azurerm_user_assigned_identity" "az-uami-aks-prod-01" {
  location            = var.location
  name                = local.user_assigned_identity_name
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

module "avm-ptn-aks-production" {
  source                      = "Azure/avm-ptn-aks-production/azurerm"
  version                     = "0.5.0"
  kubernetes_version          = "1.30"
  enable_telemetry            = var.enable_telemetry
  name                        = local.name
  tags                        = local.tags
  resource_group_name         = var.resource_group_name
  location                    = var.location
  private_dns_zone_id         = var.private_dns_zone_id_enabled == true ? var.private_dns_zone_id : null
  private_dns_zone_id_enabled = var.private_dns_zone_id_enabled
  rbac_aad_tenant_id          = var.rbac_aad_tenant_id
  network_policy              = var.network_policy
  network = {
    node_subnet_id = var.network.node_subnet_id
    pod_cidr       = var.network.pod_cidr
    service_cidr   = var.network.service_cidr
  }
  acr = {
    name                          = var.acr.name
    subnet_resource_id            = var.acr.subnet_resource_id
    private_dns_zone_resource_ids = var.acr.private_dns_zone_resource_ids
  }
  managed_identities = {
    user_assigned_resource_ids = [azurerm_user_assigned_identity.az-uami-aks-prod-01.id]
  }
  os_disk_type = var.os_disk_type
  node_pools = {
    workload = {
      name                 = "workloadworkload"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.30"
      max_count            = 10
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      os_disk_size_gb      = 128
    },
    ingress = {
      name                 = "ingress"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.30"
      max_count            = 4
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      os_disk_size_gb      = 128
      labels = {
        "ingress" = "true"
      }
    }
  }
}
