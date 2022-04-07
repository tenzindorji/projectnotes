## What is terraform?
- Tool for infrastructure provisioning (automate, manage your infra)
- uses declarative language
- open source
- create resources in correct order



##  4 steps
1. Create the terraform configuration

2. Init the terraform to download plugins as per the provider. This is required.
`terraform init`

3. Plan  create an execution plan, preview of whats going to happen
`terraform fmt` # check the format \
`terraform validate` \
`terraform plan`

4. Apply
`terraform apply`

`terraform destroy` # destroy the resources/infrastructure \
`terraform refresh`  # Query infrastructure provider to get current state\
`terraform show` # to view the details of the resources just created, it gets details from terraform.tfstate file.

terraform.tfstate file needs to be stored securely in remote location to keep track of changes and also it contain lot of sensitive information.

## Terraform Variable
- auto load tf var files
  - named var file as boo.auto.tfvars or variables.tf or terraform.tfvars
- how to load custom var file?
  - `terraform apply -var-file dev.tfvars`\
  - This will load both dev.tfvars and terraform.tfvars files\
  - Or `terraform apply -var="my_instance_type=t2.large"`
  - Or set environament variable
    `TF_VAR_my_instance_type="t2.large" terraform apply`

  - **variable precedence**
    1. Environment variable
    2. terraform.tfvars
    3. terraform.tfvars.json
    4. *.auto.tfvars or *.auto.tfvars.json
    5. Any var files

## Terraform modules
- Create folders
  - modules
    - vpc
      - var.tf
          ```
          variable "vpc_cidr" {
            default = ""
          }
          variable "tenancy" {
            default = "dedicated"
          }
          variable "vpc_id" {}
          variable "subnet_id" {}
          ```
      - networking.tf
          ```
          resource "aws_vpc" "main" {
            cidr_block = "${var.vpc_cidr}"
            instance_tenancy = "${var.tenancy}"

          }

          resource "aws_subnet" "main" {
            vpc_id = "{var.vpc_id}"
            cidr_block = "${var.subnet_cidr}"
          }

          output "vpc_id" {
            value = "${aws_vpc.main.id}" # return value
          }

          output "subnet_id" {
            value = "${aws_subnet.main.id}"
          }
          ```
    - instances
      - ec2.tf
        ```
        resource "aws_instance" "web" {
          ami = "${var.ami_id}"
          instance_type = "${var.instance_type}"
          subnet_id = "${var.subnet_id}"
        }
        ```
      - var.tf
        ```
        variable "ami_id" {}
        variable "instance_type" {
          type = "t2.micro"
        }
        variable "subnet_id" {}
        ```
  - dev
    - main.tf
    ```
    provider "aws" {
      region = ""

    }

    module "my_module_name_vpc" {
      source = "../modules/vpc"
      vpc_cidr = ""
      tenancy = ""
      vpc_id =  "${module.my_module_name_vpc.vpc_id}" # how to access value from module? define them as out put
      subnet_cidr = ""
    }

    module "my_ec2" {
      source = "../modules/ec2"
      instance_type = t2.micro
      ..
      ..
      subnet_id = "${module.my_ec2.subnet_id}"
    }
    ```
  - prod

- How do you reference to modules


## Terraform workspaces

## Terraform output

## Terraform state
- What is state
  - terraform plan/apply creates state file
  - it is a black box and keeps recording all the changes.
- What is local state
- What is remote state
  - Create s3 bucket using terraform
  - store state file to s3 using terraform
  - it will not create state file in local, still be uploaded directly to cloud

## Terraform pull command
- update local terraform state file from remote
-
 `terraform state pull`\
 `terraform state push` # Do not do this \




## Terraform VS Ansible
- They are both infrastructure as a Code.
- Terraform in mainly infra provisioning tool from scratch , Ansible is mainly a configuration tool
- Terraform can deploy applications and other tools, but for Ansible, once the infrastructure is ready, it can configure that infrastructure, deploy apps, installs/update software.
- Terraform is better tool for provisioning infrastructure whereas Ansible is better at configuring that infrastructure.

## Terraform Architecture
1. Terraform Core

2. State

3. Providers


## declarative VS Imperative
- What does declarative mean exactly?
  - You define the end sate in your config file
- Imperative - you give instruction what to do
