## Kubernetes code deployment steps 
1. Authenticate with kubernetes cluster using pks cli or anyother available authentication tool\
`./pks.exe get-kubeconfig <cluster_name> -u P2980250adm@example.com -a example.com -k` 
- -a is API URL to connect with kubernetes cluster 
2. Create a deloyment yaml file 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysite-nginx
  labels:
    app: mysite-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysite-nginx
  template:
    metadata:
      labels:
        app: mysite-nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html-volume
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html-volume
        configMap:
          name: mysite-html
---
apiVersion: v1
kind: Service
metadata:
  name:  mysite-nginx-service
spec:
  selector:
    app: mysite-nginx
  ports:
    - protocol: TCP
      port: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mysite-nginx-ingress
  annotations:
    kubernetes.io/ingress.class: "traefik"
    traefik.frontend.rule.type: PathPrefixStrip
spec:
  rules:
  - http:
      paths:
      - path: /mysite
        pathType: Prefix
        backend:
          service: 
            name: mysite-nginx-service
            port:
              number: 80

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

```
<html>
<head><title>K3S!</title>
  <style>
    html {
      font-size: 62.5%;
    }
    body {
      font-family: sans-serif;
      background-color: midnightblue;
      color: white;
      display: flex;
      flex-direction: column;
      justify-content: center;
      height: 100vh;
    }
    div {
      text-align: center;
      font-size: 8rem;
      text-shadow: 3px 3px 4px dimgrey;
    }
  </style>
</head>
<body>
  <div>Hello from K3S!</div>
</body>
</html>
```
