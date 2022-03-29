#! /bin/bash
set +ex

home=`pwd`
user=${1}

die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user server_list"
    exit 1
}

[ "$#" -eq 2 ] || die "2 argument required, $# provided"

cat /dev/null > $home/tmp/appAgent_start.log
cat /dev/null > $home/tmp/tempfile.log
cat /dev/null > $home/tmp/agent_processes.log

sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo -en "$server," >> $home/tmp/appAgent_start.log

    #$SSH_OPTION$server ps -ef|grep java|grep -v "/data/apps/kafka/"|grep -v "grep"|grep -v "machineagent.jar" > $home/tmp/agent_processes.log
    $SSH_OPTION$server sudo ps -ef > $home/tmp/tmp_agent_processes.log

    cat $home/tmp/tmp_agent_processes.log|grep httpd|head -1 > $home/tmp/agent_processes.log
    cat $home/tmp/tmp_agent_processes.log|grep java|grep -v "/data/apps/kafka/"|grep -v "grep"|grep -v "machineagent.jar"  >> $home/tmp/agent_processes.log

    afterdate="`date +%s --date="Dec22"`"
    cat /dev/null > $home/tmp/tmp.log
    cat $home/tmp/agent_processes.log | while read line
    do
      appAgentStart="`echo $line | awk '{print $5}'`"
      startdate="`date +%s --date="$appAgentStart"`"
      if [[ $startdate < $afterdate ]]; then
        echo $line| awk '{print $5}' >> $home/tmp/tempfile.log #process start date
        echo $line| awk -F "Dappdynamics.agent.nodeName=" '{print $2}'|awk '{print $1}' >> $home/tmp/tempfile.log # service name
        echo $line| awk -F "Dappdynamics.agent.nodeName=" '{print $2}'|awk '{print $1}' >> $home/tmp/tempfile.log
        echo $line| grep "aem_loc"|awk '{print $1}' >> $home/tmp/tempfile.log
        echo $line| grep -v "Dlog4j2.formatMsgNoLookups=true"|awk '{print $NF}' >> $home/tmp/tempfile.log

      fi
      #echo -en "," >> $home/tmp/tempfile.log
      #echo -en $line|grep -v "Dlog4j2.formatMsgNoLookups=true"|awk '{print $NF}' >> $home/tmp/tempfile.log
    done
    if [[ -s $home/tmp/tempfile.log ]];then
      cat $home/tmp/tempfile.log | xargs | sed -e 's/ /,/g' > $home/tmp/tmp.log
      echo -en `cat $home/tmp/tmp.log` >> $home/tmp/appAgent_start.log
      cat /dev/null >  $home/tmp/tempfile.log
    fi
    echo " " >> $home/tmp/appAgent_start.log
done
ls -1 $home/tmp/appAgent_start.log
