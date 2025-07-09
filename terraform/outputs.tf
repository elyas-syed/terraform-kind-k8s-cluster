output "kind_cluster_summary" {
  description = "Summary of the Kind cluster setup"
  value       = <<EOT
******************************* KIND CLUSTER CREATED ********************************

  Cluster Name        :  ${module.kind_cluster.cluster_name}
  Kubectl Context     :  ${module.kind_cluster.kubectl_context}
  API Endpoint        :  ${module.kind_cluster.endpoint}
  Kubeconfig Path     :  ${module.kind_cluster.kubeconfig_path}
  Success Message     :  ${module.kind_cluster.success_message}

*************************** NEXT STEPS TO VERIFY CLUSTER ****************************

  View cluster info:
    kubectl cluster-info --context ${module.kind_cluster.kubectl_context}
  
  Set kubectl context:
    kubectl config use-context ${module.kind_cluster.kubectl_context}

  View cluster nodes:
    kubectl get nodes

**************************** END OF CLUSTER SUMMARY *********************************
EOT
}