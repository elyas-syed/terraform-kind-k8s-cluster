module "kind_cluster" {
  source = "./modules/kind"

  cluster_name = "terraform-kind-cluster"
  config_path  = "../kind/kind-config.yaml"
}

module "nginx_ingress" {
  source = "./modules/nginx-ingress"
  
  cluster_ready = module.kind_cluster.success_message
}

