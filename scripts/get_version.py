with open(".jazzy.yaml") as file:
    data = file.readlines()

for i in range(len(data)):
    if data[i].startswith("module_version: "):
        version = data[i][len("module_version: "):] #I know this read call includes the \n and release.py does not, but they both work and don't add or subtract a \n. ¯\_(ツ)_/¯
        index = i

print(version, end="")