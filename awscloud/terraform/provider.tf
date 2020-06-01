#Configure AWS provider
provider "aws" {
region = var.region
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "terraform VPC"
    CreatedBy = "Tenzin Dorji"
    Email = "niznetij@gmail.com"
  }
}

resource "aws_internet_gateway" "gw-terraform" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "Internet Access by Terraform"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id = aws_vpc.terraform_vpc.id
  count = length(var.azs)
  cidr_block = element(var.subnet_cidr, count.index)
  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_network_acl" "terraform_acl" {
  vpc_id = aws_vpc.terraform_vpc.id
  #count = length(var.azs)
  #subnet_ids = "${aws_subnet.subnets.*.id}"
  egress { #outbound
    protocol    = "tcp"
    rule_no     = 200
    action      = "allow"
    cidr_block  = "10.3.0.0/18"
    from_port   = 443
    to_port     = 443
    }
  ingress { #inbound
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
    }
  tags = {
    Name = "NACL"
    }
}

#Update default route table to attach IGW
resource "aws_route" "default_rt" {
  route_table_id = aws_vpc.terraform_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw-terraform.id}"
  #tags = { Name = "terraform-rt"}
}
