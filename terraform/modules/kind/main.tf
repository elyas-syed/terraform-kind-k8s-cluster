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