#! /bin/bash
set +ex

home=~
mkdir -p $home/tmp
user=${1}
var="0"

die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user Source Destination Port"
    echo "
    Example for Source and Destination:
        1) can be regular file in the same/different location of the script,
        2) IP or hostname by comma separated,
        3) IP or hostname range by \"-\" separated,
        4) single IP or hostname.

   Example for Port:
        1) Ports list by comma separated,
        2) Port range by \"-\" separated,
        3) Or single port."

    exit 1
}

[ "$#" -eq 4 ] || die "4 arguments required, $# provided"

validate_Host() {
  rm -f $home/tmp/invalidHost &> /dev/null
  rm -f  $home/tmp/hostnames &> /dev/null

  if [[ -f ${1} ]];then
    grep -v -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" < ${1} > $home/tmp/hostnames
    if [[ -s $home/tmp/hostnames ]];then
      nslookup < $home/tmp/hostnames 2> $home/tmp/invalidHost  1> $home/tmp/invalidHost
      grep -Eq "Non-existent|istent" $home/tmp/invalidHost
      if [[ $? == 0 ]];then
        var="1"
	cat  $home/tmp/invalidHost| head
      fi
    fi
  elif [[ ${1} == *[-]* ]];then
    nslookup `echo ${1}|awk -F"-" '{print $1}'` 2> $home/tmp/invalidHost  1> $home/tmp/invalidHost
    grep -Eq "Non-existent|istent" $home/tmp/invalidHost
    if [[ $? == 0 ]];then
      var="1"
      cat  $home/tmp/invalidHost| head

    fi
  elif [[ ${1} == *[,]* ]];then
    echo ${1} | tr -s "," "\n"|grep -v -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" > $home/tmp/hostnames
    if [[ -s $home/tmp/hostnames ]];then
      nslookup < $home/tmp/hostnames 2> $home/tmp/invalidHost  1> $home/tmp/invalidHost
      grep -Eq "Non-existent|istent" $home/tmp/invalidHost
      if [[ $? == 0 ]];then
        var="1"
	cat  $home/tmp/invalidHost| head
      fi
    else
      var="0"
    fi
  else
    nslookup `echo ${1}` 2> $home/tmp/invalidHost  1> $home/tmp/invalidHost
    v=`wc -l < $home/tmp/invalidHost`
    if [[ $v -gt 0 ]];then
      grep -Eq "Non-existent|istent" $home/tmp/invalidHost
      if [[ $? == 0 ]];then
        var="1"
      fi
    else
      var="0"
    fi
  fi
return $var
}

echo "Checking the inputs..."

#validate_Host $2
#if [[ $var -eq 1 ]];then
#  die "Invalid Source Hostname or the IP"
#fi
#validate_Host $3
#if [[ $var -eq 1 ]];then
#  die "Invalid Destination Hostname or the IP"
#fi

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"
#bash can only return integer value, to return string, need to define as global var
log=""
ports=""

ip_conversion() {
  cat /dev/null > $home/tmp/ip_list
  if [[ ${1} == *[-]* ]];then
    input="`echo ${1}|sed -e 's/-/\ /g'`"
    log=${1}
    port_length=`echo ${input}|awk -F" " '{print $1}'`
    if [[ `echo ${#port_length}` -le 5 ]];then
      ports="{`echo ${1}|sed -e 's/-/../g'`}"
    else
      for ((i=`echo ${input}|awk -F" " '{print $1}'|awk -F"." '{print $4}'`; i<=`echo ${input}|awk -F" " '{print $2}'`;i++));do
        echo "`echo ${input}|awk -F" " '{print $1}'|awk -F"." '{print $1"."$2"."$3}'`.$i" >> $home/tmp/ip_list
      done
    fi

  elif [[ ${1} == *[,]* ]];then
    echo ${1}|sed -e 's/,/\ /g' >> $home/tmp/ip_list
    ports=`echo ${1}|sed -e 's/,/\ /g'`
    log=`echo ${1}|sed -e 's/,/\-/g'`
  elif [[ -f ${1} ]];then
    sed 's/\r//' ${1} > $home/tmp/ip_list
    if [[ `ls ${1}` == *[\/]* ]];then
      log=`ls -1 ${1}|awk -F"/" '{print $NF }'`
    else
      log=${1}
    fi
  else
    echo ${1} >> $home/tmp/ip_list
    log=${1}
    ports=${1}
  fi
}



