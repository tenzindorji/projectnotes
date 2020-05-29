import os
#current working Dir
cwd = os.getcwd()
print cwd

#absolute path
print (os.path.abspath('automcating_common_task.py'))
#os.path.abspath('automcating_common_task.py')

#checks if it is a file or directory
print (os.path.exists('automcating_common_task.py'))

#if it exist, os.path.isdir checks whether its a dir.
print (os.path.isdir('automcating_common_task.py'))

#similarly os.path.isfile checks whether its a file
print (os.path.isfile('automcating_common_task.py'))

#os.listdir list files and dir in the given dir
print (os.listdir(cwd))



count=0
for (dirname, dirs, files) in os.walk('.'):
    for filename in files:
        if filename.endswith('.py'):
            count = count + 1
print 'Files:', count


from os.path import join
for (dirname, dirs, files) in os.walk('.'):
    for filename in files:
        if filename.endswith('.py'):
            thefile = os.path.join(dirname,filename)
            print os.path.getsize(thefile), thefile
