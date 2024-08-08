//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :tb_top.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`timescale 1ns/10ps

`include "uvm_macros.svh"
`include "svt_tilelink.uvm.pkg"


`define  CLOCK_PERIOD 1.0

module tb_top();


  import uvm_pkg::*;
  // Import the VIP
  import svt_tilelink_uvm_pkg::*;

  logic clock;

  logic reset;

  initial begin
    #(`CLOCK_PERIOD/2); // No clock edge at T=0
    clock = 0 ;
    forever begin
      #(`CLOCK_PERIOD/2)
      clock = ~clock ;
    end
  end

  initial begin
	  reset = 1;
 	  #150ns
	  reset = 0;   
	end

  lsu_if m_lsu_if(clock,reset);

  prefetch_if m_prefetch_if(clock,reset);

  svt_tilelink_master_if  tilelink_master_if[1] (clock);
  svt_tilelink_slave_if   tilelink_slave_if[1] (clock);

	assign tilelink_master_if[0].tl_reset = reset;
	assign tilelink_slave_if[0].tl_reset = reset;
  ///////////////////////// 
  `include "dut_instance.sv"
  ///////////////////////// 
  // Example clock and reset declarations


  initial
  begin
    uvm_config_db #(virtual lsu_if)::set(null, "*", "lsu_vif", m_lsu_if);

    uvm_config_db #(virtual prefetch_if)::set(null, "*", "prefetch_vif", m_prefetch_if);
		
    /** Provide the SV interface to the TILELINK ENV.
    */
    uvm_config_db#(svt_tilelink_master_vif)::set(uvm_root::get(), "uvm_test_top.m_env.tl_env","tilelink_master_if[0]", tilelink_master_if[0]);
    uvm_config_db#(svt_tilelink_slave_vif)::set(uvm_root::get(), "uvm_test_top.m_env.tl_env","tilelink_slave_if[0]", tilelink_slave_if[0]);


  end

  initial
  begin
		$timeformat(-9,3,"ns",10);
    run_test();
  end



always @(tilelink_slave_if[0].a_opcode   )  tilelink_master_if[0].a_opcode   =  tilelink_slave_if[0].a_opcode;
always @(tilelink_slave_if[0].a_param    )  tilelink_master_if[0].a_param    =  tilelink_slave_if[0].a_param;
always @(tilelink_slave_if[0].a_size     )  tilelink_master_if[0].a_size     =  tilelink_slave_if[0].a_size; 
always @(tilelink_slave_if[0].a_source   )  tilelink_master_if[0].a_source   =  tilelink_slave_if[0].a_source;
always @(tilelink_slave_if[0].a_address  )  tilelink_master_if[0].a_address  =  tilelink_slave_if[0].a_address;
always @(tilelink_slave_if[0].a_mask     )  tilelink_master_if[0].a_mask     =  tilelink_slave_if[0].a_mask;
always @(tilelink_slave_if[0].a_data     )  tilelink_master_if[0].a_data     =  tilelink_slave_if[0].a_data;
always @(tilelink_slave_if[0].a_corrupt  )  tilelink_master_if[0].a_corrupt  =  tilelink_slave_if[0].a_corrupt;
always @(tilelink_slave_if[0].a_valid    )  tilelink_master_if[0].a_valid    =  tilelink_slave_if[0].a_valid;
always @(tilelink_slave_if[0].c_opcode   )  tilelink_master_if[0].c_opcode   =  tilelink_slave_if[0].c_opcode;
always @(tilelink_slave_if[0].c_param    )  tilelink_master_if[0].c_param    =  tilelink_slave_if[0].c_param;
always @(tilelink_slave_if[0].c_size     )  tilelink_master_if[0].c_size     =  tilelink_slave_if[0].c_size;
always @(tilelink_slave_if[0].c_source   )  tilelink_master_if[0].c_source   =  tilelink_slave_if[0].c_source;
always @(tilelink_slave_if[0].c_address  )  tilelink_master_if[0].c_address  =  tilelink_slave_if[0].c_address;
always @(tilelink_slave_if[0].c_data     )  tilelink_master_if[0].c_data     =  tilelink_slave_if[0].c_data;
always @(tilelink_slave_if[0].c_corrupt  )  tilelink_master_if[0].c_corrupt  =  tilelink_slave_if[0].c_corrupt; 
always @(tilelink_slave_if[0].c_valid    )  tilelink_master_if[0].c_valid    =  tilelink_slave_if[0].c_valid;
always @(tilelink_slave_if[0].e_sink     )  tilelink_master_if[0].e_sink     =  tilelink_slave_if[0].e_sink; 
always @(tilelink_slave_if[0].e_valid    )  tilelink_master_if[0].e_valid    =  tilelink_slave_if[0].e_valid;
always @(tilelink_slave_if[0].b_ready    )  tilelink_master_if[0].b_ready    =  tilelink_slave_if[0].b_ready;
always @(tilelink_slave_if[0].d_ready    )  tilelink_master_if[0].d_ready    =  tilelink_slave_if[0].d_ready;
always @(tilelink_slave_if[0].b_opcode   )  tilelink_master_if[0].b_opcode   =  tilelink_slave_if[0].b_opcode;
always @(tilelink_slave_if[0].b_param    )  tilelink_master_if[0].b_param    =  tilelink_slave_if[0].b_param;
always @(tilelink_slave_if[0].b_size     )  tilelink_master_if[0].b_size     =  tilelink_slave_if[0].b_size;
always @(tilelink_slave_if[0].b_source   )  tilelink_master_if[0].b_source   =  tilelink_slave_if[0].b_source;
always @(tilelink_slave_if[0].b_address  )  tilelink_master_if[0].b_address  =  tilelink_slave_if[0].b_address;
always @(tilelink_slave_if[0].b_mask     )  tilelink_master_if[0].b_mask     =  tilelink_slave_if[0].b_mask;
always @(tilelink_slave_if[0].b_data     )  tilelink_master_if[0].b_data     =  tilelink_slave_if[0].b_data;
always @(tilelink_slave_if[0].b_corrupt  )  tilelink_master_if[0].b_corrupt  =  tilelink_slave_if[0].b_corrupt;
always @(tilelink_slave_if[0].b_valid    )  tilelink_master_if[0].b_valid    =  tilelink_slave_if[0].b_valid;
always @(tilelink_slave_if[0].d_opcode   )  tilelink_master_if[0].d_opcode   =  tilelink_slave_if[0].d_opcode;
always @(tilelink_slave_if[0].d_param    )  tilelink_master_if[0].d_param    =  tilelink_slave_if[0].d_param;
always @(tilelink_slave_if[0].d_size     )  tilelink_master_if[0].d_size     =  tilelink_slave_if[0].d_size;
always @(tilelink_slave_if[0].d_source   )  tilelink_master_if[0].d_source   =  tilelink_slave_if[0].d_source;
always @(tilelink_slave_if[0].d_sink     )  tilelink_master_if[0].d_sink     =  tilelink_slave_if[0].d_sink;
always @(tilelink_slave_if[0].d_denied   )  tilelink_master_if[0].d_denied   =  tilelink_slave_if[0].d_denied;
always @(tilelink_slave_if[0].d_data     )  tilelink_master_if[0].d_data     =  tilelink_slave_if[0].d_data;
always @(tilelink_slave_if[0].d_corrupt  )  tilelink_master_if[0].d_corrupt  =  tilelink_slave_if[0].d_corrupt; 
always @(tilelink_slave_if[0].d_valid    )  tilelink_master_if[0].d_valid    =  tilelink_slave_if[0].d_valid;
always @(tilelink_slave_if[0].a_ready    )  tilelink_master_if[0].a_ready    =  tilelink_slave_if[0].a_ready;
always @(tilelink_slave_if[0].c_ready    )  tilelink_master_if[0].c_ready    =  tilelink_slave_if[0].c_ready;
always @(tilelink_slave_if[0].e_ready    )  tilelink_master_if[0].e_ready    =  tilelink_slave_if[0].e_ready;

endmodule

