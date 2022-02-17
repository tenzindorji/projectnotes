#! /bin/bash -x
set +ex

home=`pwd`
user=${1}
current_branch=${3}
new_branch=${4}

die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user server_list current_branch new_branch"
    exit 1
}

[ "$#" -eq 4 ] || die "3 argument required, $# provided"

cat /dev/null > $home/tmp/migrate.log
cat /dev/null >  $home/tmp/puppetupgrade.log

sed -i 's/\r//g' ${2}

count=0
SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    count=`expr $count + 1`
    echo "${count}:${server}:Performing clean up and will start puppet agent twice to complete the upgrade ..." >> $home/tmp/migrate.log
    $SSH_OPTION$server "sudo sed -i 's/^exclude=puppet-agent/#exclude=puppet-agent/g' /etc/yum.conf &&\
    sudo sed -i 's/vm0pnpuppta0001.twcable.com/vm0pncorexa0001.corp.chartercom.com/g' /etc/puppetlabs/puppet/puppet.conf &&\
    sudo sed -i 's/${current_branch}/${new_branch}/g' /etc/puppetlabs/puppet/puppet.conf &&\
    sudo cp -R /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl_backup &&\
    sudo rm -rf /etc/puppetlabs/puppet/ssl/ 2> /dev/null &&\
    sudo rm -rf /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock &> /dev/null &&\
    if [[ -f /var/run/puppetlabs/mcollective.pid ]]; then sudo service mcollective stop >& /dev/null;fi &&\
    sudo rm -rf /opt/puppetlabs/mcollective/* 2> /dev/null" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log
    $SSH_OPTION$server "for i in 1 2;do sudo /usr/local/bin/puppet agent -t &> /tmp/puppetupgrade.log;hostname 1>> /tmp/puppetupgrade.log 2>>/tmp/puppetupgrade.log; sudo /usr/local/bin/puppet --version >> /tmp/puppetupgrade.log;head /tmp/puppetupgrade.log;tail /tmp/puppetupgrade.log;done" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log &
done
exit
