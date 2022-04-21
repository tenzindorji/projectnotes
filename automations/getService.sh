#! /bin/bash

home=~
SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q tdorji@"

sed 's/\r//' ${1} > /tmp/serverlist

cat /dev/null > $home/servicesrunning
cat /dev/null > /tmp/services
#cat cat $home/serverlist
for server in `cat /tmp/serverlist`;do
  cat /dev/null > /tmp/processes
  ${SSH_OPTION}${server} << END
      cat /dev/null > /tmp/processes
      sudo cat /etc/puppetlabs/facter/facts.d/customfacts.txt >> /tmp/processes
      ps -ef >> /tmp/processes
      echo -en "hostname:" >> /tmp/processes; hostname >> /tmp/processes
      echo -en "apacheservices:" >> /tmp/processes; if [[ -d /data/apps/www ]]; then ls -1 /data/apps/www|grep -v ".gz"|grep -v "backup"|paste -d"," -s - >> /tmp/processes;fi
END
  if [[ $? -ne 0 ]];then
    echo $server: Access issue or something >> $home/servicesrunning;
  else
    ${SSH_OPTION}${server} cat /tmp/processes > /tmp/processes
    role=`grep -E "role=" /tmp/processes|grep -o '^[^#]*'|awk -F"::" '{print $2}'`
    application_component=`grep -E "application_component=" /tmp/processes|grep -o '^[^#]*'|awk -F"=" '{print $2}'`
    application=`grep -E "application=" /tmp/processes|grep -o '^[^#]*'|awk -F"=" '{print $2}'`
    if [[ $role == *"apache"* ]] || [[ $role == *"aem"* ]];then
      echo -en $server: >> $home/servicesrunning ;
      echo  "`grep "hostname:" /tmp/processes|awk -F":" '{print $2}'`:" >> $home/servicesrunning;
      grep "apacheservices:" /tmp/processes|awk -F":" '{print $2}' > /tmp/apacheservices
      sed -i 's/,/\n/g' /tmp/apacheservices
      cat /tmp/processes|awk -F"-jar" '{print $2}'|grep -v appdynamics|grep -v shinyproxy|awk -F" " '{print $1}'|awk -F "/" '{print $NF}'|uniq -u|sort|sed 's/\ //' >> /tmp/apacheservices
      echo "${role}_${application_component}:" >> $home/servicesrunning
      echo "`cat /tmp/apacheservices|sort|uniq`" >> $home/servicesrunning
    elif [[ $role == 'haproxy' ]];then
      echo -en $server: >> $home/servicesrunning;
      echo "`grep "hostname:" /tmp/processes|awk -F":" '{print $2}'`:" >> $home/servicesrunning;
      echo `grep "application=" /tmp/processes|awk -F"=" '{print $2}'`_haproxy >> $home/servicesrunning
    #elif [[ $role == '[aem]*' ]];then
    #  echo -en $server: >> $home/servicesrunning;
    #  echo "`grep "hostname:" /tmp/processes|awk -F":" '{print $2}'`:" >> $home/servicesrunning;
    #  echo "${role}_${application_component}" >> $home/servicesrunning
    #elif [[ $role == 'atg' ]];then
    #  echo -en $server: >> $home/servicesrunning;
    #  echo -en "`grep "hostname:" /tmp/processes|awk -F":" '{print $2}'`:" >> $home/servicesrunning;
    #  service=`grep -E "role=" /tmp/processes|awk -F"::" '{print $3}'`
    #  echo "${role}_${service}_${application_component}" >> $home/servicesrunning
    else
      cat /tmp/processes|awk -F"-jar" '{print $2}'|grep -v appdynamics|grep -v shinyproxy|awk -F".jar" '{print $1}'|awk -F "/" '{print $NF}'|uniq -u|sort|sed 's/\ //' > /tmp/services
      cat /tmp/processes|awk -F"-jar" '{print $2}'|grep -v appdynamics|grep -v shinyproxy|awk -F".war" '{print $1}'|awk -F " " '{print $1}'|awk -F "/" '{print $NF}'|awk -F".jar" '{print $1}'|uniq -u|sort|sed 's/\ //' >> /tmp/services
      sed -i '/^$/d' /tmp/services
      grep -E "/etc/elasticsearch" /tmp/processes
      if [[ $? == 0 ]]; then
            echo elasticsearch >> /tmp/services
      fi
      grep -E "/data/apps/kafka/bin/"  /tmp/processes
      if [[ $? == 0 ]]; then
            echo kafka_zookeeper >> /tmp/services
      fi
      grep -E "/usr/bin/mongod"  /tmp/processes
      if [[ $? == 0 ]]; then
            echo mongod >> /tmp/services
      fi

      grep -E "/var/opt/jfrog/artifactory"  /tmp/processes
      if [[ $? == 0 ]]; then
            echo artifactory >> /tmp/services
      fi

      echo -en $server: >> $home/servicesrunning;
      echo "`grep "hostname:" /tmp/processes|awk -F":" '{print $2}'`:" >> $home/servicesrunning;
      echo "${role}_${application}_${application_component}:" >> $home/servicesrunning;
      echo "`cat /tmp/services|grep -v '\-\-'|sort|uniq`" >> $home/servicesrunning
   fi
 fi
done
