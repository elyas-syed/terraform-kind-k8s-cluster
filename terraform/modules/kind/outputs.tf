output "cluster_name" {
  description = "The name of the created Kind cluster"
  value       = var.cluster_name
}

output "config_path" {
  description = "The path to the Kind cluster configuration file used"
  value       = var.config_path
}