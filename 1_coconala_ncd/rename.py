import os
import shutil
import fileinput

# ファイルが存在するディレクトリを指定
directory = "./data"

# ディレクトリ内の全ファイルを処理
for filename in os.listdir(directory):
    filepath = os.path.join(directory, filename)
    
    # ファイルかどうかを確認
    if os.path.isfile(filepath):
        # 拡張子を除いたファイル名を取得
        base_name, extension = os.path.splitext(filename)
        # 拡張子が空でない場合、ファイル名にドットを追加
        if extension:
            base_name = base_name
        else:
            base_name = filename
        
        # ファイル名が6文字で、最初の2文字が'O0'であることを確認
        if len(base_name) == 6 and base_name.startswith("O0"):
            # 新しいファイル名を作成（先頭の'O0'を削除）
            new_base_name = "O" + base_name[2:]
            new_filename = f"{new_base_name}{extension}"
            new_filepath = os.path.join(directory, new_filename)
            
            # ファイル名の変更
            shutil.move(filepath, new_filepath)
            
            # 2行目をチェックし、変更前ファイル名が含まれていれば置き換える
            temp_file_path = os.path.join(directory, "tempfile")
            
            with fileinput.FileInput(new_filepath, inplace=True, backup=".bak") as file:
                for i, line in enumerate(file):
                    if i == 1 and old_base_name in line:
                        line = line.replace(old_base_name, new_base_name)
                    print(line, end="")
            
            # バックアップファイルを削除
            os.remove(new_filepath + ".bak")
