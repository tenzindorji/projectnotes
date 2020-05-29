import os
import shutil
#import opencv

#dirlist = os.listdir('/') python2
#dirlist = os.scandir('/') python3

for screenshot in os.walk(r'/Users/tdorji/Desktop/'):
    if screenshot.startswith('Screen Shot'):
        shutil.copy('/Users/tdorji/Desktop/', '/Users/tdorji/Desktop/screenshot/')
