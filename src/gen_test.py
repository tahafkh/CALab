lines = []

with open("instructions.data", "r") as test_file:
    i = 0
    for line in test_file.readlines():
        lines.append("assign instructions[" + str(i) + "] = 32'b"+line.strip()+";\n")
        i += 1

for line in lines:
    print(line)    