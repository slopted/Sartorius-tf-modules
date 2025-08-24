locals {
  # Local variables for AKS module
  csp_abbreviation = "az"
  resource_type    = "aks"
  location         = var.location != null ? var.location : "weu"
  naming           = "${local.csp_abbreviation}-${local.resource_type}-${local.location}-${var.environment}-${var.additional_context}"
  name             = var.name != null ? var.name : local.naming
  tags = {
    CostCenter = var.CostCenter
    Owner      = var.Owner
    Migration  = var.Migration
  }

  # User Assigned Managed Identity configuration
  user_assigned_identity_name = var.uami_name != null ? var.uami_name : "${local.csp_abbreviation}-uami-${local.location}-${var.environment}-${var.additional_context}"

  # ACR configuration
  acr_resource_type = "acr"
  acr_name          = var.acr.name != null ? var.acr.name : "${local.csp_abbreviation}${local.acr_resource_type}${local.location}${var.environment}${var.additional_context}"
}
