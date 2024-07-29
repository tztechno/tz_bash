## Bashスクリプトによるファイル編集と自動生成

## はじめに
Bashは強力で柔軟なシェルスクリプト言語で、テキスト処理、ファイル操作、システム管理タスクなど、多岐にわたる用途に適しています。
今回、Bashのスクリプトを用いたファイル編集と自動生成の例を紹介します。

## 内容
Pelicanブログのテンプレート部分の編集を事例にあげます。
```text
template="Title:
Date:
Category: Blog
Tags:
Slug:
Authors: stpete
Summary:
```
Title, Date, Tags, Slug, Summary に決められた情報をbash scriptで書き込んで行きます。


## 実行結果例
先に実行結果を示すと、bash scriptを実行す流ことで、以下のように個々の項目が正しく編集されたファイルが生成します。

生成ファイル名称: 2024-06-27_101.md
生成ファイル内容:
```text
Title: Stop the war. スペイン語
Date: 2024-06-27
Category: Blog
Tags: war, スペイン語
Slug: 101
Authors: stpete
Summary: Stop the war.
```

## bash script(create.sh)の内容
```bash
#!/bin/bash

# 日付を取得
current_date=$(date +%Y-%m-%d)

# ファイル通番の範囲の指定
start=101
end=104

# 編集内容を定義
langs=("スペイン語" "イタリア語" "フランス語" "ドイツ語")
texts=("Stop the war.")
kws=("war")

# テンプレート内容
template="Title:
Date:
Category: Blog
Tags:
Slug:
Authors: stpete
Summary:
"

# 指定範囲の数字に対してファイルを作成または編集
for number in $(seq $start $end); do
    # 数字をゼロ埋め（zfill(3)）する
    zfilled_number=$(printf "%03d" $number)
    
    # ファイル名を作成
    file_name="${current_date}-${zfilled_number}.md"
    
    # 言語のインデックスを計算
    lang_index=$((number - start))

    # 要素を取得（配列が1つの要素しか持たない場合は常に最初の要素を使用）
    current_lang="${langs[$lang_index]}"
    current_text="${texts[0]}"
    current_kw="${kws[0]}"

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
            "Tags:")
                echo "Tags: ${current_kw}, ${current_lang}" >> "$tmp_file"
                ;;
            "Title:")
                echo "Title: ${current_text} ${current_lang}" >> "$tmp_file"
                ;;
            "Summary:")
                echo "Summary: ${current_text}" >> "$tmp_file"
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
    echo "ファイル '${file_name}' が作成または編集されました。"
done
```
IFS は "Internal Field Separator" の略で、Bashシェルにおいて重要な環境変数です。
IFS= と設定することで、一時的にIFSを空に設定した上で、read コマンドにより行全体を1つの単位として読み込み保持します。

## 実行方法
```bash
bash create.sh
```

## 終わりに
上記のスクリプトはbashの各種機能を含んでおり、必要に応じて書き換えることで、いろいろな場面で使えるか思います。

* 基本的な構造: ループ構造や条件分岐を使用。
* 配列の使用: 複数の配列（langs, texts, kws）を使用。
* ファイル操作: ファイルの読み書き、一時ファイルの作成と管理。
* エラー処理: 基本的なエラーチェックとエラーメッセージの出力。
* 日付操作: 現在の日付を取得して使用。
* テンプレート処理: テンプレートファイルの内容の動的に置き換え。
* パラメータ設定: スクリプトの動作を制御するパラメータ（start, end）を使用。


