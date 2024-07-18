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
	uvm_blocking_get_port #(data_trans) data_agent_port_update;
  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);
	extern task end_sim_check();
	extern task commit_check();
	extern task do_exp_tr();
  extern task init_spike_info(data_trans data_act_tr);

	bit     instr_finish;
	static event time_out_refresh;

	data_trans  data_act_tr,data_act_tr_1,data_exp_tr;
	bit comp_pass;
  bit comp_fail;


endclass : vpu_scb 

function vpu_scb::new(string name, uvm_component parent);
  super.new(name, parent);
	data_agent_port = new("data_agent_port",this);
	data_agent_port_update = new("data_agent_port_update",this);
	
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

	int time_cnt;
  fork

    while(1) begin
    	//#200ns;
    	if(instr_finish) begin
    		break;
    	end
    	#10;
    end

    while(1) begin
    	@time_out_refresh;
    	time_cnt=0;
    	`uvm_info(get_type_name(),$sformatf("get commit data"),UVM_DEBUG);
    end
    while(1) begin
    	@(posedge tb_top.clock);
    	time_cnt++;
    	`uvm_info(get_type_name(),$sformatf("time_cnt:%0d",time_cnt),UVM_DEBUG);
    end

    while(1) begin
    	@(posedge tb_top.clock);
    	if(time_cnt>=2000)begin
    	  `uvm_error(get_type_name(),$sformatf("commit info timeout ! "));
    	break;
      end
    end

  join_any




endtask

task vpu_scb::commit_check();

  bit dut_start_cp;
	bit [31:0] commit_num;

  // 127:64 pc  
	bit [2*`NRET*`XLEN-1:0] act_ooo_gpr_reg_info [] ;
	bit [2*`NRET*`XLEN-1:0] act_ooo_fpr_reg_info [] ;
	bit [2*`NRET*`XLEN-1:0] exp_ooo_gpr_reg_info [] ;
	bit [2*`NRET*`XLEN-1:0] exp_ooo_fpr_reg_info [] ;
	
	bit [5:0] ooo_gpr_time [] ;
	bit [5:0] ooo_fpr_time [] ;
	bit [5:0] gpr_fail_flag [];
	bit [5:0] fpr_fail_flag [];

	bit [4:0] gpr_reg_num;
  bit [4:0] fpr_reg_num;

	//`uvm_info(get_type_name(),$sformatf(" start spike! "),UVM_NONE);
 
  data_act_tr = new();
	data_act_tr_1 = new();
  data_exp_tr = new();
  act_ooo_gpr_reg_info = new[31];
  act_ooo_fpr_reg_info = new[32];
  exp_ooo_gpr_reg_info = new[31];
  exp_ooo_fpr_reg_info = new[32];
  ooo_gpr_time  = new[31];
  ooo_fpr_time  = new[32];
	gpr_fail_flag = new[31];
  fpr_fail_flag	= new[32];	


  fork


		while(1) begin


			data_agent_port.get(data_act_tr);

			if(data_act_tr.verif_commit_valid) begin

	      data_act_tr.verif_update_reg_valid = 0;
        data_act_tr.verif_update_reg_pc    = 0;
        data_act_tr.verif_update_reg_rd    = 0;
        data_act_tr.verif_update_reg_rfd   = 0;
        data_act_tr.verif_update_reg_data  = 0;
				data_act_tr.verif_update_reg_gpr_en = 0;
				data_act_tr.verif_csr_mtvalWr = data_act_tr.verif_csr_mtvalWr& 64'hFF_FFFF_FFFF;
				//data_act_tr.verif_csr_mstatusWr = data_act_tr.verif_csr_mstatusWr & 32'h7FFF_9FFF;
        //data_act_tr.verif_csr_sstatusWr = data_act_tr.verif_csr_sstatusWr & 32'h7FFF_9FFF;
				
				->time_out_refresh;
        //finsh 
				if(data_act_tr.verif_sim_halt == 2) begin
		    	`uvm_error(get_type_name(),$sformatf("instr test fail , excption! "));
				end
		    else if( data_act_tr.verif_sim_halt == 1) begin
		    	`uvm_info(get_type_name(),$sformatf("instr test finish! "),UVM_NONE);
          instr_finish =1;
		    	//break;
		    end


		    if(data_act_tr.verif_commit_prevPc == 'h8000_0000) begin
		    	dut_start_cp = 1;
		    	init_spike_info(data_act_tr);
				  //force tb_top.testHarness.SimDTM.debug_req_bits_data[31:0] = 0;
				  //force tb_top.testHarness.SimDTM.debug_req_bits_op[1:0] = 0;
				  //force tb_top.testHarness.SimDTM.debug_req_bits_addr[6:0] = 0;
				  //force tb_top.testHarness.SimDTM.debug_req_valid = 0;
		    end

		    if(dut_start_cp & instr_finish!=1) begin
         	//`uvm_info(get_type_name(),{" scb get act data : ",data_act_tr.sprint},UVM_NONE);

		       inchi_difftest_exec();
		       do_exp_tr();
           //`uvm_info(get_type_name(),{" scb get exp data : ",data_exp_tr.sprint},UVM_NONE);

           foreach (act_ooo_gpr_reg_info[i]) begin
           	if(act_ooo_gpr_reg_info[i] != 0) begin
                ooo_gpr_time[i] ++;       
           	end
           end
           
           foreach (act_ooo_fpr_reg_info[j]) begin
           	if(act_ooo_fpr_reg_info[j] != 0) begin
                ooo_fpr_time[j] ++;       
           	end
           end

		    
          if(!data_act_tr.verif_sfma)begin
		     	  comp_pass = data_act_tr.compare(data_exp_tr);
				  end
		     	commit_num ++;

		     	if(comp_pass)begin
           	`uvm_info(get_type_name(),$sformatf(" dut and spike compare success,prevPc=%0h,commit_num=%0h ",data_act_tr.verif_commit_prevPc,commit_num),UVM_NONE);
		     	end
		     	else begin

         	  `uvm_info(get_type_name(),{" scb get act data : ",data_act_tr.sprint},UVM_NONE);
		     		`uvm_info(get_type_name(),{" scb get exp data : ",data_exp_tr.sprint},UVM_NONE);
		     		`uvm_error(get_type_name(),$sformatf(" dut and spike compare fail,prevPc=%0h,commit_num=%0h ",data_act_tr.verif_commit_prevPc,commit_num));



						/*
		     		// out of order commit check
						`uvm_info(get_type_name(),{" scb get act data : ",data_act_tr.sprint},UVM_NONE);
		     	  `uvm_info(get_type_name(),{" scb get exp data : ",data_exp_tr.sprint},UVM_NONE)
		     		foreach (data_act_tr.verif_reg_gpr_arr[i]) begin
               gpr_fail_flag[i] = 0;
		     			if(data_act_tr.verif_reg_gpr_arr[i] != data_exp_tr.verif_reg_gpr_arr[i] ) begin
		     
		     				if(ooo_gpr_time[i] >0 )begin //ooo reg has already exit

		     					//dut refresh existed ooo reg
		     					if(data_act_tr.verif_reg_gpr_arr[i] != act_ooo_gpr_reg_info[i][63:0]  )begin
                    `uvm_error(get_type_name(),$sformatf(" dut refresh gpr reg ,i=%0h,pc=%0h,this_reg=%0h ,last_reg =%0h,last_pc=%0h",i, data_act_tr.verif_commit_prevPc,data_act_tr.verif_reg_gpr_arr[i],act_ooo_gpr_reg_info[i][63:0],act_ooo_gpr_reg_info[i][127:64]));
		     					end
                   //ooo reg timeout 
		     					else if(ooo_gpr_time[i] >= 32)begin
		     						`uvm_error(get_type_name(),$sformatf(" ooo reg timeout ,i=%0h,act_ooo_reg=%0h ,exp_ooo_reg =%0h,pc=%0h",i,act_ooo_gpr_reg_info[i][63:0],exp_ooo_gpr_reg_info[i][63:0],act_ooo_gpr_reg_info[i][127:64]));
		     					end

		     				end
		     			  else begin//when ooo reg time 0 ,copy pc act_reg exp_reg
		              act_ooo_gpr_reg_info[i] = {data_act_tr.verif_commit_prevPc,data_act_tr.verif_reg_gpr_arr[i]};
                  exp_ooo_gpr_reg_info[i] = {data_exp_tr.verif_commit_prevPc,data_exp_tr.verif_reg_gpr_arr[i]};
		     					`uvm_info(get_type_name(),$sformatf(" copy gpr ooo reg info,reg_num=%0h,exp_reg=%0h,exp_pc=%0h,act_reg=%0h,act_pc=%0h,gpr time=%0h ",i,data_exp_tr.verif_reg_gpr_arr[i],data_exp_tr.verif_commit_prevPc,data_act_tr.verif_reg_gpr_arr[i],data_act_tr.verif_commit_prevPc,ooo_gpr_time[i]),UVM_NONE);

		     				end

		     			  gpr_fail_flag[i] = 1;
		     				//`uvm_info(get_type_name(),$sformatf(" gpr reg compare fail , num : %0h ",i),UVM_NONE);
		     				
		     			end
		     		end // end foreach

		     		foreach (data_act_tr.verif_reg_fpr_arr[i]) begin
               fpr_fail_flag[i] = 0;
		     			if(data_act_tr.verif_reg_fpr_arr[i] != data_exp_tr.verif_reg_fpr_arr[i] ) begin
		     
		     				if(ooo_fpr_time[i] >0 )begin //ooo reg has already exit

		     					//dut refresh existed ooo reg
		     					if(data_act_tr.verif_reg_fpr_arr[i] != act_ooo_fpr_reg_info[i][63:0]  )begin
                    `uvm_error(get_type_name(),$sformatf(" dut refresh fpr reg ,i=%0h,pc=%0h,this_reg=%0h ,last_reg =%0h,last_pc=%0h",i,data_act_tr.verif_commit_prevPc ,data_act_tr.verif_reg_fpr_arr[i],act_ooo_fpr_reg_info[i][63:0],act_ooo_fpr_reg_info[i][127:64]));
		     					end
                   //ooo reg timeout 
		     					else if(ooo_fpr_time[i] >= 32)begin
		     						`uvm_error(get_type_name(),$sformatf(" ooo reg timeout ,i=%0h,act_ooo_reg=%0h ,exp_ooo_reg=%0h,pc=%0h",i,act_ooo_fpr_reg_info[i][63:0],exp_ooo_fpr_reg_info[i][63:0],act_ooo_fpr_reg_info[i][127:64]));
		     					end

		     				end
		     			  else begin//when ooo reg time 0 ,copy pc act_reg exp_reg
		              act_ooo_fpr_reg_info[i] = {data_act_tr.verif_commit_prevPc,data_act_tr.verif_reg_fpr_arr[i]};
                  exp_ooo_fpr_reg_info[i] = {data_exp_tr.verif_commit_prevPc,data_exp_tr.verif_reg_fpr_arr[i]};
		     					//`uvm_info(get_type_name(),$sformatf(" copy fpr ooo reg info "),UVM_DEBUG);
		     					`uvm_info(get_type_name(),$sformatf(" copy fpr ooo reg info,reg_num=%0h,exp_reg=%0h,exp_pc=%0h,act_reg=%0h,act_pc=%0h,fpr_time=%0h ",i,data_exp_tr.verif_reg_fpr_arr[i],data_exp_tr.verif_commit_prevPc,data_act_tr.verif_reg_fpr_arr[i],data_act_tr.verif_commit_prevPc,ooo_fpr_time[i]),UVM_NONE);
									
		     				end

		     			  fpr_fail_flag[i] = 1;
		     				//`uvm_info(get_type_name(),$sformatf(" fpr reg compare fail , num : %0h,sum:%0h ,arr=%p",i,fpr_fail_flag.sum ,fpr_fail_flag),UVM_NONE);
		     			end
		     		end //end foreach

             `uvm_info(get_type_name(),$sformatf(" pc=%0h\ngpr time info : %p\nfpr time info : %p\nexp_ooo_gpr_reg_info : %p\nexp_ooo_fpr_reg_info : %p\n",data_act_tr.verif_commit_prevPc,ooo_gpr_time,ooo_fpr_time,exp_ooo_gpr_reg_info,exp_ooo_fpr_reg_info),UVM_NONE);
		     		if(gpr_fail_flag.sum == 0 && fpr_fail_flag.sum == 0 ) begin              
		     			`uvm_error(get_type_name(),$sformatf(" dut and spike compare fail,prevPc=%0h,commit_num=%0h ",data_act_tr.verif_commit_prevPc,commit_num));
         	    `uvm_info(get_type_name(),{" scb get act data : ",data_act_tr.sprint},UVM_NONE);
		     		  `uvm_info(get_type_name(),{" scb get exp data : ",data_exp_tr.sprint},UVM_NONE);

		     		end   
						*/
		     	end// end else if comp pass

		    end //end if dut_start_cp
			end//end if valid
			  		
		end //end while 1

		
    //dut update ooo reg info
	  while(1) begin
			data_agent_port_update.get(data_act_tr_1);
			if(data_act_tr_1.verif_update_reg_valid & dut_start_cp)begin
				gpr_reg_num = data_act_tr_1.verif_update_reg_rd;
				fpr_reg_num = data_act_tr_1.verif_update_reg_rfd;

				if(data_act_tr_1.verif_update_reg_gpr_en)begin//update gpr
					if(exp_ooo_gpr_reg_info[gpr_reg_num] == {data_act_tr_1.verif_update_reg_pc,data_act_tr_1.verif_update_reg_data}) begin
	          `uvm_info(get_type_name(),$sformatf(" dut update gpr reg pc success ,reg_num=%0h,exp_reg=%0h,exp_pc=%0h,act_reg=%0h,act_pc=%0h,",gpr_reg_num,exp_ooo_gpr_reg_info[gpr_reg_num][63:0],exp_ooo_gpr_reg_info[gpr_reg_num][127:64],data_act_tr_1.verif_update_reg_data, data_act_tr_1.verif_update_reg_pc),UVM_NONE);						
            act_ooo_gpr_reg_info[gpr_reg_num] = 0;
						exp_ooo_gpr_reg_info[gpr_reg_num] = 0;
						ooo_gpr_time[gpr_reg_num] = 0;            
					end
					else if(exp_ooo_gpr_reg_info[gpr_reg_num] != 0) begin // o do not check
						`uvm_error(get_type_name(),$sformatf(" dut update gpr reg pc not match ,reg_num=%0h,exp_reg=%0h,exp_pc=%0h,act_reg=%0h,act_pc=%0h,",gpr_reg_num,exp_ooo_gpr_reg_info[gpr_reg_num][63:0],exp_ooo_gpr_reg_info[gpr_reg_num][127:64],data_act_tr_1.verif_update_reg_data, data_act_tr_1.verif_update_reg_pc));
					end
				end
				else begin //update fpr
					if(exp_ooo_fpr_reg_info[fpr_reg_num] == {data_act_tr_1.verif_update_reg_pc,data_act_tr_1.verif_update_reg_data}) begin
	          `uvm_info(get_type_name(),$sformatf(" dut update fpr reg success ,reg_num=%0h,exp_reg=%0h,exp_pc=%0h,act_reg=%0h,act_pc=%0h,",fpr_reg_num,exp_ooo_fpr_reg_info[fpr_reg_num][63:0],exp_ooo_fpr_reg_info[fpr_reg_num][127:64],data_act_tr_1.verif_update_reg_data, data_act_tr_1.verif_update_reg_pc),UVM_NONE);						
            act_ooo_fpr_reg_info[fpr_reg_num] = 0;
						exp_ooo_fpr_reg_info[fpr_reg_num] = 0;
						ooo_fpr_time[fpr_reg_num] = 0;             
					end
					else if(exp_ooo_fpr_reg_info[fpr_reg_num] != 0)begin // 0 do not check
						`uvm_error(get_type_name(),$sformatf(" dut update fpr reg pc not match ,reg_num=%0h,exp_reg=%0h,exp_pc=%0h,act_reg=%0h,act_pc=%0h,",fpr_reg_num,exp_ooo_fpr_reg_info[fpr_reg_num][63:0],exp_ooo_fpr_reg_info[fpr_reg_num][127:64],data_act_tr_1.verif_update_reg_data, data_act_tr_1.verif_update_reg_pc));
					end
				end
			end// end if data_act_tr.verif_update_reg_valid

		end // end while 1

     


	join


endtask

task vpu_scb::do_exp_tr();
 

  bit [63:0] spike_arry[154];
  /*
  struct diff_context_t {
  word_t gpr[32]; 122-153
  word_t fpr[32]; 90-121
  vector128_t vpr[32]; 26-89
  uint64_t priv; 25
  uint64_t mstatus; 24
  uint64_t sstatus; 23
  uint64_t mepc; 22
  uint64_t sepc; 21
  uint64_t mtval; 20
  uint64_t stval; 19
  uint64_t mtvec; 18
  uint64_t stvec; 17
  uint64_t mcause; 16
  uint64_t scause; 15
  uint64_t satp; 14
  uint64_t mip; 13
  uint64_t mie; 12
  uint64_t mscratch; 11
  uint64_t sscratch; 10
  uint64_t mideleg; 9
  uint64_t medeleg; 8
  uint64_t pc; 7
  uint64_t pre_pc; 6
  uint64_t minstret; 5
  uint64_t vtype; 4
  uint64_t vcsr; 3
  uint64_t vl; 2
  uint64_t vstart; 1
  uint64_t instruction; 0
  };
	*/

  inchi_difftest_get_reg(spike_arry);
  `uvm_info(get_type_name(),$sformatf(" get spike value spike_arry=%p", spike_arry),UVM_HIGH);

//if(spike_arry[6] == 'h8000_00e0)begin
//  inchi_difftest_exec();
//  inchi_difftest_get_reg(spike_arry);
//  `uvm_info(get_type_name(),$sformatf(" skip spike  spike_arry=%p", spike_arry),UVM_NONE);
//end


	data_exp_tr.verif_reg_gpr_arr = new[31];
  data_exp_tr.verif_reg_fpr_arr = new[32];
  data_exp_tr.verif_reg_vpr_arr = new[32];

    data_exp_tr.verif_commit_valid   =      1;		
    //data_exp_tr.verif_commit_start   =      1;
    data_exp_tr.verif_commit_prevPc  =      spike_arry[6];
    data_exp_tr.verif_commit_currPc  =      spike_arry[7];
    data_exp_tr.verif_commit_order   =      0;//not use
    data_exp_tr.verif_commit_insn    =      spike_arry[0];
    data_exp_tr.verif_commit_fused   =      0;//tie 0
    data_exp_tr.verif_sim_halt       =      0;//tie 0
    data_exp_tr.verif_trap_valid     =      0;//tie 0
    data_exp_tr.verif_trap_pc        =      0;//tie 0
    data_exp_tr.verif_trap_firstInsn =      0;//tie 0

		for(int i=0;i<31;i++)begin
    	data_exp_tr.verif_reg_gpr_arr[i]   =      spike_arry[i+122+1];
		//`uvm_info(get_type_name(),$sformatf(" verif_reg_gpr_arr=%0h,verif_reg_gpr=%0h", data_exp_tr.verif_reg_gpr_arr[i],vif.verif_reg_gpr[64*i+:64]),UVM_NONE);
	  end
    for(int i=0;i<32;i++)begin
    	data_exp_tr.verif_reg_fpr_arr[i]   =      spike_arry[90+i];

    	data_exp_tr.verif_reg_vpr_arr[i]   =      {spike_arry[2*i+27],spike_arry[2*i+26]};
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

    data_exp_tr.verif_csr_mstatusWr  =      spike_arry[24]; // bit 13,14,31 not care
    data_exp_tr.verif_csr_mepcWr     =      spike_arry[22];
    data_exp_tr.verif_csr_mtvalWr    =      spike_arry[20] & 64'hFF_FFFF_FFFF;
    data_exp_tr.verif_csr_mtvecWr    =      spike_arry[18];
    data_exp_tr.verif_csr_mcauseWr   =      spike_arry[16];
    data_exp_tr.verif_csr_mipWr      =      spike_arry[13];//todoy
    data_exp_tr.verif_csr_mieWr      =      spike_arry[12];
    data_exp_tr.verif_csr_mscratchWr =      spike_arry[11];
    data_exp_tr.verif_csr_midelegWr  =      spike_arry[9];
    data_exp_tr.verif_csr_medelegWr  =      spike_arry[8];
    data_exp_tr.verif_csr_minstretWr =      spike_arry[5];//todo
    data_exp_tr.verif_csr_sstatusWr  =      spike_arry[23];
    data_exp_tr.verif_csr_sepcWr     =      spike_arry[21];
    data_exp_tr.verif_csr_stvalWr    =      spike_arry[19];
    data_exp_tr.verif_csr_stvecWr    =      spike_arry[17];
    data_exp_tr.verif_csr_scauseWr   =      spike_arry[15];
    data_exp_tr.verif_csr_satpWr     =      spike_arry[14];
    data_exp_tr.verif_csr_sscratchWr =      spike_arry[10];
    data_exp_tr.verif_csr_vtypeWr    =      spike_arry[4];
    data_exp_tr.verif_csr_vcsrWr     =      spike_arry[3];
    data_exp_tr.verif_csr_vlWr       =      spike_arry[2];
    data_exp_tr.verif_csr_vstartWr   =      spike_arry[1];
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

    // do not need to compare
		data_exp_tr.verif_update_reg_valid = 0;
    data_exp_tr.verif_update_reg_pc    = 0;
    data_exp_tr.verif_update_reg_rd    = 0;
    data_exp_tr.verif_update_reg_rfd   = 0;
    data_exp_tr.verif_update_reg_data  = 0;
		data_exp_tr.verif_update_reg_gpr_en =0;



endtask



task vpu_scb::init_spike_info(data_trans data_act_tr);

    bit [63:0] spike_arry[154];

    spike_arry[6] = data_act_tr.verif_commit_prevPc;
    spike_arry[7] = data_act_tr.verif_commit_currPc;

		for(int i=0;i<31;i++)begin
    	spike_arry[i+122+1] = data_act_tr.verif_reg_gpr_arr[i];
		//`uvm_info(get_type_name(),$sformatf(" verif_reg_gpr_arr=%0h,verif_reg_gpr=%0h", data_exp_tr.verif_reg_gpr_arr[i],vif.verif_reg_gpr[64*i+:64]),UVM_NONE);
	  end
    for(int i=0;i<32;i++)begin
    	spike_arry[90+i] = data_act_tr.verif_reg_fpr_arr[i];

			spike_arry[2*i+26] = data_act_tr.verif_reg_vpr_arr[i][63:0];
			spike_arry[2*i+27] = data_act_tr.verif_reg_vpr_arr[i][127:64];
	   end



  spike_arry[24] =   data_act_tr.verif_csr_mstatusWr  ;      
  spike_arry[22] =   data_act_tr.verif_csr_mepcWr     ;      
  spike_arry[20] =   data_act_tr.verif_csr_mtvalWr    ;      
  spike_arry[18] =   data_act_tr.verif_csr_mtvecWr    ;      
  spike_arry[16] =   data_act_tr.verif_csr_mcauseWr   ;      
  spike_arry[13] =   data_act_tr.verif_csr_mipWr      ;      
  spike_arry[12] =   data_act_tr.verif_csr_mieWr      ;      
  spike_arry[11] =   data_act_tr.verif_csr_mscratchWr ;      
  spike_arry[9]  =   data_act_tr.verif_csr_midelegWr  ;      
  spike_arry[8]  =   data_act_tr.verif_csr_medelegWr  ;      
  spike_arry[5]  =   data_act_tr.verif_csr_minstretWr ;      
  spike_arry[23] =   data_act_tr.verif_csr_sstatusWr  ;      
  spike_arry[21] =   data_act_tr.verif_csr_sepcWr     ;      
  spike_arry[19] =   data_act_tr.verif_csr_stvalWr    ;      
  spike_arry[17] =   data_act_tr.verif_csr_stvecWr    ;      
  spike_arry[15] =   data_act_tr.verif_csr_scauseWr   ;      
  spike_arry[14] =   data_act_tr.verif_csr_satpWr     ;      
  spike_arry[10] =   data_act_tr.verif_csr_sscratchWr ;      
  spike_arry[4]  =   data_act_tr.verif_csr_vtypeWr    ;      
  spike_arry[3]  =   data_act_tr.verif_csr_vcsrWr     ;      
  spike_arry[2]  =   data_act_tr.verif_csr_vlWr       ;      
  spike_arry[1]  =   data_act_tr.verif_csr_vstartWr   ;      

	inchi_difftest_set_reg(spike_arry);
	
endtask

`endif // VPU_SCB_SV
