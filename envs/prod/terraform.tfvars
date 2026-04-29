region      = "ap-south-1"
environment = "prod"
project     = "ecom"

clusters = {
  ecom = {
    cluster_name = "ecom-prod-eks"
    vpc_cidr     = "10.40.0.0/16"
    az_count     = 3

    access_entries = {
      cicd_admin = {
        principal_arn = "arn:aws:iam::259974370560:role/ado-cicd-tf-eks-prod-role"
        policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      }

      akash_admin = {
        principal_arn = "arn:aws:iam::259974370560:user/Akash"
        policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      }
    }

    cluster_addons = {
      vpc-cni    = {}
      coredns    = {}
      kube-proxy = {}
    }

    node_groups = {
      general = {
        instance_types  = ["t3.xlarge"]
        capacity_type   = "ON_DEMAND"
        ami_type        = "AL2023_x86_64_STANDARD"
        disk_size       = 50
        desired_size    = 3
        min_size        = 2
        max_size        = 6
        max_unavailable = 1
        labels = {
          workload = "general"
        }
      }
    }
  }
  
}