# Docker lesson
## Docker commands
  - practice lab: https://kodekloud.com/p/docker-labs

  - run - starts the container \
  `docker run nginx` \
  `docker run --name webapp nginx:1.14-alpine`
  - list the docker container names \
    `docker ps` \  
    `docker ps -a` # gets all the container even stopped ones
  - stop container \
    `docker stop <container_name>`
  - remove container permanently\
    `docker rm <container_name>`\
    `docker container rm $(docker container ls -aq)` #remove all stopped container
  - list images\
    `docker images`
  - remove images\
    `docker rmi <image_name>`\
    `docker rmi nginx:alpine`\
    `docker rmi nginx:latest` \
    `docker image prune` # remove unused dangling images

  - download images\
    `docker run nginx` #it download and run the container\
    `docker pull nginx` #pull the image and don't run the container \
    `docker pull nginx:1.14-alpine`
  - run command on running docker container\
    `docker exec <container_name> cat /etc/hosts`
  - Run attach and deattach\
    `docker run nginx` #runs in foreground and stdout to console\
    `docker run -d nginx` # runs in background and use `docker ps` to see the running container\
    `docker attach <container_id_firstfewchar>` #to bring running container to foreground
  - login to docker container with interactive and terminal mode\
    `docker exec -it <docker PID> bash`
  - tag\
    `docker pull nginx:1.14-alpine` #After : is the tag which is version of the app. \
    If you do not mention tag, docker takes default latest tag.
  - port mapping\
    `docker run -p 80:5000 <container_name>`\
      - Container runs on docker host and every container is assigned with private IP which is not exposed to outside.\
      - Mapped docker host port to container port and use docker host IP to access the App.
  - Create vol\
    `docker volume create data_volume`
  - Vol mapping\
    `docker run -v /opt/external_data_store:/var/lib/mysql_local_mount <container_name>`\
    `docker run -v data_volume2:/var/lib/mysql mysql` # if data_volume2 is not create, docker will automatically create and mount it.
  - list local vol \
    `docker volume ls` \
    `docker volume prune` #remove unused vol
  - Inspect container\
    `docker inspect <container_name>` #all details of the container
  - Container log\
    `docker logs <container_name>`

Container only lives as long as process inside the container is running. Once it is completed, it exits and show status as exited

## How to create a docker image
- write docker file in below sequence
- Once image is created, it cannot be edited.
  1. OS -ubuntu
  2. Update apt repo
  3. install dependencies using apt
  4. install python dependencies using pip
  6. Copy source code to /opt/ folder
  7. run the web server using "flask" command

```
FROM Ubuntu

RUN apt-get update
RUN apt-get install python

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

- create the image by running below command
  `docker build Dockerfile -t tenzin/my-custom-app` #creates image locally on your system and tag it \
  `docker push tenzin/my-custom-app` #push to docker hub registry  

## CMD VS ENTRYPOINT

# Networking in docker
## Docker create three network automatically
1. Bridge (default)\
  `docker run ubuntu`\
    - private internal network created by docker(172.17.x.x.)\
    - N number of container can be accessed from outside docker host
2. none
  `docker run Ubuntu --network=none`\
    - No access to any of the the container from outside docker host\
    - They run in a isolated network.
3. host
  `docker run Ubuntu --network=host`\
    - only one container will be able to access from outside docker host

- By default docker creates only one internal network\
- If you want to create isolated custom network inside docker, use below command
  ```
  docker network create \
    --driver bridge \
    --subnet 192.168.x.x./24
    custom-isolated-network
    ```
  `docker network ls` #list all the networks\
  `docker inspect <container_name` #there is the section where it has network details
- List network\
  `docker network ls` \
  `docker network rm <network_id>`\
  `docker network prune`


## Containers can reach each other with their names
  - Docker has a build in dns server which resolves container_name to internal IP address

# Docker storage drive and file system
## File System
  - /var/lib/docker
    - aufs
    - containers
    - image
    - volumes
## Docker layers architecture

# Docker compose
