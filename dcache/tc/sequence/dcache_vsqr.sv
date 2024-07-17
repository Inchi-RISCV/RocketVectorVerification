//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_vsqr.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_VSEQUENCER_SV_
`define _DCACHE_VSEQUENCER_SV_

class dcache_vsqr extends uvm_sequencer;
  `uvm_component_utils(dcache_vsqr)

	lsu_sequencer lsu_sqr;
	tilelink_virtual_sequencer tilelink_sqr;

  extern function new(string name, uvm_component parent);

endclass : dcache_vsqr 

function dcache_vsqr::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

`endif // LSU_SEQUENCER_SV


