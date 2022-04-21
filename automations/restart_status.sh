#! /bin/bash
set +ex

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

cat /dev/null > $home/tmp/getcert.log

sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    $SSH_OPTION$server sudo ps -ef > $home/tmp/restart_temp.log
    echo $server
    cat $home/tmp/restart_temp.log | grep java|grep -v 'grep'|awk '{print $5 "" $NF}'
    cat $home/tmp/restart_temp.log | grep httpd|grep root|grep -v 'grep'|awk '{print $5 "" $NF}'
    cat $home/tmp/restart_temp.log | grep haproxy|grep root|grep -v 'grep'|awk '{print $5}'
    cat $home/tmp/restart_temp.log | grep mongod|grep -v 'grep'|awk '{print $5}'
    #$SSH_OPTION$server "hostname && ps -ef|grep java|grep -v 'grep'|awk '{print $5}' && ps -ef|grep httpd|grep -v 'grep'|awk '{print $5}' && ps -ef|grep mongod|grep -v 'grep'|awk '{print $5}' &&  ps -ef|grep haproxy|grep -v 'grep'|awk '{print $5}'"
done
