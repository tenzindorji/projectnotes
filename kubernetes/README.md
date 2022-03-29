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

# Kubernetes Architecture
## Control Plane:
  1. API Server:  - API servers perform all the administrative tasks on the master nodes. Users send the command to the API server, which then validates the request process and executes them. The API server determines if the request is valid or not and then processes it.

  2. Key-Value Store(etcd) - Etcd is an open-source distributed Key-Value Store used to hold and manage the critical information that distributed systems need to keep running. Is a database kubernetes uses to backup all the cluster data. It stores the entire configuration and state of the cluster.

  3. Controller - The role of the Controller is to obtain the desired state from the API server. It checks the current state of the nodes it is tasked to control, and determines if there are any differences.

  4. Scheduler - The Scheduler's main job is to watch for new requests coming from the API server and assign them to healthy nodes. It ranks the quality if the nodes and deploys pods to the best-suited node.


## Node Components(Worker nodes):
- Has three main components
  1. Container runtime - which runs on each work node. It pulls images and performs start stop. It should be installed independently. Not managed by kubernetes.  
    - Docker
    - rkt
    - runc
    - cri-o

  2. kubelet - runs on each node in the cluster or can say kubernetes agent. It watches for tasks sent from the API Server, executes the task, and reports back to the Master.
  Schedules container or process on the docker. It is a interface between container and node(machine). Responsible for starting a pod with a container inside and assigning resources from the node to the container like cpu, ram and diskspace.  

  3. Kube proxy - makes sure that each node gets its IP address. It runs on each worker node.
  If forwards the requests from services to pods.  It has intelligent inside which make sure the it forwards request to container inside node, instead of randomly forwarding to any replica set inside a cluster to prevent network overhead. Also, lets communicate between containers within nodes or across without needed to go through API server.

  - Add-ons
    - coreDNS
    - cni (Networking)
      - flannel
      - weave
      - caliio

  - A pod -  is the smallest element of scheduling in Kubernetes. Without it, a container cannot be part of a cluster.

## How does all the component interact with the cluster?
- schedule pod?
- monitor?
- re-schedule/re-start pod?
- join a new node?

  - All these are managed through master nodes
    - It has 4 processes running
      - api server - cluster gateway, gate keep for authentication, validation, LB across master nodes.
      - controller - Detect state changes and send request to scheduler
      - scheduler - where to put the pod, and send request to kubelet to create pods.
      - etcd(brain) - every change in a cluster are saved and updated in key value pair.
        - schedule get what resources are available from etcd
        - controller gets state update from etcd
        - api queries state information from etc or makes queries to update the state.
        - actual application data is not stored in etcd. Distributed storage across master nodes.
        - etcd talks using RAFT protocol
          - distributed, consensus, Protocol






## Services (What is it?) - Internal Service
- One of the best features kubernetes offers is that non-functioning pods get replaced by new ones automatically. The new pods have a different set of IPs. It can lead to processing issues and IP churn as the IPs no longer match. If left unattended, this property would make pods highly unreliable.
- It is component just like a Pod but not a process, it is just a abstraction layer that basically represent IP address
  - It will have its own IP address which it will be accessible
  - Also will have its own port and it is arbitrary, you can define your own Service Port
- Each Pod has its own IP address
  - Pods are ephemeral - are destroyed frequently
  - Thats why Service Provides
    - stable IP address
    - loadbalancing
    - loose coupling
    - within and outside cluster

## Types of services - There are three types
- 3 Service type attributes
  - clusterIP
  - NodePort
  - Loadbalancer

- ClusterIP (Default)

