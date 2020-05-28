# Provision AWS resources using CF cli
## Basic aws resources required for hosting a internet website
  - EC2
  - Security group
  - ELB
  - AutoScaling
  - S3
  - EBS
  - VPC
  - NACL
  - Route table
  - Elastic IP
  - Route 53

# Layers of stack
  - Front End Services (Websites)
  - Backend services (search, payments, reviews, recommendations, data services)
  - Shared Services (common monitoring, alarms, security groups, subnets)
  - Base Network (VPCs, Internet gateways, VPNs, NATs)
  - Identity (IAM users, groups, roles)

# CF Template Anatomy:
  - AWSTemplateFormatVersion
    - Required? No
  - Resources
    - Required? Yes
  - Parameters
    - Required? NO
    - Input parameters for customizing deployed resources
    - Generalized CF templates for reuse
  - Mappings
    - Required? No
    - Provides a hash map of values that can be reference within your template
    - Common use case is regional or environment specific values
  - Conditions
   - Required? No
   - Allows you to define conditional controlling when a resource is created or a property is defined
  - Outputs
   - Required? No
   - Values your stack can output for information purpose or to provide cross stack references
# Best Pratices
  - Validate template
  - Use Parameter Types
  - Use Mappings
  - Use Deletion Policies
  - Use IAM and Tags

# Convert Json to yml
 ```
 ruby -ryaml -rjson -e 'puts YAML.dump(JSON.load(ARGF))' < json_file.json > yaml_file.yml
 ```

# get top level keys using `jq`
 `cat single_ec2.json | jq 'keys[]'`

# CLI Command:
- Create stack
```
aws cloudformation create-stack --template-body file://single_ec2.yml --stack-name single-instance --parameters ParameterKey=KeyName,ParameterValue=single_ec2_ssh_key_pair ParameterKey=InstanceType,ParameterValue=t2.micro
```
- delete stack
`aws cloudformation delete-stack --stack-name single-instance`
