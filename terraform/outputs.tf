output "cluster_name" {
  description = "The name of the created Kind cluster"
  value       = module.kind_cluster.cluster_name
}

output "cluster_config_path" {
  description = "The path to the Kind cluster configuration file used"
  value       = module.kind_cluster.config_path
}

output "kubectl_context" {
  description = "The kubectl context name for the cluster"
  value       = module.kind_cluster.kubectl_context
}

output "success_message" {
  description = "Confirmation that the Kind cluster was created"
  value       = module.kind_cluster.success_message
}

output "kubeconfig_path" {
  description = "The path to the kubeconfig file for the Kind cluster"
  value       = module.kind_cluster.kubeconfig_path
}