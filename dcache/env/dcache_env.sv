//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_env.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_ENV_SV_
`define _DCACHE_ENV_SV_

class dcache_env extends uvm_env;

  `uvm_component_utils(dcache_env)
   uvm_tlm_analysis_fifo  #(lsu_trans) lsu2rm_fifo;
	 uvm_tlm_analysis_fifo  #(svt_tilelink_slave_transaction) rm2sb_tla_fifo;
	 uvm_tlm_analysis_fifo  #(svt_tilelink_slave_transaction) tl2sb_tla_fifo;

  
	lsu_agent m_lsu_agent; 

  prefetch_agent m_prefetch_agent; 

  tilelink_uvm_env tl_env;

	dcache_refm  m_refm;

	dcache_scb   m_scb;
	
	

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass : dcache_env 

function dcache_env::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

function void dcache_env::build_phase(uvm_phase phase);


  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  //if (!uvm_config_db #(dcache_env_config)::get(this, "", "m_env_config", m_env_config)) 
  //  `uvm_error(get_type_name(), "Unable to get dcache_env_config")
  m_lsu_agent = lsu_agent::type_id::create("m_lsu_agent", this);
  m_prefetch_agent = prefetch_agent::type_id::create("m_prefetch_agent", this);
	tl_env =  tilelink_uvm_env::type_id::create("tl_env", this);
	m_refm =  dcache_refm::type_id::create("m_refm", this);
	m_scb =  dcache_scb::type_id::create("m_scb", this);

	lsu2rm_fifo = new("lsu2rm_fifo",this);
	rm2sb_tla_fifo = new("rm2sb_tla_fifo",this);
	tl2sb_tla_fifo = new("tl2sb_tla_fifo",this);
	


endfunction : build_phase

function void dcache_env::connect_phase(uvm_phase phase);

  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)
	super.connect_phase(phase);
  m_lsu_agent.analysis_port_req.connect(lsu2rm_fifo.analysis_export);
	m_refm.lsu_port.connect(lsu2rm_fifo.blocking_get_export);

	tl_env.sys_env.slave[0].slave_mon.rx_xact_observed_port.connect(tl2sb_tla_fifo.analysis_export);
	m_scb.tl2sb_tla_port.connect(tl2sb_tla_fifo.blocking_get_export);

endfunction : connect_phase

// Could print out diagnostic information, for example

function void dcache_env::end_of_elaboration_phase(uvm_phase phase);

  //uvm_top.print_topology();

endfunction : end_of_elaboration_phase

task dcache_env::main_phase(uvm_phase phase);
	super.main_phase(phase);

endtask : main_phase

`endif // DCACHE_ENV_SV


