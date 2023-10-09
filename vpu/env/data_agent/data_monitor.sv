//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :data_monitor.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DATA_MONITOR_SV_
`define _DATA_MONITOR_SV_


  import "DPI-C" function void spike_init(string s);
	import "DPI-C" function void riscv_step(input int i);
 //import "DPI-C" function void st_update_csr_regs(output bit[64*22-1:0]  arry[] );
 //import "DPI-C" function void st_update_vpr_regs(output bit[64*64-1:0]  arry[] );
 //import "DPI-C" function void st_update_fpr_regs(output bit[64*64-1:0]  arry[] );
 //import "DPI-C" function void st_update_common_regs(output bit[64*35-1:0]  arry[] );
  import "DPI-C" function void st_update_csr_regs(output bit[63:0]  arry[22] );
  import "DPI-C" function void st_update_vpr_regs(output bit[63:0]  arry[64] );
  import "DPI-C" function void st_update_fpr_regs(output bit[63:0]  arry[64] );
  import "DPI-C" function void st_update_common_regs(output bit[63:0]  arry[35] );


class data_monitor extends uvm_monitor; 
  `uvm_component_utils(data_monitor)

  virtual interface  data_if vif;

  uvm_analysis_port #(data_trans) analysis_port;

  data_trans m_trans;
	bit spike_start;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_mon();

endclass : data_monitor 

function data_monitor::new(string name, uvm_component parent);

  super.new(name, parent);
  analysis_port = new("analysis_port", this);

endfunction : new

function void data_monitor::build_phase(uvm_phase phase);

  super.build_phase(phase);

endfunction : build_phase

