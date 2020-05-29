'''if __name__ == '__main__':
    n = int(input())
    student_marks = {} #Dictionary
    for _ in range(n): #_ loop till N
        line = input().split() #Split a string into a list where each word is a list item
        #print line
        name, scores = line[0], line[1:] #1: takes n number of inputs
        scores = map(float, scores) #Map applies float functions to all the input scores
        student_marks[name] = scores # Creates key value {'d': [3.0, 4.0, 5.0]}
        print (student_marks)
        #print student_marks
    student_name = input()
    query_scores = student_marks[student_name] #out put the value for the key name
    #print query_scores
    print("{0:.2f}".format(sum(query_scores)/(len(query_scores)))) #{} let you replace variable in format function.
    #2f two decimal Replace. 0: means, it is refering to first value in format. 1: will refer to second value.'''

if __name__ == '__main__':
    n = int(input())
    student_marks = {}
    for _ in range(n):
        name, *line = input().split() #https://stackoverflow.com/questions/45062375/why-used-before-declaring-a-variable-in-python
        #*line is unpacking feature introduced in python 3 called star unpacking or extended iterable unpacking.
        scores = list(map(float, line)) 
        student_marks[name] = scores
    query_name = input()
    marks = student_marks[query_name]
    #print("%.2f"%(sum(marks)/3))#python 2
    print("{0:.2f}".format(sum(marks)/(len(marks)))) #python3
