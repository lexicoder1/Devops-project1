terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.85.0"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "lexi5"
  
}


