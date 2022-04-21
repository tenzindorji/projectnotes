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
    echo -en "$server," >> $home/tmp/appd_upgrade_validation.log
    $SSH_OPTION$server  find /data/apps/appdynamics -maxdepth 1  -type l -ls|grep -v "networkVisibility" 1> $home/tmp/temp_appd_upgrade_validation.log 2>> $home/tmp/temp_appd_upgrade_validation.log;
    echo -en `grep -ir "machineAgent-*" $home/tmp/temp_appd_upgrade_validation.log|awk -F"/" '{print $9}'` >> $home/tmp/appd_upgrade_validation.log;
    echo -en "," >> $home/tmp/appd_upgrade_validation.log;
    echo -en `grep -ir "appServerAgent-*" $home/tmp/temp_appd_upgrade_validation.log|awk -F"/" '{print $9}'`  >> $home/tmp/appd_upgrade_validation.log;
    echo -en "," >> $home/tmp/appd_upgrade_validation.log;
    #echo -en `grep -ir "webServerAgent-*" $home/tmp/temp_appd_upgrade_validation.log|awk -F"/" '{print $9}'`  >> $home/tmp/appd_upgrade_validation.log;

    #$SSH_OPTION$server ps -ef|grep java|grep appdynamics|grep -v machineAgent|grep -v appServerAgent|awk '{print $8}'|awk -F "/" '{print $5}' 1> $home/tmp/java_appd_upgrade_validation.log 2>> $home/tmp/java_appd_upgrade_validation.log;
    #echo `cat $home/tmp/java_appd_upgrade_validation.log` >> $home/tmp/appd_upgrade_validation.log;

    $SSH_OPTION$server cat /data/apps/appdynamics/webServerAgent/appdynamics-sdk-native/VERSION.txt 1> $home/tmp/java_appd_upgrade_validation.log 2>> $home/tmp/java_appd_upgrade_validation.log;
    echo -en `cat $home/tmp/java_appd_upgrade_validation.log` >> $home/tmp/appd_upgrade_validation.log;

  #  $SSH_OPTION$server ps -ef|grep java 1> $home/tmp/java_appd_upgrade_validation.log 2>> $home/tmp/java_appd_upgrade_validation.log;
  #  echo -en "," >> $home/tmp/appd_upgrade_validation.log;
  #  echo -en `grep -ir "webServerAgent-20" $home/tmp/java_appd_upgrade_validation.log | sed 's/.*\(-Dlog4j2.formatMsgNoLookups=true\).*/\1/'` >> $home/tmp/appd_upgrade_validation.log;
  #  echo -en "," >> $home/tmp/appd_upgrade_validation.log;
  #  echo -en `grep -ir "webServerAgent-20" $home/tmp/java_appd_upgrade_validation.log | sed 's/.*\(-Dappdynamics.log4j2.formatMsgNoLookups=true\).*/\1/'` >> $home/tmp/appd_upgrade_validation.log;
    echo -en "," >> $home/tmp/appd_upgrade_validation.log;
    $SSH_OPTION$server grep -ir "environment" /etc/puppetlabs/puppet/puppet.conf |grep -v "#"|awk -F"=" '{print $NF}' 1>> $home/tmp/appd_upgrade_validation.log 2>> $home/tmp/appd_upgrade_validation.log
done

ls -1 $home/tmp/appd_upgrade_validation.log
