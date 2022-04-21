#! /bin/bash -x
set +e

home=`pwd`
user=${1}
current_branch=${3}
new_branch=${4}
action=${5}



echo "Deploy new_puppet_master branch from Jenkins"

die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user server_list current_branch new_branch action
        example:
        $0 tdorji server_list production new_puppet_master upgrade/rollback"
    exit 1
}

[ "$#" -eq 5 ] || die "3 argument required, $# provided"

cat /dev/null > $home/tmp/migrate.log

sed -i 's/\r//g' ${2}

count=0
SSH_OPTION="ssh -o StrictHostKeyChecking=no -q $user@"

if [[ $action == upgrade ]];then
  for server in `cat ${2}`;do
      count=`expr $count + 1`
      echo "${count}:${server}:Performing clean up ..." >> $home/tmp/migrate.log
      $SSH_OPTION$server "sudo sed -i 's/^exclude=puppet-agent/#exclude=puppet-agent/g' /etc/yum.conf &&\
      sudo rm -rf /tmp/puppet-agent* &> /dev/null &&\
      yes|sudo cp -RP /etc/puppetlabs/ /tmp/ &&\
      sudo wget --no-check-certificate --progress=bar:force -P /tmp/ https://new_puppet_master.myserverdomain.com:8140/packages/2019.8.3/el-7-x86_64/puppet-agent-6.19.1-1.el7.x86_64.rpm &&\
      sudo rpm -e puppet-agent &&\
      sudo rm -rf /etc/puppetlabs &> /dev/null &&\
      sudo rm -rf /opt/puppetlabs &> /dev/null &&\
      sudo rpm -i /tmp/puppet-agent-6.19.1-1.el7.x86_64.rpm &&\
      sudo /usr/local/bin/puppet --version &&\
      yes|sudo cp /tmp/puppetlabs/puppet/puppet.conf /etc/puppetlabs/puppet/ &&\
      yes|sudo cp -RP /tmp/puppetlabs/facter/ /etc/puppetlabs/ &&\
      sudo sed -i 's/old_puppet_master.olddomain.com/new_puppet_master.myserverdomain.com/g' /etc/puppetlabs/puppet/puppet.conf &&\
      sudo sed -i 's/${current_branch}/${new_branch}/g' /etc/puppetlabs/puppet/puppet.conf &&\
      echo "Puppet Agent installed" &&\
      sudo rm -rf /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock &> /dev/null" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log
      #$SSH_OPTION$server "for i in 1 2;do sudo /usr/local/bin/puppet agent -t &> /tmp/puppetupgrade.log;hostname 1>> /tmp/puppetupgrade.log 2>>/tmp/puppetupgrade.log; sudo /usr/local/bin/puppet --version >> /tmp/puppetupgrade.log;head /tmp/puppetupgrade.log;tail /tmp/puppetupgrade.log;done" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log &
      echo "Running puppet ..." >> $home/tmp/migrate.log
      $SSH_OPTION$server "for i in 1;do sudo /usr/local/bin/puppet agent -t &> /tmp/puppetupgrade.log;head /tmp/puppetupgrade.log;tail /tmp/puppetupgrade.log;sudo service puppet start;echo '';echo '';done" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log &
      #$SSH_OPTION$server "sudo /usr/local/bin/puppet agent -t &> /tmp/puppetupgrade.log && head /tmp/puppetupgrade.log && tail /tmp/puppetupgrade.log" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log &
  done
elif [[ $action == rollback ]];then
  for server in `cat ${2}`;do
      count=`expr $count + 1`
      echo "${count}:${server}:Rolling back ..." >> $home/tmp/migrate.log
      $SSH_OPTION$server "sudo rm -rf /tmp/puppet-agent* &> /dev/null &&\
      sudo wget --no-check-certificate --progress=bar:force -P /tmp/ https://old_puppet_master.olddomain.com:8140/packages/2018.1.2/el-7-x86_64/puppet-agent-5.5.3-1.el7.x86_64.rpm &&\
      sudo rpm -e puppet-agent &&\
      sudo rpm -i /tmp/puppet-agent-5.5.3-1.el7.x86_64.rpm &&\
      sudo /usr/local/bin/puppet --version &&\
      yes|sudo cp -RP /tmp/puppetlabs/ /etc/ &&\
      echo "Puppet Agent installed" &&\
      sudo rm -rf /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock &> /dev/null" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log
      echo "Running puppet ..." >> $home/tmp/migrate.log
      $SSH_OPTION$server "for i in 1;do sudo /usr/local/bin/puppet agent -t &> /tmp/puppetupgrade.log;head /tmp/puppetupgrade.log;tail /tmp/puppetupgrade.log; echo '';echo '';done" 1>> $home/tmp/migrate.log 2>> $home/tmp/migrate.log &
      certname=`$SSH_OPTION$server grep -ir '^certname' /etc/puppetlabs/puppet/puppet.conf|awk '{print $3}'`
      $SSH_OPTION$new_puppet_master.myserverdomain.com sudo /opt/puppetlabs/bin/puppet node purge $certname &> /dev/null &
  done
fi

sleep 10
echo "Check the upgrade status:"
echo "tail -f  $home/tmp/migrate.log"
