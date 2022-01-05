import numpy as np

np.set_printoptions(formatter={"int": hex})

A = np.arange(0, 16).reshape((4, 4))
B = np.arange(16, 32).reshape((4, 4))

C = A @ B

print(f"A={A}")
print(f"B={B}")
print(f"C=A*B={C}")

print("### code ###")

for i in range(3, -1, -1):
    if i == 3:
        print("s_rst <= '0';")
        print("s_req_result <= '1';")
    else:
        print("s_req_result <= '0';")
    left = ", ".join(reversed(list(f"X\"{a:04x}\"" for a in A[:, i])))
    print(f"s_left <= ({left});")
    top = ", ".join(reversed(list(f"X\"{b:04x}\"" for b in B[i, :])))
    print(f"s_top <= ({top});")
    print("wait for clk_period;")

print('s_top <= (X"0000", X"0000", X"0000", X"0000");')
print('s_left <= (X"0000", X"0000", X"0000", X"0000");')
print("s_req_result <= '1';")
print("wait for clk_period;")
print("s_req_result <= '0';")
print("wait;")
