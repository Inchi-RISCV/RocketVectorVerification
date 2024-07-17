//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_seq.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_SEQ_SV_
`define _PREFETCH_SEQ_SV_

class prefetch_seq extends uvm_sequence #(prefetch_trans);
  `uvm_object_utils(prefetch_seq)

  function new(string name = "prefetch_seq");
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

endclass : prefetch_seq

task prefetch_seq::body();

  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)


  req = prefetch_trans::type_id::create("req");

  start_item(req); 

  if ( !req.randomize() )
    `uvm_error(get_type_name(), "Failed to randomize transaction")
  finish_item(req); 

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)

endtask : body

//-------------------------------------------------------------------------

`endif
