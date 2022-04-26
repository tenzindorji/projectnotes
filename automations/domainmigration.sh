#! /bin/bash
set +e

die () {
    echo >&2 "$@"
    echo "
    Usage: The script is located under /tmp/
      sh $(readlink -e -- "$0") eid<adm>/vid<adm> # To perform cleanup and leave twcable domain
      sh $(readlink -e -- "$0") domain_update # update resolv.conf and hosts with tenzincom domain
      sh $(readlink -e -- "$0") nslookup # perform DNS replication validation
      sh $(readlink -e -- "$0") adjoin # adjoin and register server with Satellite
      sh $(readlink -e -- "$0") adgpupdate # To update certificate and restart centrify
        "

    exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"


DC=`adinfo|grep "Preferred site"|awk '{print $NF}'|awk -F"-" '{print $1}'`
OSVERSION=`grep REDHAT_SUPPORT_PRODUCT_VERSION /etc/os-release|awk -F"\"" '{print $2}'|awk -F"." '{print $1}'`
katelloversion=`rpm -qa | grep katello-ca-consumer|awk -F"." '{print $5}'|awk -F"-" '{print $2}'`

if [[ ${1} == *"adm" ]]; then

  #take backup
  yes|cp /etc/resolv.conf /tmp/
  yes|cp /etc/hosts /tmp/
  yes|cp /etc/centrifydc/centrifydc.conf /tmp/
  yes|cp /var/centrify/net/certs/IwaTrustRoot.cer /tmp/IwaTrustRoot.cer

  #clean up yum repo
  echo "subscription-manager unregister"
  subscription-manager unregister
  echo "------------------------------"
  echo "subscription-manager clean"
  subscription-manager clean
  echo "------------------------------"
  echo "subscription-manager remove --all"
  subscription-manager remove --all
  rm -rf /var/cache/yum/*
  echo "------------------------------"
  echo "yum clean all"
  yum clean all

  echo "------------------------------"
  # remove deprecated version of katello
  if [[ $katelloversion -lt 9 ]];then
    rpm -qa | grep katello-ca-consumer
    rpm -e `rpm -qa | grep katello-ca-consumer`
    echo "Removed katello-ca-consumer deprecated version"
  else
    echo "Has latest katello-ca-consumer version"
    rpm -qa | grep katello-ca-consumer
  fi

  echo "------------------------------"
  echo "adleave -u ${1} -r"
  adleave -u ${1} -r
  echo "------------------------------"
  echo "Proceed with DNS update"
  echo "Once DNS is updated, run below command to continue the migration"
  echo "$(readlink -e -- "$0") domain_update"
  echo ""


## Add myserverdomain.com in search string
elif [[ ${1} == "domain_update" ]];then
  echo "------------------------------"
  if [[ `grep 'search myserverdomain.com' /etc/resolv.conf` ]]; then
    echo "/etc/resolv.conf has myserverdomain.com, update not needed"
    grep "myserverdomain.com" /etc/resolv.conf
  else
    sed -i 's/myserverdomain.com//g' /etc/resolv.conf
    sed -i 's/search/search myserverdomain.com/g' /etc/resolv.conf
    sed -Ei 's/[[:space:]]+/ /g' /etc/resolv.conf
    echo "myserverdomain.com added in /etc/resolv.conf"
    grep "myserverdomain.com" /etc/resolv.conf
  fi

  echo "------------------------------"
  # Replace with myserverdomain.com if domain line exist
  if [[ `grep "^domain" /etc/resolv.conf` ]];then
    echo "Replaced domain olddomain.com with domain myserverdomain.com"
    sed -i 's/domain olddomain.com/domain myserverdomain.com/g' /etc/resolv.conf
    grep "^domain" /etc/resolv.conf
    echo "------------------------------"
  fi
  # Replace olddomain.com with myserverdomain.com in hosts file
  sed -i "s/`hostname`.olddomain.com/`hostname`.myserverdomain.com/g" /etc/hosts
  echo "replaced olddomain.com with .myserverdomain.com in /etc/hosts"
  grep "`hostname`.myserverdomain.com" /etc/hosts

  echo ""
  echo "Change recap"
  ls -ltr /etc/resolv.conf
  grep "myserverdomain.com" /etc/resolv.conf
  ls -ltr /etc/hosts
  grep "`hostname`.myserverdomain.com" /etc/hosts


echo "------------------------------"
echo "Validate DNS replication by running below command"
echo "$(readlink -e -- "$0") nslookup"
echo ""

elif [[ ${1} == "adjoin" ]];then
  adjoin -S myserverdomain.com
  #Update centrify config with home directory
  sed -i 's/nss.runtime.defaultvalue.var.home: \/home/nss.runtime.defaultvalue.var.home: \/export\/home/g' /etc/centrifydc/centrifydc.conf
  echo "/export/home path update in /etc/centrifydc/centrifydc.conf"
  grep -ir "^nss.runtime.defaultvalue.var.home" /etc/centrifydc/centrifydc.conf
  echo "------------------------------"

  service rhsmcertd restart

  katellostatus=`rpm -qa | grep katello-ca-consumer`

  #Install latest version of katello depending on DC
  if [[ $DC == CDC ]] && [[ -z ${katellostatus} ]];then
  #if [[ $DC == CDC ]];then
    echo "Installing latest katello in NCE"
    rpm -Uvh http://server1.myserverdomain.com/pub/katello-ca-consumer-latest.noarch.rpm
  elif [[ $DC == NCW ]];then
    echo "Installing latest katello in NCW"
    rpm -Uvh http://server2.myserverdomain.com/pub/katello-ca-consumer-latest.noarch.rpm
  fi
  echo "------------------------------"
  echo "katello-ca-consumer version:"
  rpm -qa | grep katello-ca-consumer
  echo "------------------------------"
  #Register server with Satellite
  if [[ $OSVERSION -lt 7 ]];then
    echo "Re-register the systems in Satellite"
    subscription-manager register --org New_Charter --activationkey RHEL6-Live --force
    subscription-manager attach --pool c3b*******token
    rm -rf /var/cache/yum/*
    yum clean all
    yum repolist
  else
    echo "Re-register the systems in Satellite"
    subscription-manager register --org New_Charter --activationkey RHEL7-Live
    yum repolist
  fi

  echo "------------------------------"
  echo "Ready to reboot the server"
  echo ""
  echo "Change recap"
  ls -ltr /etc/hosts
  grep "`hostname`.myserverdomain.com" /etc/hosts
  ls -ltr /etc/resolv.conf
  grep "myserverdomain.com" /etc/resolv.conf
  rpm -qa | grep katello-ca-consumer

  echo ""
  echo "Once reboot is completed, continue migration by running below command"
  echo "$(readlink -e -- "$0") adgpupdate"
  echo ""


echo "------------------------------"
#Adgpupdate and copy MFA certificate and restart centrify and sshd service
elif [[ ${1} == adgpupdate ]]; then
  uptime
  yes|cp /tmp/IwaTrustRoot.cer /var/centrify/net/certs/
  #chmod 640 /var/centrify/net/certs/IwaTrustRoot.cer
  #chown root:root /var/centrify/net/certs/IwaTrustRoot.cer


  #adgpupdate
  echo "restart centrifydc and sshd"
  systemctl restart centrifydc
  systemctl status centrifydc

  echo "------------------------------"
  systemctl restart centrify-sshd.service
  systemctl status centrify-sshd.service

  echo "------------------------------"
  echo "adinfo"
  adinfo

  echo "------------------------------"
  echo "change recap"
  ls -ltr /etc/resolv.conf
  grep "myserverdomain.com" /etc/resolv.conf
  echo ""
  ls -ltr /etc/hosts
  grep "`hostname`.myserverdomain.com" /etc/hosts
  echo ""
  ls -ltr /etc/centrifydc/centrifydc.conf
  grep -ir "^nss.runtime.defaultvalue.var.home" /etc/centrifydc/centrifydc.conf
  echo ""
  rpm -qa | grep katello-ca-consumer
  echo ""
  ls -ltr /var/centrify/net/certs/IwaTrustRoot.cer
  echo "MFA certificate enddate:"
  openssl x509 -enddate -noout -in /var/centrify/net/certs/IwaTrustRoot.cer

  echo "------------------------------"
  echo "migration completed!!"
  echo "Proceed with access validation and start the services"
  echo "------------------------------"
  echo ""

#DNS replication validation
elif [[ ${1} == nslookup ]]; then
  ipaddress=`hostname -i`
  servername=`hostname`
  while true
  do
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' > /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log
    nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}' >> /tmp/nslookup.log

    if grep "olddomain.com" /tmp/nslookup.log
    then
      nslookup $ipaddress 2> /dev/null|grep $servername|awk '{print $NF}'
      continue
    else
      echo ""
      cat /tmp/nslookup.log

      echo ""
      echo "dns replication completed"
      echo "Continue migration by running below command"
      echo "$(readlink -e -- "$0") adjoin"
      echo ""
      break
    fi
  done

else
  echo "Provide proper parameter as shown below"
  die

fi
