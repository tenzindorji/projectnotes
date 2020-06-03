# Kubernetes
## VM vs Kubernetes
||VM|Kubernetes|
|---|---|---|
|Security|Not Secured|Secured|
|Portability|Not Portable|Portable|
|Time|More time consuming|Time is less|

# What is Kubernetes:
  - Open source platform used for maintaining and deploying group of container(docker)
# Benefits
  - portable and 100% open source
  - work load scalability
  - high availability
  - designed for deployment
  - service discovery and load balancing
  - storage orchestration
  - self healing
  - automated roll out and roll back
  - automatic bin packing

# Kubernets Architecture
  1. kubectl (work station)
  2. master nodes:\
    1. ETCD (Cluster Store )
          - This component stores the configuration details and essential values\
          - It communicates with all other components to receive commands and work in order to perform action\
          - It also manages networking rules and post forwarding activity\
    2. Controller manager
          - It is a deamon (server) that runs in a continuous loop  and responsible for gathering information\
          sending it to an API Servers
          - It works to get the shared set of clusters and change them to desire state of the server\
    3. Scheduler
          - Assigns task to the slave nodes\
          - it is responsible for distributing work load and it stores resource usage information of every node\
          - It tracks how the working load is used on the cluster and, places the load on available resources.\
    4. API Server
  3. nodes, each nodes has multiple pods and each pod can have multiple containers(dockers)
    1. Docker\
    2. kubelet\
    3. Kubernetes proxy\


# Docker Swarm
  - Used for managing container like kubernetes

# Docker Swarm VS Kubernetes
||Docker Swarm|Kubernetes|
|---|---|---|
|Scaling|No Auto Scaling| Auto Scaling|
|Load Balancing| Auto LB| Manually configures LB|
|Installation|Easy and Fast|Long and time consuming|
|scalability|Cluster strenght is weak when compare to Kubernetes|Cluster strength is strong|
|Storage Vol Sharing|Shares storage vol with any other container|Share storage vols b/w multiple container inside same pod|
|GUI|Not available|available|


# Hardware components
  - Nodes
    - is smallest unit of hardware in kubernetes. It is representation of a single machine in the cluster
    - Is a physical machine in a Datacenter, or virtual machine hosted in cloud.

  - Cluster
    - Kubernets does not work with individual nodes; it works with the cluster as whole
    - Nodes combine their resources to form a powerful machine known as cluster
    - When nodes is added or removed. the cluster shifts around the work as necessary
  - Persistent vol
    -
# Software components
 - Container
  - The programs are bundled up into a single file(known as container) and shared on the internet.\
    Any one can download and deploy it with easy setup
  - Multiple programs are added to a single container. Limit to one process per container  as it will be \
    easy to deploy updates and diagnoses issues.
- pods
  - A pods represents a group of one or more application containers bundled up together and are highly scalable
  - if pods fails, kubernetes automatically deploys new replicas of pod to the cluster
  - Pods provide two different types of shared resources networking and storage.
- Deployment
  - Pods cannot be launched on a cluster directly; instead they are managed by one or more layer of abstraction call\
    the deployment.
- ingress
  - ingress allows access to kubernetes service from outside cluster
  - It can be done through ingress controller or LB
  - It can provide LB, SSL termination and name-based virtual hosting.

# Other components:
  1. Replication controller
    - It is used to define pod lifecycle, rather than to create pods directly
  2. Selector
    - A Selector expression matches labels to find specific resources
  3. Labels
    - They are key value pairs that are attached to the objects, such as pods
  4. Replication Set
    - they are define how many replicas of each pod will be running and manage and replace pods when they die
  6. Annotation
    - It is a label with much data capacity. It is used only for storing data that is not searched but it is \
      required by the resources.
  7. Name
    - Name by which resource is identified
  8. Volume
    - A Vol is directory with data which is accessible to a container
  9. Namespace
    - It provides additional qualification to a resource name
  10. service
    - It is a abstraction on  top of pods which provides a single  IP address and DNS name by which \
      the pods can be accessed


## Inteview Questions:
1. Why Kubernetes is widely used?
  - Kubernetes is an open source platform for automatic deployment and management of containers
    - Deployment
    - Scaling
    - Management
    - Effective persistent storage
    - support multi platform
    - Huge community support
2. What is difference between docker and kubernetes
  |Features|Kubernetes|Docker|
  |---|---|---|
  |Deployment|Applications are deployed as a combination of pods, deployment, and services|Applications are deployed in a form of services|
  |Autoscaling|Available|Not Available|
  |Health Checks|Healths of two kinds: liveliness and readiness|The health checks are limited to services|
  |setup|complicated to setup|Docker setup is easy|
  |Tolerance Ration|High Fault tolerence |Low Fault tolerence|

3. What are notable feature of Kubernetes
  - Container Balancing
    - Kubernetes always know where to put the container
  - services
    - Manages container, offers security, networking, and storage services
  - self-monitoring
    - It monitors and continuously checks the health of nodes and containers
  - scaling
    - can scale vertically and horizontally
  - open-source
  - storage orchestration
    - Kubernetes mounts and adds storage system to run apps
4. What are the main advantages of Kubernetes?
  - Automated rollback for the changes that went wrong
  - Scaling resources
  - Automates many manual process
  - saves money by optimizing resources
5. Explain the architecture layer of Kubernetes
6. Explain master nodes and list of components
7. Explain Cluster
8. What the different types of controller ?
  - Node controller - controls and handles nodes in the system
  - service account - Enable access control in the system
  - Token controller  - Cleans up any tokens for non-existent service accounts
  - Endpoint controller  - Joins services and pods to the endpoint services
  - Replication controller - manages the pod lifecycle
9. What is the role of Cloud Controller manager ?
  - Is a essential component for persistent storage, the abstraction of code specific code from core kubernetes code\
    network routing
10.
