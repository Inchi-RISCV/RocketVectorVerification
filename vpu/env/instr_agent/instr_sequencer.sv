//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_sequencer.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_SEQUENCER_SV_
`define _INSTR_SEQUENCER_SV_

class instr_sequencer extends uvm_sequencer #(instr_trans);
  `uvm_component_utils(instr_sequencer)

  extern function new(string name, uvm_component parent);

endclass : instr_sequencer 

function instr_sequencer::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

`endif // INSTR_SEQUENCER_SV


