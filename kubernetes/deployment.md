## Kubernetes code deployment steps 
1. Authenticate with kubernetes cluster using pks cli or anyother available authentication tool
`./pks.exe get-kubeconfig <cluster_name> -u P2980250adm@example.com -a cdp-pks-01.corp.chartercom.com -k` 
- -a is API URL to connect with kubernetes cluster 
2. Create a deloyment yaml file 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

3. Create a deployment using deployment file 
`./kubectl.exe apply -f deployment.yml -n <name_space>`

4. Get the deployment
`./kubectl.exe get deployments -n <name_space>`

5. Get pods 
`./kubectl.exe get pods -n <name_space>`

6. Can login to running pods 
`./kubectl.exe exec -it <pod_name> -n <name_space> /bin/sh`

7. Delete deployments 
`./kubectl.exe delete deployment <deplyoment_name> -n <name_space>`
