//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_pkg.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_PKG_SV_
`define _LSU_PKG_SV_

package lsu_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"
  `include "lsu_trans.sv"
  `include "lsu_agent_config.sv"
  `include "lsu_monitor.sv"
  `include "lsu_driver.sv"

  `include "lsu_sequencer.sv"
  `include "lsu_seq.sv"

  `include "lsu_agent.sv"

endpackage : lsu_pkg

`endif // LSU_PKG_SV

