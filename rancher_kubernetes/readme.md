## Kubernetes and Rancher

## Certified Kubernetes
- Rancher kubernetes engine(RKE) - Takes all the kubernetes and runs it on dockers container
- K3S , light weight distribution of kubernetes - run locally
- EKS(AWS), AKS(Azure), GKE(google)

## Rancher is the kubernetes management platform
**simplified cluster Operations & Infrastructure Management**
- kubernetes version management
- Visibility & Diagnostics
- Monitoring & alertings
- Centralized audit
- Node pool management
- Cluster provisioning

**Security & Authentication**
- AD
- github
- SAML
- Ping
- okta

**Policy management**
- Configuration enforcement
- RBAC policies
- CIS benchmark Monitoring
- Pod & Network security policies

**Shared tooling & services**
- Prometheus
- Jenkins
- Grafana
- HELM
- Istio
- envoy
- fluentd

## RIO
**Secure Application Deployment**
- Load Balancing
- Routing
- Metrics
- Autoscaling
- Canary
- Git deployments

## K3s
- super-lightweight CNCF-certified K8s distribution
- Different from non-production solutions like minikube/microk8s/kind
- Small binary / Uses 512MB of RAM for all of the kubernetes
- Easily installed with K3sup from Alex Ellis \
`k3sup install --ip=x.x.x.x --user=root --k3s-version=v1-17.7+k3s1`\
`systemctl restart k3s`\
- k3sup is pinged to particular version of k3s
- it ssh to the server and install k3s binary
- Now we have one node k3s cluster
- set kubeconfig\
`set -x KUBECONFIG (pwd)/kubeconfig`\
`kubectl get nodes`

## Kubernetes 101m, 99% of kubernetes
- Pods
- ReplicatSets
- Deployments
- ConfigMaps
- Services
- Ingresses

**Pods**
- Smallest unit that can be deployed in Kubernetes
- Consist of one or more containers that are always scheduled together
- Each pod is given a unique IP Address
- Containers in a pod can speak to each other via localhost
- Basic Pod Spec\
```
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox
    command: ['sh', '-c', 'echo Hello Kubernetes! && sleep 1'] # overwriting the command
```

`kubectl apply -f pod.yml`\
`kubectl get po`\
`kubectl get po -w` # watch\
`kubectl delete po/myapp-pod`\

*fun facts*
- When pods goes crazy and tries to restart multiple times, kubernetes gradually increases/delay start time to avoid resource crunch . It goes all the way to 10 minutes

**declarative and Repeatable actions** Config management system
- Terraform
- Ansible
- Kustomize

**Kustomize**
- Built into kubectl since 1.14 (-k)
- Allows easy templating and overrides
- Easily maintained in source control
- Allows separationof concerns between Dev and Ops

```
cat kustomization.yaml

resources:
- deployment.yaml
- service.yaml
configMapGenerator:
- name: index
  files:
  - configs/index.html
```

`kubectl apply -k .`
`kubectl delete -k .`


```
namePrefix: staging-
commonLabels:
  environment: staging
bases:
- ../../base
patches:
- image.yaml
- replica_count.yaml
configMapGenerator:
- name: index
  behavior: replace
  files:
  - configs/index.html
```

```
image.yaml

apiVersion: apps/v1
kind: deployment
metadata:
  name: nginx
spec:
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:1.17.alpine
```

```
replica_count.yaml

apiVersion: apps/v1
kind: deployment
metadata:
  name: nginx
spec:
  replicas: 1
```

`kubectl get configmap`


**ReplicaSet**
- Deployment creates Replica set and Replica set creates pods and manages them(state management).
- Define the desired scale and state of a group of pods
- Introduces state management
  - Actual state
  - Desire state

**Deployments**
- Deployment creates and updates ReplicaSets
- Level of abstraction above ReplicaSets
- handled by deployment controller
- Allow to easily scale and perform rolling upgrades(create new pods with new version, and kill old one and repeats till all pods are upgraded)
- Handles stateless application(http)

