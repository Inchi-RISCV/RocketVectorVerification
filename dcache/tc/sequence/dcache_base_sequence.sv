//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_base_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_BASE_SEQUENCE_SV_
`define _DCACHE_BASE_SEQUENCE_SV_

class dcache_base_sequence extends uvm_sequence;
  `uvm_object_utils(dcache_base_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	tilelink_uvm_env m_env;
	uvm_component        m_component;


  function new(string name = "dcache_base_sequence");
    super.new(name);
  endfunction
	extern task backdoor_get_data(input bit[63:0] address, input bit[`SVT_TILELINK_SIZE_WIDTH-1:0] size,output bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_out);
  extern task backdoor_put_data(input bit[63:0] address, input bit[`SVT_TILELINK_SIZE_WIDTH-1:0] size,input bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_in);
  
	extern task dcache_random_cfg(
		output bit [38:0] addr,
		input bit [26:0] tag_idx,
		input bit [6:0] set_idx,
		input bit word_idx = 0,
		input bit [1:0]	bank_idx = 0,
		input bit [2:0]	row_offset = 0
	);

	extern task dcache_load(
		input bit [38:0]  addr,
		input bit [2:0]   req_size = 6,
  	input bit         req_signed = 0,
  	input bit         req_noAlloc = 0,
  	input bit         s1_kill = 0
	);

	extern task dcache_store(
		input bit [38:0]  addr,
		input bit [511:0] req_wdata,
		input bit [2:0]   req_size = 6,
  	input bit         req_noAlloc = 0
	);

	extern task dcache_partial_mask_store(
		input bit [38:0]  addr,
		input bit [511:0] req_wdata,
		input bit [63:0] 	req_wmask,
  	input bit         req_noAlloc = 0
	);

	extern task dcache_lr(
		input bit [38:0]  addr,
		input bit [2:0]   req_size
	);

	extern task dcache_sc(
		input bit [38:0]  addr,
		input bit [511:0] req_wdata,
		input bit [2:0]   req_size
	);

	extern task dcache_amo_operation(
		input bit [4:0]  	req_cmd,
		input bit [38:0]  addr,
		input bit [511:0] req_wdata,
		input bit [2:0]   req_size,
  	input bit         req_noAlloc = 0
	);
	
	extern task dcache_prefetch_read(
		input bit [38:0]  addr
	);

	extern task dcache_prefetch_write(
		input bit [38:0]  addr
	);

	extern task tilelink_chnlB_probeblock(
		input bit [38:0] tl_b_address,
		input bit [1:0] tl_b_param	
	);

  virtual task body();	  	
		wait(!tb_top.reset) 	//wait meta array init
		#200ns;
  endtask


endclass : dcache_base_sequence

/*Task to access backdoor data from memory*/
task dcache_base_sequence::backdoor_get_data(input bit[63:0] address, input bit[`SVT_TILELINK_SIZE_WIDTH-1:0] size,output bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_out);
  
	m_component = p_sequencer.tilelink_sqr.get_parent();
	//`uvm_info(get_type_name(),$sformatf("m_component is %s",m_component.get_full_name()),UVM_NONE);
	$cast(m_env,m_component);

  //Passing address and size to backdoor access function 
  m_env.sys_env.slave[0].backdoor_access_data(address,size);
  //collecting data from backdoor queue
  foreach(m_env.sys_env.slave[0].slave_backdoor_queue[i])
    data_out[(i*8)+:8] = m_env.sys_env.slave[0].slave_backdoor_queue[i];
	`uvm_info(get_type_name(),$sformatf("backdoor_get_data size=%0h,addr=%0h,data=%0h",size,address,data_out),UVM_NONE);
endtask

/*Task to write backdoor data into memory*/
task dcache_base_sequence::backdoor_put_data(input bit[63:0] address, input bit[`SVT_TILELINK_SIZE_WIDTH-1:0] size,input bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_in);
	
	m_component = p_sequencer.tilelink_sqr.get_parent();
	//`uvm_info(get_type_name(),$sformatf("m_component is %s",m_component.get_full_name()),UVM_NONE);
	$cast(m_env,m_component);

  //Passing address and size to backdoor write function 
  m_env.sys_env.slave[0].backdoor_write_data(address,size,data_in);
	`uvm_info(get_type_name(),$sformatf("backdoor_put_data size=%0h,addr=%0h,data=%0h",size,address,data_in),UVM_NONE);
endtask

task dcache_base_sequence::dcache_random_cfg(
	output bit [38:0] addr,
	input bit [26:0] tag_idx,
	input bit [6:0] set_idx,
	input bit word_idx,
	input bit [1:0]	bank_idx,
	input bit [2:0]	row_offset
	);

	addr[38:13]		= tag_idx;
	addr[12:6]		= set_idx;
	addr[5]				= word_idx;
	addr[4:3]			= bank_idx;
	addr[2:0]			= row_offset;

	`uvm_info("RANDOM_CFG",$sformatf("initial addr = %0h, tag_idx = %0h, set_idx = %0d, word_idx = %0d, bank_idx = %0d, row_offset = %0d", addr, tag_idx, set_idx, word_idx, bank_idx, row_offset),UVM_LOW);

endtask

task dcache_base_sequence::dcache_load(
	input bit [38:0]  addr,
	input bit [2:0]   req_size = 6,
  input bit         req_signed = 0,
  input bit         req_noAlloc = 0,
	input bit         s1_kill = 0
	);
 
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   			<= 	3;
		seq.io_req_bits_cmd      			==	lsu_trans::M_XRD;
    seq.io_req_bits_paddr				 	==	addr;
    seq.io_req_bits_size     			==	req_size;	
    seq.io_req_bits_signed   			== 	req_signed;
    seq.io_req_bits_noAlloc  			==	req_noAlloc;
  	seq.io_s1_kill								== 	s1_kill;
		})

