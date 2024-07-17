//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_agent_config.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_AGENT_CONFIG_SV_
`define _PREFETCH_AGENT_CONFIG_SV_

class prefetch_agent_config extends uvm_object;
  `uvm_object_utils(prefetch_agent_config)

  rand uvm_active_passive_enum is_active = UVM_ACTIVE;

  rand bit coverage_enable = 0;
  rand bit checks_enable = 0;
  extern function new(string name = "prefetch_agent_config");

endclass : prefetch_agent_config 

function prefetch_agent_config::new(string name = "prefetch_agent_config");
  super.new(name);
endfunction : new

`endif // PREFETCH_AGENT_CONFIG_SV

