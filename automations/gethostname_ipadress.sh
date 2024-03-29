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
cat /dev/null > $home/tmp/hostnameipadress.log
sed -i 's/\r//g' ${2} #remove carriage return

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    #$SSH_OPTION${server} "hostname; adinfo --zone|cut -d '/' -f6; adinfo --domain; adinfo --site" > $home/tmp/adinfotmp.log
    #$SSH_OPTION${server} "hostname; adinfo --zone|cut -d '/' -f6; adinfo --domain; adinfo --site" > $home/tmp/adinfotmp.log
    #cat  $home/tmp/adinfotmp.log |paste -d" " -s - >> $home/tmp/adinfo.log
    #$SSH_OPTION${server} 'echo -en "`hostname` " && echo -en "`/bin/adinfo --zone|cut -d '/ -f6'` " && /bin/adinfo --site|cut -d"-" -f1 && echo ""' >> $home/tmp/adinfo.log
    $SSH_OPTION${server} 'echo -en "`hostname` " && hostname -i' >> $home/tmp/hostnameipadress.log
done

ls -1 $home/tmp/hostnameipadress.log
