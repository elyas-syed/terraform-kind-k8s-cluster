# Install Kind CLI if it's not already installed
resource "null_resource" "install_kind" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/install_kind.sh"
  }
}

# Ensure the Kind CLI is installed before creating the cluster
resource "null_resource" "ensure_kind_installed" {
  depends_on = [null_resource.install_kind]
}

# Create a Kind Kubernetes cluster using the provided config
resource "null_resource" "create_kind_cluster" {
  depends_on = [null_resource.ensure_kind_installed]

  provisioner "local-exec" {
    command = "kind create cluster --name terraform-kind --config=../kind/kind-config.yaml"
  }
}
