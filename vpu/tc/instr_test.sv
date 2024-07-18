//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_test.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_TEST_SV_
`define _INSTR_TEST_SV_

class instr_test extends vpu_base_test;
  `uvm_component_utils(instr_test)

  instr_sequence       instr_seq;

  extern function new(string name, uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass : instr_test

function instr_test::new(string name, uvm_component parent=null);
  super.new(name, parent);
endfunction : new

function void instr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

task instr_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.main_phase(phase);
	  instr_seq = instr_sequence::type_id::create("instr_seq");
    instr_seq.start(m_vseqr);
    #1000;
    phase.drop_objection(this);
endtask : main_phase

`endif // VPU_BASE_TEST_SV
