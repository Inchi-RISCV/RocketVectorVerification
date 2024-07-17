//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_base_test.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_BASE_TEST_SV_
`define _DCACHE_BASE_TEST_SV_

class dcache_base_test extends uvm_test;
  `uvm_component_utils(dcache_base_test)

  dcache_env           m_env;
  dcache_env_config    m_env_config;
  lsu_agent_config  m_lsu_agent_config;
  prefetch_agent_config  m_prefetch_agent_config;
	//svt_tilelink_slave_transaction_base_sequence tl_seq;
	dcache_vsqr          m_vsqr;
 

  extern function new(string name, uvm_component parent=null);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass : dcache_base_test

function dcache_base_test::new(string name, uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void dcache_base_test::build_phase(uvm_phase phase);
  m_env        = dcache_env::type_id::create("m_env", this);
  m_env_config    = dcache_env_config::type_id::create("m_env_config", this);
  m_lsu_agent_config = lsu_agent_config::type_id::create("m_lsu_agent_config", this);
  m_prefetch_agent_config = prefetch_agent_config::type_id::create("m_prefetch_agent_config", this);
  //tl_seq = svt_tilelink_slave_transaction_base_sequence::type_id::create("tl_seq", this);
	m_vsqr     = dcache_vsqr::type_id::create("m_vsqr", this);

 
  uvm_config_db#(dcache_env_config)::set(this, "*", "m_env_config", m_env_config);

  uvm_config_db#(lsu_agent_config)::set(this, "m_env.*", "m_lsu_agent_config", m_lsu_agent_config);

  uvm_config_db#(prefetch_agent_config)::set(this, "m_env.*", "m_prefetch_agent_config", m_prefetch_agent_config);

endfunction : build_phase

function void dcache_base_test::connect_phase(uvm_phase phase);
	m_vsqr.lsu_sqr = m_env.m_lsu_agent.m_sequencer;
	m_vsqr.tilelink_sqr = m_env.tl_env.sequencer;

endfunction : connect_phase

function void dcache_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory;

  uvm_coreservice_t cs = uvm_coreservice_t::get();

  factory = cs.get_factory();

  uvm_top.print_topology();
  `uvm_info(get_type_name(), $sformatf("Verbosity level is set to: %d", get_report_verbosity_level()), UVM_MEDIUM)
  `uvm_info(get_type_name(), "Print all Factory overrides", UVM_MEDIUM)
  factory.print();

endfunction : end_of_elaboration_phase

task dcache_base_test::main_phase(uvm_phase phase);

    super.main_phase(phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
endtask : main_phase

`endif // DCACHE_BASE_TEST_SV
