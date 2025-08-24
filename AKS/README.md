# Module: Azure Container Registry (ACR)

This Terraform module provisions an Azure Kubernetes Service (AKS) cluster following best practices for secure, scalable, and manageable deployments in Azure.

## Input Variables

| Name                        | Type      | Description                                                                                                                        | Default                | Required |
|-----------------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------|------------------------|----------|
| name                        | string    | The name for the AKS resources created in the specified Azure Resource Group.                                                      | n/a                    | yes      |
| uami_name                   | string    | (Optional) The name of the User Assigned Managed Identity (UAMI) to be used with the AKS cluster.                                  | null                   | no       |
| environment                 | string    | The environment for the AKS deployment. Allowed: `prod`, `nonprod`.                                                               | n/a                    | yes      |
| additional_context          | string    | (Optional) A string used as the last digit in the AKS cluster name for additional context or metadata.                             | "01"                   | no       |
| CostCenter                  | string    | (Optional) The cost center associated with the AKS resources. Must start with 'scs' followed by up to 7 digits.                   | n/a                    | yes      |
| Owner                       | string    | (Optional) The owner of the AKS resources.                                                                                        | n/a                    | yes      |
| Migration                   | string    | (Optional) Migration information for the AKS resources. Allowed: `yes`, `no`.                                                     | n/a                    | yes      |
| acr                         | object    | (Optional) Parameters for the Azure Container Registry to use with the Kubernetes Cluster.                                         | null                   | no       |
| location                    | string    | The Azure region where the resources should be deployed.                                                                          | n/a                    | yes      |
| network                     | object    | Values for the networking configuration of the AKS cluster.                                                                       | n/a                    | yes      |
| resource_group_name         | string    | The resource group where the resources will be deployed.                                                                          | n/a                    | yes      |
| agents_tags                 | map(string)| (Optional) A mapping of tags to assign to the Node Pool.                                                                         | {}                     | no       |
| default_node_pool_vm_sku    | string    | The VM SKU to use for the default node pool.                                                                                      | "Standard_D4d_v5"      | no       |
| enable_telemetry            | bool      | Enable telemetry for the module.                                                                                                  | true                   | no       |
| kubernetes_version          | string    | Specify which Kubernetes release to use. Specify only minor version, such as '1.28'.                                              | null                   | no       |
| lock                        | object    | Controls the Resource Lock configuration for this resource. See below for structure.                                               | null                   | no       |
| managed_identities          | object    | Controls the Managed Identity configuration on this resource. See below for structure.                                             | {}                     | no       |
| monitor_metrics             | object    | (Optional) Specifies a Prometheus add-on profile for the Kubernetes Cluster.                                                      | null                   | no       |
| network_policy              | string    | (Optional) Sets up network policy to be used with Azure CNI. Allowed: `calico`, `cilium`.                                         | "cilium"               | no       |
| node_labels                 | map(string)| (Optional) A map of Kubernetes labels which should be applied to nodes in this Node Pool.                                         | {}                     | no       |
| node_pools                  | map(object)| A map of node pools to create and attach to the Kubernetes cluster. See below for structure.                                      | {}                     | no       |
| orchestrator_version        | string    | Specify which Kubernetes release to use. Specify only minor version, such as '1.28'.                                              | null                   | no       |
| os_disk_type                | string    | (Optional) Specifies the OS Disk Type used by the agent pool. Allowed: `Managed`, `Ephemeral`.                                    | "Managed"              | no       |
| os_sku                      | string    | (Optional) Specifies the OS SKU used by the agent pool. Allowed: `Ubuntu`, `AzureLinux`.                                          | "AzureLinux"           | no       |
| outbound_type               | string    | (Optional) Specifies the outbound type for cluster egress. Allowed: `loadBalancer`, `userDefinedRouting`, `managedNATGateway`, `userAssignedNATGateway`. | "loadBalancer" | no       |
| private_dns_zone_id         | string    | (Optional) The ID of Private DNS Zone to delegate to this Cluster.                                                                | null                   | no       |
| private_dns_zone_id_enabled | bool      | (Optional) Enable private DNS zone integration for the AKS cluster.                                                               | false                  | no       |
| rbac_aad_admin_group_object_ids | list(string) | Object ID of groups with admin access.                                                                                       | null                   | no       |
| rbac_aad_azure_rbac_enabled | bool      | (Optional) Is Role Based Access Control based on Azure AD enabled?                                                                | null                   | no       |
| rbac_aad_tenant_id          | string    | (Optional) The Tenant ID used for Azure Active Directory Application.                                                             | null                   | no       |
| tags                        | map(string)| (Optional) Tags of the resource.                                                                                                 | null                   | no       |

