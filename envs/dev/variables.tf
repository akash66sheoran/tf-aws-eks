variable "region" {
  description = "AWS region where resources will be created."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, stage, or prod."
  type        = string
}

variable "project" {
  description = "Project name used for tagging resources."
  type        = string
}

variable "clusters" {
  description = "Map of EKS clusters to create in this environment."

  type = map(object({
    cluster_name = string
    vpc_cidr     = string
    az_count     = number

    access_entries = optional(map(object({
      principal_arn     = string
      policy_arn        = string
      type              = optional(string, "STANDARD")
      access_scope_type = optional(string, "cluster")
    })))

    cluster_addons = optional(map(object({
      addon_version               = optional(string)
      resolve_conflicts_on_create = optional(string, "OVERWRITE")
      resolve_conflicts_on_update = optional(string, "OVERWRITE")
    })))

    node_groups = map(object({
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
  }))
}