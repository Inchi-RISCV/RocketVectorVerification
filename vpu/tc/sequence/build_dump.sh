#!/bin/bash

# 检查是否提供了目录参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

# 检查目录是否存在
if [ ! -d "$directory" ]; then
    echo "Directory not found: $directory"
    exit 1
fi

# 创建一个名为dump的文件夹
dump_directory="$directory/dump"
mkdir -p "$dump_directory"

# 遍历目录中的所有文件
for file in "$directory"/*; do
    # 检查是否为文件
    if [ -f "$file" ]; then
        # 执行riscv64-unknown-elf-objdump命令，并将输出重定向到以.dump结尾的文件
        riscv64-unknown-elf-objdump -d "$file" > "${file}.dump"
        
        echo "Created ${file}.dump"
    fi
done

# 将所有的.dump文件移动到dump文件夹中
mv "$directory"/*.dump "$dump_directory"

echo "All .dump files have been moved to $dump_directory"