<img src="k8_service.drawio.png" width="700" height="600">

  - No type specified, it will automatically take clusterIP as a type
  - internal service
  - Accessible only within a cluster  
  - How does it work and where it is used
    - Lets say, we have microservice app deployed on port 3000
    - and side-car container on 9000, that collects microservice logs
    - Pod will get IP addresses from Node's range, example
      - Node1 has 10.2.1.x
      - Node2 has 10.2.2.x
      - Node3 has 10.2.3.x
    - It should have
      - kind: Service
      - name: Service Name
      - selector
        - app: app_name
      - ports
        - port: 3200 (serviceport)
        - targetPort: 3000 (Pod port)
    - Once the ingress hands over request to service, service knows where to send to request
      - How does service know which pods to forward the request to?
        - Pods are identified by "selector" attribute in service yaml file
        - And labels in deployment yaml file  
        - labels and selector should have same key value.
          - svc matches all the replicas
          - It registers as Endpoints
          - must match ALL the selectors
      - How does service know which port to forward the request to if pod has multiple ports open?
        - Using targetPort attribute, it is not arbitrary, it has to match the container's Port.
      - Service Endpoints
        - `kubectl get endpoints`\
        - K8s creates Endpoint object same name as Service
        - Keeps track of, which Pods are the members/endpoints of the Service
      - Multi-Port Service, how does it know? by name
        - Ports:
            - name: mongodb
              port: 27017
            - name: mongodb-exporter
              port: 9216

    - Get IP addresses of pod `kubetctl get pod -o wide`


  - Headless  
    - when do you use this?
      - Client wants to communicate with 1 specific Pod directly
      - Pods want to talk directly with specific Pod
      - so, not randomly selected
      - use Case: Stateful applications, like databases, mysql, mongodb, elasticsearch
        - Pod replicas are not identical,
          - master instance(reading and writing) <-- data replication -->  worker instance(reading)
          - when new work is started, it must connect directly to most recent worker node to clone the data from and get upto date state
          - Data synchronization
          - client wants to talk to pod directly
        - complex situation

    - Now, client needs to figure out IP addresses of each Pod
      - Option 1 - API call to K8s API server ?
        - makes app too tied to K8s API
        - inefficient
      - Option 2 - DNS lookup, Kubernetes allows client to discover Pod IP addresses through DNS lookups.
        - When a client  performs DNS lookup for a service, it return single IP address of a service(ClusterIP address)
        - But, we do not need clusterIP address of the service, by setting the `clusterIP: None` , then the DNS service will return the Pod IP address. Now a client can do simple DNS lookup to get the IP address of the Pods that are member of the service, and client can use the IP address to connect to the specific Pod or to all the Pods

    - No Cluster IP address is assigned  


- NodePort Service

<img src="K8_service_nodeport.drawio.png" width="500" height="400">

  - Creates a service that is accessible on a static port on each worker node in a cluster
  - External traffic has access to fixed port on each worker Node! Only used for testing
    - http://ip-address-worker:NodePort
  - Defined in nodePort Attribute in a service yaml file
    - Ports:
      - protocol: TCP
        port: 3200
        targetPort: 3000
        nodePort: 30008
  - Has a predefine range between 30000 - 32767 , anything outside of this range will not be accepted.
  - ClusterIP Service is automatically created
  - NodePort will have the clusterIP address and for each IP address, it will also have the  Ports open where the service is accessible at.
  - NodePort Services not efficient and are not secured since it will be directly accessible to pod from outside cluster
  - So Better alternative is Loadbalancer Service type



- Loadbalancer Service
  - External Loadbalancer Service
  <img src="K8_service_loadbalancer.drawio.png" width="500" height="400">

  - Service becomes accessible externally through cloud providers Loadbalancer and have external IP allocated to it.
  - Whenever Loadbalancer Service is created, NodePort and ClusterIP are created automatically to which external Loadbalancer of the cloud platform will route the traffic to.
  - LoadBalancer Service is an extension of NodePort Service
  - NodePort Service is an extension of ClusterIP Service
  - Each service with type LoadBalancer will create new LoadBalancer and that will cost lot of money.
  - External Service Loadbalancer Config:
  ```
  apiVersion: v1
  kind: Service
  metadata:
    name: myapp-loadbalancer
  spec:
    type: LoadBalancer
    selector:
      app: myapp
    ports:
      - protocol: TCP
        port: 3200
        targetPort: 3000
        nodePort: 30010
  ```

  - `kubectl get svc`


  - NodePort Service NOT for external connection, use it for testing but not for production use cases.


# Ingress
- What is Ingress?
- External Service vs Ingress
  1. Internal service has no NodePort whereas External service, need to mention NodePort
  2. Internal service type is default ClusterIP, whereas External service type is Loadbalancer
  3. host attribute in internal service should be valid domain and should be mapped with entrypoint's IP address or Node's IP address(ingress controller), whereas External LB, ingress controller is not required.


- Ingress YAML configuration  
```
apiVersion: v1
kind: Ingress
metadata:
  name: myapp-ingress
spec:
  rules:
  - host: myapp.com
    http: # Second step - Incoming request gets forwarded to internal service, this is not protocol, this does not correspond to http URL in browser.
      paths:
      - backend:
          serviceName: myapp-internal-service
          servicePort: 8080
```
- Internal Service looks like
```
apiVersion: v1
kind: Service
metadata:
  name: myapp-internal-service
spec:
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
```

