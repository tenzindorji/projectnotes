# Python Notes

##  Python is interpreted language
  - Python is not quickest program but quick for programmer

```
import psutil

print("Disc Partition:")
print(psutil.disk_partitations())

print("Disc Usage:")
print(psutil.disk_usage('/'))
```

```
boto3

using s3
using ec2
API to s3
API to ec2
using AWS SQS
```
* Print an object without a trailing newline
  - By default, the print function add a trailing line. To prevent this behaviors, add a comma after the statement:
    `print ("x"),;print("y")`

* To escape the sign %, just double it:
  `print "this is percentage: %%"`



# Strings:
```
a = 'Hello'

a[1]
a[1:3] #this is call slice
a[1:] # this will print ello , goes all they way thru the string
a[:] # this prints Hello, it starts from beginning
```
* Python String | find()
  - The find() method returns the lowest index of the substring if it is found in given string. If its is not found then it returns -1.

- !/usr/bin/python -tt
  - Dash tt means accept mixture of tab and spaces indentation


* List for loop:
```
for i in list:
  print i
```
* Check value exist in list
  - value in list # gives true or false

* `a = a.append(xx)` Big noooooo , append does return value but modifies list

`list.pop(0)``

`del list`  deletes the definition of list
`del list[1]`  deletes the value

* list sorting
  - `sorted` original value will not be over written with sorted value
  `help(sorted)`

instead of using for loop, we can

* For loop constraint
  - Do not add value while looping , else it will create infinite loop

The remove() method removes the specified item:
The pop() method removes the specified index, (or the last item if index is not specified):
The del keyword removes the specified index:
The del keyword can also delete the list completely:
The clear() method empties the list:
Use the extend() method to add list2 at the end of list1:


Dic: works with key value pair
d= {} #empty dictionary
very fast lookup
d['a'] = 'alpha' # assignment

d.get('a') #get the value
d['a'] #get the value

'a' in d # value exist? True or False

d.keys() # returns only keys
d.values()

for k in sorted(d.keys()):
  print 'key:', k, '->', d[k]

d.items() # pulls all the records and puts in tuples

for tuple in d.items(): print tuple


file_name.split() # default delimiter is space and it will split each word and print list   

exit(0) means a clean exit without any errors / problems

exit(1) means there was some issue / error / problem and that is why the program is exiting.

sys.argv[0], is always the name of the program as it was invoked, and sys.argv[1] is the first argument you pass to the program.
