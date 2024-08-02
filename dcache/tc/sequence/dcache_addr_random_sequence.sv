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
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit 			word_idx_t;
		bit [1:0]	bank_idx_t;
		bit [2:0]	row_offset_t;
		bit [7:0] req_source;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		//TODO:
		req_source 	= $urandom_range(3);
		tag_idx_t = 'h4_0000;

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);

		for(int j=0;j<4;j++)begin 	//4 way
			for(int i=0;i<128;i++)begin	//128 set
				backdoor_put_data(addr_t+'h40*i+'h2000*j,6,{16{'h76543210}}+i);
	  	end
		end

		for(int j=0;j<4;j++)begin 	//4 way
			for(int i=0;i<128;i++)begin	//128 set
				dcache_load(req_source,addr_t+'h40*i+'h2000*j);
			end
		end

  endtask

endclass : dcache_addr_random_sequence

`endif
