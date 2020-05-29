#! /usr/bin/env python3

from os import wait, fork, getppid
from sys import exit
from time import sleep

pid=fork()

if pid==0:
    exit("Child: Good bye! What a cruel world!")
else:
    print("Parent: This is child I created", pid, "Now I m going to sleep indifinitely")
    while True:
        sleep(1)
