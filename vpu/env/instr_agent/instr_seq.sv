//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_seq.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_SEQ_SV_
`define _INSTR_SEQ_SV_

class instr_seq extends uvm_sequence #(instr_trans);
  `uvm_object_utils(instr_seq)

  function new(string name = "instr_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
    if (starting_phase != null)
    starting_phase.raise_objection(this, {"Running sequence '",
                                          get_full_name(), "'"});

  endtask

  virtual task post_body();
    if (starting_phase != null)
    starting_phase.drop_objection(this, {"Completed sequence '",
                                         get_full_name(), "'"});

  endtask

  extern task body();

endclass : instr_seq

task instr_seq::body();

  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)


  req = instr_trans::type_id::create("req");

  start_item(req); 

  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)

endtask : body

//-------------------------------------------------------------------------

`endif
