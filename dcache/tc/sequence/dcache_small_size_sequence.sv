//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_small_size_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_small_size_sequence_SV_
`define _dcache_small_size_sequence_SV_

class dcache_small_size_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_small_size_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_small_size_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [38:0] addr_t;
		bit [7:0] wdata;
		bit [511:0] wdata_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit 			word_idx_t;
		bit [1:0]	bank_idx_t;
		bit [2:0]	row_offset_t;
		bit load_en;
		bit store_en;
		bit [7:0] req_source;
		
	 	super.body(); 
    `uvm_info(get_type_name(), "dcache store sequence starting", UVM_NONE)

		load_en = vmm_opts::get_int("load_en", 0, "load_en");
		store_en = vmm_opts::get_int("store_en", 0, "store_en");

		//TODO:
		req_source 	= $urandom_range(3);
		tag_idx_t 	= 'h4_0000;

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);

		for(int j=0;j<6;j++) begin
			//store miss: NtoT
			for(int i=0;i<(64/2**j);i++)begin
				wdata = $urandom_range(255);
				wdata_t = wdata << (8*(2**j*i));
				dcache_store(req_source,addr_t+2**j*i,wdata_t,j);
				`uvm_info("yrhu debug",$sformatf("current addr = %0h", addr_t+2**j*i),UVM_LOW);
				`uvm_info("yrhu debug",$sformatf("wdata = %0h", wdata),UVM_LOW);
				`uvm_info("yrhu debug",$sformatf("wdata_t = %0h", wdata_t),UVM_LOW);
			end

			//load hit: TtoT
			for(int i=0;i<(64/2**j);i++)begin
				dcache_load(req_source,addr_t+2**j*i,j);
			end
		end
		
  endtask

endclass : dcache_small_size_sequence

`endif
