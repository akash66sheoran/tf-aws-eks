region      = "ap-south-1"
environment = "prod"
project     = "ecom"

clusters = {
  ecom = {
    cluster_name = "ecom-prod-eks"
    vpc_cidr     = "10.40.0.0/16"
    az_count     = 3

    # access_entries = {
    #   cicd_admin = {
    #     principal_arn = "arn:aws:iam::111111111111:role/azure-devops-terraform"
    #     policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    #   }

    #   akash_admin = {
    #     principal_arn = "arn:aws:iam::111111111111:user/akash"
    #     policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    #   }

    #   dev_readonly = {
    #     principal_arn = "arn:aws:iam::111111111111:role/dev-readonly"
    #     policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
    #   }
    # }

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

  payments = {
    cluster_name = "payments-prod-eks"
    vpc_cidr     = "10.50.0.0/16"
    az_count     = 3

    access_entries = {
      cicd_admin = {
        principal_arn = "arn:aws:iam::111111111111:role/azure-devops-terraform"
        policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      }

      payments_admin = {
        principal_arn = "arn:aws:iam::111111111111:role/payments-admin"
        policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      }
    }

    cluster_addons = {
      vpc-cni    = {}
      coredns    = {}
      kube-proxy = {}
    }

    node_groups = {
      backend = {
        instance_types  = ["t3.xlarge"]
        capacity_type   = "ON_DEMAND"
        ami_type        = "AL2023_x86_64_STANDARD"
        disk_size       = 50
        desired_size    = 3
        min_size        = 2
        max_size        = 5
        max_unavailable = 1
        labels = {
          workload = "backend"
        }
      }
    }
  }
}