- When do you need ingress?
- Ingress Controller
  - Creating ingress component alone, that won't be enough for routing rules to work.
  - So, need an implementation for ingress call ingress controller.
  - Install ingress controller Pod in your cluster, thus evaluation and processing ingress rules.  
  - evaluates all the rules
  - manages redirections
  - entrypoint to cluster
  - many third-party implementations
  - Nginx is K8s supported controller
- Ingress Also have something call default_backend. Whenever request comes to Kubernetes cluster which is not mapped to any backend, so there is no rule for mapping the request to a service , then default backend is used to handle that request.
  - `kubectl describe ingress <ingress_name> -n <name_space>`\
    `kubectl describe ingress uptime -n platform-dev`
  - Then you can create a service name same as default-http-backend and same port  and route to desire landing backend to handle to customer error message.

  ```
  apiVersion: v1
  kind: Service
  metadata:
    name: default-http-backend
  spec:
    selector:
      app: default-http-backend
    ports:
      - protocol: TCP
        port: 80
        targetPort: 8080
  ```

  - It takes little of time to assign IP address to ingress after deploying ingress.
  `kubectl get ingress -n <name_space> watch` \
  `kubectl get all -n platform-dev`

  - More on routing
    - path base routing
    ```
    - host: myapp.com
    ...
      - path: /shopping
      ...
      ...
      - path: /movie
    ```
    - host base routing
    ```
    - host: shopping.myapp.com
      http:
        paths:
          backend:
            serviceName: shopping-service
            sevicePort: 3000
            ...
            ...
    - host: movie.myapp.com

    ```
  - TLS certificate
    - https
    ```
    apiVersion: v1
    kind: Ingress
    metadata:
      name: myapp-ingress
    spec:
      tls:
      - hosts:
        - myapp.com
        secreName: myapp-secret-tls
      rules:
      - host: myapp.com
        http:
          paths:
          - backend:
              serviceName: myapp-internal-service
              servicePort: 8080
    ```
    - Secret configuration
    ```
    apiVersion: v1
    kind: Secret
    metadata:
      name: myapp-secret-tls
      namespace: default # should be created in same namespace as a ingress component
    data:
      tls.crt: base64 encoded cert # values are file content, NOT the paths/location , key should be named exactly as mentioned.
      tls.key: base64 encoded key
    type: kubernetes.io/tls
    ```

# Entrypoint
- Ingress Controller is the entrypoint
- Domain should be provisioned to point to Ingress IP address(ATT, route53 or internal DNS server)

# Persistent Volumes
- storage that doesn't depend on pod lifecycle
- storage must be available to all nodes
- Storage needs to survive even if cluster crashes
- Kubernetes doesn't give you persistent storage out of the box. You need to configure yourself.

1. Persistent Volume - Just a abstract component, it must take the storage from actual physical storage, external or NFS or local Disk.  Plugins to a cluster.
2. Persistent Volume Claim - abstract component to connect with the Persistent volume and Pods. Must exist in same ns as pod
3. Storage Class - another abstraction layer. Provisions Persistent Volumes dynamically when persistentVolumeClaims it

- Storage spec will differ between different types of storage.
- are not namespace and is available to the cluster.
- local vs Remote
  - always use remote storage for persistent
  - serviceAccount is mounted on `/var/run/secrets/kubernetes.io/serviceaccount` local mount


```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-name
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: Slow
  mountOptions:
    - hard
    - nfsvers=4.0
  nfs:
    path: /dir/path/on/nfs/server
    server: nfs-server-ip-address   

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-name
spec:
  storageClassName: manual
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:                 # Volume is mounted on to the container
      - mountPath: "/var/www/html"
        name: mypd
  volumes:                          # Volume is mounted on to the pod
    - name: mypd
      persistentVolumeClaim:
        claimName: pvc-name

--- Generated automatically
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: storage-class-name
provisioner: kubernetes.io/aws-ebs # internal provisioner
parameters:
  type: io1
  iopsPerGB: "10"
  fsType: ext4
```

## configMap, Secrets
  - configMap volume type
    - local volumes
    - need to mount to pod and container same way as PV
  - secret volume type
    - local volumes
    - need to mount to pod and container same way as PV

    - Pods can use multiple volumes simultaneously


**Two types of user in Kubernetes**
- ServiceAccounts
- Normal Users
  - Static password file
  - OpenID Connect Tokens
  - x509 certificate
  - webhook

