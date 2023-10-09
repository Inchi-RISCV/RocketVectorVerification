//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_env_pkg.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

package vpu_env_pkg;


  `include "uvm_macros.svh"


  import uvm_pkg::*;


  import instr_pkg::*;

  import data_pkg::*;

  `include "vpu_env_config.sv"
  `include "vpu_refm.sv"
  `include "vpu_scb.sv"
  `include "vpu_env.sv"
endpackage : vpu_env_pkg

