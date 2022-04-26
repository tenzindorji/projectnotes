## Jenkins Job App restart using service account

This project is parameterized
  - Choice Parameter
    - Name: ACTION
    - Choices:\
        status\
        stop\
        start\
        restart
    - Description:
        <p>Choose the action carefully</p>
        <p>Core UAT java service restart,stop,start,status</p>

  - Password Parameter
    - Name: SVC_PASSWORD
    - Default Value: Concealed

Execute Shell

```
#!/bin/bash -x
set +ex

SERVERS=("server1.example.ecomorder" "server2.example.com")

if [ ${action} == "restart" ];
then
	for SERVER in "${SERVERS[@]}"
	do

	SSH_OPTION="ssh -q svc-myservice-account@${SERVER} -o StrictHostKeyChecking=no"

	$SSH_OPTION << END_CONNECTION
        echo "stopping core service on the ${SERVER} ..."
    	echo '$SVC_PASSWORD' | dzdo -S systemctl stop corerec.service
        pid=/data/apps/css-core/corerec/bin/app-status.sh|grep Service|awk -F":" '{print $2}'
        [ -z "$pid" ] && echo "core service is stopped"
        echo "starting core service on the ${SERVER} ..."
        dzdo systemctl start corerec.service
        /data/apps/css-core/corerec/bin/app-status.sh

END_CONNECTION
	done
else
	for SERVER in "${SERVERS[@]}"
	do
    SSH_OPTION="ssh -q svc-myservice-account@${SERVER} -o StrictHostKeyChecking=no"
	$SSH_OPTION << END_CONNECTION

    	if [ ${action} == "start" ] || [ ${action} == "stop" ];
        then
        	echo "${action}ing core service on the ${SERVER} ..."
        	echo '$SVC_PASSWORD' | dzdo -S systemctl ${action} corerec.service
            /data/apps/css-core/corerec/bin/app-status.sh
        else
        	echo "core service ${action} on the ${SERVER} ..."
        	/data/apps/css-core/corerec/bin/app-status.sh
        fi

END_CONNECTION
	done

fi
```
