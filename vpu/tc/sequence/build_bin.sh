#!/bin/bash

# ����������������������
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

# ����������������
if [ ! -d "$directory" ]; then
    echo "Directory not found: $directory"
    exit 1
fi

bin_directory="$directory/bin"
mkdir -p "$bin_directory"

# ��������������������
for file in "$directory"/*; do
    # ��������������
    if [ -f "$file" ]; then
        # ����������������������
        base_name=$(basename "$file" .elf)
        # ���� .bin ����
        riscv64-unknown-elf-objcopy -S --set-section-flags .bss=alloc,contents -O binary "$file" "${directory}/${base_name}.bin"
        
        echo "Created ${directory}/${base_name}.bin"
    fi
done

# �������� .bin ������ bin ����
mv "$directory"/*.bin "$bin_directory"

echo "All .bin files have been moved to $bin_directory"
