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
cat /dev/null > $home/tmp/appd_upgrade_validation.log
cat /dev/null > $home/tmp/temp_appd_upgrade_validation.log
sed -i 's/\r//g' ${2}

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    #$echo "-----------------" >> $home/tmp/appd_upgrade_validation.log
    echo -en "$server:" >> $home/tmp/appd_upgrade_validation.log

    $SSH_OPTION$server << END
      cat /dev/null > /tmp/appd_upgrade_validation.log;
      cat /dev/null > /tmp/test_validation.log;
      find /data/apps/appdynamics -maxdepth 1  -type l -ls|grep -v "networkVisibility" >> /tmp/test_validation.log;
      echo -en `grep "machineAgent-*" /tmp/test_validation.log | awk -F"/" '{print $9}'` >> /tmp/appd_upgrade_validation.log;
      echo -en "," >> /tmp/appd_upgrade_validation.log;
      echo -en `grep "appServerAgent-*" /tmp/test_validation.log | awk -F"/" '{print $9}'`  >> /tmp/appd_upgrade_validation.log;
      echo -en "," >> /tmp/appd_upgrade_validation.log;
      echo -en `grep "webServerAgent-*" /tmp/test_validation.log | awk -F"/" '{print $9}'` >> /tmp/appd_upgrade_validation.log;

# this script is not working!!!!!!!!!

      #echo -en `ps -ef|grep java|grep webServerAgent-20|sed 's/.*\(-Dlog4j2.formatMsgNoLookups=true\).*/\1/'` >> /tmp/appd_upgrade_validation.log;
      #echo -en "," >> /tmp/appd_upgrade_validation.log;

      #echo -en `ps -ef|grep java|grep webServerAgent-20|sed 's/.*\(-Dappdynamics.log4j2.formatMsgNoLookups=true\).*/\1/'` >> /tmp/appd_upgrade_validation.log;
      #echo -en "," >> /tmp/appd_upgrade_validation.log;

      grep  "environment" /etc/puppetlabs/puppet/puppet.conf |grep -v "#"|awk -F"=" '{print $NF}' >> /tmp/appd_upgrade_validation.log;
END
$SSH_OPTION$server cat /tmp/appd_upgrade_validation.log >> $home/tmp/appd_upgrade_validation.log
done

ls -1 $home/tmp/appd_upgrade_validation.log
