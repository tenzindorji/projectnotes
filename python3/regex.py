import re

Nameage = '''
Janice is 22 and Theon is 33
Gabriel is 44 and Joey is 21
'''

ages = re.findall(r'\d{1,3}', Nameage)
names = re.findall(r'[A-Z][a-z]*', Nameage)

ageDict = {}
x = 0

for eachname in names:
    ageDict[eachname] = ages[x]
    x+=1

print(ageDict)



#match = re.search('iig', 'called piiig')
def Find(pattern, text):
    match = re.search(pattern, text) #match is a object and will return object
    if match: print match.group() # group function will return matched value
    else: print 'Not found'

Find('iig', 'called piiig')

#rule number: Simple character match itself
#Rule number 2
#. dot any char (space, :, number, any char)
# \w word char, include under bar and digit
# \d digit
# \s whitespace
# \S non whitespace
# \w+
# \d+
# . inside [] is just a dot and do not have to backlash, cos it is inside []

#rule number 3: It finds match left to right

# lower case r means raw string, do not do any special processing with back slashes and send raw without unterpreted
#search function will get first match and then will stop further search
#re.findall is best , will find all the matches and it will return python list
 m=re.search(r'([\w.]+)@([\w.]+)', 'Bhal nick.p@gmail.com yatta @')
 #() will separate into two groups and @ as delimeter
 m.group(1) #left side of @ 1 represents first element
 m.group(2) # rigtside of @

re.findall(r'[\w.]+@[\w.]+', 'Bhal nick.p@gmail.com yatta@yahoo.com')
#finds all the matching.
#['nick.p@gmail.com', 'yatta@yahoo.com']
re.findall(r':\w+([\w.])+@([\w.]+)', ':Bhal nick.p@gmail.com yatta@yahoo.com')
#returns tuple list. () used for grouping and will return tuple list
# It will standard out only values in () if () grouping is used. Other search pattern will not be tupled
#[('p', 'gmail.com'), ('a', 'yahoo.com')]

#Example difference between search and findall
match=re.search(r'Popularity\sin\s(\d\d\d\d)', 'Popularity in 2006')
match.group()
#'Popularity in 2006'
match.group(1)
#'2006'
re.findall(r'Popularity\sin\s(\d\d\d\d)', 'Popularity in 2006')
#['2006']


re.findall(r'([\w.])+@([\w.]+)', 'Bhal nick.p@gmail.com yatta@yahoo.com', re.IGNORECASE)
#can use flag
