//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_load_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_load_sequence_SV_
`define _dcache_load_sequence_SV_

class dcache_load_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_load_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_load_sequence");
    super.new(name);
  endfunction

  virtual task body();
		int length;
		bit [38:0] addr;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache load sequence starting", UVM_NONE)

		dcache_random_cfg(length,addr);

		for(int i=0;i<length;i++)begin
			backdoor_put_data(addr+'h40*i,6,'ha5a5a5a5_a5a5a5a5+i);
	  end

		for(int i=0;i<length;i++)begin
			dcache_load(0,addr+'h40*i);
		end
		
  endtask

endclass : dcache_load_sequence

`endif
