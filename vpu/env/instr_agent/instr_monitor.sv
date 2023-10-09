//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_monitor.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_MONITOR_SV_
`define _INSTR_MONITOR_SV_

class instr_monitor extends uvm_monitor;
  `uvm_component_utils(instr_monitor)

  virtual interface  instr_if vif;

  uvm_analysis_port #(instr_trans) analysis_port;

  instr_trans m_trans;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_mon();

endclass : instr_monitor 

function instr_monitor::new(string name, uvm_component parent);

  super.new(name, parent);
  analysis_port = new("analysis_port", this);

endfunction : new

function void instr_monitor::build_phase(uvm_phase phase);

  super.build_phase(phase);

endfunction : build_phase

function void instr_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual instr_if)::get(this, "*", "instr_vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task instr_monitor::main_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

  m_trans = instr_trans::type_id::create("m_trans");
  do_mon();

endtask : main_phase

task instr_monitor::do_mon();

endtask : do_mon

`endif // INSTR_MONITOR_SV


