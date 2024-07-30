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

class dcache_scb extends uvm_component;
  `uvm_component_utils(dcache_scb)

  uvm_blocking_get_port #(svt_tilelink_slave_transaction) tl2sb_tla_port;
	//uvm_blocking_get_port #(svt_tilelink_slave_transaction) rm2sb_tla_port;

  static event time_out_refresh;
  extern function new(string name, uvm_component parent); 
  extern task main_phase(uvm_phase phase);
  extern task end_sim_check();
  extern task comp_a_channel();

endclass : dcache_scb 

function dcache_scb::new(string name, uvm_component parent);
  super.new(name, parent);
  tl2sb_tla_port = new("tl2sb_tla_port",this);
  //rm2sb_tla_port = new("rm2sb_tla_port",this);

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

	svt_tilelink_slave_transaction  tla_act_tr;
	
  while(1)begin

		tl2sb_tla_port.get(tla_act_tr);
		 `uvm_info(get_type_name(), {"get tla_act_tr\n",tla_act_tr.sprint}, UVM_NONE)
		

  end
endtask
`endif // DCACHE_SCB_SV
