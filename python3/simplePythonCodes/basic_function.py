

import sys

def Hello(name):
    name = name + '!!!!'
    print ('Hello', name) #python 3
    #print 'Hello', name  #python 2
    print (len(name))
    for i in range(len(name)):
      print (i)

def main():
    Hello(sys.argv[1])

if __name__ == '__main__':
    main()
