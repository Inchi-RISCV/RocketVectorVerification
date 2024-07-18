//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_base_test.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_BASE_TEST_SV_
`define _VPU_BASE_TEST_SV_

class vpu_base_test extends uvm_test;
  `uvm_component_utils(vpu_base_test)

  vpu_env           m_env;
  vpu_vseqr          m_vseqr;
  vpu_env_config    m_env_config;
  instr_agent_config  m_instr_agent_config;
  data_agent_config  m_data_agent_config;
 

  extern function new(string name, uvm_component parent=null);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass : vpu_base_test

function vpu_base_test::new(string name, uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void vpu_base_test::build_phase(uvm_phase phase);
  m_env        = vpu_env::type_id::create("m_env", this);
  m_vseqr        = vpu_vseqr::type_id::create("m_vseqr", this);
  m_env_config    = vpu_env_config::type_id::create("m_env_config", this);
  m_instr_agent_config = instr_agent_config::type_id::create("m_instr_agent_config", this);
  m_data_agent_config = data_agent_config::type_id::create("m_data_agent_config", this);
 
  uvm_config_db#(vpu_env_config)::set(this, "*", "m_env_config", m_env_config);

  uvm_config_db#(instr_agent_config)::set(this, "m_env.*", "m_instr_agent_config", m_instr_agent_config);

  uvm_config_db#(data_agent_config)::set(this, "m_env.*", "m_data_agent_config", m_data_agent_config);
	set_report_max_quit_count(1);

endfunction : build_phase

function void vpu_base_test::connect_phase(uvm_phase phase);

endfunction : connect_phase

function void vpu_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory;

  uvm_coreservice_t cs = uvm_coreservice_t::get();

  factory = cs.get_factory();

  uvm_top.print_topology();
  `uvm_info(get_type_name(), $sformatf("Verbosity level is set to: %d", get_report_verbosity_level()), UVM_MEDIUM)
  `uvm_info(get_type_name(), "Print all Factory overrides", UVM_MEDIUM)
  factory.print();

endfunction : end_of_elaboration_phase

task vpu_base_test::main_phase(uvm_phase phase);

    super.main_phase(phase);
    phase.raise_objection(this);

    phase.drop_objection(this);
endtask : main_phase

`endif // VPU_BASE_TEST_SV
