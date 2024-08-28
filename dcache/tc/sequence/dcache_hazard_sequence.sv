//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_hazard_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_hazard_sequence_SV_
`define _dcache_hazard_sequence_SV_

class dcache_hazard_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_hazard_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_hazard_sequence");
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
		bit [4:0] cmd, cmd1, cmd2;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)
		
		cmd1 = vmm_opts::get_int("cmd1", 0, "cmd1");
		cmd2 = vmm_opts::get_int("cmd2", 0, "cmd2");

		//TODO:
		length 			= 100;
		req_source	= $urandom_range(3);
		tag_idx_t 	= 'h4_0000;
		cmd 	= $urandom_range(1);

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);
		
		backdoor_put_data(addr_t,6,{16{'haaaa_0000}});

/*
		if(cmd1 == 0) begin
			dcache_load(req_source,addr_t);
		end
		else if(cmd1 == 1) begin
			dcache_store(req_source,addr_t,{16{'h76543210}});
		end

		for(int i=0;i<length;i++)begin
			if(cmd2 == 0) begin
				dcache_load(req_source,addr_t);
			end
			else if(cmd2 == 1) begin
				dcache_store(req_source,addr_t,{16{'h76543210+i}});
			end
		end
*/
		
		for(int i=0;i<length;i++)begin
			cmd 	= $urandom_range(1);
			if(cmd == 0) begin
				dcache_load(req_source,addr_t);
			end
			else if(cmd == 1) begin
				dcache_store(req_source,addr_t,{16{'h76543210+i}});
			end
		end

  endtask

endclass : dcache_hazard_sequence

`endif
