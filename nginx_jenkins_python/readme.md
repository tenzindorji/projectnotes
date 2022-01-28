
## Problem
This repository contains a small Python web application that shows the uptime of the current system.
 - Login using the provided IP address, user and password in the instruction email
 - Bring up Jenkins on the instance
 - Deploy the provided web application to the instance
 - Use nginx (or the tool of your choice) so that we can reach Jenkins from the web with the IP address and the path "/jenkins" and the web app at "/uptime"
 - Make sure that these come up automatically on startup!
 - Bonus: Create a Jenkins pipeline to run the unit test on git push to the repository (note: you will need to host this repository yourself)
 - Bonus: Dockerize the web app, what problem do you run into?

## setup nginx

## setup jenkins

Debian OS: 
open file /etc/default/jenkins

Add `--prefix=/jenkins` as shown below. This change will open jenkins as /jenkins context. Restart jenkins `systemctl restart jenkins`

`JENKINS_ARGS="--prefix=/jenkins --webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT"`

## configure jenkins and python app behind nginx
create a file name uptime under `/etc/nginx/conf.d/backends.conf` . You can create any name with extension .conf
```
upstream jenkins {
  keepalive 32; # keepalive connections
  server localhost:8081;
}

upstream uptime {
        server localhost:4567 fail_timeout=0;
}

server {
        listen 80 default_server;

  location /uptime/ {
      proxy_pass         http://uptime;
      proxy_redirect     off;
      proxy_http_version 1.1;
      proxy_set_header   Host              $http_host;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
  }

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location /jenkins/ {
      proxy_pass         http://jenkins;
      proxy_redirect     off;
      proxy_http_version 1.1;

      proxy_set_header   Connection "";

      proxy_set_header   Host              $host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_buffering            off;
      proxy_request_buffering    off; # Required for HTTP CLI commands
  }

}
```

Restart nginx `systemctl restart nginx`

Also, if there are multiples websites or applications, it will be easy to manage using separate vhost./
You can multiple vhost under `/etc/nginx/sites-available` folder and Create a symlink under `/etc/nginx/sites-enabled` 

example: 
 `uptime -> /etc/nginx/sites-available/uptime`\
 `jenkins -> /etc/nginx/sites-available/jenkins`
 
 Restart nginx `systemctl restart nginx`
 
## run python app in backgroup
`python3 /var/www/uptime/serve.py &> /var/log/nginx/websites.log &`

## create jenkins pipeline
serve.py script as unix test function 
`python3 serve.py test` #This will run unit test 

Declarative piple: 
```
// Declarative //
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Build completed'
            }
        }
        stage('Test') {
            steps {
                sh 'python3 /var/www/uptime/serve.py test'
                //echo 'Test completed'//
            }
        }
        stage('Deploy') {
            steps {
                echo 'deploy completed'
            }
        }
    }
    post { 
        always { 
            echo 'Yay!'
        }
    }
}
// Script //
```

## dockerize the setup 
- Create this dockerfile call Dockerfile
```
FROM debian

MAINTAINER Rubod


RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx python3-pip procps

#RUN pip install http


RUN rm -rf /etc/nginx/conf.d/*
RUN rm -rf /etc/nginx/sites-enabled/default


RUN mkdir -p /var/www/website/

COPY backends.conf /etc/nginx/conf.d/
COPY index.html /var/www/website/
COPY serve.py /var/www/website/
COPY start.sh /var/www/website/

RUN chmod +x /var/www/website/start.sh


EXPOSE 80

#RUN service nginx start
#CMD /usr/sbin/nginx && tail -f /dev/null
#WORKDIR /var/www/website
#CMD ["python3", "serve.py"]
#CMD ["nginx", "-g", "daemon off;"]
CMD sh /var/www/website/start.sh
```

- Create this start up script call start.sh 
```
#! /bin/bash

service nginx start
python3 /var/www/website/serve.py
```

- Files that are going to get copy to image should be kept under same local as Dockerfile 

├── Dockerfile
├── backends.conf
├── index.html
├── serve.py
└── start.sh

- Build Docker image
`docker build -t mywebsite .`
- Start the docker container 
`docker image` # list the image ID created above
`docker run -d <image_id> # run container in backgroud
`docker ps` # list running container 
`docker exect -it <container_id> bash` # ssh to running container
