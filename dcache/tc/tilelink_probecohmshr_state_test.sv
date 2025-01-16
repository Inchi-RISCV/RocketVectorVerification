
`ifndef _tilelink_probecohmshr_state_test_SV_
`define _tilelink_probecohmshr_state_test_SV_

class tilelink_probecohmshr_state_test extends dcache_base_test;
  `uvm_component_utils(tilelink_probecohmshr_state_test)

  tilelink_slave_probecohmshr_state_sequence        tl_seq;

  extern function new(string name, uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass : tilelink_probecohmshr_state_test

function tilelink_probecohmshr_state_test::new(string name, uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void tilelink_probecohmshr_state_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
	tl_seq       = tilelink_slave_probecohmshr_state_sequence::type_id::create("tl_seq", this);
	//set_inst_override("m_env.tl_env.cfg", "cust_svt_tilelink_system_configuration", "new_tilelink_system_configuration");
endfunction : build_phase


task tilelink_probecohmshr_state_test::main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
		`uvm_info(get_type_name(), "start m_vsqr", UVM_NONE)
    tl_seq.start(m_vsqr);
    phase.drop_objection(this);
endtask : main_phase

`endif
