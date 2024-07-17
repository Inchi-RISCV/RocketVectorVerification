//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_monitor.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_MONITOR_SV_
`define _PREFETCH_MONITOR_SV_

class prefetch_monitor extends uvm_monitor;
  `uvm_component_utils(prefetch_monitor)

  virtual interface  prefetch_if vif;

  uvm_analysis_port #(prefetch_trans) analysis_port;

  prefetch_trans m_trans;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_mon();

endclass : prefetch_monitor 

function prefetch_monitor::new(string name, uvm_component parent);

  super.new(name, parent);
  analysis_port = new("analysis_port", this);

endfunction : new

function void prefetch_monitor::build_phase(uvm_phase phase);

  super.build_phase(phase);

endfunction : build_phase

function void prefetch_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual prefetch_if)::get(this, "*", "prefetch_vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task prefetch_monitor::main_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

  m_trans = prefetch_trans::type_id::create("m_trans");
  do_mon();

endtask : main_phase

task prefetch_monitor::do_mon();

endtask : do_mon

`endif // PREFETCH_MONITOR_SV


