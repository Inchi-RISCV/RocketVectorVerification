#!/bin/bash
BIN_NAME=$1
BASE_NAME=`basename $BIN_NAME .bin`
HEX_NAME=`basename $BIN_NAME .hex`
#dump hex for 32 bits width
hexdump -v -e/'4 "%08x\n"' ${BIN_NAME}.bin > temp.hex
#swap even and add rows
sed '$!N;s/\([^\n]*\)\n\([^\n]*\)/\2\n\1/' temp.hex | tee > temp1.hex
#merge 2 lines into 1 line, 32bits -> 64bits
awk '{if(NR%2==0) {printf $0 "\n"} else{printf $0}}' temp1.hex | tee > ${HEX_NAME}.hex
#swap even and add rows again
#sed '$!N;s/\([^\n]*\)\n\([^\n]*\)/\2\n\1/' temp2.hex | tee > temp1.hex
#merge 2 lines into 1 line again, 64bits -> 128bits
#awk '{if(NR%2==0) {printf $0 "\n"} else{printf $0}}' temp1.hex | tee > temp2.hex
#swap even and add rows again
#sed '$!N;s/\([^\n]*\)\n\([^\n]*\)/\2\n\1/' temp2.hex | tee > temp1.hex
#merge 2 lines into 1 line again, 128bits -> 256bits
#awk '{if(NR%2==0) {printf $0 "\n"} else{printf $0}}' temp1.hex | tee > ${HEX_NAME}.hex
 
rm temp*.hex
chmod 755 ${HEX_NAME}.hex
 
