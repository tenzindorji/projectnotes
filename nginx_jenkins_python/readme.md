
## Problem
This repository contains a small Python web application that shows the uptime of the current system.
 -Login using the provided IP address, user and password in the instruction email
 -Bring up Jenkins on the instance
 -Deploy the provided web application to the instance
 -Use nginx (or the tool of your choice) so that we can reach Jenkins from the web with the IP address and the path "/jenkins" and the web app at "/uptime"
 -Make sure that these come up automatically on startup!
 -Bonus: Create a Jenkins pipeline to run the unit test on git push to the repository (note: you will need to host this repository yourself)
 -Bonus: Dockerize the web app, what problem do you run into?

## setup nginx

## setup jenkins

Debian OS: 
open file /etc/default/jenkins



## configure jenkins behind nginx
```
upstream uptime {
        server localhost:4567;
}

server {
        listen 80 default_server;
        server_name 3.138.203.88;
        #error_log /var/log/nginx/update.error.log;
        #root /var/www/uptime;
        #index index.html;
#       location /uptime/ {
#               #include /etc/nginx/proxy_params;
#               proxy_pass http://uptime;
#       }
#}
  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location /uptime/ {
      proxy_pass         http://uptime;
      rewrite ^/uptime(.*) /$1 break;
      #proxy_redirect     default;
      proxy_http_version 1.1;

      proxy_set_header   Connection "";

      proxy_set_header   Host              $host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;


      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_buffering            off;
      proxy_request_buffering    off; # Required for HTTP CLI commands
  }

}
```

```
upstream jenkins {
  keepalive 32; # keepalive connections
  server localhost:8081; # jenkins ip and port
}


server {
  listen          80;       # Listen on port 80 for IPv4 requests

  server_name     3.138.203.88;  # replace 'jenkins.example.com' with your server domain name


  access_log      /var/log/nginx/jenkins.access.log;
  error_log       /var/log/nginx/jenkins.error.log;

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;


  location / {
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

## configure python app behind nginx

## create jenkins pipeline

## dockerize the setup
