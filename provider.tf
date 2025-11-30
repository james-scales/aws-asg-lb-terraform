provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "test-bucket"
    key    = "path/to/key/113025"
    region = "sa-east-1"
  }

}
