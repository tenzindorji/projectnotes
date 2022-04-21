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

cat /dev/null > $home/tmp/update_branch.log

sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo $server
    $SSH_OPTION$server sudo sed -i 's/new_puppet_master/production/g' /etc/puppetlabs/puppet/puppet.conf &
    #$SSH_OPTION$server "hostname && sudo puppet agent --enable"  1>> $home/tmp/update_branch.log 2>>$home/tmp/update_branch.log &
    #$SSH_OPTION$server "hostname && sudo puppet agent -t" 1>> $home/tmp/update_branch.log 2>>$home/tmp/update_branch.log &
    #$SSH_OPTION$server "hostname && sudo service puppet start"  1>> $home/tmp/update_branch.log 2>>$home/tmp/update_branch.log &
    #sleep 1
    #$SSH_OPTION$server "hostname && grep -ir 'environment' /etc/puppetlabs/puppet/puppet.conf |grep -v '#'" 1>> $home/tmp/update_branch.log 2>>$home/tmp/update_branch.log &
done
#sudo puppet agent --enable 1>> $home/tmp/update_branch.log 2>>$home/tmp/update_branch.log;
cat $home/tmp/update_branch.log
