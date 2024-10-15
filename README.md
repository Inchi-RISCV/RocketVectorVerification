# RocketVectorVerification
Verification Environment
how to set up this verification environment:
step 1 :
putting the testcases under vpu/tc/sequence
step 2 :
generate bin/hex and dump files under vpu/tc/sequence
./build_dump.sh testcases_folder_name 
./build_bin.sh testcases_folder_name
./build_hex.sh testcases_folder_name/bin
step 3:
update rtl under vpu/th
step 4:
adding spike executable file under vpu/common
step 5 :
simulate under vpu/sim:
make run mode=base_func tc=instr_test  fsdb=on seed=123  cov=on cfg=vadd.elf  cfg_dir=../tc/sequence/bin_3
