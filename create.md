---
./create_files.sh
```
#!/bin/bash

# 日付を取得
current_date=$(date +%Y-%m-%d)

# 数字範囲の指定
start=96
end=100

# テンプレート内容
template="Title: xxx. xxx語
Date:
Category: Blog
Tags:
Slug:
Authors: stpete
Summary:"

# 指定範囲の数字に対してファイルを作成または編集
for number in $(seq $start $end); do
    # 数字をゼロ埋め（zfill(3)）する
    zfilled_number=$(printf "%03d" $number)
    
    # ファイル名を作成
    file_name="${current_date}-${zfilled_number}.md"
    
    # ファイルが存在しない場合、テンプレートを追加
    if [ ! -f "$file_name" ]; then
        echo "$template" > "$file_name"
    fi
    
    # 一時ファイルを作成
    tmp_file=$(mktemp)

    # ファイルの内容を読み込み、指定された行を置き換える
    while IFS= read -r line; do
        case "$line" in
            "Date:")
                echo "Date: ${current_date}" >> "$tmp_file"
                ;;
            "Slug:")
                echo "Slug: ${zfilled_number}" >> "$tmp_file"
                ;;
            "Summary:")
                echo "Summary: Stop using drugs." >> "$tmp_file"
                ;;
            "Tags:")
                echo "Tags: drug, " >> "$tmp_file"
                ;;                
             *)
                echo "$line" >> "$tmp_file"
                ;;
        esac
    done < "$file_name"

    # 一時ファイルの内容を元のファイルに書き戻す
    if ! mv "$tmp_file" "$file_name"; then
        echo "エラー: ファイル '${file_name}' の更新に失敗しました。" >&2
        rm -f "$tmp_file"
        exit 1
    fi

    # 確認メッセージ
    echo "ファイル '${file_name}' が作成されました。"
done
```
---

./rename_files.sh
```
#!/bin/bash

# 元ファイル名
original_file="2024-06-27-xxx.md"

# ファイルが存在するか確認
if [ ! -f "$original_file" ]; then
    echo "元ファイルが見つかりません: $original_file"
    exit 1
fi

# 008から020までの連番でファイルをコピー
for i in $(seq -f "%03g" 86 95); do
    new_file=$(echo "$original_file" | sed "s/xxx/$i/")
    cp "$original_file" "$new_file"
    echo "作成されたファイル: $new_file"
done

echo "すべてのファイルが作成されました。"
```
---
