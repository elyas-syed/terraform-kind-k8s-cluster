# ArgoCD Terraform Module

This module deploys ArgoCD to a Kubernetes cluster using the official Helm chart.

## Usage

```hcl
module "argocd" {
  source = "../argocd"
}
```

## Configuration

The module uses the ArgoCD Helm chart with custom values defined in `values.yaml`:
- Insecure mode enabled (for local development)
- NodePort service on port 30020

## Requirements

- Kubernetes cluster must be running
- Helm provider configured with access to the cluster
- kubectl context must be set correctly

## Outputs

This module does not currently expose outputs. The ArgoCD deployment can be verified using:

```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
```

## Accessing ArgoCD

After deployment, access ArgoCD UI at:
- URL: http://localhost:30020
- Username: `admin`
- Password: Retrieve with `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

