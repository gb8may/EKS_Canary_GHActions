resource "aws_ecr_repository" "eks-poc-repository" {
  name                 = "http-echo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}