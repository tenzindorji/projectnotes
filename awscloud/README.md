# AWS Cloud Interview Questions:
https://www.simplilearn.com/tutorials/aws-tutorial/aws-interview-questions

# EC2
## EC2 options:
  * On demand
    - This is the instance we usually create
    - There is no time commitment
    - No Advance payment
    - Need to pay only hours which it is used
    - expensive option
    - Used for the applications with short-term, irregular workloads that cannot be interrupted.
  * Reserved
    - There is time commitment, like 1 or 3 years
    - upfront, partial upfront or No upfront pay options are available
    - It gets applied to on demand instances immediately
    - billing discount applied to on demand instance
    - provides significant saving over on demand instance
  * spot
    - This type of instance are cheapest and are used for short duration
    - Need to put the bid for the instance and if the instance is available under bid prince,\
      instance is available for use. If the bid prince goes up, AWS will automatically pull down the EC2 instance.
    - Good for one who want to use high processing power at low price for small duration.
    - are a cost-effective choice if you can be flexible about when your applications run and if your applications can be     interrupted. For example, Spot Instances are well-suited for data analysis, batch jobs, background processing, and optional tasks

  * Dedicated
    - most costliest of all options
    - Give better performance as its resources are not shared.

## Define and explain three basic types of cloud services and the AWS products that are build on them?
  - compute
    - EC2
    - Elastic Beanstalk
    - Lambda
    - Autoscaling
    - Lightsail
  - storage
    - S3
    - Glacier
    - EBS (Elastic Block Storage)
    - EFS (Elastic File System)
  - networking
    - VPC
    - Route 53
    - CloudFront (edge caching service)
## What is the relationship between availability zone and region?
  - AWS region is separate geographical area
    - Example: US-WEST 1(N. California) OR  Asia South(Mumbai)
  - Each AWS Region has multiple isolated locations known as AZ
  - All AZs inside one region are isolated from one another in terms of failure
## What is auto-scaling?
  - Auto-Scaling allows automatic increase or decrease of resource capacity as per needs
  - Auto-Scaling allows you to configure and automatically provision and launch new instances whenever the demand increases
## What is geo targeting and how do you setup geo targeting in CloudFront?
  - Geo targeting is a concept where you can show personalized content to your audience based on their geographic location without changing the URL
  - AWS allows you send customized content through CloudFront
  - Amazon CloudFront connects with other members of the AWS family of services to deliver content to end users at high speed and with low lentency
  - Amazon CloudFront will now detect the country where your viewer is located and forward the country code to origin server so that you can personalize content for that viewer without changing the URL
  - CloudFront will detects user's country and pass along their country code to you in the `CloudFront-Viewer-Country` header
## What are the steps involved in a CloudFormation Solution?
 -
## AWS Cost
 - AWS Cost Explorer
  - this allows you to view and analyze cost
  - you can view cost for last 13 months
  - get cost forecast for coming 3 months
 - AWS budgets
  - Here, you can plan your service usage, service costs and instance reservations
  - You can view the following:
    - Is your current plan meeting your budget?
    - Usage details
 - Cost Allocation Tags
## What Services can be used to create a centralized logging solution?
- Log management helps organization to track a relationship between operational, security and change management events
- It also helps to understand the infrastructure
- We can create centralized logging solution using services below
  - CloudWatch logs --> Store them in S3 --> move data from S3 to Elastic Search(visualization) OR Kibana using Kinesis OR Lambda
## What are the native AWS Security logging capabilities?
- AWS CloudTrail
  - provides a history of AWS API Calls for every account
  - You can perform security analysis, resource change tracking and compliance auditing of your AWS environment
  - It delivers log files to a designated S3 bucket every 5 mins
  - It can be configured to send notifications via AWS SNS when new logs are delivered.
- AWS Config
  - Provides history of configuration changes for AWS resources
  - Provides timeline of resource configuration change for specific service
  - It can be configured to send notifications via AWS SNS when new logs are delivered.
- There are many more logging and each services provides their own logging.
## What is DDoS attack and what services can minimize DDoS Attack?
- Distributed Denial Of Service(DDoS)
  - Malicious users creating Multiple connections and keeps session open and actual users won't be able to connect to the service
- We can minimize DDoS using below services
  - AWS CloudShield
  - AWS WAF(Web Application Firewall)
- Route53, ELB, CloudFront, VPC can also prevent DDoS to some extend but their main purpose is not security.

