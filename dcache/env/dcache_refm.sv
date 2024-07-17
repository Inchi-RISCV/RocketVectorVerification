//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_refm.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_REFM_SV_
`define _DCACHE_REFM_SV_

class dcache_refm extends uvm_component;
  `uvm_component_utils(dcache_refm)

//    uvm_analysis_imp#(uart_seq_item) uart_imp;

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);

endclass : dcache_refm 

function dcache_refm::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

task dcache_refm::main_phase(uvm_phase phase);


endtask : main_phase

`endif // DCACHE_REFM_SV


