//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_refm.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_REFM_SV_
`define _VPU_REFM_SV_

class vpu_refm extends uvm_component;
  `uvm_component_utils(vpu_refm)

//    uvm_analysis_imp#(uart_seq_item) uart_imp;

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);

endclass : vpu_refm 

function vpu_refm::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

task vpu_refm::main_phase(uvm_phase phase);


endtask : main_phase

`endif // VPU_REFM_SV