**Note:**  
- Refer to `variables.tf` for full details, validation rules, and nested object structures.
- See inline comments in the variables for additional constraints and example input structures.
- Some objects (e.g., `lock`, `managed_identities`, `node_pools`, `network`) have nested attributes; see `variables.tf` for their schemas.
- Naming and value constraints are enforced via Terraform validation blocks.
- For more information on AKS naming rules, see [AKS API documentation](https://learn.microsoft.com/en-us/rest/api/aks/managed-clusters/create-or-update?view=rest-aks-2023-10-01&tabs=HTTP).

> **Note:** Refer to `variables.tf` for full details, validation rules, and nested object structures.

## Example Usage
```hcl
# main.tf

module "aks" {
    source                      = "git::https://github.com/slopted/Sartorius-tf-modules.git//AKS"
    name                        = var.name
    uami_name                   = var.uami_name
    environment                 = var.environment
    additional_context          = var.additional_context
    CostCenter                  = var.CostCenter
    Owner                       = var.Owner
    Migration                   = var.Migration
    location                    = var.location
    resource_group_name         = var.resource_group_name
    enable_telemetry            = var.enable_telemetry
    kubernetes_version          = var.kubernetes_version
    network_policy              = var.network_policy
    os_disk_type                = var.os_disk_type
    os_sku                      = var.os_sku
    outbound_type               = var.outbound_type
    private_dns_zone_id_enabled = var.private_dns_zone_id_enabled
    private_dns_zone_id         = var.private_dns_zone_id
    rbac_aad_tenant_id          = var.rbac_aad_tenant_id
    tags                        = var.tags
    acr                         = var.acr
    network                     = var.network
    managed_identities          = var.managed_identities
    node_pools                  = var.node_pools
}
```

```hcl
# example.tfvars

name                = "aks-prod"
uami_name           = "az-uami-aks-prod-01"
environment         = "prod"
additional_context  = "01"
CostCenter          = "scs1234567"
Owner               = "jane.doe@example.com"
Migration           = "no"
location            = "westeurope"
resource_group_name = "rg-aks-prod"
enable_telemetry    = true
kubernetes_version  = "1.30"
network_policy      = "cilium"
os_disk_type        = "Managed"
os_sku              = "Ubuntu"
outbound_type       = "loadBalancer"
private_dns_zone_id_enabled = false
private_dns_zone_id = null
rbac_aad_tenant_id  = null
tags = {
    environment = "prod"
    project     = "aks"
}

acr = {
    name                          = "acrprod01"
    subnet_resource_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-aks-prod/providers/Microsoft.Network/virtualNetworks/vnet-aks-prod/subnets/acr"
    private_dns_zone_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-aks-prod/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"]
}

network = {
    node_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-aks-prod/providers/Microsoft.Network/virtualNetworks/vnet-aks-prod/subnets/aks"
    pod_cidr       = "10.244.0.0/16"
    service_cidr   = "10.0.0.0/16"
}

managed_identities = {
    user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-aks-prod/providers/Microsoft.ManagedIdentity/userAssignedIdentities/az-uami-aks-prod-01"]
}
```
