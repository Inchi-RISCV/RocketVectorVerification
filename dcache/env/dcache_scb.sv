//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_scb.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_SCB_SV_
`define _DCACHE_SCB_SV_

class dcache_scb extends uvm_component;
  `uvm_component_utils(dcache_scb)

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);

endclass : dcache_scb 

function dcache_scb::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task dcache_scb::main_phase(uvm_phase phase);

endtask : main_phase


`endif // DCACHE_SCB_SV
