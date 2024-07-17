//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_pkg.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_PKG_SV_
`define _PREFETCH_PKG_SV_

package prefetch_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"
  `include "prefetch_trans.sv"
  `include "prefetch_agent_config.sv"
  `include "prefetch_monitor.sv"
  `include "prefetch_driver.sv"

  `include "prefetch_sequencer.sv"
  `include "prefetch_seq.sv"

  `include "prefetch_agent.sv"

endpackage : prefetch_pkg

`endif // PREFETCH_PKG_SV

