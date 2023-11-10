terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "<terraform state bucket>"
    key    = "vpc/terraform.tfstate"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}