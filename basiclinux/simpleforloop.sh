#! /bin/bash

echo "Hello world"
echo -n "Printing text without newline"
echo  -e "\nRemoving \t backslash \t characters \n"

echo "while loop"
count=1
while true;
do
  if [ "$count" -eq 5 ];
  then
    break
  fi
  echo count: $count
  ((count++))
  #count ++
done


echo "For loop"
for (( count=1; count<5; count++));
do
  echo count: $count
done

echo "Get input"
echo "Enter name"
read name
echo "Welcome $name"


echo "Print pyramid"
echo "Provide input:"
read p
#p=7;

for((m=1; m<=p; m++))
do
    # This loop print spaces
    # required
    for((a=i; a<=p; a++))
    do
      echo -ne "*";
    done

    # This loop print the left
    # side of the pyramid
    for((n=1; n<=m; n++))
    do
      echo -ne "#";
    done

    # This loop print right
    # side of the pryamid.
    for((i=1; i<m; i++))
    do
      echo -ne "#";
    done

    # New line
    echo;
done

for ((i=1; i<=p; i++))
do
  for ((k=i; k<=p; k++))
  do
    echo -ne " "
  done
  for ((j=1; j<=i; j++))
  do
    echo -ne "*";
  done
  for ((a=j; a<i; a++))
  do
    echo -ne "*"
  done
  echo;
done
