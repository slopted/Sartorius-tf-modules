locals {
    # Local variables for AKS module
    csp_abbreviation = "az"
    resource_type    = "aks"
    location         = var.location != null ? var.location : "weu"
    naming           = "${local.csp_abbreviation}${local.resource_type}${local.location}-${var.environment}-${var.additional_context}"
    name             = var.name != null ? var.name : local.naming
    tags = {
        CostCenter = var.CostCenter
        Owner      = var.Owner
        Migration  = var.Migration
    }

    # ACR configuration
    create_acr = var.create_acr != null ? var.create_acr : false
    acr_resource_type = "acr"

    acr_name = var.create_acr == true ? (
        var.acr.name != null ? var.acr.name : "${local.csp_abbreviation}${local.acr_resource_type}${local.location}-${var.environment}-${var.additional_context}"
    ) : null
}
