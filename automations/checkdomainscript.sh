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
cat /dev/null > $home/tmp/ssh_access.log
sed -i 's/\r//g' ${2}

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    #echo "$server:" >> $home/tmp/ssh_access.log
    $SSH_OPTION$server "hostname && ls -ltr /tmp/domainmigration.sh && ls -ltr /tmp/IwaTrustRoot.cer"
done

