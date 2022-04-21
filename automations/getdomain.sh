#! /bin/bash
set +ex

cat /dev/null > /c/cygwin64/home/P2980250/dnsdomainlist
sed -i 's/\r//g' ${1}
#nslookup < /home/P2980250/host 2> /tmp/dnsdomainlist 1> /tmp/dnsdomainlist
for i in `cat ${1}`; do
  #echo -en "$i:" >> /c/cygwin64/home/P2980250/dnsdomainlist;
  echo "${i}:`nslookup $i|grep Name`" >> /c/cygwin64/home/P2980250/dnsdomainlist &
  #echo -n `nslookup $i|grep -v 142.136.252.87|grep Address|awk '{print $NF }' >> /c/cygwin64/home/P2980250/dnsdomainlist`;
  #echo >> /c/cygwin64/home/P2980250/dnsdomainlist;
done
