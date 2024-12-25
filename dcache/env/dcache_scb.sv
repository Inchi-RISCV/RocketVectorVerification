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
 `uvm_analysis_imp_decl(_slave_trans_tx)  // for slave mon tx


class dcache_scb extends uvm_scoreboard;
  `uvm_component_utils(dcache_scb)

  uvm_blocking_get_port #(svt_tilelink_master_transaction) rm2sb_tltx_port;
	uvm_blocking_get_port #(svt_tilelink_slave_transaction)  rm2sb_tlc_port;
  uvm_blocking_get_port #(lsu_trans) lsu2sb_rsp_port;
	uvm_blocking_get_port #(lsu_trans) rm2sb_rsp_port;
	`SVT_XVM(analysis_imp_master_trans_tx)     #(svt_tilelink_master_transaction, dcache_scb) tl2sb_tltx_port;
  `SVT_XVM(analysis_imp_master_trans_rx)     #(svt_tilelink_master_transaction, dcache_scb) tl2sb_tlrx_port;
  `SVT_XVM(analysis_imp_master_trans_status) #(svt_tilelink_master_status, dcache_scb) tl2sb_tlsta_port;
  `SVT_XVM(analysis_imp_slave_trans_tx)      #(svt_tilelink_slave_transaction,  dcache_scb) tl2sb_tlc_port;
	//svt_tilelink_slave_transaction tlrx_act_q[$];
  //svt_tilelink_slave_status  tl_cha_act_q[$];

  svt_tilelink_master_transaction  tl_cha_act_q[$];
	svt_tilelink_master_transaction  tl_cha_exp_q[$];
	lsu_trans rsp_exp_q[$],rsp_act_q[$];
	lsu_trans rsp_refill_exp_q[$],rsp_refill_act_q[$];
	svt_tilelink_slave_transaction  tl_chc_exp_q[$];
	svt_tilelink_slave_transaction  tl_chc_act_q[$];


  static event time_out_refresh;
  extern function new(string name, uvm_component parent); 
  extern task main_phase(uvm_phase phase);
  extern task end_sim_check();
  extern task comp_a_channel();
	extern task comp_c_channel();
	extern task comp_lsu_rsp();

  /**  write for master driver */
  virtual function void write_master_trans_tx(svt_tilelink_master_transaction master_trans);
    `uvm_info(get_type_name(), {"get tl2sb_tltx_port\n",master_trans.sprint}, UVM_HIGH)

		if((master_trans.ch_a_msg_type ==  svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA) || (master_trans.ch_a_msg_type ==  svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA))begin
		  `uvm_info(get_type_name(), $sformatf("tl2sb_tltx_port addr=%0h,source=%0h",master_trans.a_address,master_trans.a_source), UVM_NONE)
			`uvm_info(get_type_name(), $sformatf("tl2sb_tltx_port data=%p,mask=%p",master_trans.a_data,master_trans.a_mask), UVM_NONE)
	  end
	  else  begin
      `uvm_info(get_type_name(), $sformatf("tl2sb_tltx_port addr=%0h,source=%0h",master_trans.a_address,master_trans.a_source), UVM_NONE)
	  end
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

  //  write for slave monitor 
  virtual function void write_slave_trans_tx(svt_tilelink_slave_transaction slave_trans);
    `uvm_info(get_type_name(), {"get tl2sb_tlc_port\n",slave_trans.sprint}, UVM_NONE)
		tl_chc_act_q.push_back(slave_trans);
		//`uvm_info(get_type_name(), $sformatf("tl2sb_tlc_port addr=%0h",slave_trans.status.c_address), UVM_NONE)
  endfunction : write_slave_trans_tx


endclass : dcache_scb 

function dcache_scb::new(string name, uvm_component parent);
  super.new(name, parent);

  tl2sb_tlsta_port = new("tl2sb_tlsta_port",this);
  tl2sb_tlrx_port = new("tl2sb_tlrx_port",this);
  tl2sb_tltx_port = new("tl2sb_tltx_port",this);
	
	rm2sb_tltx_port = new("rm2sb_tltx_port",this);
	lsu2sb_rsp_port = new("lsu2sb_rsp_port",this);
	rm2sb_rsp_port= new("rm2sb_rsp_port",this);
  tl2sb_tlc_port = new("tl2sb_tlc_port",this);
  rm2sb_tlc_port = new("rm2sb_tlc_port",this);
	
endfunction : new

