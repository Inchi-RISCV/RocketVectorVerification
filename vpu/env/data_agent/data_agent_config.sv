//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :data_agent_config.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DATA_AGENT_CONFIG_SV_
`define _DATA_AGENT_CONFIG_SV_

class data_agent_config extends uvm_object;
  `uvm_object_utils(data_agent_config)

  rand uvm_active_passive_enum is_active = UVM_PASSIVE;

  rand bit coverage_enable = 0;
  rand bit checks_enable = 0;
  extern function new(string name = "data_agent_config");

endclass : data_agent_config 

function data_agent_config::new(string name = "data_agent_config");
  super.new(name);
endfunction : new

`endif // DATA_AGENT_CONFIG_SV

