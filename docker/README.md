# Docker lesson
**Namespaces** are one of a feature in the Linux Kernel and fundamental aspect of containers on Linux. On the other hand, namespaces provide a layer of isolation. Docker uses namespaces of various kinds to provide the isolation that containers need in order to remain portable and refrain from affecting the remainder of the host system. Each aspect of a container runs in a separate namespace and its access is limited to that namespace.
- Namespace Types:
    1. Process ID
    2. Mount
    3. IPC (Interprocess communication)
    4. User (currently experimental support for)
    5. Network
    
**Cgroups** provide resource limitation and reporting capability within the container space. They allow granular control over what host resources are allocated to the containers and when they are allocated.\
 - Common control groups
    1. CPU
    2. Memory
    3. Network Bandwidth
    4. Disk
    5. Priority

## Install docker on debian box 
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-debian-10

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
    `docker container rm $(docker container ls -aq)` #remove all stopped container\
    `docker rm $(docker ps --filter status=exited -q)` # removed all stopped containers
    
  - list images\
    `docker images`
  - remove images\
    `docker rmi <image_name>`\
    `docker rmi nginx:alpine`\
    `docker rmi nginx:latest` \
    `docker image prune` # remove unused dangling images\
    `docker image prune --all --force` # remove all images from local
   

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
    `docker run -p <host_port>:<container_port> -d <image_id>` # run container in backgroud and bind to port\ 
    `docker run -p 80:5000 <container_name>`\
      - Container runs on docker host and every container is assigned with private IP which is not exposed to outside.\
      - Mapped docker host port to container port and use docker host IP to access the App.
      - Host port is the port which docker container process is running on docker host
      - Container port is the port which is exposed in docker file. It is within container. 
      - Host post and container ports need to bind to access the application outside of docker host. 
      -
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

## How to create docker image manually
1. Create the free account in https://hub.docker.com
2. Need to install docker in your local
3. login to docker\
`docker login`
4. create the php container \
`docker run -dP webdevops/php-nginx`
5. login to container \
`docker exec -it <container_name> /bin/bash`
6. Install and configure app
```
curl https://codeload.github.com/simplepie/simplepie/zip/1.4.3 > simplepie1.4.3.zip
unzip simplepie1.4.3.zip
mkdir /app/php
mkdir /app/cache
mkdir /app/php/library
cp -r s*/library/* /app/php/library/.
cp s*/autoloader.php /app/php/.
chmod 777 /app/cache
vi /app/rss.php
```
```
<?php
require_once('php/autoloader.php');
$feed = new SimplePie();
$feed->set_feed_url("http://rss.cnn.com/rss/edition.rss");
$feed->init();
$feed->handle_content_type();
?>
<html>
<head><title>Sample SimplePie Page</title></head>
<body>
<div class="header">
<h1><a href="<?php echo $feed->get_permalink(); ?>"><?php echo $feed->get_title(); ?></a></h1>
<p><?php echo $feed->get_description(); ?></p>
</div>
<?php foreach ($feed->get_items() as $item): ?>
<div class="item">
<h2><a href="<?php echo $item->get_permalink(); ?>"><?php echo $item->get_title(); ?></a></h2>
<p><?php echo $item->get_description(); ?></p>
<p><small>Posted on <?php echo $item->get_date('j F Y | g:i a'); ?></small></p>
</div>
<?php endforeach; ?>
</body>
</html>
```

`exit`

7. Test\
  `curl http://localhost:32773/rss.php`

8. Create new image \
`docker commit -m "Message" -a "Author Name" [containername] [imagename]`\
`docker commit -m "Added RSS" -a "Nick Chase" <containername> tenzindorji/rss-php-nginx:v1`

`docker push tenzindorji/rss-php-nginx:v1`

9. Remove container and image and build it using new image


## How to create a docker image
- write docker file in below sequence
- Once image is created, it cannot be edited.
  1. OS -ubuntu
  2. Update apt repo
  3. install dependencies using apt
  4. install python dependencies using pip
  6. Copy source code to /opt/ folder
  7. run the web server using "flask" command

- Dockerfile
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
  
## RUN Command
- Is executed during docker build to create image
- CMD is executed when container is started. 

## CMD VS ENTRYPOINT
- CMD - default command to be executed when running the contianer in the docker file 
- CMD - it can be overwritten by providing commands during docker run.
- ENTRYPOINT  - allows you to run executable files and it is not ignored when command is provided during docker run

## What is ENTRYPOINT
- Allows you to specify along with the parameters 
- Syntax `ENTRYPOINT application "arg, arg1"
- Example `ENTRYPOINT echo "Hello, $name"

## ADD  
- Copy file from host to docker image
- `ADD /SRC/ /DES/`

## ENV
- Set up environment variables
- change be overwrite during run time 

## MAINTAINER 
- `MAINTAINER niznetij@gmail.com`

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

## What is docker host, docker container and docker swamp
- Docker host is the VM where docker Engine is installed and containers run on it as a processes. 
- Docker container is process running on Docker host created from any base image. 
- Docker Swamp is group of containers 
## Docker layers architecture

# Docker compose
