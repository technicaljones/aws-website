provider "aws" {
    region     = var.aws_region
}

provider "aws" {
    alias   = "us-east-1"
    region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "awswebsiteterraformstate2"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_access_key" {}
variable "github_oauth_token" {}