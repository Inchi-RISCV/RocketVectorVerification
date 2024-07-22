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
		output int length,
		output bit [38:0] addr);

	extern task dcache_load(
		input bit [7:0]   req_source,
		input bit [38:0]  req_addr,
		input bit [2:0]   req_size = 6,
  	input bit         req_signed = 0,
  	input bit         req_noAlloc = 0);

	extern task dcache_store(
		input bit [7:0]   req_source,
		input bit [38:0]  req_addr,
		input bit [511:0] req_wdata,
  	input bit [63:0]  req_wmask = 'hffff_ffff_ffff_ffff,
		input bit [2:0]   req_size = 6,
  	input bit         req_signed = 0,
  	input bit         req_noAlloc = 0);

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
	output int length,
	output bit [38:0] addr);

	length 	= 20;			//TODO
	addr 		= 'h1000;	//TODO
	
	`uvm_info("RANDOM_CFG",$sformatf("length = %0d, initial addr = %0h", length, addr),UVM_NONE);

endtask

task dcache_base_sequence::dcache_load( 	//M_XRD
	input bit [7:0]   req_source,
	input bit [38:0]  req_addr,
	input bit [2:0]   req_size = 6,
  input bit         req_signed = 0,
  input bit         req_noAlloc = 0);
 
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   	== 	req_source;
		//seq.io_req_bits_dest     	==	req_dest;
		seq.io_req_bits_cmd      	==	'h0; 	//int load
    seq.io_req_bits_paddr    	==	req_addr;
    seq.io_req_bits_size     	==	req_size;	
    seq.io_req_bits_signed   	== 	req_signed;
    seq.io_req_bits_noAlloc  	==	req_noAlloc;
  	seq.io_s0_kill						== 	'h0;
  	seq.io_s1_kill						== 	'h0;	
		})

endtask

task dcache_base_sequence::dcache_store( 	//M_XWR
	input bit [7:0]   req_source,
	input bit [38:0]  req_addr,
	input bit [511:0] req_wdata,
  input bit [63:0]  req_wmask = 'hffff_ffff_ffff_ffff,
	input bit [2:0]   req_size = 6,
  input bit         req_signed = 0,
  input bit         req_noAlloc = 0);
 
	lsu_seq   seq;

	`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{
		seq.io_req_bits_source   	== 	req_source;
		//seq.io_req_bits_dest     	==	req_dest;
		seq.io_req_bits_cmd      	==	'h1; 	//int store
    seq.io_req_bits_paddr    	==	req_addr;
    seq.io_req_bits_wdata    	==	req_wdata;
    seq.io_req_bits_wmask    	==	req_wmask;
    seq.io_req_bits_size     	==	req_size;	
    seq.io_req_bits_signed   	== 	req_signed;
    seq.io_req_bits_noAlloc  	==	req_noAlloc;
  	seq.io_s0_kill						== 	'h0;
  	seq.io_s1_kill						== 	'h0;	
		})

endtask

`endif
