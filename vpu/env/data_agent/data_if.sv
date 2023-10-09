//============================================================================
// Copyright(c) 2022 ; Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :data_if.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DATA_IF_SV_
`define _DATA_IF_SV_

interface data_if(input clk, input rst_n);
  
  //commit signals
  logic [`NRET-1:0]          verif_commit_valid;
  logic [`NRET*`XLEN-1:0]    verif_commit_prevPc;
  logic [`NRET*`XLEN-1:0]    verif_commit_currPc;
  logic [`NRET*10-1:0]       verif_commit_order;
  logic [`NRET*32-1:0]       verif_commit_insn;
  logic [`NRET-1:0]          verif_commit_fused;
  
  //sim signals
  logic [`NRET-1:0]          verif_sim_halt;

  //trap signals
  logic [`NTRAP-1:0]         verif_trap_valid;
  logic [`NTRAP*`XLEN-1:0]   verif_trap_pc;
  logic [`NTRAP*`XLEN-1:0]   verif_trap_firstInsn;

  //reg signals
  logic [`NRET*31*`XLEN-1:0] verif_reg_gpr;
  logic [`NRET*32*`FLEN-1:0] verif_reg_fpr;
  logic [`NRET*32*`VLEN-1:0] verif_reg_vpr;

  logic [`NRET-1:0]          verif_dest_gprWr;
  logic [`NRET-1:0]          verif_dest_fprWr;
  logic [`NRET-1:0]          verif_dest_vprWr;
  logic [`NRET*8-1:0]        verif_dest_idx;
  logic [`NRET*`VLEN-1:0]    verif_src_vmaskRd;
  logic [`NRET-1:0]          verif_src1_gprRd;
  logic [`NRET-1:0]          verif_src1_fprRd;
  logic [`NRET-1:0]          verif_src1_vprRd;
  logic [`NRET*8-1:0]        verif_src1_idx;
  logic [`NRET-1:0]          verif_src2_gprRd;
  logic [`NRET-1:0]          verif_src2_fprRd;
  logic [`NRET-1:0]          verif_src2_vprRd;
  logic [`NRET*8-1:0]        verif_src2_idx;
  logic [`NRET-1:0]          verif_src3_gprRd;
  logic [`NRET-1:0]          verif_src3_fprRd;
  logic [`NRET-1:0]          verif_src3_vprRd;
  logic [`NRET*8-1:0]        verif_src3_idx;

  //csr signals
  logic [`NRET*`XLEN-1:0]   verif_csr_mstatusWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mepcWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mtvalWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mtvecWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mcauseWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mipWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mieWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mscratchWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_midelegWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_medelegWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_minstretWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_sstatusWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_sepcWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_stvalWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_stvecWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_scauseWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_satpWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_sscratchWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_vtypeWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_vcsrWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_vlWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_vstartWr;
  logic [`NRET*`XLEN-1:0]   verif_csr_mstatusRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mepcRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mtvalRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mtvecRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mcauseRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mipRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mieRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_mscratchRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_midelegRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_medelegRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_minstretRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_sstatusRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_sepcRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_stvalRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_stvecRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_scauseRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_satpRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_scratchRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_vtypeRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_vcsrRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_vlRd;
  logic [`NRET*`XLEN-1:0]   verif_csr_vstartRd;

  //mem signals
  logic [`NRET-1:0]         verif_mem_valid;
  logic [`NRET*`XLEN-1:0]   verif_mem_addr;
  logic [`NRET-1:0]         verif_mem_isStore;
  logic [`NRET-1:0]         verif_mem_isLoad;
  logic [`NRET-1:0]         verif_mem_isVector;
  logic [`NRET*`XLEN/8-1:0] verif_mem_maskWr;
  logic [`NRET*`XLEN/8-1:0]    verif_mem_maskRd;
  logic [`NRET*`VLEN*8-1:0]    verif_mem_dataWr;
  logic [`NRET*`VLEN*8-1:0]    verif_mem_dataRd;

  clocking mon_cb@(posedge clk);
    //commit signals
    output  verif_commit_valid;
    output  verif_commit_prevPc;
    output  verif_commit_currPc;
    output  verif_commit_order;
    output  verif_commit_insn;
    output  verif_commit_fused;
  
    //sim signals
    output  verif_sim_halt;

    //trap signals
    output  verif_trap_valid;
    output  verif_trap_pc;
    output  verif_trap_firstInsn;

    //reg signals
    output  verif_reg_gpr;
    output  verif_reg_fpr;
		output  verif_reg_vpr;
    output  verif_dest_gprWr;
    output  verif_dest_fprWr;
    output  verif_dest_vprWr;
    output  verif_dest_idx;
    output  verif_src_vmaskRd;
    output  verif_src1_gprRd;
    output  verif_src1_fprRd;
    output  verif_src1_vprRd;
    output  verif_src1_idx;
    output  verif_src2_gprRd;
    output  verif_src2_fprRd;
    output  verif_src2_vprRd;
    output  verif_src2_idx;
    output  verif_src3_gprRd;
    output  verif_src3_fprRd;
    output  verif_src3_vprRd;
    output  verif_src3_idx;

    //csr signals
    output  verif_csr_mstatusWr;
    output  verif_csr_mepcWr;
    output  verif_csr_mtvalWr;
    output  verif_csr_mtvecWr;
    output  verif_csr_mcauseWr;
    output  verif_csr_mipWr;
    output  verif_csr_mieWr;
    output  verif_csr_mscratchWr;
    output  verif_csr_midelegWr;
    output  verif_csr_medelegWr;
    output  verif_csr_minstretWr;
    output  verif_csr_sstatusWr;
    output  verif_csr_sepcWr;
    output  verif_csr_stvalWr;
    output  verif_csr_stvecWr;
    output  verif_csr_scauseWr;
    output  verif_csr_satpWr;
    output  verif_csr_sscratchWr;
    output  verif_csr_vtypeWr;
    output  verif_csr_vcsrWr;
    output  verif_csr_vlWr;
    output  verif_csr_vstartWr;
    output  verif_csr_mstatusRd;
    output  verif_csr_mepcRd;
    output  verif_csr_mtvalRd;
    output  verif_csr_mtvecRd;
    output  verif_csr_mcauseRd;
    output  verif_csr_mipRd;
    output  verif_csr_mieRd;
    output  verif_csr_mscratchRd;
    output  verif_csr_midelegRd;
    output  verif_csr_medelegRd;
    output  verif_csr_minstretRd;
    output  verif_csr_sstatusRd;
    output  verif_csr_sepcRd;
    output  verif_csr_stvalRd;
    output  verif_csr_stvecRd;
    output  verif_csr_scauseRd;
    output  verif_csr_satpRd;
    output  verif_csr_scratchRd;
    output  verif_csr_vtypeRd;
    output  verif_csr_vcsrRd;
    output  verif_csr_vlRd;
    output  verif_csr_vstartRd;

    //mem signals
    output  verif_mem_valid;
    output  verif_mem_addr;
    output  verif_mem_isStore;
    output  verif_mem_isLoad;
    output  verif_mem_isVector;
    output  verif_mem_maskWr;
    output  verif_mem_maskRd;
    output  verif_mem_dataWr;
    output  verif_mem_dataRd;
  endclocking


endinterface : data_if

`endif // DATA_IF_SV
