#/bin/bash -w

input_file=$1
cat $input_file
for line in `cat $input_file`
do
      echo -n "$line " "" >> /tmp/awscostprodpci.txt; echo -e `make ipall|grep $line|awk '{print $1}'` >> /tmp/awscostprodpci.txt;
done
