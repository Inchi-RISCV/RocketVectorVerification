//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_driver.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_DRIVER_SV_
`define _LSU_DRIVER_SV_

class lsu_driver extends uvm_driver #(lsu_trans);
  `uvm_component_utils(lsu_driver)

  virtual interface  lsu_if vif;
	lsu_trans lsu_q[$],rsp,req_last;

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
	extern task reset_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_drive();
  extern task get_trans();
	extern task do_resp();


endclass : lsu_driver

function lsu_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void lsu_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void lsu_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db #(virtual lsu_if)::get(this, "*", "lsu_vif", vif))
    `uvm_error("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task lsu_driver::reset_phase(uvm_phase phase);
	super.reset_phase(phase);
  `uvm_info(get_type_name(), "reset_phase", UVM_HIGH)
  phase.raise_objection(this);
	  vif.io_req_valid <=0;
    vif.io_req_bits_source <=0;
    vif.io_req_bits_paddr <=0;
    vif.io_req_bits_cmd <=0;  
    vif.io_req_bits_size <=0;	
    vif.io_req_bits_signed <=0;
    vif.io_req_bits_wdata <=0;	
    vif.io_req_bits_wmask <=0;	
    vif.io_req_bits_noAlloc <=0;
    vif.io_req_bits_dest <=0;	
    vif.io_req_bits_isRefill <=0;	
    vif.io_req_bits_refillWay <=0;	
    vif.io_req_bits_refillCoh <=0;	
    vif.io_s0_kill <=0;
    vif.io_s1_kill <=0;
	phase.drop_objection(this);

endtask : reset_phase	

task lsu_driver::main_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "main_phase", UVM_HIGH)
  rsp = new("rsp");
	req_last = new("req_last");
  fork
    get_trans();
    do_drive();
		do_resp();
  join

endtask : main_phase

task lsu_driver::get_trans();
	forever begin
  seq_item_port.get_next_item(req);
  `uvm_info(get_type_name(), {"push req item\n",req.sprint}, UVM_HIGH)
  lsu_q.push_back(req);
  //rsp = new("rsp");  
	//rsp.set_id_info(req);
  //seq_item_port.put_response(rsp);  	
  seq_item_port.item_done();

  end

endtask : get_trans


task lsu_driver::do_drive();
	lsu_trans req,req_last;

	forever begin
		@(posedge vif.clk);

		if(rsp.io_resp_bits_status == 2) begin //replay cmd
      req = req_last;
			`uvm_info(get_type_name(), {"replay , req item\n",req.sprint}, UVM_NONE)
			do begin
        vif.io_req_valid          <= #`DELAY 1;
        vif.io_req_bits_source    <= #`DELAY req.io_req_bits_source;
        vif.io_req_bits_paddr     <= #`DELAY req.io_req_bits_paddr;
        vif.io_req_bits_cmd       <= #`DELAY req.io_req_bits_cmd;  
        vif.io_req_bits_size      <= #`DELAY req.io_req_bits_size;	
        vif.io_req_bits_signed    <= #`DELAY req.io_req_bits_signed;
        vif.io_req_bits_wdata     <= #`DELAY req.io_req_bits_wdata;	
        vif.io_req_bits_wmask     <= #`DELAY req.io_req_bits_wmask;	
        vif.io_req_bits_noAlloc   <= #`DELAY req.io_req_bits_noAlloc;
        vif.io_req_bits_dest      <= #`DELAY req.io_req_bits_dest;	
        vif.io_req_bits_isRefill  <= #`DELAY req.io_req_bits_isRefill;	
        vif.io_req_bits_refillWay <= #`DELAY req.io_req_bits_refillWay;	
        vif.io_req_bits_refillCoh <= #`DELAY req.io_req_bits_refillCoh;	
        vif.io_s0_kill            <= #`DELAY req.io_s0_kill;
        vif.io_s1_kill            <= #`DELAY req.io_s1_kill;
				req_last = req;
				@(posedge vif.clk);
      end
      while (!vif.io_req_ready);
      vif.io_req_valid          <= #`DELAY 1'b0;
		end
		else if((lsu_q.size > 0)) begin
      req = lsu_q.pop_front();
      `uvm_info(get_type_name(), {"pop req item\n",req.sprint}, UVM_HIGH)
			do begin
        vif.io_req_valid          <= #`DELAY 1;
        vif.io_req_bits_source    <= #`DELAY req.io_req_bits_source;
        vif.io_req_bits_paddr     <= #`DELAY req.io_req_bits_paddr;
        vif.io_req_bits_cmd       <= #`DELAY req.io_req_bits_cmd;  
        vif.io_req_bits_size      <= #`DELAY req.io_req_bits_size;	
        vif.io_req_bits_signed    <= #`DELAY req.io_req_bits_signed;
        vif.io_req_bits_wdata     <= #`DELAY req.io_req_bits_wdata;	
        vif.io_req_bits_wmask     <= #`DELAY req.io_req_bits_wmask;	
        vif.io_req_bits_noAlloc   <= #`DELAY req.io_req_bits_noAlloc;
        vif.io_req_bits_dest      <= #`DELAY req.io_req_bits_dest;	
        vif.io_req_bits_isRefill  <= #`DELAY req.io_req_bits_isRefill;	
        vif.io_req_bits_refillWay <= #`DELAY req.io_req_bits_refillWay;	
        vif.io_req_bits_refillCoh <= #`DELAY req.io_req_bits_refillCoh;	
        vif.io_s0_kill            <= #`DELAY req.io_s0_kill;
        vif.io_s1_kill            <= #`DELAY req.io_s1_kill;
				req_last = req;
				@(posedge vif.clk);
      end
      while (!vif.io_req_ready);
			//if($urandom_range(1)) begin
        vif.io_req_valid          <= #`DELAY 1'b0;
			  repeat($urandom_range(4))@(posedge vif.clk);
		  //end
	

		end

	end
endtask : do_drive

task lsu_driver::do_resp();
	forever begin
		@(posedge vif.clk);
		if(vif.io_resp_valid) begin
			rsp.io_resp_bits_source   = vif.io_resp_bits_source;	
      rsp.io_resp_bits_dest     = vif.io_resp_bits_dest;	
      rsp.io_resp_bits_status   = vif.io_resp_bits_status;	
      rsp.io_resp_bits_hasData  = vif.io_resp_bits_hasData;	
      rsp.io_resp_bits_data     = vif.io_resp_bits_data;	
      rsp.io_nextCycleWb        = vif.io_nextCycleWb;
			`uvm_info(get_type_name(), {"rps item\n",rsp.sprint}, UVM_HIGH)
		end
	end

endtask : do_resp

`endif // LSU_DRIVER_SV


