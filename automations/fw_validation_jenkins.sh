#! /bin/bash
#set +e

home=`pwd`
rm -f ${home}/fw_${1}_to_${2}.log 1>/dev/null

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes tdorji@"

sed -e "s/\r//g" $1 > /tmp/source
sed -e "s/\r//g" $2 > /tmp/destination

source_ip="/tmp/source"
destination_ip="/tmp/destination"

port_range="$3"

if [[ $port_range == *[-]* ]]
then
  ports="{`echo $port_range|sed -e 's/-/../g'`}"
elif [[ $port_range == *[,]* ]]
then
  ports="`echo $port_range|sed -e 's/,/\ /g'`"
else
  ports=$port_range
fi

for source in `cat $source_ip`
do
  rm -f /tmp/fw_${source}_to_${2}.sh 1>/dev/null

  echo "-----------------" >> ${home}/fw_${1}_to_${2}.log
  echo "$source:$port_range" >> ${home}/fw_${1}_to_${2}.log
  echo "-----------------" >> ${home}/fw_${1}_to_${2}.log

  $SSH_OPTION$source nmap --version 1> /dev/null
  nmap_status=`echo $?`
  if [ $nmap_status -eq 0 ]
  then
    echo "source:$source:$port_range ... validating..."
    $SSH_OPTION$source nmap -Pn -p $port_range `cat $destination_ip|paste -d" " -s -` 1>> ${home}/fw_${1}_to_${2}.log 2>> ${home}/fw_${1}_to_${2}.log

  elif [[ $nmap_status -eq 127 ]]; then
    ls -ltr /tmp/fw_${source}_*.sh
    rm -f /tmp/fw_${source}_*.sh
    echo "$source: nmap not installed"
    echo "$source: nmap not installed............" >> ${home}/fw_${1}_to_${2}.log
    for destination in `cat $destination_ip`
    do
      for p in $(eval echo $ports)
      do
        echo "nc -vz -w 2 $destination $p" >> /tmp/fw_${source}_to_${2}.sh
      done
    done
    scp -B /tmp/fw_${source}_to_${2}.sh tdorji@$source:/home/tdorji/
    if [ $? -eq 0 ];then
      echo "script uploaded"
    else
      echo "script upload failed"
    fi
    echo "validating using nc command.........."
    $SSH_OPTION$source sh -x /home/tdorji/fw_${source}_to_${2}.sh 1>> ${home}/fw_${1}_to_${2}.log 2>> ${home}/fw_${1}_to_${2}.log

  else
    echo "$source: Access issue, created commands"
    echo "$source: Access issue, created commands" >> ${home}/fw_${1}_to_${2}.log
    for destination in `cat $destination_ip`
    do
      for p in $(eval echo $ports)
      do
        echo "nc -vz -w 2 $destination $p" >> /tmp/fw_${source}_to_${2}.sh
      done
    done
   fi
   echo "   " >> ${home}/fw_${1}_to_${2}.log
done
