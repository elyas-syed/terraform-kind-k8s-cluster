module "kind_cluster" {
  source = "./modules/kind"

  cluster_name = "terraform-kind-cluster"
  config_path  = "../kind/kind-config.yaml"
}