## How do you setup a system to monitor website metrics in real-time in AWS?
- CloudWatch
  - CloudWatch can monitor
    - State Changes in EC2(CPU, DISK, IO, MEM, Avg load, Network in out)
    - Auto-Scaling events
    - Scheduled Events
    - AWS API calls
    - Console sign-in Events
  - CloudWatch has a conditional statement that maps an incomming events to its target
  - A Target is a resource such as Lambda or SNS  
  - CloudWatch has three Stages
    - Green when service healthy
    - Yellow when service degraded
    - Red when service is not available  
## Global services?
  - IAM
  - Route53
  - WAF
  - CloudFront

## What are differences between NAT Gateways and NAT Instances?
  - NAT Gateway is managed by AWS and whereas NAT instance is managed by user
  - SG cannot be assigned to NAT G and but it can be assigned to NAT Instance
  - NAT Gateway is high performance and NAT instance is average performance.
## How to configure cloudWatch to recover EC2 instances
  - In CloudWatch, go to Define Alarm --> Actions tab
  - Select the `Recover this Instance` option

## What are the common and different types for AMI designs?
 - Fully Baked AMI
 - JeOS AMI (Just Enough Operating System)
 - Hybrid AMI
## How can you recover/login to an EC2 instance to which you lost the key?
- Once the key is lost, you can't recover it. Make another key and make use of that by follow below steps:
 1 Verify that the EC2config service is running \
 2 Detach the root Vol from the instance \
 3 Attach the vol to temporary instance \
 4 Login to temp instance and Modify the configuration file to take new key \
 5 Move root vol back to original instance and Restart it

# S3
## What are the key differences between AWS S3 and EBS?
  |Feature|S3|EBS|
  |---|---|---|
  |Paradigm|Object Store|FileSystem|
  |Performance|Fast|Super Fast|
  |Redundancy|Accross Data Centers(AZ)|Within A Data Center|
  |Security|Using Public Or Private key|Can be used only with EC2|
## How to you allow access to a user to a certain bucket?
  - Using IAM Policies which has allow and deny flags.
## How can you monitor S3 cross region replication to ensure consistency without actually checking the bucket?
  - CRR Monitor Cross Region Replication Monitor application is used to monitor replication status of S3 objects

# VPC
## VPC is not resolving the server through DNS . What might be the issue and how can you fix it?
  - `Enable DNS hostnames` to enable a VPC to resolve  public DNS hostnames to private IPv4 addresses
## How do you connect multiple sites to a VPC?
  - If you have multiple VPN connections, you can provide secure communication between sites using the AWS VPN CloudHub.
## Name and Explain some security products and features available at VPC?
  - Security groups
    - Act as firewall for associated EC2 instances, controlling both inbound and outbound traffic at the instance level
  - Network access control list(NACL)
    - Act as a firewall for associated subnets, controlling both inbound and outbound traffic at the subnet level
  - VPC Flow logs
    - Capture information about the IP traffic going to and from network interface in your VPC.
## How do you monitory VPC?
  - VPC Flow logs (gives information of who is allow and who is not allow)
  - CloudWatch and CloudWatch logs (gives information above data transfer)

# CF
  1 Format Version
  `AWSTemplateFormatVersion: '2010-09-09'`
  - If it is not mention, cf will automatically assume latest template version
  - value should be type `string`
  2 Description
  - value should be type `string`
  3 Resources
  4 Parameters
    - allows us to Input custom values each time we create or update the stack during run time
  5 Mappings
    - Allows you to map keys to a corresponding named value that you specify in conditional parameter
    - `Fn::FindInMap`
  6 Outputs
  7 Metadata
    - Provides more information about cf template
  8 Conditions
    - compare and conditionally create resources if it is true else it is ignored
    - `Fn::Or` `Fn::Not` `Fn::And` `Fn::Equals` `Fn::If`
  9 Transform

## Template Resource Attributes
  - Creation Policy
  - Deletion Policy
  - Depends On
  - MetaData
  - Update Policy

