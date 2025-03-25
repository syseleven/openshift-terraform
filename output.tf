output "keypair_name" {
  value       = module.keypair.keypair_name
  description = "The name of the keypair used for nodes"
  sensitive   = "true"
}

output "nodes_subnet" {
  value       = module.network.nodes_subnet
  description = "The nodes subnet"
}
