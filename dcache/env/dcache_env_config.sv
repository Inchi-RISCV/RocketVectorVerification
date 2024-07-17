//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_env_config.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_ENV_CONFIG_SV_
`define _DCACHE_ENV_CONFIG_SV_

class dcache_env_config extends uvm_object;
  `uvm_object_utils(dcache_env_config)

  extern function new(string name = "dcache_env_config");

endclass : dcache_env_config 

function dcache_env_config::new(string name = "dcache_env_config");
  super.new(name);
endfunction : new

`endif // DCACHE_ENV_CONFIG_SV

