import os
def triangle(r):
    for x in range(r):
        #print(" "*(r-x-1)+"*"*(2*x+1))
        print(" " * (r - x) + '* ' * x)
        #print('* ' * x)s
triangle(9)


for i in range(0, 9):
    print(" " * (9-i) + "* "* i)
