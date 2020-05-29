
print "always run"

def main():
    print "First Modules name: {}".format(__name__)

if __name__=='__main__':
    main()
else:
    print "run from import"

thisdict = {
    "brand" : "Ford",
    "model" : "Mustang",
    "year"  : "1994"
}

print "print dictionary:"
print (thisdict)

for x in range(1, 11):
    print('{0:5d} {0:10d} {2:3d}'.format(x, x*x, x*x*x)) #d means line shift from left to right. 50d means, print output 50 spaces away ffrom zeroth

#print object without new line
print("x"),;print("y")

print "this is percentage: %%"
