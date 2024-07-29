bash rename.sh

bash rename2.sh


了解しました。ファイル中身の書き換えがうまくいかない場合には、スクリプトを修正して、2行目の文字列を正しく確認し、置き換えが行えるようにしましょう。

以下は、`awk` での修正方法を改善し、2行目の文字列の書き換えを行うシンプルなBashスクリプトです。ファイル中身の変更を行う際に、適切に一時ファイルを使用して変更を反映させます。

### 改善されたスクリプト

```bash
#!/bin/bash

# ファイルが存在するディレクトリを指定
directory="/path/to/your/files"

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
```

### スクリプトの説明

1. **ファイル名の変更**:
   - ファイル名と拡張子を取得し、新しいファイル名を作成します。
   - `mv` コマンドでファイル名を変更します。

2. **2行目の文字列の確認と置き換え**:
   - `awk -v old="$base_name" -v new="$new_base_name"` で `awk` に変更前と変更後のファイル名を渡します。
   - `NR==2` で2行目を処理し、`$0 ~ old` で2行目の文字列に変更前のファイル名が含まれていれば、`sub(old, new)` で文字列を置き換えます。
   - `system("mv tempfile " FILENAME)` で一時ファイルを元のファイルに戻します。

3. **一時ファイルの使用**:
   - `awk` の処理結果を一時ファイル `tempfile` に書き出し、その後元のファイルに戻します。

### 注意点

- このスクリプトを実行する前に、対象ファイルのバックアップを取ることをお勧めします。
- スクリプト内の `directory` 変数に適切なパスを設定してください。
- `awk` の `sub` 関数を使用して文字列を置き換えていますが、`sub` は最初にマッチした部分のみを置き換えます。複数回の置き換えが必要な場合は、`gsub` を使用するか、`awk` の使い方を調整する必要があります。

このスクリプトを使うことで、ファイル名の変更とともに、ファイル内のテキストの2行目も正しく置き換えることができるはずです。