# kind-terraform-k8s-cluster

## Project Overview

This project provides a complete Terraform configuration to create and manage a local Kubernetes cluster using Kind (Kubernetes in Docker). It's designed for developers who need a lightweight, reproducible Kubernetes environment for development and testing purposes.

## Architecture

The project creates a Kind cluster with the following components:

- **Terraform modules**: Modular approach for better maintainability and reusability
- **Kind cluster**: Local Kubernetes cluster running in Docker containers
- **Port mapping configuration**: Direct port mapping from container to host for easy service access
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
   git clone https://github.com/yourusername/kind-terraform-k8s-cluster.git
   cd kind-terraform-k8s-cluster
   ```

2. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Create the cluster:
   ```bash
   terraform apply
   ```
   When prompted, type `yes` to confirm the creation of resources.

5. Verify the cluster is running:
   ```bash
   kubectl get nodes
   ```
   You should see three nodes (one control-plane and two workers) in the `Ready` state.

### Cleaning Up

To delete the cluster and all associated resources:

```bash
terraform destroy -auto-approve
```

## Configuration Details

### Cluster Configuration

The Kind cluster configuration is defined in `kind/kind-config.yaml`. The cluster is configured with:

- **Node Structure**:
  - 1 control-plane node (manages the cluster)
  - 2 worker nodes (run your workloads)

- **Port Mapping Configuration**:
  - Container port 30001 mapped to host port 30001 (for NodePort services)
  - Protocol: TCP
  - This allows direct access to services from your local machine

### Terraform Module Structure

The project uses a modular Terraform structure:

- **Root Module**: Defines the overall infrastructure
  - `main.tf`: References the Kind module
  - `providers.tf`: Configures required providers (Kind, Kubernetes)
  - `outputs.tf`: Defines outputs from the deployment

- **Kind Module**: Encapsulates Kind cluster creation logic
  - Located in `terraform/modules/kind/`
  - Uses the tehcyx/kind provider for native Terraform integration
  - Handles cluster creation, configuration, and destruction

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

You can access the NGINX deployment through:

- NodePort method: http://localhost:30001

The NodePort 30001 is configured in both:
- The Kind cluster configuration (host port mapping in `kind-config.yaml`)
- The NGINX service configuration (Kubernetes service NodePort in `nginx-deployment.yaml`)

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

3. **Terraform errors**:
   - Run `terraform init` again to ensure all providers are properly installed
   - Check Terraform and provider versions

## Extending the Project

You can extend this project in several ways:

1. **Add more applications**: Create additional Kubernetes manifests in the `manifests/` directory
2. **Customize the cluster**: Modify `kind-config.yaml` to change node count or port mappings
3. **Add persistent storage**: Configure persistent volumes for stateful applications
4. **Implement CI/CD**: Add GitHub Actions or other CI/CD tools to automate deployments
5. **Add Ingress Controllers**: Deploy Ingress controllers for advanced routing capabilities
6. **Add monitoring solutions**: Implement monitoring and observability tools

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.