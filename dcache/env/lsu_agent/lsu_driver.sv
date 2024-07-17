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

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase (uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
	extern task reset_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task do_drive();
  extern task get_trans();

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
  join

endtask : main_phase

task lsu_driver::get_trans();
	forever begin
  seq_item_port.get_next_item(req);
  `uvm_info(get_type_name(), {"push req item\n",req.sprint}, UVM_HIGH)
  lsu_q.push_back(req);
  seq_item_port.item_done();
  end

endtask : get_trans


task lsu_driver::do_drive();
	lsu_trans tr;
	forever begin
		@(posedge vif.clk);
		if((lsu_q.size > 0) && vif.io_req_ready ) begin
      tr = lsu_q.pop_front();
      `uvm_info(get_type_name(), {"pop req item\n",tr.sprint}, UVM_HIGH)

			//`uvm_info(get_type_name(),$sformatf("io_nextCycleWb=%0h",vif.io_nextCycleWb),UVM_NONE);
      
			//@(posedge vif.clk);
      vif.io_req_valid          <= #`DELAY 1;
      vif.io_req_bits_source    <= #`DELAY tr.io_req_bits_source;
      vif.io_req_bits_paddr     <= #`DELAY tr.io_req_bits_paddr;
      vif.io_req_bits_cmd       <= #`DELAY tr.io_req_bits_cmd;  
      vif.io_req_bits_size      <= #`DELAY tr.io_req_bits_size;	
      vif.io_req_bits_signed    <= #`DELAY tr.io_req_bits_signed;
      vif.io_req_bits_wdata     <= #`DELAY tr.io_req_bits_wdata;	
      vif.io_req_bits_wmask     <= #`DELAY tr.io_req_bits_wmask;	
      vif.io_req_bits_noAlloc   <= #`DELAY tr.io_req_bits_noAlloc;
      vif.io_req_bits_dest      <= #`DELAY tr.io_req_bits_dest;	
      vif.io_req_bits_isRefill  <= #`DELAY tr.io_req_bits_isRefill;	
      vif.io_req_bits_refillWay <= #`DELAY tr.io_req_bits_refillWay;	
      vif.io_req_bits_refillCoh <= #`DELAY tr.io_req_bits_refillCoh;	
      vif.io_s0_kill            <= #`DELAY tr.io_s0_kill;
      vif.io_s1_kill            <= #`DELAY tr.io_s1_kill;

			if($urandom_range(1)) begin
			//repeat($urandom_range(3))@(posedge vif.clk);
      @(posedge vif.clk);
			vif.io_req_valid          <= #`DELAY 0;
      vif.io_req_bits_source    <= #`DELAY 0;
      vif.io_req_bits_paddr     <= #`DELAY 0;
      vif.io_req_bits_cmd       <= #`DELAY 0;  
      vif.io_req_bits_size      <= #`DELAY 0;	
      vif.io_req_bits_signed    <= #`DELAY 0;
      vif.io_req_bits_wdata     <= #`DELAY 0;	
      vif.io_req_bits_wmask     <= #`DELAY 0;	
      vif.io_req_bits_noAlloc   <= #`DELAY 0;
      vif.io_req_bits_dest      <= #`DELAY 0;	
      vif.io_req_bits_isRefill  <= #`DELAY 0;	
      vif.io_req_bits_refillWay <= #`DELAY 0;	
      vif.io_req_bits_refillCoh <= #`DELAY 0;	
      vif.io_s0_kill            <= #`DELAY 0;
      vif.io_s1_kill            <= #`DELAY 0;
		  end


		end

	end
endtask : do_drive

`endif // LSU_DRIVER_SV


