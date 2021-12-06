iv1 = int("6ac613096d74faa3f49f89bfafe38d91", 16)
iv2 = int("a344156c6d74faa3f49f89bfafe38d91", 16)
yes = int("5965730d0d0d0d0d0d0d0d0d0d0d0d0d", 16)
no = int("4e6f0d0d0d0d0d0d0d0d0d0d0d0d0d0d", 16)
xores = iv1 ^ iv2 ^ yes
xores = hex(xores)
print(xores)
