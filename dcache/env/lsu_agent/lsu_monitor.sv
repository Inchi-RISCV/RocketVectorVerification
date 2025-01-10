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
 	bit [1:0] nextSource_q[$];
 	bit [1:0] nextSource;
	bit [2:0] req_size_q[$];
	bit [2:0] req_size;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_mon_req();
  extern task do_mon_rsp();
  extern task do_mon_nextCycle();

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
	  do_mon_rsp();
		do_mon_nextCycle();
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
			req_size_q.push_back(vif.io_req_bits_size);
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
      tr_rsp.io_resp_bits_size    = vif.io_resp_bits_size;
      //tr_rsp.io_nextCycleWb       = vif.io_nextCycleWb;	

			if(tr_rsp.io_resp_bits_status != lsu_trans::REPLAY)begin
			  analysis_port_rsp.write(tr_rsp);
			  `uvm_info(get_type_name(), {"send monitor rsp item\n",tr_rsp.sprint}, UVM_HIGH)
		  end

			//if(req_size_q.size()>0)begin
			//	req_size = req_size_q.pop_front();
			//	if(tr_rsp.io_resp_bits_size != req_size) begin
			//		`uvm_error(get_type_name(),$sformatf("Size compare fail!\nreq_size=%0h\nresp_size=%0h",req_size,tr_rsp.io_resp_bits_size));
			//	end
			//	else begin
			//		`uvm_info(get_type_name(),$sformatf("Size compare pass!!!"),UVM_NONE);
			//	end
			//end

			if(tr_rsp.io_resp_bits_status == lsu_trans::REFILL)begin
				if(nextSource_q.size()>0)begin
					nextSource = nextSource_q.pop_front();
					if(tr_rsp.io_resp_bits_source != nextSource) begin
						`uvm_error(get_type_name(),$sformatf("Source compare fail!\nnextSource=%0h\nio_resp_bits_source=%0h",nextSource,tr_rsp.io_resp_bits_source));
					end
					else begin
						`uvm_info(get_type_name(),$sformatf("Source compare pass!!!"),UVM_LOW);
					end
				end
			end
		end
	end
endtask : do_mon_rsp


task lsu_monitor::do_mon_nextCycle();
	forever begin
		@(posedge vif.clk)
		if(vif.io_nextCycleWb)begin
			nextSource_q.push_back(vif.io_nextSource);
			`uvm_info(get_type_name(),$sformatf("nextSource = %0h",vif.io_nextSource),UVM_DEBUG);
		end
	end

endtask : do_mon_nextCycle

`endif // LSU_MONITOR_SV


