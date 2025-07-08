module "kind_cluster" {
  source = "./modules/kind"

  cluster_name = "terraform-kind"
  config_path  = "../kind/kind-config.yaml"
}
