from sys import argv

script, filename = argv

text=open(filename)

print(f"Here is your file {filename}")
print(text.read())

print("Type the file name again:")
file_again=input(">")
test_again=open(file_again)
print(test_again.read())
