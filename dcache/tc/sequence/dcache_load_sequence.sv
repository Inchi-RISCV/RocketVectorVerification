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
		bit [31:0] length_t;
		bit [14:0] addr_t;
		bit [1:0] way_idx_t;
		bit [6:0] set_idx_t;
		bit 			word_idx_t;
		bit [1:0]	bank_idx_t;
		bit [2:0]	row_offset_t;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache load sequence starting", UVM_NONE)

		//TODO:
		//way_idx_t 			= $urandom_range(3);
		//set_idx_t 			= $urandom_range(127);
		//word_idx_t 			= $urandom_range(1);
		//bank_idx_t 			= $urandom_range(3);

		dcache_random_cfg(length_t,addr_t,way_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);
		
		for(int i=0;i<length_t;i++)begin
			backdoor_put_data(addr_t+'h40*i,6,{16{'h76543210}}+i);
	  end

		for(int i=0;i<length_t;i++)begin
			dcache_load(lsu_trans::SCALAR_INT,addr_t+'h40*i);
		end
		
  endtask

endclass : dcache_load_sequence

`endif
