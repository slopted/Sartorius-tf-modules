output "name" {
  description = "The name of the parent resource."
  value       = module.avm-res-containerregistry-registry.name
}

output "resource" {
  description = "This is the full output for the resource."
  value       = module.avm-res-containerregistry-registry
}

output "resource_id" {
  description = "The resource id for the parent resource."
  value       = module.avm-res-containerregistry-registry.resource_id
}