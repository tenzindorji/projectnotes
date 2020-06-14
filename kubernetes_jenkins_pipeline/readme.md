#Steps to create CI/CD pipeline

Devops tools: \
- jenkins for build and provisioning
- ansible for deployment
- docker for container
- kubernetes to deploy container


sudo mkdir /opt/k8s-lab
sudo chown -R admin:admin /opt/k8s-lab


Configuration On Kubernetes master node:


valaxy-deploy.yml\
```
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: valaxy-deployment
spec:
  selector:
    matchLabels:
      app: valaxy-devops-project
  replicas: 2 # tells deployment to run 2 pods matching the template
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1

  template:
    metadata:
      labels:
        app: valaxy-devops-project
    spec:
      containers:
      - name: valaxy-devops-project
        image: tenzindorji/simple-devops-image
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
```

valaxy-service.yml

```
apiVersion: v1
kind: Service
metadata:
  name: valaxy-service
  labels:
    app: valaxy-devops-project
spec:
  selector:
    app: valaxy-devops-project
  type: LoadBalancer
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 31200
```

50000862 ofx channel and one more
50000158  contacts
20000024 - help info and contact info
