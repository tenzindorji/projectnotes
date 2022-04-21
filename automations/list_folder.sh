#! /bin/bash
#set +ex
set -x

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

rm -rf $home/tmp/tmp/*
cat /dev/null > $home/tmp/list_folders.log
cat /dev/null > $home/tmp/tmp_list_folders.log
sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo -en "$server," > $home/tmp/tmp/${server}.log
    $SSH_OPTION$server "sudo find /data/apps/appdynamics/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \; |grep -v networkVisibility" >> $home/tmp/tmp/${server}.log &
    #paste -d, -s $home/tmp/tmp/${server}.log
done
sleep 10;

for file in `find $home/tmp/tmp/ -type f |paste -d" " -s -`;do
  sed -e 's/\r/,/g'  ${file} &
done

sleep 5

cat  `find $home/tmp/tmp/ -type f |paste -d" " -s -` >> $home/tmp/list_folders.log
#cat  $home/tmp/tmp_list_folders.log|sort | xargs | sed -e 's/ /,/g' >>  $home/tmp/list_folders.log

#
# $SSH_OPTION$server "sudo find / |grep log4j-core-2" > $home/tmp/tmp_list_folders.log
