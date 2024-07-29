//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_addr_random_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_addr_random_sequence_SV_
`define _dcache_addr_random_sequence_SV_

class dcache_addr_random_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_addr_random_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_addr_random_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [14:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit 			word_idx_t;
		bit [1:0]	bank_idx_t;
		bit [2:0]	row_offset_t;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache load sequence starting", UVM_NONE)

		tag_idx_t = 10; 	//TODO

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);

		for(int i=0;i<tag_idx_t;i++)begin
			backdoor_put_data(addr_t+'h2000*i,6,{16{'h76543210}}+i);
	  end

		//load miss: NtoB
		for(int i=0;i<tag_idx_t;i++)begin
			dcache_load(lsu_trans::SCALAR_INT,addr_t+'h2000*i);
		end

		#200ns;

  endtask

endclass : dcache_addr_random_sequence

`endif
