#! /bin/bash

set +ex

home=`pwd`

cat /dev/null > ${home}/trailingremove

sed -i 's///g' ${1} >> ${home}/trailingremove

