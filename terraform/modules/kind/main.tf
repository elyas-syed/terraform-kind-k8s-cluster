resource "kind_cluster" "cluster" {
  name            = var.cluster_name
  kubeconfig_path = pathexpand("~/.kube/config")
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 30001
        host_port      = 30001
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30020
        host_port      = 30020
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30030
        host_port      = 30030
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30040
        host_port      = 30040
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30050
        host_port      = 30050
        protocol       = "TCP"
      }
    }
    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

