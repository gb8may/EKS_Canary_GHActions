resource "aws_eks_cluster" "canary-eks-cluster" {
  name     = "canary-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [
        aws_subnet.public-subnet-a.id,
        aws_subnet.public-subnet-b.id
    ]
  }
}

resource "aws_eks_node_group" "canary-eks-cluster-node-group" {
  cluster_name    = aws_eks_cluster.canary-eks-cluster.name
  node_group_name = "canary-eks-worker-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  disk_size = 20
  instance_types = ["t2.micro"]

  subnet_ids      = [
    aws_subnet.public-subnet-a.id,
    aws_subnet.public-subnet-b.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "kubeconfig" {
  value = aws_eks_cluster.canary-eks-cluster
}