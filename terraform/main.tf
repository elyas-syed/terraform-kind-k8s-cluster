# Install Kind CLI if it's not already installed (macOS/Linux, x86/arm64)
resource "null_resource" "install_kind" {
  provisioner "local-exec" {
    command = <<EOT
      if ! command -v kind &> /dev/null; then
        echo "Installing Kind..."

        OS=$(uname | tr '[:upper:]' '[:lower:]')
        ARCH=$(uname -m)

        if [ "$ARCH" = "x86_64" ]; then
          ARCH_SUFFIX="amd64"
        elif [ "$ARCH" = "arm64" ]; then
          ARCH_SUFFIX="arm64"
        else
          echo "Unsupported architecture: $ARCH"
          exit 1
        fi

        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-${OS}-${ARCH_SUFFIX}
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
      else
        echo "Kind is already installed."
      fi
    EOT
    interpreter = ["bash", "-c"]
  }
}

# Create a Kind Kubernetes cluster using the provided config
resource "null_resource" "create_kind_cluster" {
  depends_on = [null_resource.install_kind]

  provisioner "local-exec" {
    command = "kind create cluster --name terraform-kind --config=../kind/kind-config.yaml"
  }
}