//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_vseqr.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_VSEQR_SV_
`define _VPU_VSEQR_SV_

class vpu_vseqr extends uvm_sequencer;
  `uvm_object_utils(vpu_vseqr)


  function new(string name = "vpu_vseqr");
		super.new(name);
	endfunction

endclass : vpu_vseqr


`endif 