## kubeconfig - used for authentication
- save config under ~/.kube/config. This will save you from passing --kubeconfig parameter
-
  ```
  apiVersion: v1
  clusters:
  - cluster:
      certificate-authority-data: DATA+OMITTED #Kubernetes CA certificate
      server: https://myclusterip:6443
    name: mydemocluster # Give name for the cluster inside kubeconfig
  contexts: # makes relationship between clusters and users
  - context:
      cluster: mydemocluster # used cluster name mentioned above
      namespace: default
      user: user2
    name: default # Give name to context and access default namespace by user2
  - context:
      cluster: mydemocluster
      namespace: default
      user: user1
    name: mydefaultcontext
  - context:
      cluster: mydemocluster
      namespace: platform-dev
      user: user2
    name: platform-dev
  - context:
      cluster: mydemocluster
      namespace: platform-prod
      user: user3
    name: platform-prod
  current-context: platform-dev # this value keeps changes as per use-context parameter.
  kind: Config
  preferences: {}
  users:
  - name: user1
    user:
      client-certificate-data: REDACTED
      client-key-data: REDACTED
  - name: user2
    user:
      client-certificate-data: REDACTED
      client-key-data: REDACTED
  - name: user3
    user:
      client-certificate-data: REDACTED
      client-key-data: REDACTED
  ```
` kubectl config view`\
`kubectl config use-context platform-dev`\
`kubectl get po`

## ServiceAccounts
  - Kubernetes has can't create users/groups. It needs to be managed externally.
  - ca, certificaet Authority is the brain of trust in Kubernetes
  - But, serviceaccount can be defined/created by kubernetes API and is created in namespace.
  - By Default, service account is created in each namespace but has no access to API server
  - External application gets kubernetes access using serviceaccounts. Like Prometheus, appd, splunk or DB
  - Create your own service account
    - use it in a RoleBinding or ClusterRoleBinding
    - use the service account secret to obtain the authentication token and CA certificate
    - service account gets kubernetes secret automatically and located as shown below on each container in a cluster
      ```
      kubectl run -it --rm alpine --image=alpine -- sh #once the session is close, container is deleted.
      cd /var/run/secrets/kubernetes.io/serviceaccount/
      ls -1
      ca.crt  # validate tls connection to the kubernetes api end. like curl https://
      namespace
      token #jwt token, base 64 encoded, authenticate to the cluster as default service account. try decoding it using jwt <tokencontent>. It has cluster information, namespace and so on. It is signed by API server already.
      ```

      `npm install -g jwt-cli`

    - create service account:
      ```
      kubectl create serviceaccount platform-demo --dry-run=client -o yaml
      kubectl get secret # there are three pieces of data, lets look into it, ca.crt, token and namespace.
      kubectl get secret platform-demo-token-q9qr7 -o yaml
      echo <token_content> | base64 -d # decode the token
      jwt <decoded_token> # you will get payload information
      ```

    - playload information example:
      ```
      "iss": "kubernetes/serviceaccount",
      "kubernetes.io/serviceaccount/namespace": "default",
      "kubernetes.io/serviceaccount/secret.name": "platform-demo-token-q9qr7",
      "kubernetes.io/serviceaccount/service-account.name": "platform-demo",
      "kubernetes.io/serviceaccount/service-account.uid": "8e044aa0-1ce7-4cbf-bbe3-b42ef69bedbe",
      "sub": "system:serviceaccount:default:platform-demo"
      ```

  - Use ServiceAccount in a deployment
    ```
    template:
      metadata
      ..
      spec:
        serviceAccountName: platform-demo
        containers:
          - name: apline
            image: apline-curl
            command:
              - "sh"
              - "-c"
              - "sleep 10000"

    ```

  - ssh to alpine pod container created about
    `kubectl exec -it <pod_id> -- sh`

  - Wht https://kubernetes?
    `k get svc` # It is a default service entry point to API server in default name space.

  - now use ca.crt and token to access the alpine app over curl
    ```

    /run/secrets/kubernetes.io/serviceaccount # CA=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    /run/secrets/kubernetes.io/serviceaccount # curl --cacert $CA -X GET https://kubernetes/api
    {
      "kind": "Status",
      "apiVersion": "v1",
      "metadata": {

      },
      "status": "Failure",
      "message": "Unauthorized",
      "reason": "Unauthorized",
      "code": 401

      ## Need to authorized using jwt token

    /run/secrets/kubernetes.io/serviceaccount # TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    /run/secrets/kubernetes.io/serviceaccount # curl --cacert $CA -X GET https://kubernetes/api --header "Authorization: Bearer $TOKEN"
    {
      "kind": "APIVersions",
      "versions": [
        "v1"
      ],
      "serverAddressByClientCIDRs": [
        {
          "clientCIDR": "0.0.0.0/0",
          "serverAddress": "142.136.156.145:6443"
        }
      ]

    /run/secrets/kubernetes.io/serviceaccount # curl -X GET https://kubernetes/api --header "Authorization: Bearer $TOKEN"
    curl: (60) SSL certificate problem: unable to get local issuer certificate
    More details here: https://curl.haxx.se/docs/sslcerts.html

    curl failed to verify the legitimacy of the server and therefore could not
    establish a secure connection to it. To learn more about this situation and
    how to fix it, please visit the web page mentioned above.
    /run/secrets/kubernetes.io/serviceaccount # curl -X GET https://kubernetes/api --header "Authorization: Bearer $TOKEN" --insecure
    {
      "kind": "APIVersions",
      "versions": [
        "v1"
      ],
      "serverAddressByClientCIDRs": [
        {
          "clientCIDR": "0.0.0.0/0",
          "serverAddress": "142.136.156.145:6443"
        }
      ]
    }/run/secrets/kubernetes.io/serviceaccount #

    ```

  **More On service account**
  - Secure access to API server
    - Authentication via plugins, who the heck are you?
      - Client Certificates - most common
      - Authentication token - mostly used for serviceaccount(jwt, json web token)
      - Basic HTTP - Not recommended
      - OpenID Connect - Azure
    - Authorization (permission to perform certain task) - Groups or Roles RBAC
    - Admission control (webhooks)
  - Type of users
    - Person
    - Application

  **LDAP integration**
  https://theithollow.com/2020/01/21/active-directory-authentication-for-kubernetes-clusters/
  https://computingforgeeks.com/active-directory-authentication-for-kubernetes-kubectl/

  LDAP group translate to namespace in k8s - Need to test this

