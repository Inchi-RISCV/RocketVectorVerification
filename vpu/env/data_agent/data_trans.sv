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
    //`uvm_field_int(verif_commit_start,UVM_ALL_ON)		
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

    `uvm_field_int(verif_update_reg_pc,UVM_ALL_ON)
    `uvm_field_int(verif_update_reg_pc,UVM_ALL_ON)
    `uvm_field_int(verif_update_reg_rd,UVM_ALL_ON)
    `uvm_field_int(verif_update_reg_rfd,UVM_ALL_ON)
    `uvm_field_int(verif_update_reg_data,UVM_ALL_ON)
    `uvm_field_int(verif_update_reg_gpr_en,UVM_ALL_ON)

    `uvm_field_int(verif_sfma,UVM_ALL_ON)
	`uvm_object_utils_end

  //rand bit [`NRET-1:0]          verif_commit_start;
  rand bit [`NRET-1:0]          verif_commit_valid;	
  rand bit [`NRET*`XLEN-1:0]    verif_commit_prevPc;
  rand bit [`NRET*`XLEN-1:0]    verif_commit_currPc;
  rand bit [`NRET*10-1:0]       verif_commit_order;
  rand bit [`NRET*32-1:0]       verif_commit_insn;
  rand bit [`NRET-1:0]          verif_commit_fused;
  
  //sim signals
  rand bit [1:0]          verif_sim_halt;

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

  rand bit [`NRET-1:0]         verif_update_reg_valid;
  rand bit [`NRET*`XLEN-1:0]   verif_update_reg_pc; 
  rand bit [`NRET*5-1:0]       verif_update_reg_rd; 
  rand bit [`NRET*5-1:0]       verif_update_reg_rfd; 
  rand bit [`NRET*`XLEN-1:0]   verif_update_reg_data; 
  rand bit [`NRET-1:0]         verif_update_reg_gpr_en;

	rand bit [`NRET-1:0]         verif_sfma;

  extern function new(string name = "data_trans");

	function bit my_compare(data_trans exp_trans);
  	return (this.verif_commit_valid == exp_trans.verif_commit_valid)&&
					 (this.verif_commit_prevPc[39:0] == exp_trans.verif_commit_prevPc[39:0])&&
					 (this.verif_commit_currPc[39:0] == exp_trans.verif_commit_currPc[39:0])&&
   				 (this.verif_commit_order == exp_trans.verif_commit_order)&&
   				 (this.verif_commit_insn == exp_trans.verif_commit_insn)&&
   				 (this.verif_commit_fused == exp_trans.verif_commit_fused)&&
   				 (this.verif_sim_halt == exp_trans.verif_sim_halt)&&
   				 (this.verif_trap_valid == exp_trans.verif_trap_valid)&&
   				 (this.verif_trap_pc == exp_trans.verif_trap_pc)&&
   				 (this.verif_trap_firstInsn == exp_trans.verif_trap_firstInsn)&&
   				 (this.verif_reg_gpr_arr == exp_trans.verif_reg_gpr_arr)&&
   				 (this.verif_reg_fpr_arr == exp_trans.verif_reg_fpr_arr)&&
   				 (this.verif_reg_vpr_arr == exp_trans.verif_reg_vpr_arr)&&
   				 (this.verif_dest_gprWr == exp_trans.verif_dest_gprWr)&&
   				 (this.verif_dest_fprWr == exp_trans.verif_dest_fprWr)&&
   				 (this.verif_dest_vprWr == exp_trans.verif_dest_vprWr)&&
   				 (this.verif_dest_idx == exp_trans.verif_dest_idx)&&
					 (this.verif_src_vmaskRd == exp_trans.verif_src_vmaskRd) &&
					 (this.verif_src1_gprRd == exp_trans.verif_src1_gprRd) &&
					 (this.verif_src1_fprRd == exp_trans.verif_src1_fprRd) &&
					 (this.verif_src1_vprRd == exp_trans.verif_src1_vprRd) &&
					 (this.verif_src1_idx == exp_trans.verif_src1_idx) &&
					 (this.verif_src2_gprRd == exp_trans.verif_src2_gprRd) &&
					 (this.verif_src2_fprRd == exp_trans.verif_src2_fprRd) &&
					 (this.verif_src2_vprRd == exp_trans.verif_src2_vprRd) &&
					 (this.verif_src2_idx == exp_trans.verif_src2_idx) &&
					 (this.verif_src3_gprRd == exp_trans.verif_src3_gprRd) &&
					 (this.verif_src3_fprRd == exp_trans.verif_src3_fprRd) &&
					 (this.verif_src3_vprRd == exp_trans.verif_src3_vprRd) &&
					 (this.verif_src3_idx == exp_trans.verif_src3_idx) &&
					 (this.verif_csr_mstatusWr == exp_trans.verif_csr_mstatusWr) &&
					 (this.verif_csr_mepcWr == exp_trans.verif_csr_mepcWr) &&
					 (this.verif_csr_mtvalWr == exp_trans.verif_csr_mtvalWr) &&
					 (this.verif_csr_mtvecWr == exp_trans.verif_csr_mtvecWr) &&
					 (this.verif_csr_mcauseWr == exp_trans.verif_csr_mcauseWr) &&
					 (this.verif_csr_mipWr == exp_trans.verif_csr_mipWr) &&
					 (this.verif_csr_mieWr == exp_trans.verif_csr_mieWr) &&
					 (this.verif_csr_mscratchWr == exp_trans.verif_csr_mscratchWr) &&
					 (this.verif_csr_midelegWr == exp_trans.verif_csr_midelegWr) &&
					 (this.verif_csr_medelegWr == exp_trans.verif_csr_medelegWr) &&
					 (this.verif_csr_minstretWr == exp_trans.verif_csr_minstretWr) &&
					 (this.verif_csr_sstatusWr == exp_trans.verif_csr_sstatusWr) &&
					 (this.verif_csr_sepcWr == exp_trans.verif_csr_sepcWr) &&
					 (this.verif_csr_stvalWr == exp_trans.verif_csr_stvalWr) &&
					 (this.verif_csr_stvecWr == exp_trans.verif_csr_stvecWr) &&
					 (this.verif_csr_scauseWr == exp_trans.verif_csr_scauseWr) &&
					 (this.verif_csr_satpWr == exp_trans.verif_csr_satpWr) &&
					 (this.verif_csr_sscratchWr == exp_trans.verif_csr_sscratchWr) &&
					 (this.verif_csr_vtypeWr == exp_trans.verif_csr_vtypeWr) &&
					 (this.verif_csr_vcsrWr == exp_trans.verif_csr_vcsrWr) &&
					 (this.verif_csr_vlWr == exp_trans.verif_csr_vlWr) &&
					 (this.verif_csr_vstartWr == exp_trans.verif_csr_vstartWr) &&
					 (this.verif_csr_mstatusRd == exp_trans.verif_csr_mstatusRd) &&
					 (this.verif_csr_mepcRd == exp_trans.verif_csr_mepcRd) &&
					 (this.verif_csr_mtvalRd == exp_trans.verif_csr_mtvalRd) &&
					 (this.verif_csr_mtvecRd == exp_trans.verif_csr_mtvecRd) &&
					 (this.verif_csr_mcauseRd == exp_trans.verif_csr_mcauseRd) &&
					 (this.verif_csr_mipRd == exp_trans.verif_csr_mipRd) &&
					 (this.verif_csr_mieRd == exp_trans.verif_csr_mieRd) &&
					 (this.verif_csr_mscratchRd == exp_trans.verif_csr_mscratchRd) &&
					 (this.verif_csr_midelegRd == exp_trans.verif_csr_midelegRd) &&
					 (this.verif_csr_medelegRd == exp_trans.verif_csr_medelegRd) &&
					 (this.verif_csr_minstretRd == exp_trans.verif_csr_minstretRd) &&
					 (this.verif_csr_sstatusRd == exp_trans.verif_csr_sstatusRd) &&
					 (this.verif_csr_sepcRd == exp_trans.verif_csr_sepcRd) &&
					 (this.verif_csr_stvalRd == exp_trans.verif_csr_stvalRd) &&
					 (this.verif_csr_stvecRd == exp_trans.verif_csr_stvecRd) &&
					 (this.verif_csr_scauseRd == exp_trans.verif_csr_scauseRd) &&
					 (this.verif_csr_satpRd == exp_trans.verif_csr_satpRd) &&
					 (this.verif_csr_scratchRd == exp_trans.verif_csr_scratchRd) &&
					 (this.verif_csr_vtypeRd == exp_trans.verif_csr_vtypeRd) &&
					 (this.verif_csr_vcsrRd == exp_trans.verif_csr_vcsrRd) &&
					 (this.verif_csr_vlRd == exp_trans.verif_csr_vlRd) &&
					 (this.verif_csr_vstartRd == exp_trans.verif_csr_vstartRd) &&
					 (this.verif_mem_valid == exp_trans.verif_mem_valid) &&
					 (this.verif_mem_addr == exp_trans.verif_mem_addr) &&
					 (this.verif_mem_isStore == exp_trans.verif_mem_isStore) &&
					 (this.verif_mem_isLoad == exp_trans.verif_mem_isLoad) &&
					 (this.verif_mem_isVector == exp_trans.verif_mem_isVector) &&
					 (this.verif_mem_maskWr == exp_trans.verif_mem_maskWr) &&
					 (this.verif_mem_maskRd == exp_trans.verif_mem_maskRd) &&
					 (this.verif_mem_dataWr == exp_trans.verif_mem_dataWr) &&
					 (this.verif_mem_dataRd == exp_trans.verif_mem_dataRd)&&
					 (this.verif_update_reg_pc == exp_trans.verif_update_reg_pc) &&
					 (this.verif_update_reg_rd == exp_trans.verif_update_reg_rd) &&
					 (this.verif_update_reg_rfd == exp_trans.verif_update_reg_rfd) &&
					 (this.verif_update_reg_data == exp_trans.verif_update_reg_data) &&
					 (this.verif_update_reg_gpr_en == exp_trans.verif_update_reg_gpr_en)&&
					 (this.verif_sfma == exp_trans.verif_sfma);


	endfunction
endclass : data_trans

function data_trans::new(string name = "data_trans");
  super.new(name);
endfunction : new

`endif // DATA_TRANS_SV


