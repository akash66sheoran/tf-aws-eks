variable "cluster_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "kubernetes_version" {
  type    = string
  default = "1.33"
}

variable "authentication_mode" {
  type    = string
  default = "API"
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "node_groups" {
  description = "Map of EKS managed node groups for the cluster."
  type = map(object({
    instance_types  = list(string)
    capacity_type   = string
    ami_type        = string
    disk_size       = number
    desired_size    = number
    min_size        = number
    max_size        = number
    max_unavailable = number
    labels          = map(string)
  }))
}

variable "environment" {
  type = string
}

variable "cluster_addons" {
  description = "EKS managed add-ons to install on the cluster."
  type = map(object({
    addon_version               = optional(string)
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
  }))

  default = {
    vpc-cni    = {}
    coredns    = {}
    kube-proxy = {}
  }
}

variable "access_entries" {
  description = "EKS access entries for IAM users/roles for this specific cluster."

  type = map(object({
    principal_arn     = string
    policy_arn        = string
    type              = optional(string, "STANDARD")
    access_scope_type = optional(string, "cluster")
  }))

  default = {}
}