## MongoDB and Mongo Express deployment
1. Create MongoDB pod and its Internal Service with its DB URL so that mongo express can connect to it, also need to create credentials(DB user and pwd)
  - credentails are passed in deployment file through Env variables , Kind: Secret
  - DB URL, kind: CondigMap
2. Create Mongo Express, and create external service to be accessible outside cluster.
  - deployment file which has MongoDB details, like URL and credentials


## MongoDB deployment:
- We need to create secrets before the deployment since it will be referenced in deployment file
```
kubectl apply -f mongodb-secret.yaml
secret/mongodb-secret created

kubectl get secret
NAME                  TYPE                                  DATA   AGE
default-token-9q2d4   kubernetes.io/service-account-token   3      4d5h
mongodb-secret        Opaque                                2      58s
```

- mongodb-secret
 - type: Opaque , default for arbitrary key-value pairs OR tls
 - Secret value username and password should be base 64 encoded
 - Encode cred with base 64
   `echo -n 'username' | base64`
   `echo -n 'password' | base64`

- Create internal service
  - Selector points to label in deployment file, thats how service discover the pods
  - After service is created, how do you check if the service is attached to correct deployment pod?
    `kubectl describe service mongodb-service` Look for Endpoints\
    `kubectl get po -o wide` IP and Endpoints should have same value.

- mongo Express, need to below details to connect to mongoDB
  1. Which database to connect?
    - MongoDB Address / Internal Service
    - MongoDB server
  2. Which credentials to authenticate
    - ADMINUSERNAME
    - ADMINPASSWORD
  3. Order matters, need to create configMap before creating mongo-express deployment


- Create external service for mongo express,
  - two things are needed to make it service external
    - type: LoadBalancer , not a good name for external service.
    - nodePort: must be between 30000-32767
  - Ingress configuration is not created, just a service which is external should be enough to reach to DB

```
kubectl get service
NAME                               TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)          AGE
kubernetes                         ClusterIP      10.43.0.1       <none>            443/TCP          4d7h
mongodb-service                    ClusterIP      10.43.137.184   <none>            27017/TCP        47m
mongodb-express-service-external   LoadBalancer   10.43.116.147   142.136.156.145   8081:30000/TCP   19s
```

`kubectl get endpoints`


- Refer to mongodb image document in documents for ports and environment details
