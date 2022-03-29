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

cat /dev/null > $home/tmp/run_puppet.log

sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo $server
    #echo $server >> $home/tmp/run_puppet.log
    #$SSH_OPTION$server sudo sed -i 's/updating_appd_agent_versions/production/g' /etc/puppetlabs/puppet/puppet.conf
    $SSH_OPTION$server sudo puppet agent -t 1>> $home/tmp/run_puppet.log 2>>$home/tmp/run_puppet.log &
done

ls -1 $home/tmp/run_puppet.log
