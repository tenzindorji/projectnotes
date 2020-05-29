import re #
for _ in range(int(input())):
    print(bool(re.match(r'^[-+]?[0-9]*\.[0-9]+$', input())))

'''
A regular expression (or RegEx) specifies a set of strings that matches it.
A regex is a sequence of characters that defines a search pattern, mainly for the use of string pattern matching.
'''

'''
r means raw string.With the r, backslashes are treated as literal.
r'^[+-]? says that the input start with + or -
[0-9]* says that the next char will be 0,1,2,3,4,5,6,7,8 or 9 the digit will be appear once or more.

. here \ is a skip char that is used for "." ,without using . compiler can't understand "." char

"[0-9]+$" says that the last digit will be at least one digit from 0,1,2,3,4,5,6,7,8,9 decimal digit. dolar sign is ending symbol.
'+' says that whichever thing it follows[in this case it is[0-9]], it can repeat arbitrarily times, but atleast one time.
'''

'''re.search()''' 
