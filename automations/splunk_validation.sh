#! /bin/bash
set +ex

home=`pwd`
user=${1}

die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user server_list sourcetype"
    exit 1
}

[ "$#" -eq 3 ] || die "3 argument required, $# provided"
cat /dev/null > $home/tmp/splunk_validation.log
sed -i 's/\r//g' ${2}

SSH_OPTION="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -q $user@"

for server in `cat ${2}`;do
    echo "-----------------" >> $home/tmp/splunk_validation.log
    echo $server >> $home/tmp/splunk_validation.log

    #echo $server >>
    $SSH_OPTION$server sudo grep -ir "${3}" /opt/splunkforwarder/etc/apps/spectrum_it-eCommerce-order-oob_forwarders/local/inputs.conf 1>> $home/tmp/splunk_validation.log 2>> $home/tmp/splunk_validation.log
done

ls -1 $home/tmp/splunk_validation.log
