# kind-terraform-k8s-cluster

Terraform configuration to create and manage a local Kubernetes cluster using Kind (Kubernetes in Docker). This setup uses NodePort for service exposure.

## Prerequisites

- Docker installed and running
- kubectl installed
- Kind installed (see [Kind Installation Guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
- Terraform installed

## Usage

1. Clone this repository
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
5. To delete the cluster:
   ```bash
   terraform destroy
   ```

## Configuration

The Kind cluster configuration is defined in `kind/kind-config.yaml`. The cluster is configured with:
- 1 control-plane node
- 2 worker nodes
- NodePort configuration:
  - Container port 30001 mapped to host port 30001
  - Protocol: TCP

## Deploying NGINX

1. Deploy the NGINX application and service:
   ```bash
   kubectl apply -f manifests/nginx-deployment.yaml
   ```

2. Verify the deployment and service:
   ```bash
   kubectl get pods
   kubectl get services
   ```

## Accessing Services

Once the NGINX deployment is running, you can access it through the NodePort:

- NGINX web server: http://localhost:30001

The NodePort 30001 is configured in both:
- The Kind cluster configuration (host port mapping)
- The NGINX service configuration (Kubernetes service NodePort)