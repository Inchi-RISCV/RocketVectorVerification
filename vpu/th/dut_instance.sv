`define  RTL_PATH  tb_top.testHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core
`define  VIF_PATH  tb_top.m_data_if

TestHarness testHarness(
    .clock(clock),
    .reset(reset),
    .io_success(success)
  );


initial begin

 force `VIF_PATH.verif_commit_valid   =  `RTL_PATH.io_verif_commit_valid;
 force `VIF_PATH.verif_commit_prevPc  =  `RTL_PATH.io_verif_commit_prevPc;
 force `VIF_PATH.verif_commit_currPc  =  `RTL_PATH.io_verif_commit_currPc;
 force `VIF_PATH.verif_commit_order   =  `RTL_PATH.io_verif_commit_order;
 force `VIF_PATH.verif_commit_insn    =  `RTL_PATH.io_verif_commit_insn;
 force `VIF_PATH.verif_commit_fused   =  `RTL_PATH.io_verif_commit_fused;
 force `VIF_PATH.verif_sim_halt       =  `RTL_PATH.io_verif_sim_halt;
 force `VIF_PATH.verif_trap_valid     =  `RTL_PATH.io_verif_trap_valid;
 force `VIF_PATH.verif_trap_pc        =  `RTL_PATH.io_verif_trap_pc;
 force `VIF_PATH.verif_trap_firstInsn =  `RTL_PATH.io_verif_trap_firstInsn;
 force `VIF_PATH.verif_reg_gpr        =  `RTL_PATH.io_verif_reg_gpr;
 force `VIF_PATH.verif_reg_fpr        =  `RTL_PATH.io_verif_reg_fpr;
 force `VIF_PATH.verif_reg_vpr        =  `RTL_PATH.io_verif_reg_vpr;
 force `VIF_PATH.verif_dest_gprWr     =  `RTL_PATH.io_verif_dest_gprWr;
 force `VIF_PATH.verif_dest_fprWr     =  `RTL_PATH.io_verif_dest_fprWr;
 force `VIF_PATH.verif_dest_vprWr     =  `RTL_PATH.io_verif_dest_vprWr;
 force `VIF_PATH.verif_dest_idx       =  `RTL_PATH.io_verif_dest_idx;
 force `VIF_PATH.verif_src_vmaskRd    =  `RTL_PATH.io_verif_src_vmaskRd;
 force `VIF_PATH.verif_src1_gprRd     =  `RTL_PATH.io_verif_src1_gprRd;
 force `VIF_PATH.verif_src1_fprRd     =  `RTL_PATH.io_verif_src1_fprRd;
 force `VIF_PATH.verif_src1_vprRd     =  `RTL_PATH.io_verif_src1_vprRd;
 force `VIF_PATH.verif_src1_idx       =  `RTL_PATH.io_verif_src1_idx;
 force `VIF_PATH.verif_src2_gprRd     =  `RTL_PATH.io_verif_src2_gprRd;
 force `VIF_PATH.verif_src2_fprRd     =  `RTL_PATH.io_verif_src2_fprRd;
 force `VIF_PATH.verif_src2_vprRd     =  `RTL_PATH.io_verif_src2_vprRd;
 force `VIF_PATH.verif_src2_idx       =  `RTL_PATH.io_verif_src2_idx;
 force `VIF_PATH.verif_src3_gprRd     =  `RTL_PATH.io_verif_src3_gprRd;
 force `VIF_PATH.verif_src3_fprRd     =  `RTL_PATH.io_verif_src3_fprRd;
 force `VIF_PATH.verif_src3_vprRd     =  `RTL_PATH.io_verif_src3_vprRd;
 force `VIF_PATH.verif_src3_idx       =  `RTL_PATH.io_verif_src3_idx;
 force `VIF_PATH.verif_csr_mstatusWr  =  `RTL_PATH.io_verif_csr_mstatusWr;
 force `VIF_PATH.verif_csr_mepcWr     =  `RTL_PATH.io_verif_csr_mepcWr;
 force `VIF_PATH.verif_csr_mtvalWr    =  `RTL_PATH.io_verif_csr_mtvalWr;
 force `VIF_PATH.verif_csr_mtvecWr    =  `RTL_PATH.io_verif_csr_mtvecWr;
 force `VIF_PATH.verif_csr_mcauseWr   =  `RTL_PATH.io_verif_csr_mcauseWr;
 force `VIF_PATH.verif_csr_mipWr      =  `RTL_PATH.io_verif_csr_mipWr;
 force `VIF_PATH.verif_csr_mieWr      =  `RTL_PATH.io_verif_csr_mieWr;
 force `VIF_PATH.verif_csr_mscratchWr =  `RTL_PATH.io_verif_csr_mscratchWr;
 force `VIF_PATH.verif_csr_midelegWr  =  `RTL_PATH.io_verif_csr_midelegWr;
 force `VIF_PATH.verif_csr_medelegWr  =  `RTL_PATH.io_verif_csr_medelegWr;
 force `VIF_PATH.verif_csr_minstretWr =  `RTL_PATH.io_verif_csr_minstretWr;
 force `VIF_PATH.verif_csr_sstatusWr  =  `RTL_PATH.io_verif_csr_sstatusWr;
 force `VIF_PATH.verif_csr_sepcWr     =  `RTL_PATH.io_verif_csr_sepcWr;
 force `VIF_PATH.verif_csr_stvalWr    =  `RTL_PATH.io_verif_csr_stvalWr;
 force `VIF_PATH.verif_csr_stvecWr    =  `RTL_PATH.io_verif_csr_stvecWr;
 force `VIF_PATH.verif_csr_scauseWr   =  `RTL_PATH.io_verif_csr_scauseWr;
 force `VIF_PATH.verif_csr_satpWr     =  `RTL_PATH.io_verif_csr_satpWr;
 force `VIF_PATH.verif_csr_sscratchWr =  `RTL_PATH.io_verif_csr_sscratchWr;
 force `VIF_PATH.verif_csr_vtypeWr    =  `RTL_PATH.io_verif_csr_vtypeWr;
 force `VIF_PATH.verif_csr_vcsrWr     =  `RTL_PATH.io_verif_csr_vcsrWr;
 force `VIF_PATH.verif_csr_vlWr       =  `RTL_PATH.io_verif_csr_vlWr;
 force `VIF_PATH.verif_csr_vstartWr   =  `RTL_PATH.io_verif_csr_vstartWr;
 force `VIF_PATH.verif_csr_mstatusRd  =  `RTL_PATH.io_verif_csr_mstatusRd;
 force `VIF_PATH.verif_csr_mepcRd     =  `RTL_PATH.io_verif_csr_mepcRd;
 force `VIF_PATH.verif_csr_mtvalRd    =  `RTL_PATH.io_verif_csr_mtvalRd;
 force `VIF_PATH.verif_csr_mtvecRd    =  `RTL_PATH.io_verif_csr_mtvecRd;
 force `VIF_PATH.verif_csr_mcauseRd   =  `RTL_PATH.io_verif_csr_mcauseRd;
 force `VIF_PATH.verif_csr_mipRd      =  `RTL_PATH.io_verif_csr_mipRd;
 force `VIF_PATH.verif_csr_mieRd      =  `RTL_PATH.io_verif_csr_mieRd;
 force `VIF_PATH.verif_csr_mscratchRd =  `RTL_PATH.io_verif_csr_mscratchRd;
 force `VIF_PATH.verif_csr_midelegRd  =  `RTL_PATH.io_verif_csr_midelegRd;
 force `VIF_PATH.verif_csr_medelegRd  =  `RTL_PATH.io_verif_csr_medelegRd;
 force `VIF_PATH.verif_csr_minstretRd =  `RTL_PATH.io_verif_csr_minstretRd;
 force `VIF_PATH.verif_csr_sstatusRd  =  `RTL_PATH.io_verif_csr_sstatusRd;
 force `VIF_PATH.verif_csr_sepcRd     =  `RTL_PATH.io_verif_csr_sepcRd;
 force `VIF_PATH.verif_csr_stvalRd    =  `RTL_PATH.io_verif_csr_stvalRd;
 force `VIF_PATH.verif_csr_stvecRd    =  `RTL_PATH.io_verif_csr_stvecRd;
 force `VIF_PATH.verif_csr_scauseRd   =  `RTL_PATH.io_verif_csr_scauseRd;
 force `VIF_PATH.verif_csr_satpRd     =  `RTL_PATH.io_verif_csr_satpRd;
 force `VIF_PATH.verif_csr_scratchRd  =  `RTL_PATH.io_verif_csr_sscratchRd;
 force `VIF_PATH.verif_csr_vtypeRd    =  `RTL_PATH.io_verif_csr_vtypeRd;
 force `VIF_PATH.verif_csr_vcsrRd     =  `RTL_PATH.io_verif_csr_vcsrRd;
 force `VIF_PATH.verif_csr_vlRd       =  `RTL_PATH.io_verif_csr_vlRd;
 force `VIF_PATH.verif_csr_vstartRd   =  `RTL_PATH.io_verif_csr_vstartRd;
 force `VIF_PATH.verif_mem_valid      =  `RTL_PATH.io_verif_mem_valid;
 force `VIF_PATH.verif_mem_addr       =  `RTL_PATH.io_verif_mem_addr;
 force `VIF_PATH.verif_mem_isStore    =  `RTL_PATH.io_verif_mem_isStore;
 force `VIF_PATH.verif_mem_isLoad     =  `RTL_PATH.io_verif_mem_isLoad;
 force `VIF_PATH.verif_mem_isVector   =  `RTL_PATH.io_verif_mem_isVector;
 force `VIF_PATH.verif_mem_maskWr     =  `RTL_PATH.io_verif_mem_maskWr;
 force `VIF_PATH.verif_mem_maskRd     =  `RTL_PATH.io_verif_mem_maskRd;
 force `VIF_PATH.verif_mem_dataWr     =  `RTL_PATH.io_verif_mem_dataWr;
 force `VIF_PATH.verif_mem_dataRd     =  `RTL_PATH.io_verif_mem_datatRd;

 end
