resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.7.0"
  
  values = [
    <<-EOT
    controller:
      service:
        type: NodePort
      hostPort:
        enabled: true
      nodeSelector:
        kubernetes.io/hostname: terraform-kind-cluster-control-plane
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
    EOT
  ]
  
  # Use the cluster_ready variable to establish dependency
  depends_on = [var.cluster_ready]
}