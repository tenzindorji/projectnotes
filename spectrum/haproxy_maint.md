## Haproxy Maint Jenkins Job


This project is parameterized
  - > Choice Parameter
    - Name: ACTION
    - Choices:
        enable
        disable
  - > Choice Parameter
    - Name: DC
    - Choices:
        nce
        ncw

Execute Shell

```
#!/bin/bash -x


BACKEND="my-app-backend"
HAPROXY_SERVERS=("haproxy1.example.com"
    			       "haproxy2.example.com"
                 "haproxy3.example.com"
    			       "haproxy4.example.com")                


if [[ ${DC} == "nce" ]]
then                    
	SERVERS=("server1-nce.example.com"
    	     "server2-nce.example.com")
elif [[ ${DC} == "ncw" ]]
then                    
	SERVERS=("server1-ncw.example.com"
    	     "server2-ncw.example.com")

fi

for HAPROXY_SERVER in ${HAPROXY_SERVERS[@]}
do

  SSH_OPTION="ssh jenkins_worker@${HAPROXY_SERVER} -o StrictHostKeyChecking=no"

  for SERVER in ${SERVERS[@]}

  do

  	$SSH_OPTION "hostname && echo $ACTION $SERVER in backend $BACKEND && echo $ACTION server $BACKEND/$SERVER | sudo socat stdio /var/lib/haproxy/stats"

  done
done
```