- Create role and rolebinding
  - ClusterRoleBinding - cluster level
  - RoleBinding - limited to namespace

  ```
  k create role podlister --verb=list --resource=pods --dry-run=client -o yaml
  k create role podlister --verd=list --resource=pods
  k create rolebinding podlisterrolebinding --serviceaccount=default:platform-demo --role podlister --dry-run=client -o yaml
  k create rolebinding podlisterrolebinding --serviceaccount=default:platform-demo --role podlister
  ```

    ```
    k exec -it apline-serviceaccount-deployment-5f976c7b64-cj9vw -- sh

    / # CA=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    / # TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    / # curl --cacert $CA -X GET https://kubernetes/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN"| head -n 20
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0{
      "kind": "PodList",
      "apiVersion": "v1",
      "metadata": {
        "resourceVersion": "976596"
      },
      "items": [
        {
          "metadata": {
            "name": "mongodb-deployment-555cdf5fdf-rw6r4",
            "generateName": "mongodb-deployment-555cdf5fdf-",
            "namespace": "default",
            "uid": "3b562343-b60f-4b28-9b60-45517b2651b0",
            "resourceVersion": "466349",
            "creationTimestamp": "2022-03-19T00:20:07Z",
            "labels": {
              "app": "mongodb",
              "pod-template-hash": "555cdf5fdf"
            },
            "ownerReferences": [
    100  8493    0  8493    0     0  1184k      0 --:--:-- --:--:-- --:--:-- 1184k
    curl: (23) Failed writing body (0 != 5930)

    ```

