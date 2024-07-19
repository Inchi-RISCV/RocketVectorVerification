//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_test_pkg.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_TEST_PKG_SV_
`define _VPU_TEST_PKG_SV_

package vpu_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import instr_pkg::*;

  import data_pkg::*;

  import vpu_env_pkg::*;
  `include "vpu_base_test.sv"

endpackage : vpu_test_pkg

`endif // VPU_TEST_PKG_SV

