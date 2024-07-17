//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_driver.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_DRIVER_SV_
`define _PREFETCH_DRIVER_SV_

class prefetch_driver extends uvm_driver #(prefetch_trans);
  `uvm_component_utils(prefetch_driver)

  virtual interface  prefetch_if vif;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_drive(prefetch_trans req);

endclass : prefetch_driver

function prefetch_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void prefetch_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void prefetch_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual prefetch_if)::get(this, "*", "prefetch_vif", vif))
    `uvm_error("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task prefetch_driver::main_phase(uvm_phase phase);
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

task prefetch_driver::do_drive(prefetch_trans req);


endtask : do_drive

`endif // PREFETCH_DRIVER_SV


