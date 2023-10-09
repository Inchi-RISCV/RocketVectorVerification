//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_scb.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_SCB_SV_
`define _VPU_SCB_SV_

class vpu_scb extends uvm_component;
  `uvm_component_utils(vpu_scb)
	uvm_blocking_get_port #(data_trans) data_agent_port;

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);
	extern task end_sim_check();
	extern task commit_check();
	extern task do_exp_tr();

	static event instr_finish;

	data_trans  data_act_tr,data_exp_tr;


endclass : vpu_scb 

function vpu_scb::new(string name, uvm_component parent);
  super.new(name, parent);
	data_agent_port = new("data_agent_port",this);
endfunction : new

task vpu_scb::main_phase(uvm_phase phase);
	phase.raise_objection(this);

	fork
		commit_check();
		end_sim_check();
	join_any

	`uvm_info(get_type_name(),$sformatf(" scb finish! "),UVM_NONE);

	phase.drop_objection(this);

endtask : main_phase


task vpu_scb::end_sim_check();

	fork

  #50us;
	join_any


endtask

task vpu_scb::commit_check();

  bit dut_start_cp;

	`uvm_info(get_type_name(),$sformatf(" start spike! "),UVM_NONE);
 
  data_act_tr = new();
  data_exp_tr = new();


	fork

		while(1) begin


			data_agent_port.get(data_act_tr);

			if(data_act_tr.verif_commit_prevPc == 'h8000_019c) begin
				dut_start_cp = 1;
			end
      
			if(dut_start_cp) begin
      	`uvm_info(get_type_name(),{" scb get act data : ",data_act_tr.sprint},UVM_NONE);

		    riscv_step(1);
			  do_exp_tr();
        `uvm_info(get_type_name(),{" scb get exp data : ",data_exp_tr.sprint},UVM_NONE)
				
		  end


			
		end



	join;


    


endtask

task vpu_scb::do_exp_tr();

	bit [64*22-1:0] csr_arry_bit;
	bit [64*64-1:0] vpr_arry_bit;
	bit [64*64-1:0] fpr_arry_bit;
	bit [64*35-1:0] common_arry_bit;



	bit [63:0] csr_arry[22];//22
	bit [63:0] vpr_arry [64];//64
	bit [63:0] fpr_arry [64];//64
	bit [63:0] common_arry[35];//35

  st_update_csr_regs(csr_arry);
  `uvm_info(get_type_name(),$sformatf(" get spike value csr_arry=%0h", csr_arry[0]),UVM_NONE);
  st_update_vpr_regs(vpr_arry);
  `uvm_info(get_type_name(),$sformatf(" get spike value vpr_arry=%0h", vpr_arry[0]),UVM_NONE);
  st_update_fpr_regs(fpr_arry);
  `uvm_info(get_type_name(),$sformatf(" get spike value fpr_arry=%0h", fpr_arry[0]),UVM_NONE);
  st_update_common_regs(common_arry);
  `uvm_info(get_type_name(),$sformatf(" get spike value common_arry0=%0h,common_arry1=%0h", common_arry[0],common_arry[1]),UVM_NONE);

	data_exp_tr.verif_reg_gpr_arr = new[31];
  data_exp_tr.verif_reg_fpr_arr = new[32];
  data_exp_tr.verif_reg_vpr_arr = new[32];

    data_exp_tr.verif_commit_valid   =      1;
    data_exp_tr.verif_commit_prevPc  =      common_arry[1];
    data_exp_tr.verif_commit_currPc  =      common_arry[0];
    data_exp_tr.verif_commit_order   =      0;//not use
    data_exp_tr.verif_commit_insn    =      common_arry[2];
    data_exp_tr.verif_commit_fused   =      0;//tie 0
    data_exp_tr.verif_sim_halt       =      0;//tie 0
    data_exp_tr.verif_trap_valid     =      0;//tie 0
    data_exp_tr.verif_trap_pc        =      0;//tie 0
    data_exp_tr.verif_trap_firstInsn =      0;//tie 0

		for(int i=0;i<31;i++)begin
    	data_exp_tr.verif_reg_gpr_arr[i]   =      common_arry[i+3];
		//`uvm_info(get_type_name(),$sformatf(" verif_reg_gpr_arr=%0h,verif_reg_gpr=%0h", data_exp_tr.verif_reg_gpr_arr[i],vif.verif_reg_gpr[64*i+:64]),UVM_NONE);
	  end
    for(int i=0;i<32;i++)begin
    	data_exp_tr.verif_reg_fpr_arr[i]   =      fpr_arry[2*i];

    	data_exp_tr.verif_reg_vpr_arr[i]   =      {vpr_arry[i+1],vpr_arry[i]};
	   end

    data_exp_tr.verif_dest_gprWr     =      0;//todo
    data_exp_tr.verif_dest_fprWr     =      0;
    data_exp_tr.verif_dest_vprWr     =      0;
    data_exp_tr.verif_dest_idx       =      0;
    data_exp_tr.verif_src_vmaskRd    =      0;
    data_exp_tr.verif_src1_gprRd     =      0;
    data_exp_tr.verif_src1_fprRd     =      0;
    data_exp_tr.verif_src1_vprRd     =      0;
    data_exp_tr.verif_src1_idx       =      0;
    data_exp_tr.verif_src2_gprRd     =      0;
    data_exp_tr.verif_src2_fprRd     =      0;
    data_exp_tr.verif_src2_vprRd     =      0;
    data_exp_tr.verif_src2_idx       =      0;
    data_exp_tr.verif_src3_gprRd     =      0;
    data_exp_tr.verif_src3_fprRd     =      0;
    data_exp_tr.verif_src3_vprRd     =      0;
    data_exp_tr.verif_src3_idx       =      0;

    data_exp_tr.verif_csr_mstatusWr  =      csr_arry[0];
    data_exp_tr.verif_csr_mepcWr     =      csr_arry[1];
    data_exp_tr.verif_csr_mtvalWr    =      csr_arry[2];
    data_exp_tr.verif_csr_mtvecWr    =      csr_arry[3];
    data_exp_tr.verif_csr_mcauseWr   =      csr_arry[4];
    data_exp_tr.verif_csr_mipWr      =      csr_arry[5];
    data_exp_tr.verif_csr_mieWr      =      csr_arry[6];
    data_exp_tr.verif_csr_mscratchWr =      csr_arry[7];
    data_exp_tr.verif_csr_midelegWr  =      csr_arry[8];
    data_exp_tr.verif_csr_medelegWr  =      csr_arry[9];
    data_exp_tr.verif_csr_minstretWr =      csr_arry[10];
    data_exp_tr.verif_csr_sstatusWr  =      csr_arry[11];
    data_exp_tr.verif_csr_sepcWr     =      csr_arry[12];
    data_exp_tr.verif_csr_stvalWr    =      csr_arry[13];
    data_exp_tr.verif_csr_stvecWr    =      csr_arry[14];
    data_exp_tr.verif_csr_scauseWr   =      csr_arry[15];
    data_exp_tr.verif_csr_satpWr     =      csr_arry[16];
    data_exp_tr.verif_csr_sscratchWr =      csr_arry[17];
    data_exp_tr.verif_csr_vtypeWr    =      csr_arry[18];
    data_exp_tr.verif_csr_vcsrWr     =      csr_arry[19];
    data_exp_tr.verif_csr_vlWr       =      csr_arry[20];
    data_exp_tr.verif_csr_vstartWr   =      csr_arry[21];
    data_exp_tr.verif_csr_mstatusRd  =      0;
    data_exp_tr.verif_csr_mepcRd     =      0;
    data_exp_tr.verif_csr_mtvalRd    =      0;
    data_exp_tr.verif_csr_mtvecRd    =      0;
    data_exp_tr.verif_csr_mcauseRd   =      0;
    data_exp_tr.verif_csr_mipRd      =      0;
    data_exp_tr.verif_csr_mieRd      =      0;
    data_exp_tr.verif_csr_mscratchRd =      0;
    data_exp_tr.verif_csr_midelegRd  =      0;
    data_exp_tr.verif_csr_medelegRd  =      0;
    data_exp_tr.verif_csr_minstretRd =      0;
    data_exp_tr.verif_csr_sstatusRd  =      0;
    data_exp_tr.verif_csr_sepcRd     =      0;
    data_exp_tr.verif_csr_stvalRd    =      0;
    data_exp_tr.verif_csr_stvecRd    =      0;
    data_exp_tr.verif_csr_scauseRd   =      0;
    data_exp_tr.verif_csr_satpRd     =      0;
    data_exp_tr.verif_csr_scratchRd  =      0;
    data_exp_tr.verif_csr_vtypeRd    =      0;
    data_exp_tr.verif_csr_vcsrRd     =      0;
    data_exp_tr.verif_csr_vlRd       =      0;
    data_exp_tr.verif_csr_vstartRd   =      0;

    data_exp_tr.verif_mem_valid      =      0;//todo
    data_exp_tr.verif_mem_addr       =      0;
    data_exp_tr.verif_mem_isStore    =      0;
    data_exp_tr.verif_mem_isLoad     =      0;
    data_exp_tr.verif_mem_isVector   =      0;
    data_exp_tr.verif_mem_maskWr     =      0;
    data_exp_tr.verif_mem_maskRd     =      0;
    data_exp_tr.verif_mem_dataWr     =      0;
    data_exp_tr.verif_mem_dataRd     =      0;



endtask




`endif // VPU_SCB_SV
