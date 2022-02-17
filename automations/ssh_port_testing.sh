#! /bin/bash
#set +e

#Check the firewall connectivity
#Takes two arguments 1) fqdn/IP 2) port

rm -rf /home/P2980250/ssh.log

for i in `cat /home/P2980250/twc_hosts`; do
  for j in `cat /home/P2980250/user1`; do
    echo -en "$i:22:$j::" >> /home/P2980250/ssh.log; ssh -o BatchMode=yes $j@$i echo "SecurityBreached" 2>> /home/P2980250/ssh.log 1> /dev/null
    echo -en "$i:80:$j::" >> /home/P2980250/ssh.log; ssh -o BatchMode=yes -p 80 $j@$i echo "SecurityBreached" 2>> /home/P2980250/ssh.log 1> /dev/null
    echo -en "$i:443:$j::" >> /home/P2980250/ssh.log; ssh -o BatchMode=yes -p 443 $j@$i echo "SecurityBreached" 2>> /home/P2980250/ssh.log 1> /dev/null
  done
done
