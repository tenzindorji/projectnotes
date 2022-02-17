#! /bin/bash
set +ex

cat /dev/null > /c/cygwin64/home/P2980250/dnsdomainlist
sed 's/\r//' /c/cygwin64/home/P2980250/ip_addresses > /c/cygwin64/home/P2980250/host
#nslookup < /home/P2980250/host 2> /tmp/dnsdomainlist 1> /tmp/dnsdomainlist
for i in `cat /c/cygwin64/home/P2980250/host`; do
  echo -en "$i:" >> /c/cygwin64/home/P2980250/dnsdomainlist;
  echo `nslookup $i|grep Name >> /c/cygwin64/home/P2980250/dnsdomainlist`;
  #echo -n `nslookup $i|grep -v 142.136.252.87|grep Address|awk '{print $NF }' >> /c/cygwin64/home/P2980250/dnsdomainlist`;
  #echo >> /c/cygwin64/home/P2980250/dnsdomainlist;
done
