resource "aws_ecr_repository" "eks-poc-repository" {
  name                 = "eks-canary-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}