task dcache_scb::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	fork
		comp_a_channel();
		comp_c_channel();
		end_sim_check();
		comp_lsu_rsp();
	join_any

	`uvm_info(get_type_name(),$sformatf(" scb finish! "),UVM_NONE);
  phase.drop_objection(this);

endtask : main_phase

task dcache_scb::end_sim_check();

	int time_cnt;
	int delay_time;
	delay_time = vmm_opts::get_int("delay_time",3000,"delay_time");
  fork


    while(1) begin
    	@time_out_refresh;
    	time_cnt=0;
    	`uvm_info(get_type_name(),$sformatf("Get DUT data"),UVM_DEBUG);
    end
    while(1) begin
    	@(posedge tb_top.clock);
    	time_cnt++;
    	`uvm_info(get_type_name(),$sformatf("time_cnt:%0d",time_cnt),UVM_DEBUG);
    end

    while(1) begin
    	@(posedge tb_top.clock);
			if(time_cnt>=delay_time)begin
				`uvm_info(get_type_name(),$sformatf("DUT donot has data for %0h cycle,finish!",delay_time),UVM_NONE);
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
			wait(tl_cha_act_q.size()>0 & tl_cha_exp_q.size()>0);
    	if(tl_cha_act_q.size()>0)begin
    		tla_act_tr = tl_cha_act_q.pop_front();
				tla_exp_tr = tl_cha_exp_q.pop_front();
				->time_out_refresh;
    	  `uvm_info(get_type_name(), {"get tl_cha_act_tr\n",tla_act_tr.sprint}, UVM_HIGH)

			 if(tla_exp_tr.a_address != tla_act_tr.a_address || tla_exp_tr.a_size != tla_act_tr.a_size || tla_exp_tr.a_source != tla_act_tr.a_source || tla_exp_tr.ch_a_msg_type  != tla_act_tr.ch_a_msg_type  || tla_exp_tr.a_param != tla_act_tr.a_param)begin

				 `uvm_error(get_type_name(),$sformatf(" tl cha compare fail!\nExpect addr=%0h,size=%0h,opcede=%0h,source=%0h,param=%0h\nActual addr=%0h,size=%0h,opcede=%0h,source=%0h,param=%0h",tla_exp_tr.a_address,tla_exp_tr.a_size,tla_exp_tr.ch_a_msg_type,tla_exp_tr.a_source,tla_exp_tr.a_param,tla_act_tr.a_address,tla_act_tr.a_size,tla_act_tr.ch_a_msg_type,tla_act_tr.a_source,tla_act_tr.a_param));

			 end
			 else begin
         `uvm_info(get_type_name(), $sformatf("tl cha compare pass! addr=%0h,source=%0h,param=%0h",tla_act_tr.a_address,tla_act_tr.a_source,tla_act_tr.a_param), UVM_NONE)
			 end

			 //put

			 if((tla_act_tr.ch_a_msg_type ==  svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA) || (tla_act_tr.ch_a_msg_type ==  svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA))begin

				 if(tla_exp_tr.a_data != tla_act_tr.a_data || tla_exp_tr.a_mask != tla_act_tr.a_mask)begin
					 `uvm_error(get_type_name(),$sformatf(" tl cha compare fail!\naddr=%0h\nExpect data=%p,mask=%p\nActual data=%p,mask=%p",tla_exp_tr.a_address,tla_exp_tr.a_data,tla_exp_tr.a_mask,tla_act_tr.a_data,tla_act_tr.a_mask));


				 end
	    end


      end	
    end

  join
endtask

