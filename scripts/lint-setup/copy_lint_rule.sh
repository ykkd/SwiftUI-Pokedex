#!/bin/bash

# 指定されたソースファイルとターゲットディレクトリ
source_file=$1
target_directory=$2

# パッケージファイルが存在するディレクトリを検索し、リストに保存
directories=$(find "$target_directory" -type f -name "Package.swift" -exec dirname {} \;)

# 各ディレクトリにソースファイルをコピー
for dir in $directories; 
do
  cp "$source_file" "$dir/"
done

echo "ファイルのコピーが完了しました。"
