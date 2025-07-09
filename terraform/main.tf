module "kind_cluster" {
  source = "./modules/kind"

  cluster_name = "terraform-kind-cluster"
}

