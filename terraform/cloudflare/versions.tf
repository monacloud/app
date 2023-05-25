terraform {

  backend "remote" {
    organization = "mvkaran"

    workspaces {
      name = "monacloud-cloudflare"
    }
  }

  required_providers {

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
