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
  import lsu_pkg::*;
  import prefetch_pkg::*;


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

endmodule

