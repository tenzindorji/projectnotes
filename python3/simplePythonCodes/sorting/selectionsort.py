

a=[6,1,4,9,0,3,5,6]

for i in range(len(a)):
    min_value=i
    for j in range(i+1, len(a)):
        if a[i]>a[j]:
            min_value=j
            a[i],a[min_value]=a[min_value],a[i]

print "Selection sort:", a

for i in range(len(a)-1):
    for j in range(len(a)-1-i):
        if a[j] > a[j+1]:
            a[j],a[j+1]=a[j+1],a[j]
print "Bubble sort:", a


for i in range(len(a)):
    cursor=a[i]
    position=i
    while position>0 and a[i-1]>cursor:
        a[position]=a[position-1] #swap second element with first element
        position=position-1 #first index
        a[position]=cursor #swap first element with second element

print "Insertion sort:", a
