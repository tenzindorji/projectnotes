# HA Proxy setup - High availability
  - It is very popular open source software for TCP/HTTP LB and provide proxy solution
  - HAproxy is used to improve performance and reliability of servers by distributing the work between multiple servers
  - Other similar software are : nginx, squid and Varnish


## Transport layer LB:
- this is called 4 layer LB.
- Used to load balance network traffic bw mutiple servers.
- Based on IP range and Port number.
## Application layer LB:
- This is call layer 7 LB
- Used to load balance network traffic bw mutiple servers.
- based on contents of user request

## HAproxy terminology
1. ACl - Access Control list
- used to verify condition and perform action.
2. Backend
- This is set of servers which receives forwarded requests from frontend.
- two parameters contained by backend
  a. list of servers and port
  b. LB algorithm to use
  Example:
  ```
  backend appserver
    balance roundrobin
    server app1 app1.xxx.com:80 check
    server app2 app2.xxx.com:80 check
  ```
3. Frontend
- This define how request should be forward to backend.
- Contains
  a. Set of IP address and port
  b. ACL's
  c. backend rule which already defined in backend

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
