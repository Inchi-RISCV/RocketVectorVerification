//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_sequencer.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_SEQUENCER_SV_
`define _PREFETCH_SEQUENCER_SV_

class prefetch_sequencer extends uvm_sequencer #(prefetch_trans);
  `uvm_component_utils(prefetch_sequencer)

  extern function new(string name, uvm_component parent);

endclass : prefetch_sequencer 

function prefetch_sequencer::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

`endif // PREFETCH_SEQUENCER_SV


