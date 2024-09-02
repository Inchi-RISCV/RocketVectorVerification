//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_reset_load_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _dcache_reset_load_sequence_SV_
`define _dcache_reset_load_sequence_SV_

class dcache_reset_load_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_reset_load_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_reset_load_sequence");
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
		length 			= 20;
		req_source	= $urandom_range(3);
		tag_idx_t 	= 'h4_0000;

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t,word_idx_t,bank_idx_t,row_offset_t);
		
		for(int i=0;i<length;i++)begin
			backdoor_put_data(addr_t+'h40*i,6,{16{'h76543210}}+i);
	  end

		for(int i=0;i<length;i++)begin
			dcache_load(req_source,addr_t+'h40*i);
		end
		#200ns;

		uvm_hdl_force("tb_top.reset",1);
		#150ns;
		uvm_hdl_force("tb_top.reset",0);
		#200ns;

		for(int i=0;i<length;i++)begin
			dcache_load(req_source,addr_t+'h40*i);
		end

  endtask

endclass : dcache_reset_load_sequence

`endif
