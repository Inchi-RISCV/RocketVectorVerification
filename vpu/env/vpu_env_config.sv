//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_env_config.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_ENV_CONFIG_SV_
`define _VPU_ENV_CONFIG_SV_

class vpu_env_config extends uvm_object;
  `uvm_object_utils(vpu_env_config)

  extern function new(string name = "vpu_env_config");

endclass : vpu_env_config 

function vpu_env_config::new(string name = "vpu_env_config");
  super.new(name);
endfunction : new

`endif // VPU_ENV_CONFIG_SV

