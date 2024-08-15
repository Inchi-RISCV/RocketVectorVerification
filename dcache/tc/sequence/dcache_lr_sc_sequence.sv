//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_lr_sc_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_lr_sc_sequence_SV_
`define _dcache_lr_sc_sequence_SV_

class dcache_lr_sc_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_lr_sc_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_lr_sc_sequence");
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
		bit [2:0]	size_t;
		bit is_mmio_range;
		bit [7:0] req_source;
		
	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		
		//TODO:
		length 			= 20;
		size_t 			= $urandom_range(2,3);
		req_source 	= $urandom_range(3);
		if(is_mmio_range) begin
			tag_idx_t 	= 'h3_0000;
		end
		else begin
			tag_idx_t 	= 'h4_0000;
		end

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);

		for(int i=0;i<length;i++)begin
			dcache_sc(req_source,addr_t+(2**size_t)*i,{16{'hffff_1111}}+i,size_t); 	//sc miss fail
			dcache_lr(req_source,addr_t+(2**size_t)*i+'h2000,size_t);
			dcache_lr(req_source,addr_t+(2**size_t)*i,size_t);
			dcache_sc(req_source,addr_t+(2**size_t)*i,{16{'hffff_2222}}+i,size_t);	//sc hit success
			dcache_sc(req_source,addr_t+(2**size_t)*i,{16{'hffff_3333}}+i,size_t);	//sc hit fail
		end
		
  endtask

endclass : dcache_lr_sc_sequence

`endif
