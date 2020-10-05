#! /bin/bash -ex
for i in `cat apiservicelist`;
do
  echo $i
  content=$(curl -s 'http://devops.ncw.webapps.rr.com/alias?dc=NCW&env=QA1&resource='$i)
  echo $content >> /tmp/output
done
