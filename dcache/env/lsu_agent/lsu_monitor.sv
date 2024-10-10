//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_monitor.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_MONITOR_SV_
`define _LSU_MONITOR_SV_

`define DELAY 0.01ns

class lsu_monitor extends uvm_monitor;
  `uvm_component_utils(lsu_monitor)

  virtual interface  lsu_if vif;

  uvm_analysis_port #(lsu_trans) analysis_port_req;
	uvm_analysis_port #(lsu_trans) analysis_port_rsp;

	lsu_trans req_mon_q[$];
 
  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_mon_req();
  extern task do_mon_rsp();

endclass : lsu_monitor 

function lsu_monitor::new(string name, uvm_component parent);

  super.new(name, parent);
  analysis_port_req = new("analysis_port_req", this);
  analysis_port_rsp = new("analysis_port_rsp", this);

endfunction : new

function void lsu_monitor::build_phase(uvm_phase phase);

  super.build_phase(phase);

endfunction : build_phase

function void lsu_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual lsu_if)::get(this, "*", "lsu_vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task lsu_monitor::main_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)
  fork
    do_mon_req();
	  //do_mon_rsp();
  join


endtask : main_phase

task lsu_monitor::do_mon_req();

	lsu_trans tr_req , tr_rsp;

	tr_req = new("tr_req");
  tr_rsp = new("tr_rsp");

	forever begin
		@(posedge vif.clk)
		//`uvm_info(get_type_name(),$sformatf("monitor req doing ,valid=%0h,ready=%0h",vif.io_req_valid,vif.io_req_ready),UVM_NONE)
		if(vif.io_req_valid & vif.io_req_ready)begin
      tr_req.io_req_bits_source    = vif.io_req_bits_source;
      tr_req.io_req_bits_paddr     = vif.io_req_bits_paddr;
      tr_req.io_req_bits_cmd       = vif.io_req_bits_cmd;  
      tr_req.io_req_bits_size      = vif.io_req_bits_size;	
      tr_req.io_req_bits_signed    = vif.io_req_bits_signed;
      tr_req.io_req_bits_wdata     = vif.io_req_bits_wdata;	
      tr_req.io_req_bits_wmask     = vif.io_req_bits_wmask;	
      tr_req.io_req_bits_noAlloc   = vif.io_req_bits_noAlloc;
      tr_req.io_req_bits_dest      = vif.io_req_bits_dest;	
      tr_req.io_s0_kill            = vif.io_s0_kill;
      tr_req.io_s1_kill            = vif.io_s1_kill;
			//tr_req.replay_req            = vif.replay_req;
			`uvm_info(get_type_name(),$sformatf("monitor req ,addr=%0h,dest=%0h,cmd=%0h",tr_req.io_req_bits_paddr,tr_req.io_req_bits_dest,tr_req.io_req_bits_cmd),UVM_NONE)
			//req_mon_q.push_back(tr_req);
			analysis_port_req.write(tr_req);
		end			
	end

endtask : do_mon_req

task lsu_monitor::do_mon_rsp();

  lsu_trans tr_rsp,tr_req;
	tr_rsp = new();
  tr_req = new();

	forever begin
		@(posedge vif.clk)
		if(vif.io_resp_valid)begin
      tr_rsp.io_resp_bits_source  = vif.io_resp_bits_source;	
      tr_rsp.io_resp_bits_dest    = vif.io_resp_bits_dest;	
      tr_rsp.io_resp_bits_status  = vif.io_resp_bits_status;	
      tr_rsp.io_resp_bits_hasData = vif.io_resp_bits_hasData;	
      tr_rsp.io_resp_bits_data    = vif.io_resp_bits_data;	
      tr_rsp.io_nextCycleWb       = vif.io_nextCycleWb;	

			if(tr_rsp.io_resp_bits_status == lsu_trans::REPLAY)begin
				tr_req = req_mon_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("replay rsp donot send to scb ,dest=%0h",tr_rsp.io_resp_bits_dest),UVM_NONE)
				`uvm_info(get_type_name(),$sformatf("replay cmd donot send to rm ,addr=%0h,dest=%0h",tr_req.io_req_bits_paddr,tr_req.io_req_bits_dest),UVM_NONE)
			end
			else begin
			  analysis_port_rsp.write(tr_rsp);
				`uvm_info(get_type_name(), {"send monitor rsp item\n",tr_rsp.sprint}, UVM_HIGH)
				if(tr_rsp.io_resp_bits_status == lsu_trans::HIT || tr_rsp.io_resp_bits_status == lsu_trans::MISS)begin
					tr_req = req_mon_q.pop_front();
				  analysis_port_req.write(tr_req);
				  `uvm_info(get_type_name(), {"send monitor req item\n",tr_req.sprint}, UVM_HIGH)
			  end
			end		
		end	
	end

endtask : do_mon_rsp


`endif // LSU_MONITOR_SV


