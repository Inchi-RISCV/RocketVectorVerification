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
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit 			word_idx_t;
		bit [1:0]	bank_idx_t;
		bit [2:0]	row_offset_t;
		bit load_en;
		bit store_en;
		bit is_mmio_range;
		bit noAlloc;
		bit [7:0] req_source;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)
		
		load_en = vmm_opts::get_int("load_en", 0, "load_en");
		store_en = vmm_opts::get_int("store_en", 0, "store_en");
		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		noAlloc = vmm_opts::get_int("noAlloc", 0, "noAlloc");

		//TODO:
		length 			= 20;
		req_source	= $urandom_range(3);
		if(is_mmio_range) begin
			tag_idx_t 	= 'h3_0000;
		end
		else begin
			tag_idx_t 	= 'h4_0000;
		end

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);
		
		for(int i=0;i<length;i++)begin
			backdoor_put_data(addr_t+'h40*i,6,{16{'h76543210}}+i);
	  end

		//load miss: NtoB
		for(int i=0;i<length;i++)begin
			dcache_load(req_source,addr_t+'h40*i,,,noAlloc);
		end

		//load hit: BtoB
		if(load_en) begin
			for(int i=0;i<length;i++)begin
				dcache_load(req_source,addr_t+'h40*i);
			end
		end

		//store miss: BtoT
		if(store_en) begin
			for(int i=0;i<length;i++)begin
				dcache_store(req_source,addr_t+'h40*i,{16{'habababa0}}+i);
			end
		end

  endtask

endclass : dcache_load_sequence

`endif
