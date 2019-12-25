with open("Package.swift") as file:
    data = file.readlines()

for i in range(len(data)):
    if "//dev" in data[i]:
        data[i] = data[i][2:]
    if "//nodev" in data[i]:
        data[i] = "//" + data[i]

with open("Package.swift", "w") as file:
    file.writelines(data)