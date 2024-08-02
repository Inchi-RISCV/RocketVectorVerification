//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_partial_mask_store_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_partial_mask_store_sequence_SV_
`define _dcache_partial_mask_store_sequence_SV_

class dcache_partial_mask_store_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_partial_mask_store_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_partial_mask_store_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] 	length;
		bit [38:0] 	addr_t;
		bit [26:0] 	tag_idx_t;
		bit [6:0] 	set_idx_t;
		bit 				word_idx_t;
		bit [1:0]		bank_idx_t;
		bit [2:0]		row_offset_t;
		bit [7:0] 	req_source;
		bit [63:0] 	req_wmask;
		bit [511:0]	wdata, exp_data;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)


		//TODO:
		length 			= 20;
		tag_idx_t 	= 'h4_0000;

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);

		for(int i=0;i<length;i++)begin
			req_source 	= $urandom_range(3);
			wdata = {16{'h76543210}}+i;
			success = std::randomize (req_wmask) with {req_wmask <= (2**(2**6))-1;};
			
			foreach(req_wmask[k]) begin
				if(req_wmask[k]) begin
					exp_data[8*k+:8] = wdata[8*k+:8];
				end
			end
			`uvm_info("yrhu debug",$sformatf("req_wmask = %0h", req_wmask),UVM_LOW);
			`uvm_info("yrhu debug",$sformatf("exp_data = %0h", exp_data),UVM_LOW);

			dcache_partial_mask_store(req_source,addr_t+'h40*i,wdata,req_wmask);
			dcache_load(req_source,addr_t+'h40*i);
		end

  endtask

endclass : dcache_partial_mask_store_sequence

`endif
