provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

resource "aws_instance" "name_within_terraform" {
    ami = "ami-<>"
    instance_type = "t2.micro"

    tags = {
        Name = "myapp"
    }
}