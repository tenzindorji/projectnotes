#Steps to create CI/CD pipeline

Devops tools: \
- jenkins for build and provisioning
- ansible for deployment
- docker for container
- kubernetes to deploy container


mkdir /opt/k8s-lab
chown -R admin:admin /opt/k8s-lab


Configuration On Kubernetes master node:

Dockerfile\
```
FROM tomcat:latest

MAINTAINER AR Shankar

COPY . /usr/local/tomcat/webapps
```
valaxy-deploy.yml\
```
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


cat ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD83nRhUC8qiS1yvtgtoqVHREejGXHYm2ofRHVYj010H9vHj4sAhWpx3TlFF9MjSBHH2Y0JRJUo+Oa9JPYk0QfzfNlW2n/PctITVIsfElmcTf98wAc4iST1WlBVOPPME0norukHK0F2v5FefB5B6Qix64cMfFx8XMVZzgK3t4SSsIKFE13Me0+4758YtO6VPatbt5z6miRzcT7XVRAsKGGIpRj1X7oGeTimM9fvPa65EYcjSjtoujjx5SPVxLHYmF5o8MWBb4y+sF9hoAPsM8SMipXylF0L3lQT9RkctS6Qx7Cz9w4EbbPryTBq6SewuUc9iTsHijF1IlkqQMt4XLWYx9aPjZ+di6fITb4yK6AYaOnf3Erp07hhmWaISNTmZmo7q4cw+0V71pYAhB71zAmKFc/4daiAKL/TDpegbUf1QKpN+B08c1ONc44XD33TMcj+SzMhqD3R0LixE8CYS/+0Oa9cMkCZSE9Za5IJMgIbSLehMXb7OTQ70q9lwlMS4dE= kubernetes.tenzindorji.com-85:6b:28:a0:0b:f1:0f:28:18:3f:c4:cf:63:40:5e:b4
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+BAYdHEPbiPmVQov/Sy30Lrlro2ScBXc26ABUQhE2ZCpzmF5U0nu3rKm7U1OamewcIlFiLLN5duCZgQY6oOgPXP7s8+9+6D31nBXJgiPrM6fmrY7+q4jUTh88rVqNYiN0361x8xSHrJAAXhzUMIpKvOrJ5nJlqdT5CQqwQkl6f923GUyDae8cOXGTTX9JPkM5SapbAtJG4Nrs3FViOeqGFJ6ZGYLf2/oR/sOOzUHSzmZG1sWBV/WnkqJFCybOzRzi8fTk8bbSaVgrkw2yVQzjNW+FRGuV1g5fekZbHIPuTIofU3UdvGkXeREdrjy0Mj/Ym9nRhKKesFt9DPcnelmVa8+AUkljwQCLc5EqoF7jSt9lEogGSFdQx/W7cxNR1t1mxDbTaHZ164U5gqXZKK03d+yUO4A87p84TFCP7VaR3Fchc+01xj84XWtNwrcWJhzSF6eRVswtup8hMf/YlZHpM+jO5Wbj5v1d9L0WEqLbPUM+dvkQMf9l73bPXzrNdc= ansadmin@ip-172-31-31-124.us-west-2.compute.internal
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBQo++QBOz+ltC4u9KMAG+CZ/LRppwpeGsJNgawUYDUq97FmhMiDpBj8nMj2oWqt2nZRL2/9G7WxnjptdWr5ixT2IzsUw58hYT4OPxVQ/s4lPEjhVmPZ368U/3WuBcNatcATxYJhZrE0yejh9YK8KYoTdjEBVcXQXJlIxmsLEPxG32B4k0pBRCIWGIn2dBk96i4vnBU7u/GxxHC5yhgjyONBVTH4nm0Wh/NFm77A7OwQFH1B4wy0Pkm8ol0JooXhGon2hrvkeS67SXvdiuuSZWkfPLLxe+DZT0/GQhn+iOVFfmPs/me5c7JJW9wxVr/8Iww7y0Dy3no+pmlRMkSuen ansadmin@ip-172-31-18-142
