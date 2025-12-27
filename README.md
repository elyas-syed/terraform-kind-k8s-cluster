# kind-terraform-k8s-cluster

## Project Overview

This project provides a complete Terraform configuration to create and manage a local Kubernetes cluster using Kind (Kubernetes in Docker). It's designed for developers who need a lightweight, reproducible Kubernetes environment for development and testing purposes.

## Architecture

The project creates a Kind cluster with the following components:

- **Terraform modules**: Modular approach for better maintainability and reusability
- **Kind cluster**: Local Kubernetes cluster running in Docker containers (1 control-plane, 2 workers)
- **ArgoCD**: GitOps continuous delivery tool for Kubernetes applications
- **Port mapping configuration**: Direct port mapping from container to host for easy service access
  - Port 30001: NodePort services (e.g., NGINX)
  - Port 30020: ArgoCD server (HTTP)
  - Ports 30030, 30040, 30050: Reserved for future services
- **App of Apps pattern**: ArgoCD Application that manages child applications
- **NGINX example deployment**: Sample application to verify the cluster functionality

## Prerequisites

- **Docker**: Container runtime (v20.10.0 or newer recommended)
- **kubectl**: Kubernetes command-line tool (v1.20.0 or newer recommended)
- **Kind**: Kubernetes in Docker tool (v0.11.0 or newer recommended)
  - See [Kind Installation Guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- **Terraform**: Infrastructure as Code tool (v1.0.0 or newer recommended)

## Usage

### Setting Up the Cluster

1. Clone this repository
   ```bash
   git clone https://github.com/elyas-syed/kind-terraform-k8s-cluster.git
   cd kind-terraform-k8s-cluster
   ```

2. **Step 1: Create the Kind cluster**
   
   Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

   Initialize Terraform:
   ```bash
   terraform init
   ```

   Create the cluster:
   ```bash
   terraform apply
   ```
   When prompted, type `yes` to confirm the creation of resources.

   Verify the cluster is running:
   ```bash
   kubectl get nodes
   ```
   You should see three nodes (one control-plane and two workers) in the `Ready` state.

3. **Step 2: Bootstrap ArgoCD**
   
   Navigate to the bootstrap directory:
   ```bash
   cd ../bootstrap
   ```

   Initialize Terraform:
   ```bash
   terraform init
   ```

   Deploy ArgoCD:
   ```bash
   terraform apply
   ```
   When prompted, type `yes` to confirm.

   Wait for ArgoCD to be ready (this may take a few minutes):
   ```bash
   kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
   ```

4. **Step 3: Access ArgoCD UI**
   
   Get the ArgoCD admin password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
   ```

   Access the ArgoCD UI:
   - URL: http://localhost:30020
   - Username: `admin`
   - Password: (from the command above)

5. **Step 4: Configure App of Apps (Optional)**
   
   Before applying the App of Apps pattern, update `apps/app-of-apps.yaml`:
   - Replace `<your-username>` and `<your-repo>` with your actual GitHub repository details
   
   Apply the App of Apps:
   ```bash
   kubectl apply -f ../apps/app-of-apps.yaml
   ```

### Cleaning Up

To delete all resources, run destroy in reverse order:

1. Delete ArgoCD and applications:
   ```bash
   cd bootstrap
   terraform destroy -auto-approve
   ```

2. Delete the Kind cluster:
   ```bash
   cd ../terraform
   terraform destroy -auto-approve
   ```

## Configuration Details

### Cluster Configuration

The Kind cluster configuration is defined inline in `terraform/modules/kind/main.tf`. The cluster is configured with:

- **Node Structure**:
  - 1 control-plane node (manages the cluster)
  - 2 worker nodes (run your workloads)

- **Port Mapping Configuration**:
  - Container port 30001 → Host port 30001 (for NodePort services like NGINX)
  - Container port 30020 → Host port 30020 (for ArgoCD server HTTP)
  - Container ports 30030, 30040, 30050 → Reserved for future services
  - Protocol: TCP
  - This allows direct access to services from your local machine

> **Note**: The `kind/kind-config.yaml` file exists but is not currently used. The configuration is defined inline in the Terraform module.

### Terraform Module Structure

The project uses a modular Terraform structure:

- **Root Module** (`terraform/`): Defines the overall infrastructure
  - `main.tf`: References the Kind module
  - `providers.tf`: Configures required providers (Kind, Kubernetes, Helm)
  - `outputs.tf`: Defines outputs from the deployment

- **Kind Module** (`terraform/modules/kind/`): Encapsulates Kind cluster creation logic
  - Uses the tehcyx/kind provider for native Terraform integration
  - Handles cluster creation, configuration, and destruction
  - Defines port mappings and node configuration

- **Bootstrap Module** (`bootstrap/`): Deploys ArgoCD to the cluster
  - `bootstrap.tf`: References the ArgoCD module
  - `providers.tf`: Configures Helm and Kubernetes providers with cluster context

- **ArgoCD Module** (`argocd/`): ArgoCD Helm chart configuration
  - `helm.tf`: Defines the ArgoCD Helm release
  - `values.yaml`: Custom ArgoCD configuration (insecure mode, NodePort service)

## Deploying NGINX

The project includes a sample NGINX deployment to verify the cluster functionality:

### Using NodePort

1. Deploy the NGINX application and service:
   ```bash
   kubectl apply -f manifests/nginx-deployment.yaml
   ```

2. Verify the deployment is running:
   ```bash
   kubectl get pods
   ```
   You should see an NGINX pod with status `Running`.

3. Verify the service is created:
   ```bash
   kubectl get services
   ```
   You should see `nginx-service` of type `NodePort` with port mapping `80:30001/TCP`.

## Accessing Services

You can access the deployed services through:

- **NGINX**: http://localhost:30001 (NodePort service)
- **ArgoCD UI**: http://localhost:30020 (NodePort service)
  - Username: `admin`
  - Password: Retrieve with `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

The NodePort 30001 is configured in:
- The Kind cluster configuration (host port mapping in `terraform/modules/kind/main.tf`)
- The NGINX service configuration (Kubernetes service NodePort in `manifests/nginx-deployment.yaml`)

## Troubleshooting

### Common Issues

1. **Cluster creation fails**:
   - Ensure Docker is running
   - Check if another Kind cluster is already using the same name
   - Verify you have sufficient system resources

2. **Cannot access NGINX on port 30001**:
   - Verify the NGINX pods are running: `kubectl get pods`
   - Check the service configuration: `kubectl describe service nginx-service`
   - Ensure no other service is using port 30001 on your host machine

3. **Cannot access ArgoCD UI**:
   - Verify ArgoCD pods are running: `kubectl get pods -n argocd`
   - Check ArgoCD server status: `kubectl get deployment argocd-server -n argocd`
   - Wait for all pods to be ready: `kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s`
   - Ensure no other service is using port 30020 on your host machine

4. **Terraform errors**:
   - Run `terraform init` again to ensure all providers are properly installed
   - Check Terraform and provider versions
   - Ensure you're running commands from the correct directory (`terraform/` or `bootstrap/`)

5. **Bootstrap fails with context errors**:
   - Ensure the Kind cluster is created first (run `terraform apply` in `terraform/` directory)
   - Verify kubectl context: `kubectl config current-context` (should be `kind-terraform-kind-cluster`)
   - If context is different, update `bootstrap/providers.tf` with the correct context name

## Project Structure

```
kind-terraform-k8s-cluster/
├── terraform/              # Main Terraform configuration for Kind cluster
│   ├── main.tf
│   ├── providers.tf
│   ├── outputs.tf
│   └── modules/
│       └── kind/           # Kind cluster module
├── bootstrap/              # ArgoCD bootstrap configuration
│   ├── bootstrap.tf
│   └── providers.tf
├── argocd/                 # ArgoCD Helm chart configuration
│   ├── helm.tf
│   └── values.yaml
├── apps/                   # ArgoCD Application manifests
│   ├── app-of-apps.yaml    # App of Apps pattern
│   └── child-apps/
│       └── nginx.yaml      # Child application (to be configured)
├── manifests/              # Kubernetes manifests (for manual deployment)
│   └── nginx-deployment.yaml
├── kind/                   # Kind config file (currently unused)
│   └── kind-config.yaml
└── README.md
```

## Extending the Project

You can extend this project in several ways:

1. **Add more applications via ArgoCD**:
   - Create child application manifests in `apps/child-apps/`
   - Update `apps/app-of-apps.yaml` with your repository URL
   - Applications will be automatically synced by ArgoCD

2. **Add more applications manually**:
   - Create additional Kubernetes manifests in the `manifests/` directory
   - Deploy using `kubectl apply -f manifests/`

3. **Customize the cluster**:
   - Modify `terraform/modules/kind/main.tf` to change node count or port mappings
   - Add additional port mappings as needed

4. **Add persistent storage**: Configure persistent volumes for stateful applications

5. **Implement CI/CD**: Add GitHub Actions or other CI/CD tools to automate deployments

6. **Add Ingress Controllers**: Deploy Ingress controllers for advanced routing capabilities

7. **Add monitoring solutions**: Implement monitoring and observability tools (Prometheus, Grafana, etc.)

8. **Configure ArgoCD projects**: Create ArgoCD projects for better access control and organization

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.