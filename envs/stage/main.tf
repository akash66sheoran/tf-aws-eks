module "eks_clusters" {
  source = "../../modules"

  for_each = var.clusters

  cluster_name = each.value.cluster_name
  vpc_cidr     = each.value.vpc_cidr
  az_count     = each.value.az_count

  node_groups    = each.value.node_groups
  access_entries = try(each.value.access_entries, {})

  cluster_addons = try(each.value.cluster_addons, {
    vpc-cni    = {}
    coredns    = {}
    kube-proxy = {}
  })

  environment = var.environment
  project     = var.project

  tags = {
    Environment = var.environment
    Project     = var.project
    Cluster     = each.value.cluster_name
  }
}