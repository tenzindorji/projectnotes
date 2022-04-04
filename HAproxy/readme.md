# HA Proxy setup - High availability
  - It is very popular open source software for TCP/HTTP LB and provide proxy solution
  - HAproxy is used to improve performance and reliability of servers by distributing the work between multiple servers
  - Other similar software are : nginx, squid and Varnish


## What is proxy
  - hides the identity of client, meaning server will not know who the client is. Server only gives response to proxy server, and then proxy server to client
  - Clients --> Proxy Servers --> Servers
  - Servers have no idea who is client

  **Benifits**
    - anonymity
    - caching - Static sites
    - blocking unwanted sites
    - GeoFencing

## what is reverse Proxy:
  - Servers --> Proxy --> Clients
  - Clients have no idea which servers it is connected

  **Benifits**
    - LB
    - Caching
    - Isolating Internal Traffic
    - Logging
    - Canary Deployment

## layer 4 LB (Haproxy, NLB - Network Loadbalancer ) , we only know the port and IP
- Forwards packets based on basic rules, it only knows IP and PORT and perhaps latency of the target service. This is what is available at layer 4/3. This load balancer doesn't look at the content so it doesn't know the the protocol whether its HTTP or not, it doesn't know the URL or the path or the resources you are consuming or whether you are using GET or POST.

-

  - Pros:
    1. Great for simple packet-level LB
    2. Fast and efficient doesn't look at the data
    3. More secure as it can't really look at your packets. so if it was compromised no one can look at the data.
    4. Doesn't need to decrypt the content it merely forwards whatever content in it.
    5. uses NAT -
    6. One connection between client and server NATed so your LB can serve a maximum number of tcp connections = to (number of servers * max connections per server)

  - Cons:
    1. Can't do smart LB based on the content, such as switch request based on the requested media type.
    2. Can't do real microservices with this type
    3. Has to be sticky as it is stateful protocol (all segments ) once a connections is established it goes to one server at the backend. All packets flowing to this connection goes to one server. The next connection will pick another server based on the algorithm(Roundrobind, leaseconnection).

   ```
   defaults
   errorfile  200 /etc/haproxy/errorfiles/gslb_health
   log  global
   maxconn  6000
   mode  tcp # this is layer 4 LB setting in haproxy

   ```
