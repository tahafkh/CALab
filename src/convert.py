import os

for file in os.listdir('.'):
    print(file)
    if file.split('.')[-1] == "bak":
        os.remove(file)