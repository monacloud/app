
resource "random_string" "suffix" {
  length  = 8
  special = false
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

data "github_repository" "repo" {
  full_name = "monacloud/app"
}

data "env_variable" "aws_access_key_id" {
  name = "AWS_ACCESS_KEY_ID"
}

data "env_variable" "aws_secret_access_key" {
  name = "AWS_SECRET_ACCESS_KEY"
}

locals {
  cluster_name = "tf-monacloud-${random_string.suffix.result}"
  cluster_version = "1.22"
  vpc_name = "vpc-${local.cluster_name}"
  github_env = "preview"
}
