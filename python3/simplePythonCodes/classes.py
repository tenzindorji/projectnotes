class Robot: #class name starts with capital
    def introduce_self(self):
        print("My Name is " + self.name)

r1 = Robot()
r1.name = "Tom"
r1.color = "red"
r1.weight = 30

print("Without constructor, it is difficult to maintain the instance variables")
r1.introduce_self()


### using constructor
class People:
        def __init__(self, name, age, hight):
            self.name = name
            self.age = age
            self.hight = hight

        def introduce_self(self):
            print("My name is " + self.name)

p1 = People("Jerry", 25, 130)
print("using constructor")
p1.introduce_self()
p2 = People("Woomy", 25, 130)
p2.introduce_self()


class Emptyclass:
    pass #Class defination cannot be empty, so put the pass statement to aviod the error


##Inheretence from class People
class Person(People):
    pass

person1 = Person("Tenzin", 34, 130)
person1.introduce_self()

##Add attributes to the child class
class Student(People):
    def __init__(self, name, age, hight, year):
        super().__init__(name, age, hight)
        self.graduationyear = year

    def welcome(self):
        print("Welcome ", self.name, " to the class of ", self.graduationyear )

student1 = Student("Chimi",12,40,2012)
student1.introduce_self()

student2 = Student("Chimi",12,40,2020)
student2.welcome()
student2.introduce_self()


import numpy
import matplotlib.pyplot as plt

x = numpy.random.normal(5.0, 1.0, 100000)

plt.hist(x, 100)
plt.show()
