//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :data_trans.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DATA_TRANS_SV_
`define _DATA_TRANS_SV_

class data_trans extends uvm_sequence_item; 
  `uvm_object_utils_begin(data_trans)
    `uvm_field_int(verif_commit_valid,UVM_ALL_ON)
    `uvm_field_int(verif_commit_prevPc,UVM_ALL_ON)
    `uvm_field_int(verif_commit_currPc,UVM_ALL_ON)
    `uvm_field_int(verif_commit_order,UVM_ALL_ON)
    `uvm_field_int(verif_commit_insn,UVM_ALL_ON)
    `uvm_field_int(verif_commit_fused,UVM_ALL_ON)
    `uvm_field_int(verif_sim_halt,UVM_ALL_ON)
    `uvm_field_int(verif_trap_valid,UVM_ALL_ON)
    `uvm_field_int(verif_trap_pc,UVM_ALL_ON)
    `uvm_field_int(verif_trap_firstInsn,UVM_ALL_ON)
    `uvm_field_array_int(verif_reg_gpr_arr,UVM_ALL_ON)
    `uvm_field_array_int(verif_reg_fpr_arr,UVM_ALL_ON)
	  `uvm_field_array_int(verif_reg_vpr_arr,UVM_ALL_ON)
    `uvm_field_int(verif_dest_gprWr,UVM_ALL_ON)
    `uvm_field_int(verif_dest_fprWr,UVM_ALL_ON)
    `uvm_field_int(verif_dest_vprWr,UVM_ALL_ON)
    `uvm_field_int(verif_dest_idx,UVM_ALL_ON)
    `uvm_field_int(verif_src_vmaskRd,UVM_ALL_ON)
    `uvm_field_int(verif_src1_gprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src1_fprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src1_vprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src1_idx,UVM_ALL_ON)
    `uvm_field_int(verif_src2_gprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src2_fprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src2_vprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src2_idx,UVM_ALL_ON)
    `uvm_field_int(verif_src3_gprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src3_fprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src3_vprRd,UVM_ALL_ON)
    `uvm_field_int(verif_src3_idx,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mstatusWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mepcWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mtvalWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mtvecWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mcauseWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mipWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mieWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mscratchWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_midelegWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_medelegWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_minstretWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_sstatusWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_sepcWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_stvalWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_stvecWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_scauseWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_satpWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_sscratchWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vtypeWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vcsrWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vlWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vstartWr,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mstatusRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mepcRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mtvalRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mtvecRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mcauseRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mipRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mieRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_mscratchRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_midelegRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_medelegRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_minstretRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_sstatusRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_sepcRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_stvalRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_stvecRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_scauseRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_satpRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_scratchRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vtypeRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vcsrRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vlRd,UVM_ALL_ON)
    `uvm_field_int(verif_csr_vstartRd,UVM_ALL_ON)
    `uvm_field_int(verif_mem_valid,UVM_ALL_ON)
    `uvm_field_int(verif_mem_addr,UVM_ALL_ON)
    `uvm_field_int(verif_mem_isStore,UVM_ALL_ON)
    `uvm_field_int(verif_mem_isLoad,UVM_ALL_ON)
    `uvm_field_int(verif_mem_isVector,UVM_ALL_ON)
    `uvm_field_int(verif_mem_maskWr,UVM_ALL_ON)
    `uvm_field_int(verif_mem_maskRd,UVM_ALL_ON)
    `uvm_field_int(verif_mem_dataWr,UVM_ALL_ON)
    `uvm_field_int(verif_mem_dataRd,UVM_ALL_ON)

	`uvm_object_utils_end

  rand bit [`NRET-1:0]          verif_commit_valid;
  rand bit [`NRET*`XLEN-1:0]    verif_commit_prevPc;
  rand bit [`NRET*`XLEN-1:0]    verif_commit_currPc;
  rand bit [`NRET*10-1:0]       verif_commit_order;
  rand bit [`NRET*32-1:0]       verif_commit_insn;
  rand bit [`NRET-1:0]          verif_commit_fused;
  
  //sim signals
  rand bit [`NRET-1:0]          verif_sim_halt;

  //trap signals
  rand bit [`NTRAP-1:0]         verif_trap_valid;
  rand bit [`NTRAP*`XLEN-1:0]   verif_trap_pc;
  rand bit [`NTRAP*`XLEN-1:0]   verif_trap_firstInsn;

  //reg signals
  rand bit [`NRET*`XLEN-1:0] verif_reg_gpr_arr [] ;
  rand bit [`NRET*`FLEN-1:0] verif_reg_fpr_arr [] ;
  rand bit [`NRET*`VLEN-1:0] verif_reg_vpr_arr [] ;	
  rand bit [`NRET-1:0]          verif_dest_gprWr;
  rand bit [`NRET-1:0]          verif_dest_fprWr;
  rand bit [`NRET-1:0]          verif_dest_vprWr;
  rand bit [`NRET*8-1:0]        verif_dest_idx;
  rand bit [`NRET*`VLEN-1:0]     verif_src_vmaskRd;
  rand bit [`NRET-1:0]          verif_src1_gprRd;
  rand bit [`NRET-1:0]          verif_src1_fprRd;
  rand bit [`NRET-1:0]          verif_src1_vprRd;
  rand bit [`NRET*8-1:0]        verif_src1_idx;
  rand bit [`NRET-1:0]          verif_src2_gprRd;
  rand bit [`NRET-1:0]          verif_src2_fprRd;
  rand bit [`NRET-1:0]          verif_src2_vprRd;
  rand bit [`NRET*8-1:0]        verif_src2_idx;
  rand bit [`NRET-1:0]          verif_src3_gprRd;
  rand bit [`NRET-1:0]          verif_src3_fprRd;
  rand bit [`NRET-1:0]          verif_src3_vprRd;
  rand bit [`NRET*8-1:0]        verif_src3_idx;

  //csr signals
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mstatusWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mepcWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mtvalWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mtvecWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mcauseWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mipWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mieWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mscratchWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_midelegWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_medelegWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_minstretWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_sstatusWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_sepcWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_stvalWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_stvecWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_scauseWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_satpWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_sscratchWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vtypeWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vcsrWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vlWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vstartWr;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mstatusRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mepcRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mtvalRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mtvecRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mcauseRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mipRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mieRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_mscratchRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_midelegRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_medelegRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_minstretRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_sstatusRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_sepcRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_stvalRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_stvecRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_scauseRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_satpRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_scratchRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vtypeRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vcsrRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vlRd;
  rand bit [`NRET*`XLEN-1:0]   verif_csr_vstartRd;

  //mem signals
  rand bit [`NRET-1:0]         verif_mem_valid;
  rand bit [`NRET*`XLEN-1:0]   verif_mem_addr;
  rand bit [`NRET-1:0]         verif_mem_isStore;
  rand bit [`NRET-1:0]         verif_mem_isLoad;
  rand bit [`NRET-1:0]         verif_mem_isVector;
  rand bit [`NRET*`XLEN/8-1:0] verif_mem_maskWr;
  rand bit [`NRET*`XLEN/8-1:0] verif_mem_maskRd;
  rand bit [`NRET*`VLEN*8-1:0] verif_mem_dataWr;
  rand bit [`NRET*`VLEN*8-1:0] verif_mem_dataRd;

  extern function new(string name = "data_trans");

endclass : data_trans

function data_trans::new(string name = "data_trans");
  super.new(name);
endfunction : new

`endif // DATA_TRANS_SV

