//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_driver.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_DRIVER_SV_
`define _INSTR_DRIVER_SV_

class instr_driver extends uvm_driver #(instr_trans);
  `uvm_component_utils(instr_driver)

  virtual interface  instr_if vif;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_drive(instr_trans req);

endclass : instr_driver

function instr_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void instr_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void instr_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual instr_if)::get(this, "*", "instr_vif", vif))
    `uvm_error("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task instr_driver::main_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

  forever
  begin
    seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), {"req item\n",req.sprint}, UVM_HIGH)

    do_drive(req);

    //$cast(rsp, req.clone());
    seq_item_port.item_done();
    # 10ns;

  end

endtask : main_phase

task instr_driver::do_drive(instr_trans req);


endtask : do_drive

`endif // INSTR_DRIVER_SV


