+incdir+../env/lsu_agent
+incdir+../env/prefetch_agent
+incdir+../env/tilelink_agent
+incdir+../th
+incdir+../env
+incdir+../tc
+incdir+../common
+incdir+../common/utils/src/verilog
+incdir+../common/utils/src/sverilog
+incdir+../common/utils/include/verilog
+incdir+../common/utils/include/sverilog



../env/lsu_agent/lsu_pkg.sv 
../env/lsu_agent/lsu_if.sv 

../env/prefetch_agent/prefetch_pkg.sv 
../env/prefetch_agent/prefetch_if.sv 

-F ../env/tilelink_agent/tilelink_agent.f

-F ../env/dcache_env.f
-F ../tc/tc.f

//../env/dcache_env_pkg.sv 
//../tc/dcache_test_pkg.sv 
../th/tb_top.sv 

