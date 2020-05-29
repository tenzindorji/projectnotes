import os
import sys
import commands

def find_services(filename):

    for i in filename:
        cmd='make ipall|grep' + i + '>> /tmp/qa_prf_pci.txt'
        #os.system(mycmd)
        (status, output) = commands.getstatusoutput(cmd)


def main():
    input=sys.argv[1]
    services=find_services(input)

if __name__=='__main__':
    main()

for p in (peptides.txt)
do
    echo "${p}"
done
