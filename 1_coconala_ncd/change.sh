#!/bin/bash

# ファイルが存在するディレクトリを指定
directory="./"

# ディレクトリ内の全ファイルを処理
for filepath in "$directory"/*; do
    # ファイル名を取得（拡張子を含む）
    filename=$(basename "$filepath")
    # 拡張子を除いたファイル名を取得
    base_name="${filename%.*}"
    # 拡張子の取得（拡張子がない場合は空になる）
    extension="${filename##*.}"
    # 拡張子が空でない場合、ファイル名にドットを追加
    if [ "$extension" != "$filename" ]; then
        base_name="${filename%.*}"
    else
        base_name="$filename"
    fi
    
    # ファイル名が6文字で、最初の2文字が'O0'であることを確認
    if [[ ${#base_name} -eq 6 && ${base_name:0:2} == "O0" ]]; then
        # 新しいファイル名を作成（先頭の'O0'を削除）
        new_base_name="O${base_name:2}"
        # 新しいファイル名に拡張子を追加
        new_filename="${new_base_name}.${extension}"
        # ファイル名の変更
        mv "$filepath" "$directory/$new_filename"
        # 2行目をチェックし、変更前ファイル名が含まれていれば置き換える
        awk -v old="$base_name" -v new="$new_base_name" '
        NR==2 {
            if ($0 ~ old) {
                sub(old, new)
                modified=1
            }
        }
        {
            print
        }
        END {
            if (modified) {
                # 変更を反映するための一時ファイル作成
                system("mv tempfile " FILENAME)
            }
        }' "$directory/$new_filename" > "${directory}/tempfile"
        # 一時ファイルを元のファイルに戻す
        mv "${directory}/tempfile" "$directory/$new_filename"
    fi
done
