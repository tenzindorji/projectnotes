import yaml

with open("first_yaml.yaml", 'r') as stream:
    for x in yaml.load_all(stream):
        print(x)
        print(type(x))

def sum(a, b):
    return (a + b)

sum(100, 200)