## Layer 7 LB (Ngix and Haproxy) -
- This type of proxy actually looks at the content and have more context, it knows you are visiting the /users resource so it may forward it to a different server. Essential and great for microservices, it knows the content is video:image and it con do compression. It can add its own headers so other proxies or LB can see that this has passed through a proxy. It can also cache, we can't really do caching on layer 4 because we have no clue whats in the packet.

  - Pros
    1. Smart routing based on the URL(microservices) flexible
    2. Provide caching
  - Cons
    1. Expensive need to decrypt
    2. Security, you have to share your certificate with the LoadBalancers. If an attacker compromised the LB they have access to all your data.
    3. Proxy creates multiple connections (client to proxy/proxy to server). So your are bounded by the max TCP connections on your LB. Example, if your LB supports 200 mx TCP connections and you have 5 backend servers, the LB servers each with 200 mac connection. Your LB can only serve (concurrently)(200 - 5) clients. 5 connections are from the LB to each backend server and 195 available for clients. Where if that was layer 4 LB, you can serve 200 * 5 connections.


    ```
    defaults
    errorfile  200 /etc/haproxy/errorfiles/gslb_health
    log  global
    maxconn  6000
    mode http # this is layer 7 LB setting in haproxy


With all those cons we almost have to use Layer 7 load balancer because the benefits outway the cons, especially that we don't have resources constraints.


## headers
## cookies
## Content type

## ELB VS ALB VS NLB



## Iptables
  - Kernel native LBing netfilter packet level
  - No software
  - Layer4 LB
  - order matters a lot

    ```
    sudo iptables --table nat --list
    Chain PREROUTING (policy ACCEPT)
    target     prot opt source               destination

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination

    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination

    Chain POSTROUTING (policy ACCEPT)
    target     prot opt source               destination

    ```



## Transport layer LB:
- this is called 4 layer LB.
- Used to load balance network traffic bw mutiple servers.
- Based on IP range and Port number.
## Application layer LB:
- This is call layer 7 LB
- Used to load balance network traffic bw mutiple servers.
- based on contents of user request

## HAproxy terminology
1. ACL - Access Control list
- used to verify condition and perform action.
2. Backend
- This is set of servers which receives forwarded requests from frontend.
- two parameters contained by backend
  a. list of servers and port
  b. LB algorithm to use, Balance(roundrobin, leastconnection, source)
    - default roundrobin if not specificied \
    - leastconnection - connect to the server which has least amount of TCP connection - used for long tcp connection \
    - source - sticky session - connect to particular backend always if the request is coming from particular IP \
  c. Timeout Connect (how long Haproxy wants to wait for connection until it gives up)
  d. Timeout server (how long haproxy wants to wait for response from backend)
  e.
  Example:
  ```
  backend appserver
    balance roundrobin
    server app1 app1.xxx.com:80 check
    server app2 app2.xxx.com:80 check
  ```
3. Frontend # anything infront of HAproxy server
- Port at which HAProxy listens to
-
- This define how request should be forward to backend.
- Contains
  a. timeout client (disconnect TCP connection if it is inactive for 1 min)
  b. bind (which port and which IP it is listening on front end)
  c. ACL's (Access Control list, conditional Example block somewebsites, or area)
  d. backend rule which already defined in backend
  e. Set of IP address and port

  example:
  ```
  frontend webapp
    bind *:80 #Transport layer
    default_backend appserver
  ```
  ```
  frontend webapp
    bind *:80 #Application layer
    acl url_blog path_beg/blog
    default_backend appserver
  ```

## Load balancing algorithm
1. roundrobin - one by one
2. Least connection - depend on load
  - select server with less number of connection
  - recommended for longer sessions
3. source - Depend on user/source IP
4. Sticky Session - Continues connection
  - to connect same server for session
5. Health Check - To check server availability

## install haproxy
`yum install haproxy`
`cd /etc/haproxy`
`vi haproxy.cfg`
  Add frontend and backend configuration and save the file
`server haproxy start`
Validate the LB using haproxy IP

# HA Proxy Architecture
1. Multiple frontends OR multiple backends
2. Frontend bind to one or more ports
3. A frontend connections to a backend

- Example: Two Frontends
  - Frontend-http -binds 80 (forwards to https backend)
  - Frontend-HTTPS -binds 443

# HAproxy mode (TCP and HTTP)
- By default, it uses TCP mode and this keep connection live till timeout(statefull)
- supports layer 4(TCP) and layer 7 (HTTP)
- TCP(layer 4) - can see IP and port but cannot see content of the traffic
- HTTP(layer 7) - look at the data /apps/content and forward to correct backend
                - Decrypt content using TLS offloading and look into it for LB purpose
                - SSL pass through
- HTTP mode is stateless (every request is a new request)
# ACL
1. Conditionals applies to route the traffic
2. Applies to both frontend and backend
3. Example: block any requests to /admin (needs http mode)
4. reroute traffic to different backend microservices


# TLS termination VS TLS pass through
1. TLS termination (trust haproxy)
  - Frontend is TLS (eg: HTTPS) backend is  (HTTP)
  - Haproxy terminates TLS and decrypts and send encrypted
  - can look at the data, L7 ACL, re-write headers, cache but requires cert
2. TLS pass through (do not trust haproxy)
  - Backend is TLS
  - HAproxy front-ends proxy the packets directly to the backend.
  - No caching, L4 ACL only, but more secure haproxy doesn't need cert.
P@ssw0rd1
# Example Haproxy config
```
frontend httpsandhttp
  bind *:80
  bind *:443 ssl crt /path/to/haproxy.pem alpn
h2, http/1.1
  timeout client 20s
  mode http
  acl app1 path_end -i /app1
  acl app2 path_end -i /app2
  http-request deny if {path -i -m beg /admin}
  use_backend app1Server if app1
  use_backed app2Server if app2

  default_backend allServers

backend app1Server
  timeout connect 20s
  timeout server 10s
  balance source
  mode http
  server server2222 172.0.0.1:2222
  server server3333 172.0.0.1:3333

backend app2Server
  timeout connect 20s
  timeout server 10s
  mode http
  server server4444 172.0.0.1:4444
  server server5555 172.0.0.1:5555

backend allServers
  timeout connect 20s
  timeout server 10s
  mode http
  server server2222 172.0.0.1:2222
  server server3333 172.0.0.1:3333
  server server4444 172.0.0.1:4444
  server server5555 172.0.0.1:5555
```

Start haproxy
`haproxy -t <config.cfg>`

alpn(application layer protocol negotiation)
h2 - http2

https://www.bing.com/videos/search?q=haproxy+tutorial&docid=608049472514492166&mid=0D0E4469A0AB6D5CC3100D0E4469A0AB6D5CC310&view=detail&FORM=VIRE
##
-


## HA setup using haproxy:
nbsrv -number of backend server

```
frontend www-ssl
  acl is_myapp                     hdr_beg(host)             myapp uat-myapp
  acl is_myapp_down                 nbsrv(www-myapp)     lt 1
  bind *:443 ssl npn http/1.0,http/1.1 no-sslv3 crt /etc/ssl/myapp.pem
  use_backend www-myapp                       if    is_myapp_ui # primary servers
  use_backend www-myapp-backup             if    is_myapp_down is_myapp

backend www-myapp
  balance leastconn
  cookie SOMUI insert indirect nocache
  log 127.0.0.1 local3 notice
  server sr1 server1:7210 check cookie primary
  server sr2 server2:7210 check cookie primary

backend www-myapp-backup
  balance leastconn
  cookie SOMUI insert indirect nocache
  log 127.0.0.1 local3 notice
  server sr3 server3:7210 check cookie backup
  server sr4 server4:7210 check cookie backup

```
