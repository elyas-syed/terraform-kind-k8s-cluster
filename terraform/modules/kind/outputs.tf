output "cluster_name" {
  description = "The name of the created Kind cluster"
  value       = kind_cluster.cluster.name
}

output "kubeconfig_path" {
  description = "The path to the kubeconfig file"
  value       = kind_cluster.cluster.kubeconfig_path
}

output "kubectl_context" {
  description = "The kubectl context name for the cluster"
  value       = "kind-${kind_cluster.cluster.name}"
}

output "endpoint" {
  description = "The Kubernetes API server endpoint"
  value       = kind_cluster.cluster.endpoint
}

output "success_message" {
  description = "Confirmation that the Kind cluster was created"
  value       = "Kind cluster named '${kind_cluster.cluster.name}' has been created successfully!"
}


