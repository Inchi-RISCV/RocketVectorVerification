+incdir+../env/instr_agent
+incdir+../env/data_agent
+incdir+../th
+incdir+../env
+incdir+../tc
+incdir+../common

//../env/instr_agent/instr_pkg.sv 
-f ../env/instr_agent/instr_agent.f
../env/instr_agent/instr_if.sv 

//../env/data_agent/data_pkg.sv 
-f ../env/data_agent/data_agent.f
../env/data_agent/data_if.sv 

//../env/vpu_env_pkg.sv
-f ../env/env.f
-f ../tc/tc.f 
../th/tb_top.sv 
//../cfg/cov.cfg

