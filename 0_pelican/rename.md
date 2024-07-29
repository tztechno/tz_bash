
---

以下は、`2024-06-20-xxx.md`ファイル名の`xxx`部分を008から020までの連番で変えて、コピーファイルを作成するためのBashスクリプトです。元のファイル名が`2024-06-20-xxx.md`であることを前提としています。スクリプトは現在のディレクトリにあるファイルを操作します。

1. スクリプトファイルを作成し、任意の名前を付けます（例: `copy_files.sh`）。
2. 以下の内容をスクリプトファイルに記述します。

```bash
#!/bin/bash

# 元ファイル名
original_file="2024-06-20-xxx.md"

# ファイルが存在するか確認
if [ ! -f "$original_file" ]; then
    echo "元ファイルが見つかりません: $original_file"
    exit 1
fi

# 008から020までの連番でファイルをコピー
for i in $(seq -f "%03g" 8 20); do
    new_file=$(echo "$original_file" | sed "s/xxx/$i/")
    cp "$original_file" "$new_file"
    echo "作成されたファイル: $new_file"
done

echo "すべてのファイルが作成されました。"
```

3. スクリプトファイルに実行権限を付与します。

```bash
chmod +x copy_files.sh
```

4. スクリプトを実行します。

```bash
./copy_files.sh
```

このスクリプトは、`2024-06-20-xxx.md`という名前のファイルを元に、`2024-06-20-008.md`から`2024-06-20-020.md`までのファイルを作成します。

---

`xxx.md` の `xxx` 部分が3桁の数字であるファイルを見つけて、そのファイル名を `2024-06-19-xxx.md` に変更するシェルスクリプトを作成します。

以下はそのためのシェルスクリプトの例です：

### シェルスクリプトの作成と実行

1. **シェルスクリプトの作成**

任意のテキストエディタを使って、以下の内容を含む `rename_files.sh` という名前のファイルを作成します。

```bash
#!/bin/bash

# 現在のディレクトリに移動する
cd "$(dirname "$0")"

# findコマンドで3桁の数字を含むファイルを見つけ、mvコマンドで名前を変更する
find . -type f -name '[0-9][0-9][0-9].md' | while read file; do
    # ディレクトリ部分を取得
    dir=$(dirname "$file")
    # ファイル名部分を取得
    base=$(basename "$file")
    # 新しいファイル名を作成
    new_base="2024-06-19-$base"
    # mvコマンドでファイル名を変更
    mv "$file" "$dir/$new_base"
    echo "Renamed $file to $dir/$new_base"
done
```

2. **実行権限の付与**

ターミナルを開いて、スクリプトに実行権限を付与します。

```bash
chmod +x rename_files.sh
```

3. **スクリプトの実行**

スクリプトが配置されているディレクトリに移動して、スクリプトを実行します。

```bash
./rename_files.sh
```

### スクリプトの内容の説明

- `#!/bin/bash`: シェルスクリプトがBashで実行されることを指定します。
- `cd "$(dirname "$0")"`: スクリプトが配置されているディレクトリに移動します。
- `find . -type f -name '[0-9][0-9][0-9].md' | while read file; do ... done`: `find` コマンドで、3桁の数字を含む `.md` ファイルを見つけ、それぞれのファイルについてループを回します。
- `dir=$(dirname "$file")`: ファイルのディレクトリ部分を取得します。
- `base=$(basename "$file")`: ファイル名部分を取得します。
- `new_base="2024-06-19-$base"`: 新しいファイル名を作成します。
- `mv "$file" "$dir/$new_base"`: ファイル名を変更します。
- `echo "Renamed $file to $dir/$new_base"`: ファイル名の変更を確認します。

これで、指定したディレクトリ内の3桁の数字を含む `.md` ファイルが `2024-06-19-xxx.md` に変更されます。

---
