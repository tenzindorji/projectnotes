## Jenkins Job Elasticsearch restart

This project is parameterized
  -  Choice Parameter
    - Name: ACTION
    - Choices:\
        status
        stop
        start
        restart
    - Description:
        <br>status,
        <br>stop,
        <br>start,
        <br>restart

  -  Choice Parameter
    - Name: Node
    - Choices:\
        server1.example.com
        server2.example.com

Execute Shell
```
#!/bin/bash -x

SERVER=${Node}


if [ ${action} == "restart" ];
then
	SSH_OPTION="ssh -q jenkins_worker@${SERVER} -o StrictHostKeyChecking=no"

	$SSH_OPTION << END_CONNECTION

    	sudo su
        systemctl status elasticsearch.service
        systemctl stop elasticsearch.service
        systemctl start elasticsearch.service
        systemctl status elasticsearch.service
        tail -10 /data/apps/css-core/elasticsearch/logs/core.log

END_CONNECTION

else
	SSH_OPTION="ssh -q jenkins_worker@${SERVER} -o StrictHostKeyChecking=no"

	$SSH_OPTION << END_CONNECTION

        if [ ${action} == "status" ];
        then
            echo ""
            echo "----------------------------------"
        	echo "Elasticsearch cluster node status:"
            echo "----------------------------------"
            curl -XGET https://${SERVER}:7117/_cat/nodes?v -u elastic:recommEng -k
            echo ""
            echo "----------------------------------"
            echo "Elasticsearch cluster status:"
            echo "----------------------------------"
        	curl -XGET https://${SERVER}:7117/_cluster/health?pretty -u elastic:recommEng -k
            echo ""
            echo "----------------------------------"
            echo "Last 10 lines of elasticsearch log:"
            echo "----------------------------------"
            tail -10 /data/apps/css-core/elasticsearch/logs/core.log
        	sudo su
            echo ""
            echo "----------------------------------"
            echo "Elasticsearch service status:"
            echo "----------------------------------"
        	systemctl ${action} elasticsearch.service
        else
            sudo su
        	systemctl ${action} elasticsearch.service
            tail -10 /data/apps/css-core/elasticsearch/logs/core.log
        fi

END_CONNECTION

fi

```
