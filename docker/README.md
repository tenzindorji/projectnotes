# Docker lesson

Containers are made up of three basic Linux which makes them separated from each other

## Namespace
**Namespaces** are one of a feature in the Linux Kernel and fundamental aspect of containers on Linux. On the other hand, namespaces provide a layer of isolation. Docker uses namespaces of various kinds to provide the isolation that containers need in order to remain portable and refrain from affecting the remainder of the host system. Each aspect of a container runs in a separate namespace and its access is limited to that namespace.

- Isolation mechanism for resources
- Changes to resources within namespace can be invisible outside the namespace
- Resource mapping with permission changes
- Provide processes with their own view of system 
- 
- What namespaces are available:
    1. Processes(pid)
    2. Filesystem(mounts)
    3. IPC (Inter-process communication)
    4. Hostname and domain name(uts)
    5. User and group IDs
    6. Network
    7. cgroup
 
 
**Network Namespace** 
- Frequently used in containers 
- **veth** (virtual Ethernet) devices can connect different namespaces. Docker uses separate network namespace per container and by default configures each container namespace, such as it has veth pair connected to Linux bridge to enable outbound connectivety. 
- **docker run** uses a separate network namespace per container
- Multiple containers can share a network namespace
    - kubernetes pods
    - Amazon ECS tasks with the awsvpc networking mode
   
**Mount Namespace**  One of the halmark of Linux Container is that they have a separate view of their filesystem with thier own set of files from their container image.
- Used for giving containers their own filesystem
- Container image is mounted as the root filesystem 
- **Volumes** to share data between containers or the host

```
mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=8121108k,nr_inodes=2030277,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,seclabel,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,blkio)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,memory)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,perf_event)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,hugetlb)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuacct,cpu)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,freezer)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,net_prio,net_cls)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,devices)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuset)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,pids)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/mapper/vg_root-lv_root on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=34,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=12868)
```

**procfs virtual filesystem** Is the machenism that the linux kernal exposes for introinspection of its data
- This file system includes lots of information about each process that is running 
- One of the piece of information that is available is the namespace to which process belong
- Inside the process directory is the directory call **ns** . This directory contains symbolic links to the namespace, however they are not quite regular symbolic link 
- The link contains the namespace type and inode number to identify the namespace 
```
readlink /proc/$$/ns/*
ipc:[4026531839]
mnt:[4026531840]
net:[4026531956]
pid:[4026531836]
user:[4026531837]
uts:[4026531838]
```

**Creating namespaces**
- clone(2) and unshare(2) - these are sys call
    - clone(2) is for new processes to create new namespaces 
    - unshare(2) is for existing processes to create new namespaces
- CLONE_NEW* flags to specify which namespaces 

**Namespace cannot be empty**
- The kernel automatically garbage-collects namespaces be referenc-counting 
- New namespace remains open by two means 
    - a process is open
    - a mount is open
- Bind-mount a file in /proc/$$/ns to another place on the filesystem 

```
mount \
--bind /proc/$$/ns/net \
/var/run/netns/lfnw
```
**Entering Namespace**
- Open a file from /proc/$$/ns (or a bing-mount)
- Pass to **setns(2)** to enter the existing namespace
- Namespace remains open as long as the process is running, even if the original file goes away

- **nsenter(1)** is a command for doing this interactively
- **ip-netns(8)** works specifically for network namespaces

**Network namespace example**
```
ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:50:56:bc:bd:ed brd ff:ff:ff:ff:ff:ff
```
- LO interface is used for localhost
**Create new network namespace**
```
 sudo unshare --net ip link
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```
- We can different output compare to previous one, instead of two interface, we only see one that lo, and actually is different lo since this is inside the new network namespace
- Namespace goes away if nothing holds them open 
- Since this command just ran ip program, it exited and namespace is gone

**Open shell with new namespace**
```
sudo unshare --net bash 
[root@vm0pncorexa0001 proc]# ip link
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```
- Run same **ip link** comand and get same output. It is same interface we saw it before

**How to make namespace persistent** 
- Long running process
- Create symlink file in /proc file system. Namespace persist by creating bind-mount
```
sudo unshare --net bash 
readlink /proc/$$/ns/*
touch /var/run/netns/lfnw
mount --bind /proc/$$/ns/net /var/run/netns/lfnw
ip netns list
ip netns identify $$
exit
```
- Now you can access lfnw namespace since there is active mount bind
```
ip netns list
sudo ip netns exec lfnw ip link
```




## **Cgroups** (Control Groups) 
- Is a Linux system used for tracking, grouping and organizing the processes that run. Every Processes is tracked with cgroup regardless of whether it is container or none
- Cgroups are typically used to associate processes with resources. 
- Provides metering and limiting, Access control
- All the processes are controlled by cgroups

