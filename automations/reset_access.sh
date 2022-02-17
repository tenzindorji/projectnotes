#! /bin/bash
set +xe

sed -i 's/\r//g' ${3}
workdir=`pwd`
cat /dev/null > ${workdir}/tmp/reset_pwd.log
#echo $workdir
#for server in `cat ${3}`;do
#ssh -o StrictHostKeyChecking=no -q ${1}@${server} << END
#sudo su
#echo "$2"| passwd $1 --stdin
#END

#done

for server in `cat ${3}`; do
 #echo $server >>  ${workdir}/tmp/reset_pwd.log
 echo "Updating on $server"
 ssh -o StrictHostKeyChecking=no -q ${1}@${server} "hostname && echo $2| sudo passwd $4 --stdin"  1>> ${workdir}/tmp/reset_pwd.log 2>> ${workdir}/tmp/reset_pwd.log &
 sleep 1
done
