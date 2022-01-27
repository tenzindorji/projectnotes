
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

## create jenkins pipeline

## dockerize the setup
