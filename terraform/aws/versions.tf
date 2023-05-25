terraform {

  backend "remote" {
    organization = "mvkaran"

    workspaces {
      name = "monacloud-aws"
    }
  }
  
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.10.0"
    }

    env = {
      source = "tchupp/env"
      version = "0.0.2"
    }

  }
}
