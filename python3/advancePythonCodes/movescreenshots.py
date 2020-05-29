import os
import fnmatch
import shutil

#this program moves Screen Shot files away from Desktop folder

# Move a file by renaming it's path
#os.rename('/Users/billy/d1/xfile.txt', '/Users/billy/d2/xfile.txt')

# Move a file from the directory d1 to d2
#shutil.move('/Users/tdorji/Desktop/Screen\*', '/Users/tdorji/Desktop/screenshot/')

image = raw_input("Enter Regx file names to be moved: ")

for desktop, dirnames, filenames in os.walk('/Users/tdorji/Desktop/'):
    for filename in fnmatch.filter(filenames, image):
        folder="/Users/tdorji/Desktop/"
        f=folder+filename
        ifexist = os.path.isfile('f')
        if ifexist:
            print f
            shutil.move(f, '/Users/tdorji/Documents/screenshot/')
        else:
            print "file not found"
