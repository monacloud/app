data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Configure the GitHub Provider with GITHUB_TOKEN environment variable
provider "github" {
  owner = "monacloud"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "19.5.1"
  
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  
  vpc_id  = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }
  
  eks_managed_node_groups = {
    workers = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t2.medium"]
      k8s_labels = {
        Environment = "demo"
        GitHubRepo  = "app"
        GitHubOrg   = "monacloud"
        ProvisionedBy = "terraform"
      }
      additional_tags = {
        ProvisionedBy = "terraform"
      }

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }

  tags = {
    Environment = "demo"
    GitHubRepo  = "app"
    GitHubOrg   = "monacloud"
    ProvisionedBy = "terraform"
  }
}

# AWS Auth (kubernetes_config_map)
module "eks-auth" {
  source  = "aidanmelen/eks-auth/aws"
  version = "1.0.0"
  eks = module.eks

  map_roles = [
    {
      rolearn  = "arn:aws:iam::756877124396:role/GitHubActionsOIDC"
      username = "GitHubActionsOIDC"
      groups   = ["system:masters"]
    },
  ]
}


# Fetch the GitHub repository and Actions environment where secrets have to be updated for use by Actions workflows
resource "github_repository_environment" "repo_environment" {
  repository       = data.github_repository.repo.name
  environment      = local.github_env
}


# Upsert a secret named CLUSTER_NAME to hold the name of the cluster used for setting kubectl context
resource "github_actions_environment_secret" "cluster_name" {
  repository       = data.github_repository.repo.name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "CLUSTER_NAME"
  plaintext_value  = local.cluster_name
}

# Upsert AWS access keys
resource "github_actions_environment_secret" "aws_access_key_id" {
  repository       = data.github_repository.repo.name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "AWS_ACCESS_KEY_ID"
  plaintext_value  = data.env_variable.aws_access_key_id.value
}

resource "github_actions_environment_secret" "aws_secret_access_key" {
  repository       = data.github_repository.repo.name
  environment      = github_repository_environment.repo_environment.environment
  secret_name      = "AWS_SECRET_ACCESS_KEY"
  plaintext_value  = data.env_variable.aws_secret_access_key.value
}
