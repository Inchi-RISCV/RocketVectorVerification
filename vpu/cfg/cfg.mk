UVM_HOME = /tools/synopsys/vcs/Q-2020.03-SP2-7/etc/uvm-1.2
UVM_DIR = +incdir+$(UVM_HOME) +incdir+$(UVM_HOME)/dpi $(UVM_HOME)/uvm.sv $(UVM_HOME)/dpi/uvm_dpi.cc
TB_PATH = ../../
TB_F = ../cfg/tb.f
RTL_F = ../cfg/dut.f
SPIKE_F = ../cfg/spike.f
pl := UVM_MEDIUM
seed := 1
mode := base_func
tc := instr_test
cfg:=rv64ui-p-add
cfg_base:=$(basename $(cfg))
cfg_dir := ../tc/sequence


instr_name =$(cfg_dir)/$(cfg)


USER_COMP_OPTS := -full64  -cc gcc-5 -LDFLAGS -Wl,--no-as-needed +v2k -sverilog -timescale=1ns/10ps \
	                -debug_access+all -kdb  -CFLAGS -DVCS  +vcs+lic+wait


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
                  +define+CLOCK_PERIOD=1.0 \
                  +define+RANDOMIZE_REG_INIT \
                  +define+RANDOMIZE_GARBAGE_ASSIGN \
                  +define+RANDOMIZE_INVALID_ASSIGN \
                  +define+RANDOMIZE_DELAY=0.1 \
						      +define+FSDB+define+WAVES_FSDB+define+WAVES="fsdb"\
						      +libext+.v 

#define+RANDOMIZE_MEM_INIT \


USER_COMP_OPTS += +define+NRET=1\
						      +define+NTRAP=1\
					      	+define+XLEN=64\
					      	+define+FLEN=64\
					      	+define+VLEN=128\


#USER_RUN_OPTS := +UVM_TESTNAME=$(tc) +UVM_VERBOSITY=${pl} +ntb_random_seed=${seed} +SPIKE_INSTR_NAME=$(cfg_dir)/$(cfg).elf +DUT_INSTR_NAME=$(cfg_dir)/hex/$(cfg).hex
USER_RUN_OPTS := +UVM_TESTNAME=$(tc) +UVM_VERBOSITY=${pl} +ntb_random_seed=${seed} +SPIKE_INSTR_NAME=$(cfg_dir)/$(cfg) +DUT_INSTR_NAME=$(cfg_dir)/hex/$(cfg_base).hex
USER_VERDI_OPTS += -dbdir ./$(mode)/exec/simv.daidir

fsdb :=on
wave_name :=$(tc)_$(seed)
ifeq ($(fsdb),on)
  wave_file := $(mode)/wave
  USER_RUN_OPTS += +fsdbfile+$(wave_file)/$(wave_name).fsdb -ucli -do ../tc/wave_fsdb.do
endif

cov := on
ifeq ($(cov),on)
  cov_dir  := ./$(mode)/cov/simv
  coverage := line+cond+tgl+fsm+branch+assert
  cov_nmae := $(tc)_$(seed)
  #USER_COMP_OPTS += -cm $(coverage) -cm_dir $(cov_dir)
  USER_RUN_OPTS  += -cm $(coverage) -cm_name $(cov_nmae) 
endif

USER_COMP_OPTS += -cm $(coverage) -cm_dir $(cov_dir) -cm_hier ../cfg/cov.cfg


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
	./${mode}/exec/simv  +permissive ${USER_RUN_OPTS} -sv_liblist ${SPIKE_F}  +permissive-off  -l ./${mode}/logs/${wave_name}.log


run: comp ncrun

clean:
	rm -rf  verdiLog  *fsdb* *log novas* csrc ucli.key vc_hdrs.h ./${mode}/exec
verdi:
	verdi ${USER_VERDI_OPTS}&
