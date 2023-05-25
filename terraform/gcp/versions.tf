terraform {

  backend "remote" {
    organization = "mvkaran"

    workspaces {
      name = "monacloud-gcp"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.63.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }

    env = {
      source = "tchupp/env"
      version = "0.0.2"
    }
  }

  required_version = ">= 0.14"
}
