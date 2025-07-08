# Create a Kind Kubernetes cluster using the provided config
resource "null_resource" "create_kind_cluster" {
  provisioner "local-exec" {
    command = "kind create cluster --name terraform-kind --config=../kind/kind-config.yaml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name terraform-kind"
  }
}
