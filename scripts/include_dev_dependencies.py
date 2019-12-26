from os import rename as move
from os import path

with open("Package.swift") as file:
    data = file.readlines()

for i in range(len(data)):
    if "//dev" in data[i]:
        data[i] = data[i][2:]
    if "//nodev" in data[i]:
        data[i] = "//" + data[i]

with open("Package.swift", "w") as file:
    file.writelines(data)

if path.exists("Package.resolved"):
    move("Package.resolved", "Package.resolved.nodanger")
if path.exists("Package.resolved.danger"):
    move("Package.resolved.danger", "Package.resolved")
