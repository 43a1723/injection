def string_to_hex(content):
    return ''.join(f'\\x{c:02x}' for c in content)

with open('injection.js', 'rb') as file:
    content = file.read()

with open('injection.py', 'rb') as file:
    contentinjection = file.read()

hex_content = string_to_hex(content)

# Ghi chuỗi hex vào một tệp mới
with open('injection-o.py', 'w') as output_file:
    output_file.write(hex_content)

print("Chuỗi hex đã được ghi vào tệp injection-o.js")
