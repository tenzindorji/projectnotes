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
cat /dev/null > $home/tmp/puppetversion.log
sed -i 's/\r//g' ${2} #remove carriage return

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
  echo -en "$server " >>$home/tmp/puppetversion.log; $SSH_OPTION${server} puppet --version >> $home/tmp/puppetversion.log
done

ls -1 $home/tmp/puppetversion.log