endtask

task dcache_base_sequence::dcache_store(
	input bit [38:0]  addr,
	input bit [511:0] req_wdata,
	input bit [2:0]   req_size = 6,
  input bit         req_noAlloc = 0
	);
 
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   		<= 	3;
		seq.io_req_bits_cmd      		==	lsu_trans::M_XWR;
		seq.io_req_bits_paddr			 	==	addr;
		seq.io_req_bits_wdata    		==	req_wdata;
    seq.io_req_bits_size     		==	req_size;	
    seq.io_req_bits_noAlloc  		==	req_noAlloc;
  	seq.io_s1_kill							== 	'h0;	
		})
		
endtask

task dcache_base_sequence::dcache_partial_mask_store(
	input bit [38:0]  addr,
	input bit [511:0] req_wdata,
	input bit [63:0] 	req_wmask,
  input bit         req_noAlloc = 0
	);
	
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   		<= 	3;
		seq.io_req_bits_cmd      		==	lsu_trans::M_PWR;
		seq.io_req_bits_paddr			 	==	addr;
		seq.io_req_bits_wdata    		==	req_wdata;
    seq.io_req_bits_wmask    		==	req_wmask;
    seq.io_req_bits_size     		==	6;	
    seq.io_req_bits_noAlloc  		==	req_noAlloc;
  	seq.io_s1_kill							== 	'h0;	
		})

endtask

task dcache_base_sequence::dcache_lr(
	input bit [38:0]  addr,
	input bit [2:0]   req_size
	);
	
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   		<= 	1; 	//only support scalar
		seq.io_req_bits_cmd      		==	lsu_trans::M_XLR;
		seq.io_req_bits_paddr			 	==	addr;
    seq.io_req_bits_size     		==	req_size;
		seq.io_req_bits_signed   		== 	1;
    seq.io_req_bits_noAlloc  		==	0;
  	seq.io_s1_kill							== 	'h0;	
		})

endtask

task dcache_base_sequence::dcache_sc(
	input bit [38:0]  addr,
	input bit [511:0] req_wdata,
	input bit [2:0]   req_size
	);
	
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   		<= 	1; 	//only support scalar
		seq.io_req_bits_cmd      		==	lsu_trans::M_XSC;
		seq.io_req_bits_paddr			 	==	addr;
		seq.io_req_bits_wdata    		==	req_wdata;
    seq.io_req_bits_size     		==	req_size;
    seq.io_req_bits_noAlloc  		==	0;
  	seq.io_s1_kill							== 	'h0;	
		})

endtask

task dcache_base_sequence::dcache_amo_operation(
	input bit [4:0]  	req_cmd,
	input bit [38:0]  addr,
	input bit [511:0] req_wdata,
	input bit [2:0]   req_size,
  input bit         req_noAlloc = 0
	);
	
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   		<= 	3;
		seq.io_req_bits_cmd      		==	req_cmd;
		seq.io_req_bits_paddr			 	==	addr;
		seq.io_req_bits_wdata    		==	req_wdata;
    seq.io_req_bits_size     		==	req_size;
		seq.io_req_bits_signed   		== 	1;
    seq.io_req_bits_noAlloc  		==	req_noAlloc;
  	seq.io_s1_kill							== 	'h0;	
		})

endtask

task dcache_base_sequence::dcache_prefetch_read(
	input bit [38:0]  addr
	);
 
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   			<= 	3;
		seq.io_req_bits_cmd      			==	lsu_trans::M_PFR;
    seq.io_req_bits_paddr				 	==	addr;
    seq.io_req_bits_size     			<=	6;	
    seq.io_req_bits_signed   			== 	'h0;
    seq.io_req_bits_noAlloc  			==	'h0;
  	seq.io_s1_kill								== 	'h0;
		})

endtask

task dcache_base_sequence::dcache_prefetch_write(
	input bit [38:0]  addr
	);
 
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   			<= 	3;
		seq.io_req_bits_cmd      			==	lsu_trans::M_PFW;
    seq.io_req_bits_paddr				 	==	addr;
    seq.io_req_bits_size     			<=	6;	
    seq.io_req_bits_signed   			== 	'h0;
    seq.io_req_bits_noAlloc  			==	'h0;
  	seq.io_s1_kill								== 	'h0;
		})

endtask

task dcache_base_sequence::tilelink_chnlB_probeblock(
	input bit [38:0] tl_b_address,
	input bit [1:0] tl_b_param	
	);

	svt_tilelink_slave_transaction tr;

	`svt_xvm_create_on(tr,p_sequencer.tilelink_sqr.slave_sequencer[0])
	
	if(!tr.randomize() with {
															tr.drive_chnl_B 		== 1;
                              tr.ch_b_msg_type 		== svt_tilelink_slave_transaction::CH_B_PROBE_BLOCK; 
                              tr.b_param 					== tl_b_param;
                              tr.b_size 					== 6;
                              tr.b_source 				<= 31;
                              tr.b_address 				==	tl_b_address;
															//tr.b_mask[0] 				== 'hffff_ffff_ffff_ffff;
	}) `uvm_error("Randomization Failure","tilelink_slave_base_sequence")
	
	`svt_xvm_send(tr)

	get_response(rsp);

endtask

`endif
