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
`terraform plan`

4. Apply
`terraform apply`

`terraform destroy` # destroy the resources/infrastructure \
`terraform refresh`  # Query infrastructure provider to get current state\
`terraform show` # to view the details of the resources just created


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