# RBAC - Role base access control
 - user should have , key pair (.key and .crt) and .csr (ceriticaet signing request)
 - kubernetes master have Certificate Authority ca.key and ca.crt

 - role applies to only particular namespace
 - clusterrole applies to entire cluster

 - k3s CA certificates are located under `/var/lib/rancher/k3s/server/tls/client-ca.*`
 - k8s and minikube CA certificates are located under `/etc/kubernetes/pki/ca.*`

 - When you create a role, you need to define *rules*
  1. apiGroups
    - core api group
    - extensions
    - apps
    - networking
  2. resources(noun)
    - pods
    - deployments
    - replicasets
  3. verbs(action) - what user can do
    - get, list, watch, update, delete

 - Demo
  - create user certificates:
    ```
    openssl genrsa -out john.key 2048 # create use private key
    openssl req -new -key john.key -out john.csr -subj "/CN=john/O=platform-prod" # create user certificate signing request, platform-prod is a namespace

    # Generate user .crt signed by kubernetes CA certificate authority, this action should be performed by Admin/kubernetes.
    openssl x509 -req -in john.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out john.crt -days 365 # k8s
    openssl x509 -req -in john.csr -CA /var/lib/rancher/k3s/server/tls/client-ca.crt -CAkey /var/lib/rancher/k3s/server/tls/client-ca.key -CAcreateserial -out john.crt -days 365 #k3s

    --
    ateserial -out john.crt -days 365
    Signature ok
    subject=/CN=john/O=platform-prod
    Getting CA Private Key
    ```

  - Now share .csr and CA to user so user can configure kubeconfig himself, or admin can configure and share the kubeconfig to user

  - using user certificate .key and .crt, generate user Kubeconfig manually, lets say create user.

    ```
    k config view # get cluster name and ip address

    kubectl --kubeconfig john.kubeconfig config set-cluster kubernetes --server https://<kubernetes_master>:6443 --certificate-authority=ca.crt #k8s

    kubectl --kubeconfig john.kubeconfig config set-cluster default --server https://127.0.0.1:6443 --certificate-authority=/var/lib/rancher/k3s/server/tls/client-ca.crt #setting up new cluster kubernetes in kubeconfig # k3s
      Cluster "kubernetes" set.

    # add user to kubeconfig
    k --kubeconfig john.kubeconfig config set-credentials john --client-certificate john.crt --client-key john.key
    User "john" set.

    # set context for user
    k --kubeconfig john.kubeconfig config set-context john-kubernetes --cluster kubernetes --namespace platform-prod --user john  
    ```

   **output keys with base64 without line break/wrapping**
    ```
    cat john.crt|base64 -w0
    cat john.key|base64 -w0
    ```

  - OR copy ~/.kube/config john.kubeconfig  OR  cp /etc/rancher/k3s/k3s.yaml john.kubeconfig and edit the file

    ```
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data:  <leave as it is, this is ca.crt>
        server: https://127.0.0.1:6443
      name: default
    contexts:
    - context:
        cluster: default
        user: <username>
        namespace: default
      name: default
    current-context: default
    kind: Config
    preferences: {}
    users:
    - name: <username>
      user:
        client-certificate-data:  <base64 -w0 user.crt>
        client-key-data: <base64 -w0 user.key>
    ```

  - Create role\
    `k create role readonlyuser --verb=get,list --resource=pods --namespace=default`

    ```
    k get role readonlyuser -o yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      creationTimestamp: "2022-03-24T03:46:22Z"
      name: readonlyuser
      namespace: default
      resourceVersion: "1031108"
      uid: 35b79bff-bcdc-41f3-90e9-fcda69e8978e
    rules:
    - apiGroups:
      - '*'
      resources:
      - pods
      - *
      verbs:
      - get
      - list
      - *

    ```
  -  Rolebinding - bind role to the user\
    `k create rolebinding readonlyrolebinding --role=readonlyuser --user=john --namespace=default`

    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      creationTimestamp: "2022-03-24T03:49:02Z"
      name: readonlyrolebinding
      namespace: default
      resourceVersion: "1030777"
      uid: a28dc645-2dda-4fe1-9036-353ae9b3df2c
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: readonlyuser
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: john

    ```
  - **Group**
    - To avoid rolebinding user list from growing, use Kind: group
    - **How do you list user in a group**?
      - You cannot.  group name is created during user certificate signing request, /O=<groupname>
        `-subj "/CN=john/O=platform-prod"`\
        **CN:** This will be set as username\
        **O:** Org name. This is actually used as a group by kubernetes while authenticating/authorizing users. You could add as many as you need\
        `openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=dev/O=example.org"`\
        `openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=default"`

    - Bind group and role:\
     `k create rolebinding groupbinding --role=readonlyuser --group=<groupname, should be same as certificate subj /O=<groupname>> -n <namespace>`


# What is a namespace in Kubernetes
- In Kubernetes, namespaces provides a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. Namespace-based scoping is applicable only for namespaced objects (e.g. Deployments, Services, etc) and not for cluster-wide objects (e.g. StorageClass, Nodes, PersistentVolumes, etc).
- There are thee namespaces created by kubernetes
  1. default, by default you can deploy components to it.  
  2. kube-system, It is the Namespace for objects created by Kubernetes systems/control plane.
  3. kube-public, Namespace for resources that are publicly readable by all users. This namespace is generally reserved for cluster usage.

# yaml explained
- Every configuration file in kubernetes has three parts
  1. metadata
    - has name of the component itself
    -
  2. specification
    - attributes will be specific to the kind of the component
  3. Where is the third part in a configuration?
  - Status
    - status is automatically generated by kubernetes
    - It compares Desired state to actual state
    - This information is fetched from etcd
    - It updates the state continuously

- First two lines are what you want to create and which api version to use for each component

- Template, call Pods blueprint
  - has it's own metadata and spec
  - configuration inside a configuration
  - this configuration applies to a pod
  - spec inside template is the blueprint of pod, like which image, which port and name of the container

- Connectors, through Labels and Selectors
  - metadata part contains labels
  - specification part contains selectors
  - pods get the label through the template blueprint, and this label is matched by the selector
    ```
    selector:
      matchLabels:
        app: nginx
    ```
  - Means, match all the labels with app: nginx in a deployment to create the connections
- Deployment has its own label, this label is mapped by the selector in service to establish the connections between deployment and service components.


## Jobs
- Jobs run until it is exited with completion code
- if the job pod is deleted, it gets created again until job is completed.

- **completion**
  - Runs in sequence, once first job is completed, it created new pod and start the same job.

- **parallelism**
  - All the job pods will be created and executed at the same time.

- **backoffLimit**
  - Number of retries when job fails, we do not want to create job infinite times.

- **activeDeadineSeconds**
  - set a threshold, if the job is not completed within provided time limit, delete the job.

```
apiVersion: batch/v1
kind: Job
metadata:
  name: demo-job
