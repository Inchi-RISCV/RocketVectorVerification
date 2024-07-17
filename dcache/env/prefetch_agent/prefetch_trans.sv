//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_trans.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_TRANS_SV_
`define _PREFETCH_TRANS_SV_

class prefetch_trans extends uvm_sequence_item; 
  `uvm_object_utils(prefetch_trans)

  extern function new(string name = "prefetch_trans");

endclass : prefetch_trans

function prefetch_trans::new(string name = "prefetch_trans");
  super.new(name);
endfunction : new

`endif // PREFETCH_TRANS_SV

