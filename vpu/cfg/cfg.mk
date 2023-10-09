UVM_HOME = /tools/synopsys/vcs/vcs/Q-2020.03-SP2-7/etc/uvm-1.2
UVM_DIR = +incdir+$(UVM_HOME) +incdir+$(UVM_HOME)/dpi $(UVM_HOME)/uvm.sv $(UVM_HOME)/dpi/uvm_dpi.cc
TB_PATH = ../../
TB_F = ../cfg/tb.f
RTL_F = ../cfg/dut.f
SPIKE_F = ../cfg/spike.f
pl := UVM_MEDIUM
seed := 1
mode := base_func
tc := instr_test
instr_name =../tc/sequence/rv64uf-p-move
#instr_name =../tc/sequence/riscv_floating_point_arithmetic_test_0

USER_COMP_OPTS := -full64  -cc gcc-5 -LDFLAGS -Wl,--no-as-needed +v2k -sverilog -timescale=1ns/10ps \
	                -debug_access+all -kdb -fsdb -CFLAGS -DVCS -ntb_opts rvm
USER_RUN_OPTS := 
USER_VERDI_OPTS := 


sim_csrcs = \
    ../common/csrc/SimDTM.cc \
    ../common/csrc/SimJTAG.cc \
    ../common/csrc/debug_rob.cc \
    ../common/csrc/remote_bitbang.cc

USER_COMP_OPTS +=	-Mdir=./${mode}/exec/csrc -o ./${mode}/exec/simv \
						      +vc+list -CC "-I$(VCS_HOME)/include" \
	                -CC "-I$(RISCV)/include" \
	                -CC "-std=c++17" \
                  -CC "-Wl,-rpath,$(RISCV)/lib" \
                  $(RISCV)/lib/libfesvr.a \
                  $(sim_csrcs)\
                  +define+CLOCK_PERIOD=1.0 \
                  +define+RANDOMIZE_MEM_INIT \
                  +define+RANDOMIZE_REG_INIT \
                  +define+RANDOMIZE_GARBAGE_ASSIGN \
                  +define+RANDOMIZE_INVALID_ASSIGN \
                  +define+RANDOMIZE_DELAY=0.1 \
						      +define+FSDB+define+WAVES_FSDB+define+WAVES="fsdb"\
						      +libext+.v 

USER_COMP_OPTS += +define+NRET=1\
						      +define+NTRAP=1\
					      	+define+XLEN=64\
					      	+define+FLEN=64\
					      	+define+VLEN=128

fsdb :=on
wave_name :=$(tc)_$(seed)

ifeq ($(fsdb),on)
wave_file := $(mode)/wave
USER_RUN_OPTS += +fsdbfile+$(wave_file)/$(wave_name).fsdb -ucli -do ../tc/wave_fsdb.do

endif

USER_RUN_OPTS += +UVM_TESTNAME=$(tc) +UVM_VERBOSITY=${pl} +ntb_random_seed=${seed}
USER_VERDI_OPTS += -dbdir ./$(mode)/exec/simv.daidir

export SHELL =/bin/csh -f



mkdir:
	if ( ! -e "${mode}" ) mkdir ${mode}
	if ( ! -e "${mode}/logs" ) mkdir ${mode}/logs
	if ( ! -e "${mode}/wave" ) mkdir ${mode}/wave
	if ( ! -e "${mode}/exec" ) mkdir ${mode}/exec
	if ( ! -e "${mode}/cov" ) mkdir ${mode}/cov

comp:
	vcs ${USER_COMP_OPTS} ${UVM_DIR}  -f ${RTL_F} -f ${TB_F} -l ./${mode}/logs/vcs_compiler.log
comp: mkdir comp

ncrun:
	./${mode}/exec/simv  +permissive ${USER_RUN_OPTS} -sv_liblist ${SPIKE_F}  +permissive-off  ${instr_name} -l ./${mode}/logs/${wave_name}.log


run: comp ncrun

clean:
	rm -rf  verdiLog  *fsdb* *log novas* csrc ucli.key vc_hdrs.h ./${mode}/exec
verdi:
	verdi ${USER_VERDI_OPTS}&
