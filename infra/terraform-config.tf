provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_access_key
    region     = var.aws_region
}

provider "aws" {
    alias   = "us-east-1"
    region  = "us-east-1"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_access_key
}

variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_access_key" {}
variable "github_oauth_token" {}