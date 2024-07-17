//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_agent_config.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_AGENT_CONFIG_SV_
`define _LSU_AGENT_CONFIG_SV_

class lsu_agent_config extends uvm_object;
  `uvm_object_utils(lsu_agent_config)

  rand uvm_active_passive_enum is_active = UVM_ACTIVE;

  rand bit coverage_enable = 0;
  rand bit checks_enable = 0;
  extern function new(string name = "lsu_agent_config");

endclass : lsu_agent_config 

function lsu_agent_config::new(string name = "lsu_agent_config");
  super.new(name);
endfunction : new

`endif // LSU_AGENT_CONFIG_SV

