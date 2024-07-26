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
		bit [31:0] length_t;
		bit [14:0] addr_t;
		bit [1:0] way_idx_t;
		bit [6:0] set_idx_t;
		bit 			word_idx_t;
		bit [1:0]	bank_idx_t;
		bit [2:0]	row_offset_t;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache store sequence starting", UVM_NONE)

		dcache_random_cfg(length_t,addr_t,way_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);

		for(int i=0;i<length_t;i++)begin
			dcache_store(lsu_trans::SCALAR_INT,addr_t+'h40*i,{16{'h76543210}}+i);
		end
		
  endtask

endclass : dcache_store_sequence

`endif
