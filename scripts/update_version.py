with open(".jazzy.yaml") as file:
    data = file.readlines()

for i in range(len(data)):
    if data[i].startswith("module_version: "):
        version = data[i][len("module_version: "):]
        index = i

print("Current version: " + version)
version = input("Input new version: ")

data[index] = "module_version: " + version + "\n"

with open(".jazzy.yaml", "w") as file:
    file.writelines(data)