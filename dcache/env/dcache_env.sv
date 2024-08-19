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
	 uvm_tlm_analysis_fifo  #(svt_tilelink_master_transaction) rm2sb_tltx_fifo;
	 uvm_tlm_analysis_fifo  #(lsu_trans) lsu2sb_rsp_fifo;
	 uvm_tlm_analysis_fifo  #(lsu_trans) rm2sb_rsp_fifo; 
	 uvm_tlm_analysis_fifo  #(svt_tilelink_slave_transaction) rm2sb_tlc_fifo;  
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
  extern function void report_phase(uvm_phase phase);
  extern virtual task shutdown_phase(uvm_phase phase);

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
	rm2sb_tltx_fifo = new("rm2sb_tltx_fifo",this);
  lsu2sb_rsp_fifo = new("lsu2sb_rsp_fifo",this);
  rm2sb_rsp_fifo = new("rm2sb_rsp_fifo",this);
	rm2sb_tlc_fifo = new("rm2sb_tlc_fifo",this);

endfunction : build_phase

function void dcache_env::connect_phase(uvm_phase phase);

  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)
	super.connect_phase(phase);
  m_lsu_agent.analysis_port_req.connect(lsu2rm_fifo.analysis_export);
	m_refm.lsu_port.connect(lsu2rm_fifo.blocking_get_export);


	m_refm.rm2sb_tltx_port.connect(rm2sb_tltx_fifo.analysis_export);
	m_scb.rm2sb_tltx_port.connect(rm2sb_tltx_fifo.blocking_get_export);

  m_lsu_agent.analysis_port_rsp.connect(lsu2sb_rsp_fifo.analysis_export);
	m_scb.lsu2sb_rsp_port.connect(lsu2sb_rsp_fifo.blocking_get_export);

	m_refm.rm2sb_rsp_port.connect(rm2sb_rsp_fifo.analysis_export);
	m_scb.rm2sb_rsp_port.connect(rm2sb_rsp_fifo.blocking_get_export);

	m_refm.rm2sb_tlc_port.connect(rm2sb_tlc_fifo.analysis_export);
	m_scb.rm2sb_tlc_port.connect(rm2sb_tlc_fifo.blocking_get_export);


  //tl_env.sys_env.slave[0].slave_mon.status_xact_observed_port.connect(m_scb.tl2sb_tlsta_port);
  tl_env.sys_env.master[0].master_mon.tx_xact_observed_port.connect(m_scb.tl2sb_tltx_port);
  tl_env.sys_env.master[0].master_mon.rx_xact_observed_port.connect(m_scb.tl2sb_tlrx_port);
  tl_env.sys_env.master[0].master_mon.status_xact_observed_port.connect(m_scb.tl2sb_tlsta_port);


	tl_env.sys_env.slave[0].slave_mon.rx_xact_observed_port.connect(m_refm.tl2rm_tlrx_port);
	tl_env.sys_env.slave[0].slave_mon.tx_xact_observed_port.connect(m_scb.tl2sb_tlc_port);
 // tl_env.sys_env.slave[0].slave_mon.status_xact_observed_port.connect(tl2rm_tltx_fifo.analysis_export);
 //m_refm.tl2rm_tltx_port.connect(tl2rm_tltx_fifo.blocking_get_export);


endfunction : connect_phase

// Could print out diagnostic information, for example

function void dcache_env::end_of_elaboration_phase(uvm_phase phase);

  //uvm_top.print_topology();

endfunction : end_of_elaboration_phase

task dcache_env::main_phase(uvm_phase phase);
	super.main_phase(phase);

endtask : main_phase


task dcache_env::shutdown_phase(uvm_phase phase);

  if(!lsu2rm_fifo.is_empty())begin
    `uvm_error(get_type_name(), "lsu2rm_fifo is not empty!")
	end
  if(!rm2sb_tltx_fifo.is_empty())begin
    `uvm_error(get_type_name(), "rm2sb_tltx_fifo is not empty!")
	end
  if(!lsu2sb_rsp_fifo.is_empty())begin
    `uvm_error(get_type_name(), "lsu2sb_rsp_fifo is not empty!")
	end
  if(!rm2sb_rsp_fifo.is_empty())begin
    `uvm_error(get_type_name(), "rm2sb_rsp_fifo is not empty!")
	end



endtask : shutdown_phase



function void dcache_env::report_phase(uvm_phase phase);
	uvm_report_server srv;
	int err_cnt;

  srv= uvm_report_server::get_server();
	err_cnt = srv.get_severity_count(UVM_FATAL)+srv.get_severity_count(UVM_ERROR);

	if(err_cnt!=0)begin
    $display("~~~~~~~~~~~~~~~~ Simulation_FAIL ~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	end
	else begin
    $display("~~~~~~~~~~~~~~~~ Simulation_PASS ~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	end


endfunction 



`endif // DCACHE_ENV_SV


