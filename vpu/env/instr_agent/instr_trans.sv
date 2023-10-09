//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_trans.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_TRANS_SV_
`define _INSTR_TRANS_SV_

class instr_trans extends uvm_sequence_item; 
  `uvm_object_utils(instr_trans)

  extern function new(string name = "instr_trans");

endclass : instr_trans

function instr_trans::new(string name = "instr_trans");
  super.new(name);
endfunction : new

`endif // INSTR_TRANS_SV

