resource "null_resource" "create_kind_cluster" {
  triggers = {
    cluster_name = var.cluster_name
    config_path  = var.config_path
  }

  provisioner "local-exec" {
    command = "kind create cluster --name ${var.cluster_name} --config=${var.config_path}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name ${self.triggers.cluster_name}"
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [null_resource.create_kind_cluster]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for Kind cluster to become reachable..."

      for i in {1..30}; do
        kubectl get nodes --context kind-${var.cluster_name} &> /dev/null
        if [ $? -eq 0 ]; then
          echo "✅ Kind cluster is ready!"
          exit 0
        fi
        echo "Waiting for cluster... attempt $i"
        sleep 3
      done

      echo "❌ Timed out waiting for Kind cluster to be ready."
      exit 1
    EOT
    interpreter = ["bash", "-c"]
  }
}

