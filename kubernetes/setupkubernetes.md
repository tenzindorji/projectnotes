# Setup kubernetes using kops CLI
https://github.com/simplilearn-github/kubernetes/blob/master/simplilearn-kops-setup.MD

1. Create EC2 instance to run and install kubernetes
    Use cloud formation to launch EC2 instance.
      It should have access to S3, route , VPC, autoscaling ..
      Create IAM role and attach to EC2.
      Create S3 bucket.
      tenzindorjik8 - created
      Create private hosting in route 53
      tenzindorji.in - created

2. Install kops in ec2 instance
  ```
  curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
  chmod +x kops-linux-amd64
  sudo mv kops-linux-amd64 /usr/local/bin/kops
```

3. Install kubectl
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

4. Configure environment variable
  - open .bashrc file and add below lines
  ```
  PATH=/usr/local/bin:$PATH

  export KOPS_CLUSTER_NAME=tenzindorji.in
  export KOPS_STATE_STORE=s3://tenzindorjik8
  ```
  - run source
  `source ~./bashrc`

5. create ssh key pair in the ec2 node
  `ssh-keygen`

6. Create kubernetes cluster defination
```
    kops create cluster \
    --state=${KOPS_STATE_STORE} \
    --node-count=2 \
    --master-size=t2.micro \
    --node-size=t2.micro \
    --zones=us-west-2a,us-west-2b \
    --name=${KOPS_CLUSTER_NAME} \
    --dns private \
    --master-count 1
```
7. Create kubernetes cluster
`kops update cluster --yes`
`kops validate cluster`

8. To connect to the master
`ssh admin@api.tenzindorji.in`

9. Deploy app.
  ```
  kubectl get nodes
  kubectl get po
  kubectl run k8learning app --image=simplilearndockerhub/my-nodeapp --replicas=2 --port=8080
  kubectl get po
  kubectl get deployment
  kubectl expose deployment k8learning
  kubectl get svc
  curl http://100.70.84.215:8080
  kubectl get service -o wide
  ```

# Destroy the kubernetes cluster
`kops delete cluster  --yes`
