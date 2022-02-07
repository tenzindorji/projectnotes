## AMS Elastic Container Service
- Manage docker containers


## Why ECS
- Can be easily scaled and it is automatic
- highly available
- quickly launch, exit, manage docker containers on a cluster
- migration to AWS makes easily without changing code


## What is docker
- is a tool to automate the deployment of an application as a lightweight container so that the application can work efficiently in different environments
- contains all the dependencies in a package
- highly scalable
- very shot boot-up time
- Reusable Data Volumes
- Isolated applications, though they are running on same host


## Advantages of ECS
- Highly Secured
- Cost Efficient due to lightweight, resources can be shared
- Extensible service
- Easily scalable


## Architecture of Amazon ECS
- Container Image
- Container registry(Amazon ECR, Docker hub)
- VPC - Amazon ECS  (AZ)



## How does ECS work
- There are two mode
  - Fargate mode
  - EC2 mode

## what Fargate service
- Task are launched using the fargate
- Fargate is a compute engine in ECS that allows a user to launch containers without having to monitor clusters
- Amazon manages the cluster

## Task
- Task has two components
  - ECS container instance: is a part of AWS EC2 instance which runs Amazon ECS container agent
  - Container agent: It is responsible for the communication between Amazon ECS and the instance. Also, provides the status of running containers.

## Elastic Network interface
- is a virtual interface network that can be connected to an instance( Example VPC)

## Amazon ECS Cluster
- A cluster is a set of ECS container instances
- It handles the process of scheduling, monitoring, and scaling requests


## How to deploy Docker containers on Amazon ECS
- 
