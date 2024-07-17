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

  virtual task body();	  	

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

//-------------------------------------------------------------------------

`endif
