//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_store_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_store_sequence_SV_
`define _dcache_store_sequence_SV_

class dcache_store_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_store_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_store_sequence");
    super.new(name);
  endfunction

  virtual task body();
		int length;
		bit [38:0] addr;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache store sequence starting", UVM_NONE)

		dcache_random_cfg(length,addr);

		for(int i=0;i<length;i++)begin
			dcache_store(0,addr+'h40*i,{16{'h12345678}}+i);
		end
		
  endtask

endclass : dcache_store_sequence

`endif
