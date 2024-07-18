//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :tb_top.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef RESET_DELAY
 `define RESET_DELAY 777.7
`endif

 `define  CLOCK_PERIOD 1.0

module tb_top();

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  //import instr_pkg::*;
  //import data_pkg::*;
  //import vpu_test_pkg::*;
  //import vpu_env_pkg::*;
  reg clock ;
  reg reset ;
  reg success;
	string spike_instr_name;
	string dut_instr_name;
  
  ///////////////////////// 
  `include "dut_instance.sv"
  ///////////////////////// 
  // Example clock and reset declarations

	initial begin
		clock = 0;
		reset = 1;
		//#10
		//reset = 0;
		//#10 
		//reset = 1;
 		#(`RESET_DELAY)
		reset = 0;
		if ($value$plusargs("DUT_INSTR_NAME=%s",dut_instr_name)) begin
		  `uvm_info("tb_top",$sformatf(" dut init instr = %s\n ",dut_instr_name),UVM_NONE)    
			$display("Current working directory: %0s", $system("pwd"));;

			$readmemh(dut_instr_name,tb_top.testHarness.mem.srams.mem.mem_ext.ram);
			//$readmemh("../tc/sequence/bin_2_try/hex/vadd.vv_10001.hex",tb_top.testHarness.mem.srams.mem.mem_ext.ram);
		end
	end


	initial begin
    	//spike_init("../tc/sequence/rv64ui-p-add");
			
			//spike_init("../tc/sequence/riscv_floating_point_arithmetic_test_0");
    //`ifdef SPIKE_INSTR
    //  `uvm_info("tb_top",$sformatf(" spike init instr = %s\n ",`SPIKE_INSTR),UVM_NONE);
		//`else
	  //  `uvm_error("tb_top",$sformatf(" no spike instr "));
		//`endif
		//inchi_difftest_init();
		//inchi_difftest_memcpy(`SPIKE_INSTR);

		
		if ($value$plusargs("SPIKE_INSTR_NAME=%s",spike_instr_name)) begin
		  `uvm_info("tb_top",$sformatf(" spike init instr = %s\n ",spike_instr_name),UVM_NONE);
		  inchi_difftest_init();
		  inchi_difftest_memcpy(spike_instr_name);
		end


	end

  instr_if m_instr_if();

  data_if m_data_if(clock,reset);


  initial begin
    #(`CLOCK_PERIOD/2); // No clock edge at T=0
    clock = 0 ;
    forever begin
      #(`CLOCK_PERIOD/2)
      clock = ~clock ;
    end
  end



  initial
  begin
    uvm_config_db #(virtual instr_if)::set(null, "*", "instr_vif", m_instr_if);

    uvm_config_db #(virtual data_if)::set(null, "*", "data_vif", m_data_if);

  end

//initial begin
//#1us;
//$readmemh("/datahdd/riscv/sunjiawen/rocketverification/vpu/sim1/hex_file/vadd.vv_10001.hex",tb_top.testHarness.mem.srams.mem.mem_ext.ram);
//
//end

  initial
  begin
    run_test();
  end

endmodule