task dcache_scb::comp_c_channel();
	svt_tilelink_slave_transaction  tr,tlc_act_tr,tlc_exp_tr;

	fork

    while(1)begin
      rm2sb_tlc_port.get(tr);
    	`uvm_info(get_type_name(), {"get tl_chc_exp_tr\n",tr.sprint}, UVM_HIGH)
    	tl_chc_exp_q.push_back(tr);	
    end

	  while(1)begin
			wait(tl_chc_act_q.size()>0 & tl_chc_exp_q.size()>0 );
    	if(tl_chc_act_q.size()>0)begin
    		tlc_act_tr = tl_chc_act_q.pop_front();
				tlc_exp_tr = tl_chc_exp_q.pop_front();
				->time_out_refresh;
    	  `uvm_info(get_type_name(), {"get tl_chc_act_tr\n",tlc_act_tr.sprint}, UVM_HIGH)

				if(tlc_act_tr.status.c_address != tlc_exp_tr.status.c_address || tlc_act_tr.status.c_size != tlc_exp_tr.status.c_size ||
				   tlc_act_tr.status.ch_c_msg_type!=  tlc_exp_tr.status.ch_c_msg_type  || tlc_act_tr.status.c_param != tlc_exp_tr.status.c_param ||
					 tlc_act_tr.status.c_data != tlc_exp_tr.status.c_data )begin
					 `uvm_error(get_type_name(),$sformatf(" tl chc compare fail!\nExpect addr=%0h,size=%0h,opcede=%0h,param=%0h\nActual addr=%0h,size=%0h,opcede=%0h,param=%0h\nExpect data=%p\nActual data=%p",tlc_exp_tr.status.c_address,tlc_exp_tr.status.c_size,tlc_exp_tr.status.ch_c_msg_type,tlc_exp_tr.status.c_param,tlc_act_tr.status.c_address,tlc_act_tr.status.c_size,tlc_act_tr.status.ch_c_msg_type,tlc_act_tr.status.c_param,tlc_exp_tr.status.c_data,tlc_act_tr.status.c_data));

				end
				else begin
           `uvm_info(get_type_name(), $sformatf("tl chc compare pass! addr=%0h,opcode=%0h,param=%0h",tlc_act_tr.status.c_address,tlc_act_tr.status.ch_c_msg_type,tlc_act_tr.status.c_param), UVM_NONE)
				end

			end

	  end
  

  join

endtask

