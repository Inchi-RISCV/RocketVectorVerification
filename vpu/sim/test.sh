#!/bin/bash

# 检查参数数量
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# 输入文件路径
input_file="$1"

# 搜索文件中是否存在字符串"commit info timeout"
if grep -q "commit info timeout" "$input_file"; then
    echo "Time OUT"
    exit 1
fi

# 生成输出文件名
output_file1="${input_file%.*}_act.log"
output_file2="${input_file%.*}_exp.log"

# 删除已经存在的输出文件
rm -f "$output_file1" "$output_file2"

# 使用awk从输入文件中提取所需内容并写入两个输出文件中
awk -v output_file1="$output_file1" -v output_file2="$output_file2" '
BEGIN {
    file1_started = 0;
    file2_started = 0;
    file1_count = 0;
    end_start = 0;
    end_count = 0;
}

/UVM_INFO \.\.\/env\/vpu_scb\.sv\([0-9]+\) @ [0-9]+: uvm_test_top\.m_env\.m_scb \[vpu_scb\]  scb get exp data : [\-]+/ {
    if (file1_started == 0) {
        file1_started = 1;
        file2_started = 0;
    }
}

/UVM_INFO \.\.\/env\/vpu_scb\.sv\([0-9]+\) @ [0-9]+: uvm_test_top\.m_env\.m_scb \[vpu_scb\]  scb get act data : [\-]+/ {
    if (file2_started == 0) {
        file2_started = 1;
        file1_started = 0;
    }
}

/verif_sfma.*/ {
    if(file1_started == 1){
    end_start = 1;
    }
}

{
    if (file1_started == 1 && $0 != end_marker &&!end_count) {
        print $0 >> output_file1;
        if(end) end_count ++;
    }
    else if (file2_started == 1 && $0 != end_marker) {
        print $0 >> output_file2;
    }
    else if (file1_started == 1 && $0 == end_marker) {
        file1_started = 0;
    }
}
' "$input_file"
vimdiff -d "$output_file2" "$output_file1"
rm "$output_file2" "$output_file1"

