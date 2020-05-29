#Filename: main.py
import yaml
# Reading YAML data
file_name = 'list.yml'
with open(file_name, 'r') as f:
    data = yaml.load(f)

print(data["Vessels"])
