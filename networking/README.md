# Networking
## NAT
  - Network Address Translation
## CIDR
  - Classless Inter-Domain Routing
  - Simplies routing tables
  - Reduces IPv4 exhaustion
## Private IP Ranges:
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
  - Cidr range calculater: https://mxtoolbox.com/subnetcalculator.aspx

## VPC (Virtual Private Cloud)
  - Select IP range for VPC , example `172.31.0.0/16  `
  - Avoid ranges the overlap with other networks that which you might connect
  - subnets
    - subnet1 `172.31.0.0/24`
    - subnet2 `172.31.0.1/24`
    - subnet3 `172.31.0.2/24`
  - Route table
    - contain rules for which packages go where
    - Your vpc has default(main) route table
    - But, you can assign different route table to different subnets
    - Used for VPC peering(pcx), internet gateway, vgw(VPN Connection), VPC end points, local(traffic within VPC)
  - internet gate way (igw)
    - attached to route table.
    - `0.0.0.0/0` or `::/0 (IPv6)` - igw means everything not destined in VPC goes to internet
  - Network Security:
    - Sg
      - stateful firewall
    - NACL
  - Routing by subnet (Restricting internet access)
   - Public Subnet has access to internet
   - Private subnet has not access to internet
      - NAT instance or Nat gateway attached to SG will allow to connect to internet.
  - VPC peering
    - Once the VPC peering is established, we can use SG to allow traffic
    - Inter region VPC
      -
## VPN(Virtaul Private Network) and Direct Connect
  - VPN:
  - is a pair of IPsec tunnels over internet
  - Customer Gateway is client side (firewall or router)
  - VPG (virtual Private Gateway )

  - Direct Connect:
  - is a pair of IPsec tunnels over internet
  - AWS VGW <-->  AWS Direct Connect Gateway <--> Private Virtual Interface attachment <--> Direct Connect (Client DC)

## Access services outside VPC
  - you can access S3 via IGW from VPC
  - But there is better way, VPC end point without going via IGW
  - Add S3 VPC end point entry in route table

## VPC End Points
  - Is created under VPC end point and are automatically added to route table 
