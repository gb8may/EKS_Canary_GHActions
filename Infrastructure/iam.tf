resource "aws_iam_role" "github_actions_assume_role" {
  name = "GitHubActionsRunnerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_permissions" {
  name        = "GitHubActionsPermissions"
  description = "Permissions for GitHub Actions role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "ecr:GetAuthorizationToken", 
          "ecr:BatchCheckLayerAvailability", 
          "ecr:GetDownloadUrlForLayer", 
          "ecr:GetRepositoryPolicy", 
          "ecr:ListImages", 
          "ecr:DescribeRepositories", 
          "ecr:GetLifecyclePolicy", 
          "ecr:GetLifecyclePolicyPreview", 
          "ecr:GetImagePolicy", 
          "ecr:GetImage", 
          "ecr:BatchGetImage", 
          "ecr:GetRepositoryPolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:TagResource",
          "ecr:DescribeImages"
          ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_permissions" {
  name       = "GitHubActionsAttachPermissions"
  policy_arn = aws_iam_policy.github_actions_permissions.arn
  roles      = [aws_iam_role.github_actions_assume_role.name]
}

output "iam_role_arn" {
  value = aws_iam_role.github_actions_assume_role.arn
}