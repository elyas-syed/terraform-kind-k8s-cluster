variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
}

variable "config_path" {
  description = "Path to the Kind cluster configuration file"
  type        = string
}

variable "nginx_ingress_version" {
  description = "Version of the NGINX Ingress Controller to install"
  type        = string
  default     = "4.12.0" # Default version for the NGINX Ingress Controller

}