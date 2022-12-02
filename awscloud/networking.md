# AWS Networking

## what is Routing Table

1. Default OR Main RT
    - Automatically created for you.
    - Has cidr block and target is local
    - It is private by default
    - lets say default cidr is 10.10.0.0/16
    - It can be assigned to any subnet in VPC
    - each subnet in VPC must be associated with one RT, otherwise is associated with default RT
    - subnet can only associate one RT at a time, but RT can be associated with more than one subnet.
    - local route - communication within VPC

2. Public RT
  ```
  10.10.0.0/16 local
  0.0.0.0/0 igw
  ```
Public subnet will have igw association

3. Private RT

|Destination|Target|Comment|
|---|---|---|
|10.10.0.0/16|local|routed within VPC|
|0.0.0.0/0|nat-id|routed to internet to any IP address|
|172.68.0.0/16|vgw|virtual private gateway through VPN to customer gateway in corporate network, connected to on perm network|
|172.31.0.0/16|pcx-*|VPC peering connection|
|tightening the rules(allow/deny)|More general||

  - Private subnet has NAT(Network address Translation) to connect with internet but has no IGW association.
  - Disable *Source/Destination Checking* for NAT instances. It is on by default, to prevent from man in middle attack

VGW - Virtual private gateway (Connect AWS from private data center over VPN)



You can access your instance using bastion host hosted in public subnet and has access to private subnet

**0.0.0.0** IP means any IP either from local system or from anywhere on the internet can access
**0.0.0.0/0**- Represent all IPv4 addresses

## What is the NACL?
- Another layer of security component.  All traffic entering or exiting a subnet is checked against the NACL rules to determine whether the traffic is allowed in/out of the subnet
- **By default it allows inbound outbound traffic** but custom NACL rules by default has denied inbound and outbound rules.
- Each subnet should be associated with one NACL, else default will be associated
- You can associate NACL with multiple subnets but subnet can be associated with only one NACL at a time.
- stateless - which means that responses to allow inbound traffic are subjected to the rules for outbound traffic (and vice versa). Return traffic must be explicitly allowed by rules.

- Components of NACL
  1. Rule Number - Rules are match as per the priority, if found, it doesn't proceed further.
  2. Type - Type of traffic, ssh or all traffic
  3. protocol -
  4. Port Range
  5. source(cidr range)
  6. Destination(cidr range)
  7. Allow/Deny


## Difference between NACL(Network Access Control list) and Route Table
|NACL|RT|
|---|---|
|Firewall for subnet|Firewall for VPC|
|Executed in defined order|Checked against smallest cidr range to find the matching destination|
|has inbound and outbound rules||
|stateless||

## What is security group?
  - Virtual firewall for instance level not Subnet level
  - you can assign upto 5 SG
  - can only allow rules
  - stateful - if we send a request from our instance, the response traffic for that request is allowed to flow in regardless of inbound security group rules. Responses to allowed inbound traffic are allowed to flow out, regardless of outbound rules.
  - by default, it has no inbound rules. Return traffic is automatically allow, regardless of any rules.
  - instances associated with a security group can't talk to each other unless you allow it.

## Difference between SG and NACL
|SG|NACL|
|---|---|
|operates at the instance level|Operates at subnet level|
|supports allow rules only|supports allow and deny rules|
|stateful|stateless|
|evaluate all rules before deciding whether to allow traffic|Process rules in order|
|applies to an instance only|Automatically applies to all instances in the subnet|

## wavelength associate carrier IP
Amazon procure IP for wavelength

Allocate and associate a Carrier IP address with the instance in the Wavelength Zone subnet

If you used the Amazon EC2 console to launch the instance, or you did not use the associate-carrier-ip-address option in the AWS CLI, then you must allocate a Carrier IP address and assign it to the instance:

To allocate and associate a Carrier IP address using the AWS CLI

    Use the allocate-address command as follows.

    aws ec2 allocate-address --region us-east-1 --domain vpc --network-border-group us-east-1-wl1-iah-wlz-1 —profile profilename

aws ec2 allocate-address --region us-east-1 --domain vpc --network-border-group us-east-1-wl1-iah-wlz-1 --profile profilename 

Returned 

{

    "AllocationId": "eipalloc-",

    "PublicIpv4Pool": "amazon",

    "NetworkBorderGroup": "us-east-1-wl1-iah-wlz-1",

    "Domain": "vpc",

    "CarrierIp": "155.146.xx.xxx"

}

Use the associate-address command to associate the Carrier IP address with the EC2 instance as follows.

aws ec2 associate-address --allocation-id eipalloc-05807b62acEXAMPLE --network-interface-id eni-1a2b3c4d

The following is example output:
{
    "AssociationId": "eipassoc-02463d08ceEXAMPLE",
}


aws ec2 associate-address --allocation-id eipalloc-02d6 --network-interface-id eni-07e3ea2 —profile profilename

{
