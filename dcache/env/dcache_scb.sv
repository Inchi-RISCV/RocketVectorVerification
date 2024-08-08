//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_scb.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_SCB_SV_
`define _DCACHE_SCB_SV_

//`uvm_analysis_imp_decl(_slave_trans_status)
`uvm_analysis_imp_decl(_master_trans_tx) // for master mon write for tx

`uvm_analysis_imp_decl(_master_trans_rx) // for master mon write for rx
`uvm_analysis_imp_decl(_master_trans_status) // for master mon write for status

class dcache_scb extends uvm_scoreboard;
  `uvm_component_utils(dcache_scb)

  uvm_blocking_get_port #(svt_tilelink_master_transaction) rm2sb_tltx_port;
	`SVT_XVM(analysis_imp_master_trans_tx)     #(svt_tilelink_master_transaction, dcache_scb) tl2sb_tltx_port;
  `SVT_XVM(analysis_imp_master_trans_rx)     #(svt_tilelink_master_transaction, dcache_scb) tl2sb_tlrx_port;
  `SVT_XVM(analysis_imp_master_trans_status) #(svt_tilelink_master_status, dcache_scb) tl2sb_tlsta_port;
 
	//svt_tilelink_slave_transaction tlrx_act_q[$];
  //svt_tilelink_slave_status  tl_cha_act_q[$];

  svt_tilelink_master_transaction  tl_cha_act_q[$];
	svt_tilelink_master_transaction  tl_cha_exp_q[$];
  static event time_out_refresh;
  extern function new(string name, uvm_component parent); 
  extern task main_phase(uvm_phase phase);
  extern task end_sim_check();
  extern task comp_a_channel();
	extern task comp_lsu_rsp();

  /**  write for master driver */
  virtual function void write_master_trans_tx(svt_tilelink_master_transaction master_trans);
    `uvm_info(get_type_name(), {"get tl2sb_tltx_port\n",master_trans.sprint}, UVM_HIGH)

		`uvm_info(get_type_name(), $sformatf("tl2sb_tltx_port addr=%0h,source=%0h",master_trans.a_address,master_trans.a_source), UVM_NONE)
     tl_cha_act_q.push_back(master_trans);

  endfunction : write_master_trans_tx

  /**  write for master MOnitor */
  virtual function void write_master_trans_rx(svt_tilelink_master_transaction master_trans);
	 //`uvm_info(get_type_name(), {"get tl2sb_tlrx_port\n",master_trans.sprint}, UVM_HIGH)
  endfunction : write_master_trans_rx

  /**  write for master Monitor */
  virtual function void write_master_trans_status(svt_tilelink_master_status master_trans);
	 //`uvm_info(get_type_name(), {"get tl2sb_tlsta_port\n",master_trans.sprint}, UVM_HIGH)


  endfunction : write_master_trans_status




endclass : dcache_scb 

function dcache_scb::new(string name, uvm_component parent);
  super.new(name, parent);

  tl2sb_tlsta_port = new("tl2sb_tlsta_port",this);
  tl2sb_tlrx_port = new("tl2sb_tlrx_port",this);
  tl2sb_tltx_port = new("tl2sb_tltx_port",this);
	
	rm2sb_tltx_port = new("rm2sb_tltx_port",this);

endfunction : new

task dcache_scb::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	fork
		comp_a_channel();
		end_sim_check();
	join_any

	`uvm_info(get_type_name(),$sformatf(" scb finish! "),UVM_NONE);
  phase.drop_objection(this);

endtask : main_phase

task dcache_scb::end_sim_check();

	int time_cnt;
  fork


    while(1) begin
    	@time_out_refresh;
    	time_cnt=0;
    	`uvm_info(get_type_name(),$sformatf("Get Tilelink A data"),UVM_DEBUG);
    end
    while(1) begin
    	@(posedge tb_top.clock);
    	time_cnt++;
    	`uvm_info(get_type_name(),$sformatf("time_cnt:%0d",time_cnt),UVM_DEBUG);
    end

    while(1) begin
    	@(posedge tb_top.clock);
    	if(time_cnt>=2000)begin
    	  //`uvm_error(get_type_name(),$sformatf("No Tilelink A data, timeout ! "));
				`uvm_info(get_type_name(),$sformatf("No Tilelink A data, timeout !"),UVM_NONE);
    	break;
      end
    end

  join_any
endtask


task dcache_scb::comp_a_channel();

	svt_tilelink_master_transaction  tla_act_tr;
	svt_tilelink_master_transaction tla_exp_tr,tr;

	tla_act_tr = new();
  tla_exp_tr = new();
	tr=new();


	fork
		
    while(1)begin
			rm2sb_tltx_port.get(tr);
			`uvm_info(get_type_name(), {"get tl_cha_exp_tr\n",tr.sprint}, UVM_HIGH)
			tl_cha_exp_q.push_back(tr);	
    end

    while(1)begin
			wait(tl_cha_act_q.size()>0);
    	if(tl_cha_act_q.size()>0)begin
    		tla_act_tr = tl_cha_act_q.pop_front();
				tla_exp_tr = tl_cha_exp_q.pop_front();
    	 `uvm_info(get_type_name(), {"get tl_cha_act_tr\n",tla_act_tr.sprint}, UVM_HIGH)

			 if(tla_exp_tr.a_address != tla_act_tr.a_address || tla_exp_tr.a_size != tla_act_tr.a_size || tla_exp_tr.a_source != tla_act_tr.a_source || tla_exp_tr.ch_a_msg_type  != tla_act_tr.ch_a_msg_type  || tla_exp_tr.a_param != tla_act_tr.a_param)begin

				 `uvm_error(get_type_name(),$sformatf(" tl cha compare fail!\nExpect addr=%0h,size=%0h,opcede=%0h,source=%0h,param=%0h\nActual addr=%0h,size=%0h,opcede=%0h,source=%0h,param=%0h",tla_exp_tr.a_address,tla_exp_tr.a_size,tla_exp_tr.ch_a_msg_type,tla_exp_tr.a_source,tla_exp_tr.a_param,tla_act_tr.a_address,tla_act_tr.a_size,tla_act_tr.ch_a_msg_type,tla_act_tr.a_source,tla_act_tr.a_param));

			 end
			 else begin
         `uvm_info(get_type_name(), $sformatf("tl cha compare pass! addr=%0h,source=%0h,param=%0h",tla_act_tr.a_address,tla_act_tr.a_source,tla_act_tr.a_param), UVM_NONE)
			 end

      end	
    end

  join
endtask

task dcache_scb::comp_lsu_rsp();


endtask
`endif // DCACHE_SCB_SV
