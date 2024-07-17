//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_sequencer.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_SEQUENCER_SV_
`define _LSU_SEQUENCER_SV_

class lsu_sequencer extends uvm_sequencer #(lsu_trans);
  `uvm_component_utils(lsu_sequencer)

  extern function new(string name, uvm_component parent);

endclass : lsu_sequencer 

function lsu_sequencer::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

`endif // LSU_SEQUENCER_SV


