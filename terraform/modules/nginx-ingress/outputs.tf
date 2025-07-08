output "ingress_class_name" {
  description = "The name of the IngressClass to use with Ingress resources"
  value       = "nginx"
}

output "ingress_namespace" {
  description = "The namespace where the Ingress controller is installed"
  value       = "ingress-nginx"
}

output "status" {
  description = "Status of the deployed Helm chart"
  value       = helm_release.ingress_nginx.status
}