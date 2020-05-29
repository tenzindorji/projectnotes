import os
import sys
import shutil
import commands #help(commands.getstatusoutput) return (status, output)

def List(dir):
    cmd='ls' + dir
    print 'about to do this', cmd
    (status, output)=commands.getstatusoutput(cmd)
    if status:
        sys.stderr.write('there was an error:' + output)
        sys.exit(1)

    filenames=os.listdir(dir)
    for filename in filenames:
        path=os.path.join(dir, filename)
        print path
        print os.path.abspath(path)
    #print filenames
    #os.path.exists('/tmp/foo')
    #os.mkdir('mention path')
    #shutil.copy(source, dest)
    print output



def main():
    List(sys.argv[1])

if __name__=='__main__':
    main()
