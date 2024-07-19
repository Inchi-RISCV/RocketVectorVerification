//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_seqence.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_SEQUENCE_SV_
`define _INSTR_SEQUENCE_SV_

class instr_sequence extends uvm_sequence;
  `uvm_object_utils(instr_sequence)
	`uvm_declare_p_sequencer(vpu_vseqr);

  instr_sequence       intr_seq;
	//uvm_table_printer printer;
	
  function new(string name = "instr_sequence");
		super.new(name);
	  //printer = new();
	  //printer.knobs.begin_elements = -1; // this indicates to print all
  	//printer.knobs.end_elements = -1; // this indicates to print all
		uvm_default_printer.knobs.begin_elements=-1; // this indicates to print all

	endfunction


  virtual task body();

	`uvm_info("body", "sequence start", UVM_NONE)

	//#1us;
	///$readmemh("/datahdd/riscv/sunjiawen/rocketverification/vpu/sim1/hex_file/vadd.vv_10001.hex",tb_top.testHarness.mem.srams.mem.mem_ext.ram);



  
	`uvm_info("body", "sequence end", UVM_NONE)


	endtask


endclass : instr_sequence




`endif 