**In Short** Cgroup is limit how much you can use and Namespace is limit what you can see and therefor use it

**What can you user cgroups for?**
- cgroups can be used independently of containers 
- cgroups control resource limits for processes
- Monitor processes and organize them
- Be careful not to break any assumptions your container runtime or orchestrator might have it
    - example Amazon ECS uses cgroup hierarchy to know where to read CPU and memory utilization information and cutilizer does the same

**Subsystem** 
- Control groups system is an abstract framework
- Way you interact with cgroups is through subsystem
- Subsystem is a concrete implementations
- Different subsystems can organize processes separately 
- Most subsystem are resource controlled
- Example of subsystems: 
    - Memory
    - CPU time
    - Block I/O
    - Number of Discrete processes(Pids)
    - CPU and Memory pinning
    - Freezer (Used by docker pause)
    - Devices
    - Network priority

**Hierarchical Representation**
- Independent subsystem hierarchies
- Every PID is represented exactly once in each subsystem
- New processes inherit cgroups from their parents
- 
**cgroup virtaul filesystem
- Typically mounted at /sys/fs/cgroup
- **Task** virtaul file holds all pids in the cgroup
- other files have settings and utilization data

**subsystem Example**
```
ls /sys/fs/cgroup
blkio    cpu,cpuacct  freezer  net_cls           perf_event
cpu      cpuset       hugetlb  net_cls,net_prio  pids
cpuacct  devices      memory   net_prio          systemd
```
```
ls /sys/fs/cgroup/devices/
cgroup.clone_children  cgroup.sane_behavior  devices.list       tasks
cgroup.event_control   devices.allow         notify_on_release
cgroup.procs           devices.deny          release_agent
```
```
tree /sys/fs/cgroup/
/sys/fs/cgroup/
├── blkio (block io controller)
.....
└── systemd
    ├── cgroup.clone_children
    ├── cgroup.event_control
    ├── cgroup.procs
    ├── cgroup.sane_behavior
    ├── notify_on_release
    ├── release_agent
    ├── system.slice
    │   ├── appd_machine_agent.service
    │   │   ├── cgroup.clone_children
    │   │   ├── cgroup.event_control
    │   │   ├── cgroup.procs
    │   │   ├── notify_on_release
    │   │   └── tasks
    │   ├── appd_netviz_agent.service
    │   │   ├── cgroup.clone_children
    │   │   ├── cgroup.event_control
    │   │   ├── cgroup.procs
    │   │   ├── notify_on_release
    │   │   └── tasks
```
- These bunch of files are interfaces into the kernal data stracture for cgroups
- To find find which cgroup an arbitary process ID assigned to, you can find from /proc file 
- proc file system that contains directory that corresponds to each Process ID
```
ls /proc
1      1639   27541  330   364   545   816  875   9467         loadavg
10     16796  2798   331   365   546   817  876   954          locks
1000   16800  28     332   366   5682  818  877   956          mdstat
1030   16801  28546  333   367   6     819  880   975          meminfo
10415  16802  2870   334   368   60    820  881   980          misc
10474  16935  29     335   369   61    821  882   982          modules
1056   16937  30     336   37    62    822  883   988          mounts
1077   16938  301    3364  370   628   823  884   989          mtrr
1091   16939  3027   337   371   64    824  885   991          net
10962  17     303    338   372   659   825  886   992          pagetypeinfo
1097   1702   304    339   373   661   826  888   acpi         partitions
11     1705   305    34    374   662   827  889   buddyinfo    sched_debug
118    1717   306    340   38    67    828  890   bus          schedstat
1185   17365  307    341   39    673   829  891   cgroups      scsi
12     17792  309    342   4     7     830  892   cmdline      self
1278   18     31     343   407   7696  831  893   consoles     slabinfo
12996  18766  311    344   409   772   832  894   cpuinfo      softirqs
13     19     312    345   4323  773   833  895   crypto       stat
1324   1934   31330  346   469   774   834  897   devices      swaps
1390   1941   314    347   49    775   835  898   diskstats    sys
1393   2      315    348   50    776   836  899   dma          sysrq-trigger
1396   20390  316    349   51    777   837  9     driver       sysvipc
14     21     317    35    510   7777  841  900   execdomains  timer_list
1400   2170   318    350   511   778   842  901   fb           timer_stats
1402   22     319    351   52    779   843  902   filesystems  tty
1404   2225   32     352   522   782   845  903   fs           uptime
1405   23     320    353   523   783   846  904   interrupts   version
1409   23386  321    355   535   784   847  907   iomem        vmallocinfo
1410   24     322    356   536   786   850  912   ioports      vmstat
1412   2422   323    357   537   7866  852  913   irq          zoneinfo
1422   2506   324    358   538   788   854  914   kallsyms
1427   2508   325    359   539   789   855  915   kcore
1474   2543   326    36    540   8     870  916   keys
1483   26     327    360   541   80    871  917   key-users
1531   26578  328    361   542   813   872  918   kmsg
16     26825  329    362   543   814   873  9188  kpagecount
16056  2730   33     363   544   815   874  919   kpageflags

```
- find shell process which is regular process 
echo $$
16939

