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

cat /dev/null > $home/tmp/dup_processes.log
cat /dev/null > $home/tmp/tmp_dup_processes.log

sed -i 's/\r//g' ${2}


SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo -en "$server," >> $home/tmp/dup_processes.log
    $SSH_OPTION$server sudo ps aux | sort --key=11 | uniq -c -d --skip-fields=10 | sort -nr --key=1,1|grep java|awk '{print $NF}' > $home/tmp/tmp_dup_processes.log
    if [[ -s $home/tmp/tmp_dup_processes.log ]];then
      cat $home/tmp/tmp_dup_processes.log | xargs | sed -e 's/ /,/g' > $home/tmp/tmp.log
      echo -en `cat $home/tmp/tmp.log` >> $home/tmp/dup_processes.log
      cat /dev/null >  $home/tmp/tmp_dup_processes.log
    fi
    echo " " >> $home/tmp/dup_processes.log
done
ls -1 $home/tmp/dup_processes.log
