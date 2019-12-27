from os import rename as move

with open("Package.swift") as file:
    data = file.readlines()

for i in range(len(data)):
    if "//dev" in data[i]:
        data[i] = "//" + data[i]
    if "//nodev" in data[i]:
        data[i] = data[i][2:]

with open("Package.swift", "w") as file:
    file.writelines(data)

if path.exists("Package.resolved"):
    move("Package.resolved", "Package.resolved.danger")
if path.exists("Package.resolved.nodanger"):
    move("Package.resolved.nodanger", "Package.resolved")
