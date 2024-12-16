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
	lsu_trans lsu_q[$];
	bit destid_reuse [1024];
	rand bit [4:0] destid;
	//bit [5:0] destid_last[32];

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
	extern task reset_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_drive();
  extern task get_trans();
	extern task release_destid();


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
  fork
    get_trans();
    do_drive();
		release_destid();
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
	lsu_trans req,req_last,rsp;

  rsp = new("rsp");
	req_last = new("req_last");

	forever begin
		@(posedge vif.clk);

		if(vif.io_resp_valid) begin
      rsp.io_resp_bits_status   = vif.io_resp_bits_status;
      `uvm_info(get_type_name(),$sformatf("io_resp_bits_status=%0h",rsp.io_resp_bits_status),UVM_HIGH);	
		end

		if(rsp.io_resp_bits_status == 2) begin //replay cmd
      req = req_last;
      //req.replay_req =1;
			//`uvm_info(get_type_name(), {"replay , req item\n",req.sprint}, UVM_HIGH)
			`uvm_info(get_type_name(),$sformatf("replay req , addr=%0h",req.io_req_bits_paddr),UVM_NONE);
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
        vif.io_req_bits_dest      <= #`DELAY destid;	
        vif.io_req_bits_isRefill  <= #`DELAY req.io_req_bits_isRefill;	
        vif.io_req_bits_refillWay <= #`DELAY req.io_req_bits_refillWay;	
        vif.io_req_bits_refillCoh <= #`DELAY req.io_req_bits_refillCoh;	
        vif.io_s0_kill            <= #`DELAY req.io_s0_kill;
        vif.io_s1_kill            <= #`DELAY 0;
				req_last = req;
				@(posedge vif.clk);	
				vif.io_s1_kill            <= #`DELAY req.io_s1_kill;
      end
      while (!vif.io_req_ready);
      vif.io_req_valid          <= #`DELAY 1'b0;
		end
		else if((lsu_q.size > 0)) begin
      req = lsu_q.pop_front();
      `uvm_info(get_type_name(), {"pop req item\n",req.sprint}, UVM_HIGH)

			while(1)begin
        destid = $urandom_range(31);
				//`uvm_info("YRHU",$sformatf("destid = %0h",destid),UVM_LOW);
				`uvm_info("YRHU",$sformatf("destid_reuse = %0h,destid=%0h,source=%0h,realid=%0h,",destid_reuse[{req.io_req_bits_source,destid}],destid,req.io_req_bits_source,{req.io_req_bits_source,destid}),UVM_LOW);
			  if(!destid_reuse[{req.io_req_bits_source,destid}] && !(req.io_req_bits_source==0 && destid ==0))
					break;
			end

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
        vif.io_req_bits_dest      <= #`DELAY destid;	
        vif.io_req_bits_isRefill  <= #`DELAY req.io_req_bits_isRefill;	
        vif.io_req_bits_refillWay <= #`DELAY req.io_req_bits_refillWay;	
        vif.io_req_bits_refillCoh <= #`DELAY req.io_req_bits_refillCoh;	
        vif.io_s0_kill            <= #`DELAY req.io_s0_kill;
        vif.io_s1_kill            <= #`DELAY 0;
				req_last = req;

			  //when has data, set destid_reuse 1
		    if(req.io_req_bits_cmd == lsu_trans::M_XRD||req.io_req_bits_cmd == lsu_trans::M_XA_SWAP||req.io_req_bits_cmd == lsu_trans::M_XA_ADD||req.io_req_bits_cmd == lsu_trans::M_XA_XOR||req.io_req_bits_cmd == lsu_trans::M_XA_OR||req.io_req_bits_cmd == lsu_trans::M_XA_AND||req.io_req_bits_cmd == lsu_trans::M_XA_MIN||req.io_req_bits_cmd == lsu_trans::M_XA_MAX||req.io_req_bits_cmd == lsu_trans::M_XA_MINU||req.io_req_bits_cmd == lsu_trans::M_XA_MAXU) begin
				  destid_reuse[{req.io_req_bits_source,destid}] = 1;
				  `uvm_info(get_type_name(),$sformatf("set destid_reuse , destid = %0h,io_req_bits_source = %0h,realid=%0h",destid,req.io_req_bits_source,{req.io_req_bits_source,destid}),UVM_HIGH);	
			  end
				@(posedge vif.clk);
				vif.io_s1_kill            <= #`DELAY req.io_s1_kill;
      end
      while (!vif.io_req_ready);
			//if($urandom_range(1)) begin
      vif.io_req_valid          <= #`DELAY 1'b0;	
			//repeat($urandom_range(4))@(posedge vif.clk);
		  //end
	 	end

	end
endtask : do_drive


task lsu_driver::release_destid();
	forever begin
		@(posedge vif.clk);
		if(vif.io_resp_valid) begin
			//when rsp hit or hasdata,set destid_reuse 0
      //`uvm_info(get_type_name(),$sformatf("vif.io_resp_bits_hasData=%0h",vif.io_resp_bits_hasData),UVM_NONE);
			if(!vif.io_resp_bits_status | vif.io_resp_bits_hasData ) begin
				destid_reuse[{vif.io_resp_bits_source,vif.io_resp_bits_dest}] = 0;
				`uvm_info(get_type_name(),$sformatf("clear destid_reuse , destid = %0h,source = %0h,realid=%0h",vif.io_resp_bits_dest,vif.io_resp_bits_source,{vif.io_resp_bits_source,vif.io_resp_bits_dest}),UVM_NONE);	
			end

		end
	end

endtask : release_destid


`endif // LSU_DRIVER_SV