spec:
  completions: 3 # three pods will be created two sec apart
  parallelism: 4 # runs 4 pods in same time
  backoffLimit: 2 # two retry if the jobs fails
  activeDeadlineSeconds: 10 #
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["echo", "Hello Kubernetes"]
      restartPolicy: Never

```

## Cronjobs
- By default it shows last three jobs
- suspending cron jobs
  - prevent cronjob from creating new jobs, but will not stop current running one.
  - set suspend to true Or dynamically
    - use yaml to trace the log, update the file and apply\
    `kubectl apply -f <cronjob>.yaml`
    - using dynamically:
    `kubectl patch cronjob demo-cronjob -p '{"spec":{"suspend": "true"}}'`

- concurrencyPolicy
  - allow more than one job to run
  - **Allow** Default, it will create new job even if previous job is running
  - **Replace** If the previous takes long time, Replace with new Job
  - **Forbid** wait for the job to complete before scheduling another job
- idempotency
- Use cases:
  - DB backup
  - sending emails
  - anything periodic



```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: demo-cronjob
spec:
  schedule: "* * * * *"
  successfulJobsHistoryLimit: 0 # 3 is default, zero will retain 1 job history
  failedJobsHistoryLimit: 0 # 1 is default
  suspend: false # true
  concurrencyPolicy: Forbid # it take three values Allow (default), Replace, Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: busybox
            image: busybox
            command: ["echo", " Hello cronjob"]
          restartPolicy: Never

```

## multi-container Pod (sidecar, init, others)

## Deployment strategies
  - blue/green
  - canary
  - rolling updates

## API Depreciation

## Health checks
  - **startup Probes**:
    - Responsible for application deployed inside the docker container
    - If the application is not running, there is no point is livenessProbes and then readinessProbes.
    - If the application is successfully started, then only start liveness and readiness probes
    - Once application is started, it will tells liveness and readiness probes to start.
    ```
    startupProbe:
      httpGet:
        path: /hello
        port: 8080
      failureThreshold: 30 # K8s will try incase probe fails, max it will wait for 5 mins(30 * 10 (retry every 10 sec) = 300 sec) to finish up application start.
      periodSeconds: 10 # how often the check is performed
    ```

  - **liveness probes**
    - responsible for telling docker container needs restart
    - responsible for docker container

      ```
      livenessProbe:
        httpGet:
          path: /hello # health endpoint of the applications, there will be multiple endpoints
          port: 8080
        initialDelaySeconds: 15 # The first time when liveness will test. It is needed when we deploy application for first time and delays for 15 sec before it starts periodSeconds probe
        periodSeconds: 10 # Regular interval after the application startup.
      ```
  - **readiness probes**:
    - Door keeper for incoming traffic
    - responsible for whole Pod
    - responsible for telling the pod is ready to receive the traffic or Not. If the pod is not ready to receive the traffic, the readiness probe will tell kubernetes cluster that the pod is not health and remove from LB.
    - Configuration is same as liveliness probe.

    ```
    readinessProbe:
      httpGet:
        path: /hello
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 10
    ```

## container logs
-
## debugging in Kubernetes



# Docker Swarm
  - Used for managing container like kubernetes

# Docker Swarm VS Kubernetes
||DockerSwarm|Kubernetes|
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
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  selector:
    matchLabels:
      app: hello
      tier: backend
      track: stable
  replicas: 3
  template:
    metadata:
      labels:
        app: hello
        tier: backend
        track: stable
    spec:
      containers:
        - name: hello
          image: "gcr.io/google-samples/hello-go-gke:1.0"
          ports:
            - name: http
              containerPort: 80
 ```
