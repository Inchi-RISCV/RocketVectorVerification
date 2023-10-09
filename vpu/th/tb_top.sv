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
   
	end


	initial begin
    	//spike_init("../tc/sequence/rv64uf-p-move");
			spike_init("../tc/sequence/riscv_floating_point_arithmetic_test_0");
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

  initial
  begin
    run_test();
  end

endmodule

