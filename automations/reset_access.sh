#! /bin/bash
set +xe


die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user userid newpwd serverlist"

    exit 1
}

[ "$#" -eq 4 ] || die "4 argument required, $# provided"


sed -i 's/\r//g' ${4}
workdir=`pwd`
cat /dev/null > ${workdir}/tmp/reset_pwd.log




for server in `cat ${4}`; do
 #echo $server >>  ${workdir}/tmp/reset_pwd.log
 echo "Updating on $server"
 ssh -o StrictHostKeyChecking=no -q ${1}@${server} "sudo pam_tally2 --user $2 --reset" &
 ssh -o StrictHostKeyChecking=no -q ${1}@${server} "hostname && echo $2| sudo passwd $3 --stdin" &  #1>> ${workdir}/tmp/reset_pwd.log 2>> ${workdir}/tmp/reset_pwd.log &
 sleep 1
done
