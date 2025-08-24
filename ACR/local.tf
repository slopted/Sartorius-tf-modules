locals {
  # Local variables for ACR module
  csp_abbreviation = "az"
  resource_type    = "acr"
  naming           = "${local.csp_abbreviation}${local.resource_type}${var.location}-${var.environment}-${var.additional_context}"
  name             = var.name != null ? var.name : local.naming
  tags = {
    CostCenter = var.CostCenter
    Owner      = var.Owner
    Migration  = var.Migration
  }
}
