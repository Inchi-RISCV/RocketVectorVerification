//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_test_pkg.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_TEST_PKG_SV_
`define _DCACHE_TEST_PKG_SV_

package dcache_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import lsu_pkg::*;

  import prefetch_pkg::*;

  import dcache_env_pkg::*;
  `include "dcache_base_test.sv"

endpackage : dcache_test_pkg

`endif // DCACHE_TEST_PKG_SV