ip_conversion $2
src_log=$log
if [[ -f ${2} ]];then
  echo "Source:";
  cat $home/tmp/ip_list
else
  echo "Source:`cat $home/tmp/ip_list |paste -d" " -s -`"
fi
source_ip=`cat $home/tmp/ip_list |paste -d" " -s -`
ip_conversion $3
des_log=$log
if [[ -f ${3} ]];then
  echo "Destination:";
  cat $home/tmp/ip_list
else
  echo "Destination:`cat $home/tmp/ip_list|paste -d" " -s -`"
fi
destination_ip=`cat $home/tmp/ip_list |paste -d" " -s -`
ip_conversion $4
echo "Port_Range:${4}"
echo "---------------------------"

cat /dev/null > ${home}/tmp/fw_${src_log}_to_${des_log}.log
fw_log=${home}/tmp/fw_${src_log}_to_${des_log}.log

echo "Running Firewall Validation, Give it a second...."





for source in $source_ip
do
  rm -f $home/tmp/fw_${source}_to_${des_log}.sh &> /dev/null
  echo "---------------------------" >> $fw_log

  if [[ "$source" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "SRC:$source(`nslookup $source|grep Name|awk '{print $NF}'|awk -F"." '{print $1}'`):$4" >> $fw_log
  else
    echo "SRC:$source(`nslookup $source 2> /dev/null |head -5|tail +5|awk '{print $NF}'`):$4" >> $fw_log
  fi
  echo "---------------------------" >> $fw_log

  $SSH_OPTION$source nmap --version 1> /dev/null 2> /dev/null
  nmap_status=`echo $?`
  if [ $nmap_status -eq 0 ]
  then
    echo "source:${source}:Destination:${4}...fw_validating..."
    $SSH_OPTION$source nmap -Pn -p $4 $destination_ip | grep -v latency |grep -v "Starting Nmap"|grep -v "Nmap done:"|grep -v SERVICE|grep -v rDNS|grep -v "Host is up"|grep -v "^$" 1>> $fw_log 2>> $fw_log
    echo "" >> $fw_log
  elif [[ $nmap_status -eq 127 ]]; then
    echo "Installing nmap on $source"
    $SSH_OPTION$source sudo yum install nmap -y &> /dev/null
    $SSH_OPTION$source nmap --version|grep version
    echo "source:${source}:Destination:${4}...fw_validating..."
    $SSH_OPTION$source nmap -Pn -p $4 $destination_ip | grep -v latency |grep -v "Starting Nmap"|grep -v "Nmap done:"|grep -v SERVICE|grep -v rDNS|grep -v "Host is up"|grep -v "^$" 1>> $fw_log 2>> $fw_log &
    #sleep 5
  else
    echo "AccessIssue. Run commands in a below file on the server $source:" |tee >> $fw_log
    echo "$home/tmp/fw_${source}_to_${des_log}.sh" |tee >> $fw_log
    for destination in $destination_ip
    do
      for p in $(eval echo $ports)
      do
        echo "nc -vz -w 2 $destination $p" >> $home/tmp/fw_${source}_to_${des_log}.sh
      done
    done
   fi

done

echo "---------------------------"
echo "validation completed"
if grep -E 'filtered|AccessIssue' $fw_log > /dev/null; then
  if [[ `wc -l <$fw_log` -gt 30 ]];then
    echo "Some rules are not working Or Due to access issue, check the log:"
    echo "$fw_log"
    echo "---------------------------"

  else
    echo "Some rules are not working Or Due to access issue"
    cat $fw_log
    echo "---------------------------"
  fi
else
  echo "Great! All rules are opened"
  if [[ `wc -l <$fw_log` -lt 30 ]];then
    echo "---------------------------"
    cat $fw_log
  else
    echo "To view the status for all, check the log:"
    echo "$fw_log"
    echo "---------------------------"
  fi
fi

if [[ `wc -l <$fw_log` -gt 30 ]];then
  grep -E 'filtered|timed|AccessIssue|route' $fw_log
fi