- ingress
  - ingress allows access to kubernetes service from outside cluster
  - It can be done through ingress controller or LB
  - It can provide LB, SSL termination and name-based virtual hosting.
  - is an API object that provides routing rules to manage external users' access to the services in a Kubernetes cluster
  - Evalautes all the rules
  - Manages redirections
  - Entrypoint to cluster
  - It is managed using ingress controler Pod provided by Kubernetes itself K8s nignx Ingress Controller
  - There are many third party ingress implemention, ELB, Proxy server - this will be entrypoint to the cluster and then request will go to ingress controller.
  -

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
    - A Service in Kubernetes is an abstraction which defines a logical set of Pods and a policy by which to access them. Services enable a loose coupling between dependent Pods.
```
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  selector:
    app: hello
    tier: backend
  ports:
  - protocol: TCP
    port: 80
    targetPort: http
```
# Inteview Questions:
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
10. Rollback
  -  To display all the previous deployments
    `kubectl rollout history deployment <deployment_name>`
  -  To Restore the last deployment
    `kubectl rollout undo deployment <deployment_name>`
11. What is init container
  - A pod can have many containers. Init container gets executed before any other containers run in the pod
12. How do you package kubernetes application
  - helm is a package manager which allow user to package, configure and deploy the application and services to\
    the kubernetes cluster
    ```
    helm search redis
    helm install stable/redis
    helm ls
    ```
13. Zero down time deployment
  - By default deployment in Kubernetes using rolling update as strategy
    - Update the ngnix image
      `kubectl set image deployment ngnix ngnix=ngnix:1.15`
    - Check the replicas set
      `kubectl get replicasets`
    - Check the status of deployment rollout
      `kubectl rollout history deployment ngnix`
    - Check the revision in the deployment
      `kubectl rollout history deployment ngnix`
14. How do you monitor the pods that is always running
  - A liveness probe always checks if an application in a pod is running,\
    If the check fails, the container will get restarted
  - readiness probe
  - Three types of probe
    1. http
    2. command
    3. tcp

15. How do you drain traffic for maintenance\
  - `kubectl drain <nodename>`\
  - `kubectl uncordon <nodename>` # put the node back to rotation

# ConfigMaps
A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

# Deployment types
1. Recreate deployment
- used in dev environment, running container is terminated and created with new contianer
2. Rolling update
- deploy new version of app, and terminate one version
- Deployment with new replicaSet is launched and replicaSet of old version is terminated. Eventually all the old version is terminated
3. Blue/green deployment
- Rapid transition from old version to new version, making sure new version works 100%.
- Green version is deployed with existing blue version.
- Once testing is completed, DNS is switched to new version.
4. Cannary deployment
- A smaller group of user are routed to new version of an application, once testing is error free, replicas of new version is scaled up and thus old version is replicaed in an orderly manner


# Firewall validation from Kubernetes cluster
1. Authenticate using pks: \
`./pks.exe get-kubeconfig cdp-dev-oobs-sit -u tdorji@example.COM -a example.com -k`

2. Login to container: \
- ssh to one of the running container: \
  `./kubectl.exe exec -it debug -n oobs-sali-sit -- /bin/sh `

- OR create new container: \
`./kubectl.exe run firewall-test --image=brix4dayz/swiss-army-knife --restart=Never -n namespace-dev`\
`./kubectl.exe exec -it firewall-test -n oobs-sali-sit -- /bin/sh`

- OR, this should work if none of the above two are not working\
`./kubectl.exe run -i -t --rm --image=brix4dayz/swiss-army-knife --restart=Never firewall-test -n namespace-dev`

3. using nc command to validate the firewall rules\
`nc -vz -w 2 111.111.111.111 443`
