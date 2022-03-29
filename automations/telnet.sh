#! /bin/bash -ex

#Check the firewall connectivity
#Takes two arguments 1) fqdn/IP 2) port

rm -rf /tmp/telnet-*
rm -rf /tmp/connectionresults.log
#counter=0

telnet_func(){
    ssh tdorji@$1 telnet "$2" "$3"  &>> /tmp/telnet-"$1"-"$2"-"$3".log
    #cat /tmp/tmp-$1-$2-$3.log |grep -v "Trying"|grep -v "Escape character is '^]'."|grep -v "Connection closed by foreign host." > /tmp/telnet-$1-$2-$3.log
}

while IFS= read -r sourceServer
do
  while IFS= read -r desServer
  do
    while IFS= read -r port
    do
        echo $sourceServer:$desServer:$port::> /tmp/telnet-"$sourceServer"-"$desServer"-"$port".log
        telnet_func "$sourceServer" "$desServer" "$port" &
        #echo "" >> /tmp/telnet-$sourceServer-$desServer-$port.log
    done < /tmp/destinationPorts
  done < /tmp/destinationServerList
done < /tmp/sourceServerList
wait


cat /tmp/telnet-* |grep -v "Trying"|grep -v "Escape character is '^]'."|grep -v "Connection closed by foreign host." > /tmp/connectionresults.log
#cat /tmp/telnet-*  > /tmp/connectionresults.log
#rm -rf /tmp/tmp-*.log


echo "Script execution completed"
