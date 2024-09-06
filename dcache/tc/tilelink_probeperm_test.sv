//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :tilelink_probeperm_test.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _tilelink_probeperm_test_SV_
`define _tilelink_probeperm_test_SV_

class tilelink_probeperm_test extends dcache_base_test;
  `uvm_component_utils(tilelink_probeperm_test)

  tilelink_slave_probeperm_sequence        tl_seq;

  extern function new(string name, uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass : tilelink_probeperm_test

function tilelink_probeperm_test::new(string name, uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void tilelink_probeperm_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
	tl_seq       = tilelink_slave_probeperm_sequence::type_id::create("tl_seq", this);
endfunction : build_phase


task tilelink_probeperm_test::main_phase(uvm_phase phase);

    super.main_phase(phase);
    phase.raise_objection(this);
		`uvm_info(get_type_name(), "start m_vsqr", UVM_NONE)
    tl_seq.start(m_vsqr);
		#1000ns;
    phase.drop_objection(this);
endtask : main_phase

`endif
