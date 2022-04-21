#! /bin/bash
set +ex

home=`pwd`
user=${1}

die () {
    echo >&2 "$@"
    echo "
    Usage:
        $0 ssh_user server_list filename
        filename gets copied to /tmp/"
    exit 1
}

[ "$#" -eq 3 ] || die "3 argument required, $# provided"

sed -i 's/\r//g' ${2}

for server in `cat ${2}`;do
  echo $server
  ssh -o StrictHostKeyChecking=no -q ${user}@${server} sudo rm -rf /tmp/${3}
  scp -o StrictHostKeyChecking=no $3 ${user}@${server}:/tmp/
  #ssh -o StrictHostKeyChecking=no -q ${user}@${server} "sudo chmod 755 /tmp/${3} && sudo chown root:root /tmp/${3}" &> /dev/null &
done

for server in `cat ${2}`;do
  #scp -o StrictHostKeyChecking=no $3 ${user}@${server}:/tmp/ &> /dev/null &
  ssh -o StrictHostKeyChecking=no -q ${user}@${server} "sudo chmod 755 /tmp/${3} && sudo chown root:root /tmp/${3}"
done
