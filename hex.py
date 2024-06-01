def string_to_hex(string):
    return ''.join(f'\\x{ord(c):02x}' for c in string)

with open('injection.js', 'rb') as file:
    content = file.read()

print(string_to_hex(content))