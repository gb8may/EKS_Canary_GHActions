data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_availability_zones" "azs" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                 = "elk-vpc"
  cidr                 = "172.16.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.14.0"

  cluster_name    = "canary-elk-cluster"
  cluster_version = "1.28"
  subnet_ids      = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    disk_size              = 8
  }

  eks_managed_node_groups = {
    eks-worker-nodes = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND"
      tags = {
        Name = "eks-worker-node"
      }
    }
  }
}