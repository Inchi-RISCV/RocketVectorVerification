//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_env_pkg.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

package dcache_env_pkg;


  `include "uvm_macros.svh"


  import uvm_pkg::*;


  import lsu_pkg::*;

  import prefetch_pkg::*;

	import svt_tilelink_uvm_pkg::*;

  `include "dcache_env_config.sv"
  `include "dcache_refm.sv"
  `include "dcache_scb.sv"
  `include "dcache_env.sv"
endpackage : dcache_env_pkg

