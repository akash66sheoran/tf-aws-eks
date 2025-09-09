# Get current caller identity (the Terraform user/role)
data "aws_caller_identity" "current" {}

#################################
# Access Entry for Cluster Creator
#################################
resource "aws_eks_access_entry" "creator" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "creator_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.creator.principal_arn

  # Full admin rights
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}