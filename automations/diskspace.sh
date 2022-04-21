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

cat /dev/null > $home/tmp/diskspace.log

sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo $server
    #$SSH_OPTION$server sudo sed -i 's/webapps_certupdate_aem/production/g' /etc/puppetlabs/puppet/puppet.conf &
    #$SSH_OPTION$server "hostname && sudo puppet agent --enable"  1>> $home/tmp/diskspace.log 2>>$home/tmp/diskspace.log &
    #$SSH_OPTION$server "hostname && sudo puppet agent -t" 1>> $home/tmp/diskspace.log 2>>$home/tmp/diskspace.log &
    #$SSH_OPTION$server "hostname && sudo service puppet start"  1>> $home/tmp/diskspace.log 2>>$home/tmp/diskspace.log &

    $SSH_OPTION$server "hostname && df -h|grep 'var$'" 1>> $home/tmp/diskspace.log 2>>$home/tmp/diskspace.log &
done
#sudo puppet agent --enable 1>> $home/tmp/diskspace.log 2>>$home/tmp/diskspace.log;
ls -1 $home/tmp/diskspace.log
