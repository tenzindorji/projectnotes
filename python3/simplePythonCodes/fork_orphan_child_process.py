#! /usr/bin/env python3

from os import fork, getppid, wait
from sys import exit
from time import sleep

#Fork the process
pid = fork()

if pid==0: #we are in the child process
    print("child: whatsup?")
    print("child: this is my parent", getppid())
else: #we are in parent process
    print("Parent: I just created child", pid)
    sleep(1) #Sleep for a second to aviod bing dropped back to shell when the parent finishes


print("waiting for child to complete the process by using wait() method")

if pid==0:
    print("Child: my parent is waiting for me")
    for _ in range(100):
        sleep(1)
        print("Child: my parent is", getppid())
else:
    #wait() #waits for child process to complete the execution, else it will create zombie processs
    print("Parent: I just created child", pid)
    sleep(1)

"""
print("Creating zombie process")

if pid==0:
    print("Child: I am about to become orphan")
    for _ in range(5):
        sleep(1)
        print("Child: my parent is", getppid())
else:
    #wait() #waits for child process to complete the execution, else it will create zombie processs
    print("Parent: I just created child", pid)
    sleep(1)
"""
