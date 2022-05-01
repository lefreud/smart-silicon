
print("Version: 2\n")
print("""
#######
# North
#######""")
for i in range(4):
    for j in range(16):
        print(f"Pin: i_top[{i}][{j}] N")
print("""
#######
# East
#######""")
for i in range(4):
    for j in range(16):
        print(f"Pin: i_left[{i}][{j}] W")
print("""
#######
# West
#######""")
for i in range(4):
    for j in range(16):
        print(f"Pin: o_data[{i}][{j}] S")
