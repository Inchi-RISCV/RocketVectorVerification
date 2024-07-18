
#!/bin/bash

# �������������� bin ��������
if [ $# -ne 1 ]; then
    echo "Usage: $0 <bin_directory>"
    exit 1
fi

bin_directory="$1"

# ���� bin ������������
if [ ! -d "$bin_directory" ]; then
    echo "Directory not found: $bin_directory"
    exit 1
fi

# ���� hex ����������
parent_directory=$(dirname "$bin_directory")
hex_directory="$parent_directory/hex"
mkdir -p "$hex_directory"

# ���� bin ������������ .bin ����
for bin_file in "$bin_directory"/*.bin; do
    # ������������ .bin ����
    if [ -f "$bin_file" ]; then
        # ��������������������������
        BASE_NAME=$(basename "$bin_file" .bin)
        HEX_NAME="$BASE_NAME.hex"

        # ������32����������������
				hexdump -v -e/'4 "%08x\n"' "$bin_file" > temp.hex
        # ������������������
        sed '$!N;s/\([^\n]*\)\n\([^\n]*\)/\2\n\1/' temp.hex | tee > temp1.hex
        
        # ������������������32��������64��
        awk '{if(NR%2==0) {printf $0 "\n"} else{printf $0}}' temp1.hex | tee > "$hex_directory/$HEX_NAME"

        # ������������
        rm temp.hex temp1.hex

        echo "64-bit hex file generated: $hex_directory/$HEX_NAME"
    else
        echo "No .bin files found in $bin_directory"
    fi
done
