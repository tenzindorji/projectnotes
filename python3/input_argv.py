print("How old are you? ", end='')
age=input()
print("How tall are you? ", end='')
height=input()
print("How much do you weigh? ", end='')
weight=input()

# f is string formating
print(f"So, you're {age} old, {height} tall and {weight} heavy.")



#prompting user

age=input("How old are you? ")
height=input("How tall are you? ")
weight=input("How much do you weigh? ")

print(f"So, you're {age} old, {height} tall and {weight} heavy")

from sys import argv
script, user_name = argv
prompt = '>'

print(f"Hi {user_name},  I'm the {script} script.")
print(f"Do you like me {user_name}?")
likes =input(prompt)
print("What kind of computer do you have?")
computer=input(prompt)

print(f"you said {likes} and have {computer} computer")
