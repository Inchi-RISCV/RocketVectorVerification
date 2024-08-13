UVM_HOME = $(VCS_HOME)/etc/uvm-1.2
UVM_DIR = +incdir+$(UVM_HOME) $(UVM_HOME)/uvm.sv $(UVM_HOME)/dpi/uvm_dpi.cc
TB_PATH = ../../
TB_F = ../cfg/tb.f
RTL_F = ../cfg/dut.f
pl := UVM_LOW
seed := 1
mode = base_func
tc := dcache_sanity_test
cfg := empty

USER_COMP_OPTS := -full64  -cc gcc-5 -LDFLAGS -Wl,--no-as-needed +v2k -sverilog -timescale=1ns/10ps \
	                -debug_access+all -kdb  -CFLAGS -DVCS +vcs+lic+wait -lca -ntb_opts rvm +libext+.v+.V+.sv+.svh


USER_COMP_OPTS += -Mdir=./${mode}/exec/csrc -o ./${mode}/exec/simv \
	                 +define+UVM_PACKER_MAX_BYTES=1500000 +define+UVM_DISABLE_AUTO_ITEM_RECORDING \
                   +define+SYNOPSYS_SV +define+SVT_UVM_INCLUDE_USER_DEFINES+define+SVT_TILELINK_SINK_WIDTH=3

USER_RUN_OPTS := 1
USER_VERDI_OPTS := 1

USER_COMP_OPTS += +define+WAVES_FSDB +define+WAVES="fsdb"

fsdb :=on
wave_name :=$(tc)_$(seed)

ifeq ($(fsdb),on)
wave_file := $(mode)/wave
USER_RUN_OPTS += +fsdbfile+$(wave_file)/$(wave_name).fsdb -ucli -do ../tc/wave_fsdb.do
endif

USER_RUN_OPTS += +UVM_TESTNAME=$(tc) +UVM_VERBOSITY=${pl} +ntb_random_seed=${seed}
USER_RUN_OPTS += +vmm_opts_file+../tc/cfg/$(cfg).cfg
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
	./${mode}/exec/simv   ${USER_RUN_OPTS}  -l ./${mode}/logs/${wave_name}.log

run: comp ncrun

clean:
	rm -rf  verdiLog  *fsdb* *log novas* csrc ucli.key vc_hdrs.h ./${mode}/exec
verdi:
	verdi ${USER_VERDI_OPTS}&
