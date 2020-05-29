#!/usr/bin/python -tt
# Copyright 2010 Google Inc.
# Licensed under the Apache License, Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0

# Google's Python Class
# http://code.google.com/edu/languages/google-python-class/

import sys
import re

'''
<h3 align="center">Popularity in 1990</h3>
....
<tr align="right"><td>1</td><td>Michael</td><td>Jessica</td>
<tr align="right"><td>2</td><td>Christopher</td><td>Ashley</td>
<tr align="right"><td>3</td><td>Matthew</td><td>Brittany</td>
'''

def extract_names(filename):
    names = []
    f=open(filename, 'rU')
    text=f.read()
    f.close()

    year_match=re.search(r'Popularity\sin\s(\d\d\d\d)', text)
    if not year_match:
        sys.stderr.write('couldn\'t find year\n')
        sys.exit(1)
    year=year_match.group(1)
    names.append(year)#list assignment
    #print names

    tuples=re.findall(r'<td>(\d+)</td><td>(\w+)</td><td>(\w+)</td>', text) #list of tuples
    babynames={}
    #print tuples
    for tuple in tuples:
        (rank, boyname, girlname)=tuple
        if boyname not in babynames:
            babynames[boyname]=rank
        if girlname not in babynames:
            babynames[girlname]=rank
    sorted_names=sorted(babynames.keys())
    #print sorted_names
    for name in sorted_names:
        names.append(name + " " + babynames[name]) # ['2006', 'Trace 519', 'Tracy 826',]

    print "Babynames:", names
    #return names



def main():
  # This command-line parsing code is provided.
  # Make a list of command line arguments, omitting the [0] element
  # which is the script itself.
  args = sys.argv[1:]

  if not args:
    print 'usage: [--summaryfile] file [file ...]'
    sys.exit(1)

  # Notice the summary flag and remove it from args if it is present.
  summary = False
  if args[0] == '--summaryfile':
    summary = True
    del args[0]

  # +++your code here+++
  # For each filename, get the names, then either print the text output
  # or write it to a summary file
  for filename in args:
      names=extract_names(filename)
      text='\n'.join(names) #'2002\nAaliyah 64\nAaron 44\nAbagail 882 and will print in new line
      #every element is appended with new line\n
      #print text

  if summary:
      output=open(filename + '.summary', 'w')
      output.write(text + '\n')
      output.close()
  else:
      print text


if __name__ == '__main__':
  main()