## Intrinsic functions:
  - `Fn::GetAtt` Used for getting values for the resources which are already created for output purpose or for nested stack
    - Shortcut
      - `!GetAtt myELB.DNSName`
      - GetAtt logicalName.AttributeName
  - `Fn::FindInMap` returns the value corresponding to keys in a two-level map that is declared in the Mappings section
    `!FindInMap [ MapName, TopLevelKey, SecondLevelKey ]`
    - Example:
      ```
      Mappings:
        AWSInstanceType2Arch:
          t1.micro:
            Arch: HVM64
          t2.nano:
            Arch: HVM64
          t2.micro:
            Arch: HVM64
          t2.small:
            Arch: HVM64
        AWSRegionArch2AMI:
          us-east-1:
            HVM64: ami-0080e4c5bc078760e
            HVMG2: ami-0aeb704d503081ea6
          us-west-2:
            HVM64: ami-01e24be29428c15b2
            HVMG2: ami-0fe84a5b4563d8f27
      ```
      ```
      Fn:FindInMap:
        - AWSRegionArch2AMI
        - !Ref AWS::Region
        - Fn:FindInMap:
          - AWSInstanceType2Arch
          - Ref: InstanceType
          - Arch
      ```

# IAM

  - You launch you media company and want your files to be viewable on a variety of devices. Which AWS service will you make use of?
    - Elastic Transcoder
  - Your application runs in a production environment that has 4 identical web servers that makes use of auto scaling. All of these web servers make use of same public subnet and belong to the same security group. All of these web servers are seated behind same elastic load balancer. Now, you add 5th instance into the same subnet, same security group. This does not have internet connectivity. Why is that?
    - this instance does not have elastic ip address assigned
  - Which AWS service is used for collating large amounts of data streamed from multiple sources?
   - kinesis
  - You work for a media company.They have just released a new mobile app that allows users to post their photos in real time same as instagram. Your organization expects this app to grow very quickly, essentially doubling its user base each month. The app uses AWS S3 to store the images, and you are expecting sudden and sizeable increases in traffic to S3 when a major news event takes place. You need to keep your storage costs to a minimum, and it does not matter if some objects are lost. With these factors in mind, which storage media should you use to keep costs as low as possible?
    - S3 Reduced Redundancy Storage
  - You run a popular photo sharing website that depends on S3 to store content. Paid advertising is your primary source of revenue. However, you have discovered that other websites are linking directly to the images in your buckets, not to the HTML pages that serve the content. This means that people are not seeing the paid advertising, and you are paying AWS unnecessarily to serve content directly from S3. How might you resolve this issue?
    - Remove public access and used signed URLs with expiration
  - How are EBS snapshots backed up onto S3?
   - Snapshots are incremental backups in EBS. They are point-in-time backups
  - Can you use the AWS Console to add a role to an EC2 instance after that instance has been created and powered-up?
    - Not possible
  - Which AWS CLI command that should be used to create a snapshot of an EBS volume?
    `aws ec2 create-snapshot`
  - You have enabled versioning in your S3 environment. Your employer asked you to disable versioning. What will you do?
    - S3 version cannot be deleted once created. Copy the S3 data to new S3 bucket which is created without versioning and delete the original one.  
  - Which AWS service is ideal for BI tools and datawarehousing ?
   - Redshift is datawarehousing, BI, Big data solution for AWS
  - What is advantage of session affinity in ELB?
    - The ELB new feature sticky session also called session affinity enabled user session to be bound to specific instance
  - What are the two types of Elastic Load Balancer Sticky Sessions?
    - duration based stickiness and application-controlled based stickiness
  - Which ELB metric does provide details on count of the total number of requests that are queued for a registered instance?
    - SearchQueenLength
  - You create an amazon S3 bucket. You upload a file called file1. Upload second file called file2. Now, you enable versioning. You upload file1 and file2 again. What will be the version id of file1 and file2 uploaded in first attempt before versioning is enabled?
   - An object uploaded prior to enabling version will have version id null
  - You are trying to create a new bucket in amazon S3 and end up getting 409 conflict error. What is the reason behind this?
   - bucket name already exist
  - What is the best practice recommendation while making use of IAM role?
   - Create an IAM role that has specific access to AWS service. Grant access to the specific AWS service
  - Your organization stores critical data that needs to be patented onto S3. An accidental deletion of this information leads to data loss. You employer enquires you to determine what could have been done to avoid accidental data loss in s3. What is your answer?
    - s3 bucker versioning could have been enabled and MFA could have been enabled on the bucket.
  - You want to disable detailed monitoring for a running instance. What command should you make use of?
    `unmonitor-instances`
  - Your project makes use of DynamoDB. Your manager asked you to provide details on provisioned capacity limits for your AWS account in a region. what command can you run?
   - `describe-limits`
  - What is time to live TTL in DynamoDB?
   - Parameter that allows us to define when items in a table expire so that the can be automatically deleted from the database.
  - How will you accomplish extra capacity with additional CPU and RAM in EMR?
    - by adding more task nodes
