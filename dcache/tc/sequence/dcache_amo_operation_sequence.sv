//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_amo_operation_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_amo_operation_sequence_SV_
`define _dcache_amo_operation_sequence_SV_

class dcache_amo_operation_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_amo_operation_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_amo_operation_sequence");
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
		bit [4:0] req_cmd;
		
	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		req_cmd = vmm_opts::get_int("req_cmd", 0, "req_cmd");
		
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
			backdoor_put_data(addr_t+(2**size_t)*i,size_t,{16{'hffff_1111}}+i);
			dcache_amo_operation(req_source,req_cmd,addr_t+(2**size_t)*i,{16{'hffff_2222}}+i,size_t); 	//init state: N
				
			dcache_load(req_source,addr_t+(2**size_t)*i,size_t);
			dcache_amo_operation(req_source,req_cmd,addr_t+(2**size_t)*i,{16{'hffff_3333}}+i,size_t); 	//init state: B

			dcache_store(req_source,addr_t+(2**size_t)*i,{16{'hffff_4444}}+i,size_t);
			dcache_amo_operation(req_source,req_cmd,addr_t+(2**size_t)*i,{16{'hffff_5555}}+i,size_t);		//init state: Dirty
		end

  endtask

endclass : dcache_amo_operation_sequence

`endif
