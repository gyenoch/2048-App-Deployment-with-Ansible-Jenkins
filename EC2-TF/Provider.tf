terraform {
  backend "s3" {
    bucket         = "gyenoch-tetris-bucket"
    region         = "us-east-1"
    key            = "EKS-DevSecOps-Tetris-Project/EC2-TF/terraform.tfstate"
    dynamodb_table = "terraform-state-lock" 
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
