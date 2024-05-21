terraform {
  cloud {
    organization = "mpmt"
    workspaces {
      name = "wiregurad-server"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
  required_version = ">= 1.3.0"
}
