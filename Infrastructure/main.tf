terraform {
  required_version = ">= 1.2.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket               = "mgouveia-pocs-tfstate"
    workspace_key_prefix = "canary-eks-ghactions"
    key                  = "canary-eks-ghactions"
    region               = "us-east-1"
    dynamodb_table       = "pocs-tfstate-lock"
    encrypt              = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      GitHub-repo = "https://github.com/gb8may/EKS_Canary_GHActions"
      Description = "Canary deployment to EKS using GitHub actions"
      Author      = "Mayara Gouveia - gb8may@gmail.com"
    }
  }
}