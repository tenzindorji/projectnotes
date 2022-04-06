terraform {
  backend "s3" {
    bucket = "terraformstate_bucket" # bucket needs to exist before running terraform (manually)
    key = "terraform.tfstate" # store the state file
    region = "us-east-1"
  }
}

provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    name = "my vpc"
  }
}

resource "aws_subnet" "sub" {
  vpc_id = aws_vpc.my_vpc.id # This is how to get vpc id REMEMBER this
  cidr_block = "10.0.1.0/24"

  tags = {
    name = "My sub"
  }
}

resource "aws_instance" "name_within_terraform" {
    ami = "ami-<>"
    instance_type = var.my_instance_type

    tags = var.instance_tags
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "s3-demo-bucket"
  acl = "private"
  tag = {
    Name = "My demo bucket"
    Environment = "dev"
  }
  versioning {
    enable=true
  }
}
