# Module: Azure Container Registry (ACR)

This Terraform module provisions an Azure Container Registry (ACR) using the official AVM module. It encapsulates best practices for secure, scalable, and manageable container registry deployments in Azure.

## Input Variables

| Name                         | Type    | Description                                                                                                    | Default    | Required |
|------------------------------|---------|----------------------------------------------------------------------------------------------------------------|------------|----------|
| name                         | string  | The name of the Container Registry. Must be 5-50 alphanumeric characters.                                      | n/a        | yes      |
| environment                  | string  | The environment for the resource (e.g., dev, test, prod).                                                      | n/a        | yes      |
| additional_context           | string  | Additional context to append to the resource name for uniqueness.                                              | "01"       | no       |
| CostCenter                   | string  | (Optional) The cost center associated with the resources. Must start with 'scs' and up to 7 digits.            | n/a        | yes      |
| Owner                        | string  | (Optional) The owner of the resources.                                                                         | n/a        | yes      |
| Migration                    | string  | (Optional) Migration information. Allowed values: 'yes' or 'no'.                                               | n/a        | yes      |
| location                     | string  | The Azure region where the Container Registry will be deployed.                                                | "we"       | no       |
| resource_group_name          | string  | The resource group where the resources will be deployed.                                                       | n/a        | yes      |
| customer_managed_key         | object  | Customer-managed key for encryption. See variables.tf for structure.                                           | null       | no       |
| diagnostic_settings          | map     | Diagnostic settings for monitoring and logging.                                                                | {}         | no       |
| enable_telemetry             | bool    | Enable telemetry for the module.                                                                               | false      | no       |
| enable_trust_policy          | bool    | Specifies whether trust policy is enabled for this Container Registry.                                         | true       | no       |
| lock                         | object  | Resource lock configuration. Possible values for kind: "CanNotDelete", "ReadOnly".                             | null       | no       |
| managed_identities           | object  | Managed identity configuration.                                                                                | {}         | no       |
| private_endpoints            | map     | Private endpoint configuration.                                                                                | {}         | no       |
| private_endpoints_manage_dns_zone_group | bool | Manage private DNS zone groups for private endpoints.                                                          | true       | no       |
| role_assignments             | map     | Role assignments for the registry.                                                                             | {}         | no       |
| tags                         | map     | Tags to assign to the registry.                                                                                | null       | no       |
| admin_enabled                | bool    | Specifies whether the admin user is enabled.                                                                   | false      | no       |
| anonymous_pull_enabled       | bool    | Specifies whether anonymous (unauthenticated) pull access is allowed. Requires Standard or Premium SKU.        | false      | no       |
| data_endpoint_enabled        | bool    | Specifies whether to enable dedicated data endpoints. Requires Premium SKU.                                    | false      | no       |
| export_policy_enabled        | bool    | Specifies whether export policy is enabled. Requires public_network_access_enabled = false to disable.         | true       | no       |
| georeplications              | list    | List of geo-replication configurations.                                                                        | []         | no       |
| network_rule_bypass_option   | string  | Allow trusted Azure services access. Possible values: "AzureServices", "None".                                 | "AzureServices" | no   |
| network_rule_set             | object  | Network rule set configuration. Requires Premium SKU.                                                          | null       | no       |
| public_network_access_enabled| bool    | Specifies whether public access is permitted.                                                                  | false      | no       |
| quarantine_policy_enabled    | bool    | Specifies whether the quarantine policy is enabled.                                                            | false      | no       |
| retention_policy_in_days     | number  | Retention policy for untagged manifests (in days).                                                             | 7          | no       |
| sku                          | string  | The SKU name of the Container Registry. Possible values: "Basic", "Standard", "Premium".                       | "Premium"  | no       |
| zone_redundancy_enabled      | bool    | Specifies whether zone redundancy is enabled.                                                                  | true       | no       |

> **Note:** Refer to `variables.tf` for full details, validation rules, and nested object structures.

## Output Values

| Name           | Description                                         |
|----------------|-----------------------------------------------------|
| name           | The name of the parent resource.                    |
| resource       | The full output object for the resource.            |
| resource_id    | The resource ID for the parent resource.            |

**Note:**  
- Output values are defined in `outputs.tf` and expose key attributes for use in other modules or root configurations.
- The `resource` output provides the complete set of attributes returned by the AVM module for advanced use cases.

## Resources

This module manages the following resources (via the AVM module):

- **azurerm_container_registry**: The main Azure Container Registry resource.
- **azurerm_private_endpoint**: Private endpoint(s) for secure access (if configured).
- **azurerm_role_assignment**: Role assignments for access control (if configured).
- **azurerm_monitor_diagnostic_setting**: Diagnostic settings for monitoring (if configured).

## File Structure

```
.
├── main.tf         # Core resource definitions (module block)
├── variables.tf    # Input variable declarations
├── outputs.tf      # Output value definitions
├── README.md       # Module documentation
└── ...             # Additional supporting files
```

## Example Usage

```hcl
module "acr" {
    source  = "git::https://github.com/slopted/Sartorius-tf-modules.git//ACR?ref=1.0.0"

    name                        = "myacrprod001"
    location                    = "westeurope"
    resource_group_name         = "rg-prod-containers-001"
    sku                         = "Premium"
    admin_enabled               = false
    enable_trust_policy         = true
    public_network_access_enabled = false
    zone_redundancy_enabled     = true
    retention_policy_in_days    = 14

    customer_managed_key = {
        key_vault_id = "azurerm_key_vault.example.id"
        key_name     = "acr-cmk"
        key_version  = "1234567890abcdef"
    }

    diagnostic_settings = {
        log_analytics_workspace_id = "azurerm_log_analytics_workspace.example.id"
        logs = [
            {
                category = "ContainerRegistryLoginEvents"
                enabled  = true
            },
            {
                category = "ContainerRegistryRepositoryEvents"
                enabled  = true
            }
        ]
    }

    enable_telemetry = false

    lock = {
        kind = "ReadOnly"
    }

    managed_identities = {
        system_assigned = true
        user_assigned   = ["azurerm_user_assigned_identity.example.id"]
    }

    private_endpoints = {
        "acr-pe" = {
            subnet_id = "azurerm_subnet.example.id"
            private_dns_zone_ids = [
                "azurerm_private_dns_zone.acr.id"
            ]
        }
    }

    private_endpoints_manage_dns_zone_group = true

    role_assignments = {
        "acr-push" = {
            principal_id = "00000000-0000-0000-0000-000000000000"
            role_definition_name = "AcrPush"
        }
    }

    tags = {
        environment = "production"
        workload    = "containers"
        CostCenter  = "scs1234567"
        Owner       = "jane.doe@example.com"
        Migration   = "no"
    }

    anonymous_pull_enabled     = false
    data_endpoint_enabled      = true
    export_policy_enabled      = true

    georeplications = [
        {
            location                  = "northeurope"
            zone_redundancy_enabled   = true
            regional_endpoint_enabled = true
            tags = {
                environment = "production"
                region      = "northeurope"
            }
        }
    ]

    network_rule_bypass_option = "AzureServices"

    network_rule_set = {
        default_action = "Deny"
        ip_rules = [
            {
                action   = "Allow"
                ip_range = "203.0.113.0/24"
            }
        ]
        virtual_network_rules = [
            {
                action      = "Allow"
                subnet_id   = "azurerm_subnet.example.id"
            }
        ]
    }

    quarantine_policy_enabled = false

See the `examples/` directory for more comprehensive usage scenarios.