- Lets looks the cgroup of current shell process ID
```
cat /proc/16939/cgroup
11:memory:/
10:devices:/
9:pids:/
8:cpuset:/
7:cpuacct,cpu:/
6:blkio:/
5:net_prio,net_cls:/
4:hugetlb:/
3:perf_event:/
2:freezer:/
1:name=systemd:/user.slice/user-32394.slice/session-c6254.scope
```
single / slash indicates most of the cgroups are in root directory

**Process Limit** can be control by updating file pids.max, it can only run mentioned number of process under this subsystem. By defaultm there is no limit.

**Docker** uses its own cgroup cal docker
- ls /sys/fs/cgroup/cpu/docker 


## UNION FileSytem


## Install docker on debian box 
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-debian-10

## Install docker on Linux: 
https://computingforgeeks.com/install-docker-ce-on-rhel-7-linux/

**Clean up before docker installation*
```
yum list installed|grep -i docker
#Example remove all the docker repo as show below
yum remove docker-client.x86_64 docker-common.x86_64 docker-rhel-push-plugin.x86_64 
```
**Install docker**

```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker.service
sudo systemctl start docker.service
sudo systemctl start docker.service
docker version
docker run hello-world
```

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
    `docker run -p <host_port>:<container_port> -d <image_id>` # run container in backgroud and bind to port
    
    `docker run -p 80:5000 <container_name>`\
      - Container runs on docker host and every container is assigned with private IP which is not exposed to outside.\
      - Mapped docker host port to container port and use docker host IP to access the App.
      - Host port is the port which docker container process is running on docker host
      - Container port is the port which is exposed in docker file. It is within container. 
      - Host post and container ports need to bind to access the application outside of docker host. 
      ```
      docker port my_container
      5000/tcp -> 0.0.0.0:80 ## 5000/tcp is the container port and 0.0.0.0:80 is the docker host port
      
      # This shows, docker can supports same(80) port for multiple container, not with docker host, it needs to be unique. 
      docker ps --format "table {{.Image}}\t{{.Ports}}" 
      nginx                 80/tcp # container port is not bind with docker host port, not accessible from docker host
      rancher/hello-world   0.0.0.0:700->80/tcp, :::700->80/tcp
      rancher/hello-world   0.0.0.0:800->80/tcp, :::800->80/tcp
      rancher/hello-world   0.0.0.0:80->80/tcp, :::80->80/tcp
      rancher/hello-world   0.0.0.0:500->88/tcp, :::500->88/tcp, 0.0.0.0:600->99/tcp, :::600->99/tcp # Even during run time, docker did not support same docker host port
      rancher/hello-world   0.0.0.0:200->80/tcp, 0.0.0.0:300->80/tcp, 0.0.0.0:400->80/tcp, :::200->80/tcp, :::300->80/tcp, :::400->80/tcp 
      ```
      |Container|Docker host port|Container Port|validate|
      |---|---|---|---|
      |single|one(same)|Multi(unque)|Yes, need to expose multi container ports in docker file|
      |multi|multi(unque)|one(same)|yes|
      |multi|one(same)|multi(unque)|no|
      
      - Docker host can have duplicate ports? , 80:8080(container1), 80:8080(container2), container1 and 2 are different web service
        - No, you will get below error if you try to bind second container with same docker host port.
        - Also, from outside world, container can be reached only on port 80,443 , thats why we use reverse_proxy(nginx) to support multiple services on single docker host
         ```
         Bind for 0.0.0.0:80 failed: port is already allocated.
        ```
        - 0.0.0.0 on the server means, request is reacable by any local IP addresses to the container. 
        - 
      - Port syntax 
      ```
      -P
      format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort
      When specifying ranges for both, the number of container ports in the range must match the number of host ports in the range. (e.g., `-p 1234-1236:1234-1236/tcp`)
      ```
      
     - EXPOSE in docker file 
         - EXPOSE line in docker file opens the port for the container but it is not exposed to anyone, not even to docker host. 
         - You can open multiple container ports using EXPOSE line 
         - To access from docker host/outside world, need to map the container port with docker host port, example
         - `docker run -p <host_port>:<container_port> -d <image_id>`
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
    `docker logs <container_id>`
    `docker logs --follow <container_id>` # live log
    
    - Volume, sometime, /var disk runs out. Need to perform disk cleanup to remove unused volume\
    `docker volume prune`

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

**Note** Before pushing the image, make sure to login to docker hub\
`docker logout`\
`docker login`

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
