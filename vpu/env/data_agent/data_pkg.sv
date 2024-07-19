//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :data_pkg.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DATA_PKG_SV_
`define _DATA_PKG_SV_

package data_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"
  `include "data_trans.sv"
  `include "data_agent_config.sv"
  `include "data_monitor.sv"
  `include "data_agent.sv"

endpackage : data_pkg

`endif // DATA_PKG_SV

