output "cluster_name" {
  description = "The name of the created Kind cluster"
  value       = var.cluster_name
}

output "config_path" {
  description = "The path to the Kind cluster configuration file used"
  value       = var.config_path
}

output "kubectl_context" {
  description = "The kubectl context name for the cluster"
  value       = "kind-${var.cluster_name}"
}

output "success_message" {
  description = "Confirmation that the Kind cluster was created"
  value       = "Kind cluster '${var.cluster_name}' has been created successfully!"
}
output "kubeconfig_path" {
  description = "The path to the kubeconfig file for the Kind cluster"
  value       = "${path.module}/kubeconfig-${var.cluster_name}"
}