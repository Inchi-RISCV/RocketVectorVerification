//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_pkg.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_PKG_SV_
`define _INSTR_PKG_SV_

package instr_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"
  `include "instr_trans.sv"
  `include "instr_agent_config.sv"
  `include "instr_monitor.sv"
  `include "instr_driver.sv"

  `include "instr_sequencer.sv"
  `include "instr_seq.sv"

  `include "instr_agent.sv"

endpackage : instr_pkg

`endif // INSTR_PKG_SV

