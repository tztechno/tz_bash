
```
chmod +x generate_text.sh
./generate_text.sh
bash generate_text.sh
```

```

#!/bin/bash

# 配列の定義
langs=("スペイン語" "イタリア語" "フランス語" "ドイツ語")
texts=("I sincerely apologize to you.")

# 出力ファイルの定義
output_file="translations.txt"

# 出力ファイルが既に存在する場合は削除
if [ -f $output_file ]; then
    rm $output_file
fi

# 翻訳と文法説明を出力
for ((i=0; i<${#langs[@]}; i++)); do
    echo "${texts[0]} を ${langs[i]} に翻訳し、その文法をわかりやすく説明する。" >> $output_file
done

echo "Translations and explanations have been written to $output_file."

```