`kubectl create deploy nginx --image=nginx:1.16-alpine --dry-run=client -o yaml`\ # prints deployment yml in console
`kubectl get deploy`\
`kubectl get rs`\
`kubectl get pods/<pod_name> -o yaml ^&1 | less` # prints out pods config
`kubectl describe po <pod_name> -o yaml ^&1 |less` # kubernetes understanding of object from outside, everything of object, more information, used for stopped pods
`kubectl scale deploy/nginx --replicas=3`
`kubectl set image deploy/nginx nginx=nginx:1.17-alpine` #upgrade
`kubectl rollout status deploy/nginx`
`kubectl rollout undo deploy/nginx`
`kubectl edit deploy/nginx` # can edit on the fly
`kubectl delete deploy/nginx`


**ConfigMaps**
- Used to override container-specific data like , can attach the volume, NFS
  - Configuration files
  - Environment variables
  - Entire directories of data
- Automatically updated within container when changed
  - nginx ingress controller
- Best practice is to version COnfigMaps and perform rolling update
  - Kustomize will do this for us

**Services** layer 4 LB
- Define a DNS entry that can be used to refer to a group of pods, provide stable DNS name and IP
- Provide a consistent endpoint for the group of pods
- Different types:
  - *ClusterIP*, creates inside of the cluster, accessible only from cluster
  - *NodePort*, opens up port on all of the nodes in a cluster(3000-32767),randomly assigned. Traffic that lands on that port is then routed to the cluster IP service and then routed to pods.  \
    NodePort service can be used with external Loodbalancer(F5, HAproxy), Performs health checking and ssl termination externally  
  - *LoadBalancer*, if the cluster is in cloud, you can create Loadbalancer, reaches out to cloud provider over their API and configures cloud LB.

  `kubectl get service`

  ```
  apiVersion: v1
  kind: Service
  metadata:
    labels:
      app: nginx
    name: nginx
  spec:
    ports:
    - port: 80
      protocol: TCP
      targetPort: 80
    selector:
      app: nginx
    sessionAffinity: None
    type: NodePort # ClusterIP
  ```

  - NodePort 80:32513/TCP
  - ClusterIP 80/TCP, only listening in a cluster

  *fun facts*
  - You are not going to create one to one LB when you have thousand of websites on it, you can do it using *ingress* . Name based virtual routing like apache

  **Ingresses** Layer 7
  - Define how traffic outside the cluster is routed to inside the cluster
  - Used to expose Kubernetes services to the world
  - Route traffic to internal services based on factors such as host and path
  - Ingress is usually implemented by a Load Balancer(Ngnix, Haproxy ...)
  - workload --> ClusterIP(layer 4) --> Ingress --> Service --> Pod
  - outside of the cluster, Layer 4 LB(Haproxy...) --> Ingress --> Service --> Pod
  - allows you to save money

`kubectl get ingress`


## Rancher Installation
- bring up single node RKE cluster and later add second node and run `rke up`
- rolebase access, one person leaves the org, disabling his account will clean up whatever resources he created
- `docker run -d --restart=unless-stopped  -p 80:80 -p 443:443 --privileged -v /opt/rancher:/data/apps/rancher rancher/rancher:latest` # bind to docker vol to persistent location /opt/ and /var/  *check the disk space, needs atleast 50 GB in var or data
- from browser, use server IP to access the rancher. Bt default it uses selfsigned certificate. Will ask to set admin password, provide server URL(important) and will be used for connecting to Kubernetes cluster
- Default, it provide two namespaces
  - system  - leave it alone
  - default
- Make changes to project and it propagates to all the namespaces below

**Namespace**
- logical grouping of resources inside kubernetes cluster, boundary for rolebase access. There cannot be duplicate resource running in same name space.  
