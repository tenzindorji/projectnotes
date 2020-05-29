#fibonacci
def fibonacci(n):
    if n == 0:
        print("invalid response")
    elif n == 1:
        return 1
    elif n == 2:
        return 1
    else:
        return fibonacci(n-1) + fibonacci(n-2)

n=5
print(fibonacci(n))

#palindrome
def reverse(s):
    return s[::-1]
def palindrome(s):
    rev=reverse(s)
    if rev==s:
        return True
    else:
        return False

s="malayalam"
v=palindrome(s)
if v == True:
    print("yes")
else:
    print("No")

#bubble sort

def bubblesort(list):
    n=len(list)
    for i in range(n-1):
        for j in range(n-1-i):
            if list[j] > list[j+1]:
                list[j], list[j+1]=list[j+1], list[j]
    return list

list=[9,0,0,3,7,1,8,2,6]
print(bubblesort(list))

#Seven Boom
def sevenboom(list):
    n=len(list)
    for i in range(n-1):
        if list[i]==7:
            print("7 found Boom")

list=[9,3,5,2,0,0,0,3,5]
sevenboom(list)

#convert lower case to uppor case
def convert_lower_upper_case(s):
    newstring=""
    for i in s:
        if i.isupper()==True:
            newstring+=i.lower()
        elif i.islower()==True:
            newstring+=i.upper()
        elif i.isspace()==True:
            newstring+=i
        else:
            newstring+=i
    return newstring

s="HEllo4 World 2"
print(convert_lower_upper_case(s))

thickness=5
c="H"
'''
for i in range(thickness):
    print((c*i).rjust(thickness-1) + c + (c*i).ljust(thickness-1))
    '''
# Top Pillars
for i in range(thickness + 1):
    print((c * thickness).center(thickness * 2) + (c * thickness).center(thickness * 6))
'''
# Middle Belt
for i in range(int((thickness + 1)/2)):
    print((c * thickness * 5).center(thickness * 6))

# Bottom Pillars
for i in range(thickness + 1):
    print((c * thickness).center(thickness * 2) + (c * thickness).center(thickness * 6))

# Bottom Cone
for i in range(thickness):
    print(((c * (thickness - i - 1)).rjust(thickness) + c + (c * (thickness - i - 1)).ljust(thickness)).rjust(thickness * 6))
    '''