task dcache_scb::comp_lsu_rsp();
	lsu_trans exp_tr,act_tr,rsp_act_tr,rsp_refill_act_tr,rsp_exp_tr,refill_exp_tr,act_tr_tmp,exp_tr_tmp;

  exp_tr =  new();
  rsp_act_tr = new();
	rsp_exp_tr = new();
	refill_exp_tr = new();
  rsp_refill_act_tr = new();
  act_tr = new();


	fork 

    while(1)begin
		  exp_tr_tmp =new();	 
		  rm2sb_rsp_port.get(exp_tr);
		  exp_tr_tmp.copy(exp_tr);
		  `uvm_info(get_type_name(), {"get exp_tr\n",exp_tr_tmp.sprint}, UVM_HIGH)
		  if(exp_tr_tmp.io_resp_bits_status == lsu_trans::REFILL  )begin
				rsp_refill_exp_q.push_back(exp_tr_tmp);
		   end
			else begin
        rsp_exp_q.push_back(exp_tr_tmp);
			end
		end

    while(1)begin
			act_tr_tmp =new();
			lsu2sb_rsp_port.get(act_tr);
			->time_out_refresh;
      act_tr_tmp.copy(act_tr);
			`uvm_info(get_type_name(), {"get rsp_act_tr\n",act_tr_tmp.sprint}, UVM_HIGH)	
			if(act_tr_tmp.io_resp_bits_status == lsu_trans::REFILL)begin
        rsp_refill_act_q.push_back(act_tr_tmp);     
				//`uvm_info(get_type_name(),$sformatf("put rsp_refill_act_q tr ,dest=%0h,status=%0h",act_tr_tmp.io_resp_bits_dest,act_tr_tmp.io_resp_bits_status),UVM_NONE)
				//foreach(rsp_refill_act_q[i]) begin
        //  $display(rsp_refill_act_q[i].io_resp_bits_dest);
				//end
		  end
			else begin
        rsp_act_q.push_back(act_tr_tmp);
			end 
		 end

     // comp refill rsp
	   while(1)begin
       wait (rsp_refill_act_q.size()>0 && rsp_refill_exp_q.size()>0);
			 //`uvm_info(get_type_name(),$sformatf("rsp_refill_act_q size=%0h",rsp_refill_act_q.size()),UVM_NONE) 
       rsp_refill_act_tr = rsp_refill_act_q.pop_front();
			 `uvm_info(get_type_name(),$sformatf("get rsp_refill_act_q tr ,dest=%0h,status=%0h",rsp_refill_act_tr.io_resp_bits_dest,rsp_refill_act_tr.io_resp_bits_status),UVM_NONE)   
			 refill_exp_tr = rsp_refill_exp_q.pop_front();
       if(rsp_refill_act_tr.io_resp_bits_source != refill_exp_tr.io_resp_bits_source || rsp_refill_act_tr.io_resp_bits_dest != refill_exp_tr.io_resp_bits_dest || rsp_refill_act_tr.io_resp_bits_status != refill_exp_tr.io_resp_bits_status || rsp_refill_act_tr.io_resp_bits_hasData != refill_exp_tr.io_resp_bits_hasData  || rsp_refill_act_tr.io_resp_bits_data != refill_exp_tr.io_resp_bits_data )begin
			   `uvm_error(get_type_name(),$sformatf(" refill rsp compare fail!\nExpect dest=%0h,source=%0h,status=%0h,hasdata=%0h,data=%0h\nActual dest=%0h,source=%0h,status=%0h,hasdata=%0h,data=%0h",refill_exp_tr.io_resp_bits_dest,refill_exp_tr.io_resp_bits_source,refill_exp_tr.io_resp_bits_status,refill_exp_tr.io_resp_bits_hasData,refill_exp_tr.io_resp_bits_data,rsp_refill_act_tr.io_resp_bits_dest,rsp_refill_act_tr.io_resp_bits_source,rsp_refill_act_tr.io_resp_bits_status,rsp_refill_act_tr.io_resp_bits_hasData,rsp_refill_act_tr.io_resp_bits_data));
			 end
			 else begin
         `uvm_info(get_type_name(),$sformatf("refill rsp compare pass,dest=%0h,source=%0h,status=%0h,hasdata=%0h,data=%0h",rsp_refill_act_tr.io_resp_bits_dest,rsp_refill_act_tr.io_resp_bits_source,rsp_refill_act_tr.io_resp_bits_status,rsp_refill_act_tr.io_resp_bits_hasData,rsp_refill_act_tr.io_resp_bits_data),UVM_NONE)
			 end
     end

     //comp hit&miss rsp
	   while(1) begin
			 wait (rsp_act_q.size()>0 & rsp_exp_q.size()>0);
       rsp_act_tr = rsp_act_q.pop_front();
       rsp_exp_tr = rsp_exp_q.pop_front();
			 if(rsp_act_tr.io_resp_bits_source != rsp_exp_tr.io_resp_bits_source || rsp_act_tr.io_resp_bits_dest != rsp_exp_tr.io_resp_bits_dest || rsp_act_tr.io_resp_bits_status != rsp_exp_tr.io_resp_bits_status || rsp_act_tr.io_resp_bits_hasData != rsp_exp_tr.io_resp_bits_hasData)begin
				 `uvm_error(get_type_name(),$sformatf("rsp compare fail!\nExpect dest=%0h,source=%0h,status=%0h,hasdata=%0h\nActual dest=%0h,source=%0h,status=%0h,hasdata=%0h",rsp_exp_tr.io_resp_bits_dest,rsp_exp_tr.io_resp_bits_source,rsp_exp_tr.io_resp_bits_status,rsp_exp_tr.io_resp_bits_hasData,rsp_act_tr.io_resp_bits_dest,rsp_act_tr.io_resp_bits_source,rsp_act_tr.io_resp_bits_status,rsp_act_tr.io_resp_bits_hasData));
			 end
			 else begin
         `uvm_info(get_type_name(),$sformatf("rsp compare pass,dest=%0h,source=%0h,status=%0h,hasdata=%0h",rsp_act_tr.io_resp_bits_dest,rsp_act_tr.io_resp_bits_source,rsp_act_tr.io_resp_bits_status,rsp_act_tr.io_resp_bits_hasData),UVM_NONE)
			 end

		   if(rsp_act_tr.io_resp_bits_hasData)begin
			   if(rsp_act_tr.io_resp_bits_data != rsp_exp_tr.io_resp_bits_data)begin
				   `uvm_error(get_type_name(),$sformatf("rsp compare fail!\nExpect dest=%0h,source=%0h,status=%0h,hasdata=%0h,data=%0h\nActual dest=%0h,source=%0h,status=%0h,hasdata=%0h,data=%0h",rsp_exp_tr.io_resp_bits_dest,rsp_exp_tr.io_resp_bits_source,rsp_exp_tr.io_resp_bits_status,rsp_exp_tr.io_resp_bits_hasData,rsp_exp_tr.io_resp_bits_data,rsp_act_tr.io_resp_bits_dest,rsp_act_tr.io_resp_bits_source,rsp_act_tr.io_resp_bits_status,rsp_act_tr.io_resp_bits_hasData,rsp_act_tr.io_resp_bits_data));
			   end
			 else begin
				 `uvm_info(get_type_name(),$sformatf("rsp compare pass,dest=%0h,source=%0h,status=%0h,hasdata=%0h,data=%0h",rsp_act_tr.io_resp_bits_dest,rsp_act_tr.io_resp_bits_source,rsp_act_tr.io_resp_bits_status,rsp_act_tr.io_resp_bits_hasData,rsp_act_tr.io_resp_bits_data),UVM_NONE)
			 end

		end



		 end


	join

endtask
`endif // DCACHE_SCB_SV
