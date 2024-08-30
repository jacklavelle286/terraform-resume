provider "aws" {
 region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "tfbackendstate20240930"
    key            = "terraform.tfstate"
    region         = "us-east-1" 
  }
}
