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
   # echo -en "`$SSH_OPTION$server nslookup $server|grep 'Name'` " 1>> $home/tmp/getcert.log 2>>$home/tmp/getcert.log
    echo -en "${server} " >> $home/tmp/getcert.log
    $SSH_OPTION$server "grep -ir '^certname' /etc/puppetlabs/puppet/puppet.conf|awk '{print $3}'" 1>> $home/tmp/getcert.log 2>>$home/tmp/getcert.log
    #$SSH_OPTION$server "hostname && grep -ir '^environment' /etc/puppetlabs/puppet/puppet.conf|awk '{print $3}'" 1>> $home/tmp/getcert.log 2>>$home/tmp/getcert.log &
done

cat $home/tmp/getcert.log
