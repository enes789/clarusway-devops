terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.44.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.10.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


provider "github" {
  token = "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"
}