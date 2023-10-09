//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_agent_config.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_AGENT_CONFIG_SV_
`define _INSTR_AGENT_CONFIG_SV_

class instr_agent_config extends uvm_object;
  `uvm_object_utils(instr_agent_config)

  rand uvm_active_passive_enum is_active = UVM_ACTIVE;

  rand bit coverage_enable = 0;
  rand bit checks_enable = 0;
  extern function new(string name = "instr_agent_config");

endclass : instr_agent_config 

function instr_agent_config::new(string name = "instr_agent_config");
  super.new(name);
endfunction : new

`endif // INSTR_AGENT_CONFIG_SV

