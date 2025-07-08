output "kind_cluster_summary" {
  description = "Summary of the Kind cluster setup"
  value       = <<EOF
******************************* KIND CLUSTER CREATED ********************************

  Cluster Name        :  ${module.kind_cluster.cluster_name}
  Kubectl Context     :  kind-${module.kind_cluster.cluster_name}
  Config File Used    :  ${module.kind_cluster.config_path}
  Success Message     :  ${module.kind_cluster.success_message}

*************************** NEXT STEPS TO VERIFY CLUSTER ****************************

  Set kubectl context:
    kubectl config use-context kind-${module.kind_cluster.cluster_name}

  View cluster info:
    kubectl cluster-info --context kind-${module.kind_cluster.cluster_name}

  View cluster nodes:
    kubectl get nodes

**************************** END OF CLUSTER SUMMARY *********************************
EOF
}