function void data_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual data_if)::get(this, "*", "data_vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task data_monitor::main_phase(uvm_phase phase);

 bit [63:0] common_arry[35];//35

  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

  m_trans = data_trans::type_id::create("m_trans");
	m_trans.verif_reg_gpr_arr = new[31];
  m_trans.verif_reg_fpr_arr = new[32];
  m_trans.verif_reg_vpr_arr = new[32];

	fork
		#2000;
	  while(1)begin
	    @(posedge vif.clk);
	    riscv_step(1);
	    st_update_common_regs(common_arry);
			//`uvm_info(get_type_name(),$sformatf(" spike_start=%0h,prev_pc=%0h", spike_start,common_arry[0]),UVM_NONE);
	  	if(common_arry[0] == 'h8000_019c)begin
	  		`uvm_info(get_type_name(),$sformatf(" spike_start=%0h,prev_pc=%0h", spike_start,common_arry[0]),UVM_NONE);
        break;
	  	end
	  end
  join_none

	forever begin
  	do_mon();			
	end

endtask : main_phase

task data_monitor::do_mon();
	@(posedge vif.clk);
	if(vif.verif_commit_valid)begin
    m_trans.verif_commit_valid   =      vif.verif_commit_valid;
    m_trans.verif_commit_prevPc  =      vif.verif_commit_prevPc;
    m_trans.verif_commit_currPc  =      vif.verif_commit_currPc;
    m_trans.verif_commit_order   =      vif.verif_commit_order ;
    m_trans.verif_commit_insn    =      vif.verif_commit_insn;
    m_trans.verif_commit_fused   =      vif.verif_commit_fused;
    m_trans.verif_sim_halt       =      vif.verif_sim_halt;
    m_trans.verif_trap_valid     =      vif.verif_trap_valid;
    m_trans.verif_trap_pc        =      vif.verif_trap_pc;
    m_trans.verif_trap_firstInsn =      vif.verif_trap_firstInsn;

		for(int i=0;i<31;i++)begin
    	m_trans.verif_reg_gpr_arr[i]   =      vif.verif_reg_gpr[`XLEN*i+:`XLEN];
		//`uvm_info(get_type_name(),$sformatf(" verif_reg_gpr_arr=%0h,verif_reg_gpr=%0h", m_trans.verif_reg_gpr_arr[i],vif.verif_reg_gpr[64*i+:64]),UVM_NONE);
	  end
    for(int i=0;i<32;i++)begin
    	m_trans.verif_reg_fpr_arr[i]   =      vif.verif_reg_fpr[`FLEN*i+:`FLEN];
    	m_trans.verif_reg_vpr_arr[i]   =      vif.verif_reg_vpr[`VLEN*i+:`VLEN];
	   end

    m_trans.verif_dest_gprWr     =      vif.verif_dest_gprWr;
    m_trans.verif_dest_fprWr     =      vif.verif_dest_fprWr;
    m_trans.verif_dest_vprWr     =      vif.verif_dest_vprWr;
    m_trans.verif_dest_idx       =      vif.verif_dest_idx;
    m_trans.verif_src_vmaskRd    =      vif.verif_src_vmaskRd;
    m_trans.verif_src1_gprRd     =      vif.verif_src1_gprRd;
    m_trans.verif_src1_fprRd     =      vif.verif_src1_fprRd;
    m_trans.verif_src1_vprRd     =      vif.verif_src1_vprRd;
    m_trans.verif_src1_idx       =      vif.verif_src1_idx;
    m_trans.verif_src2_gprRd     =      vif.verif_src2_gprRd;
    m_trans.verif_src2_fprRd     =      vif.verif_src2_fprRd ;
    m_trans.verif_src2_vprRd     =      vif.verif_src2_vprRd;
    m_trans.verif_src2_idx       =      vif.verif_src2_idx;
    m_trans.verif_src3_gprRd     =      vif.verif_src3_gprRd;
    m_trans.verif_src3_fprRd     =      vif.verif_src3_fprRd;
    m_trans.verif_src3_vprRd     =      vif.verif_src3_vprRd;
    m_trans.verif_src3_idx       =      vif.verif_src3_idx;
    m_trans.verif_csr_mstatusWr  =      vif.verif_csr_mstatusWr;
    m_trans.verif_csr_mepcWr     =      vif.verif_csr_mepcWr;
    m_trans.verif_csr_mtvalWr    =      vif.verif_csr_mtvalWr;
    m_trans.verif_csr_mtvecWr    =      vif.verif_csr_mtvecWr;
    m_trans.verif_csr_mcauseWr   =      vif.verif_csr_mcauseWr;
    m_trans.verif_csr_mipWr      =      vif.verif_csr_mipWr;
    m_trans.verif_csr_mieWr      =      vif.verif_csr_mieWr;
    m_trans.verif_csr_mscratchWr =      vif.verif_csr_mscratchWr;
    m_trans.verif_csr_midelegWr  =      vif.verif_csr_midelegWr;
    m_trans.verif_csr_medelegWr  =      vif.verif_csr_medelegWr;
    m_trans.verif_csr_minstretWr =      vif.verif_csr_minstretWr;
    m_trans.verif_csr_sstatusWr  =      vif.verif_csr_sstatusWr;
    m_trans.verif_csr_sepcWr     =      vif.verif_csr_sepcWr;
    m_trans.verif_csr_stvalWr    =      vif.verif_csr_stvalWr;
    m_trans.verif_csr_stvecWr    =      vif.verif_csr_stvecWr;
    m_trans.verif_csr_scauseWr   =      vif.verif_csr_scauseWr;
    m_trans.verif_csr_satpWr     =      vif.verif_csr_satpWr;
    m_trans.verif_csr_sscratchWr =      vif.verif_csr_sscratchWr;
    m_trans.verif_csr_vtypeWr    =      vif.verif_csr_vtypeWr;
    m_trans.verif_csr_vcsrWr     =      vif.verif_csr_vcsrWr;
    m_trans.verif_csr_vlWr       =      vif.verif_csr_vlWr;
    m_trans.verif_csr_vstartWr   =      vif.verif_csr_vstartWr;
    m_trans.verif_csr_mstatusRd  =      vif.verif_csr_mstatusRd;
    m_trans.verif_csr_mepcRd     =      vif.verif_csr_mepcRd;
    m_trans.verif_csr_mtvalRd    =      vif.verif_csr_mtvalRd;
    m_trans.verif_csr_mtvecRd    =      vif.verif_csr_mtvecRd;
    m_trans.verif_csr_mcauseRd   =      vif.verif_csr_mcauseRd;
    m_trans.verif_csr_mipRd      =      vif.verif_csr_mipRd;
    m_trans.verif_csr_mieRd      =      vif.verif_csr_mieRd;
    m_trans.verif_csr_mscratchRd =      vif.verif_csr_mscratchRd;
    m_trans.verif_csr_midelegRd  =      vif.verif_csr_midelegRd;
    m_trans.verif_csr_medelegRd  =      vif.verif_csr_medelegRd;
    m_trans.verif_csr_minstretRd =      vif.verif_csr_minstretRd;
    m_trans.verif_csr_sstatusRd  =      vif.verif_csr_sstatusRd;
    m_trans.verif_csr_sepcRd     =      vif.verif_csr_sepcRd;
    m_trans.verif_csr_stvalRd    =      vif.verif_csr_stvalRd;
    m_trans.verif_csr_stvecRd    =      vif.verif_csr_stvecRd;
    m_trans.verif_csr_scauseRd   =      vif.verif_csr_scauseRd;
    m_trans.verif_csr_satpRd     =      vif.verif_csr_satpRd;
    m_trans.verif_csr_scratchRd  =      vif.verif_csr_scratchRd;
    m_trans.verif_csr_vtypeRd    =      vif.verif_csr_vtypeRd;
    m_trans.verif_csr_vcsrRd     =      vif.verif_csr_vcsrRd;
    m_trans.verif_csr_vlRd       =      vif.verif_csr_vlRd;
    m_trans.verif_csr_vstartRd   =      vif.verif_csr_vstartRd;
    m_trans.verif_mem_valid      =      vif.verif_mem_valid;
    m_trans.verif_mem_addr       =      vif.verif_mem_addr;
    m_trans.verif_mem_isStore    =      vif.verif_mem_isStore;
    m_trans.verif_mem_isLoad     =      vif.verif_mem_isLoad;
    m_trans.verif_mem_isVector   =      vif.verif_mem_isVector;
    m_trans.verif_mem_maskWr     =      vif.verif_mem_maskWr;
    m_trans.verif_mem_maskRd     =      vif.verif_mem_maskRd;
    m_trans.verif_mem_dataWr     =      vif.verif_mem_dataWr;
    m_trans.verif_mem_dataRd     =      vif.verif_mem_dataRd;

		analysis_port.write(m_trans);

		//if(spike_start)begin
		//	riscv_step(1);
		//	`uvm_info(get_type_name(),$sformatf(" spike step 1"),UVM_NONE);
	  //end
  


  end

endtask : do_mon

`endif // DATA_MONITOR_SV


