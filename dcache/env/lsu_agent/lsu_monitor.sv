//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_monitor.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_MONITOR_SV_
`define _LSU_MONITOR_SV_

`define DELAY 0.01ns

class lsu_monitor extends uvm_monitor;
  `uvm_component_utils(lsu_monitor)

  virtual interface  lsu_if vif;

  uvm_analysis_port #(lsu_trans) analysis_port;

  lsu_trans m_trans;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_mon();

endclass : lsu_monitor 

function lsu_monitor::new(string name, uvm_component parent);

  super.new(name, parent);
  analysis_port = new("analysis_port", this);

endfunction : new

function void lsu_monitor::build_phase(uvm_phase phase);

  super.build_phase(phase);

endfunction : build_phase

function void lsu_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual lsu_if)::get(this, "*", "lsu_vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task lsu_monitor::main_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

  m_trans = lsu_trans::type_id::create("m_trans");
  do_mon();

endtask : main_phase

task lsu_monitor::do_mon();
	forever begin
		@(posedge vif.clk)
		if(vif.io_req_valid)begin
      m_trans.io_req_bits_source    <= #`DELAY vif.io_req_bits_source;
      m_trans.io_req_bits_paddr     <= #`DELAY vif.io_req_bits_paddr;
      m_trans.io_req_bits_cmd       <= #`DELAY vif.io_req_bits_cmd;  
      m_trans.io_req_bits_size      <= #`DELAY vif.io_req_bits_size;	
      m_trans.io_req_bits_signed    <= #`DELAY vif.io_req_bits_signed;
      m_trans.io_req_bits_wdata     <= #`DELAY vif.io_req_bits_wdata;	
      m_trans.io_req_bits_wmask     <= #`DELAY vif.io_req_bits_wmask;	
      m_trans.io_req_bits_noAlloc   <= #`DELAY vif.io_req_bits_noAlloc;
      m_trans.io_req_bits_dest      <= #`DELAY vif.io_req_bits_dest;	
      m_trans.io_req_bits_isRefill  <= #`DELAY vif.io_req_bits_isRefill;	
      m_trans.io_req_bits_refillWay <= #`DELAY vif.io_req_bits_refillWay;	
      m_trans.io_req_bits_refillCoh <= #`DELAY vif.io_req_bits_refillCoh;	
      m_trans.io_s0_kill            <= #`DELAY vif.io_s0_kill;
      m_trans.io_s1_kill            <= #`DELAY vif.io_s1_kill;
			analysis_port.write(m_trans);
		end

	end

endtask : do_mon

`endif // LSU_MONITOR_SV


