module "avm-res-containerregistry-registry" {
  source                                  = "Azure/avm-res-containerregistry-registry/azurerm"
  version                                 = "0.4.0"
  name                                    = local.name
  location                                = var.location
  resource_group_name                     = var.resource_group_name
  customer_managed_key                    = var.customer_managed_key
  diagnostic_settings                     = var.diagnostic_settings
  enable_telemetry                        = var.enable_telemetry
  enable_trust_policy                     = var.enable_trust_policy
  lock                                    = var.lock
  managed_identities                      = var.managed_identities
  private_endpoints                       = var.private_endpoints
  private_endpoints_manage_dns_zone_group = var.private_endpoints_manage_dns_zone_group
  role_assignments                        = var.role_assignments
  tags                                    = local.tags
  admin_enabled                           = var.admin_enabled
  anonymous_pull_enabled                  = var.anonymous_pull_enabled
  data_endpoint_enabled                   = var.data_endpoint_enabled
  export_policy_enabled                   = var.export_policy_enabled
  georeplications                         = var.georeplications
  network_rule_bypass_option              = var.network_rule_bypass_option
  network_rule_set                        = var.network_rule_set
  public_network_access_enabled           = var.public_network_access_enabled
  quarantine_policy_enabled               = var.quarantine_policy_enabled
  retention_policy_in_days                = var.sku == "Premium" ? var.retention_policy_in_days : null
  sku                                     = var.sku
  zone_redundancy_enabled                 = var.sku == "Premium" ? var.zone_redundancy_enabled : false
}