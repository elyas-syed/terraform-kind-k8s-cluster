resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_ingress_version # Optional: pin a version

  create_namespace = true

  values = [
    <<EOF
controller:
  publishService:
    enabled: false
  service:
    type: NodePort
    nodePorts:
      http: 30080
      https: 30443
EOF
  ]
}
