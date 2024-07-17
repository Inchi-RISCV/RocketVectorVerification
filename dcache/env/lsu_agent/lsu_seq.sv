//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_seq.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_SEQ_SV_
`define _LSU_SEQ_SV_

class lsu_seq extends uvm_sequence #(lsu_trans);
  `uvm_object_utils(lsu_seq)

  rand bit [7:0]   io_req_bits_source;
  rand bit [38:0]  io_req_bits_paddr;
  rand bit [4:0]   io_req_bits_cmd;  
	rand bit [2:0]   io_req_bits_size;	
  rand bit         io_req_bits_signed;
	rand bit [511:0] io_req_bits_wdata;	
  rand bit [63:0]  io_req_bits_wmask;	
  rand bit         io_req_bits_noAlloc;
  rand bit [4:0]   io_req_bits_dest;	
  rand bit         io_req_bits_isRefill;	
  rand bit [1:0]   io_req_bits_refillWay;	
  rand bit         io_req_bits_refillCoh;	
  rand bit         io_s0_kill;
  rand bit         io_s1_kill;	
  rand bit [7:0]   io_resp_bits_source;	
  rand bit [4:0]   io_resp_bits_dest;	
  rand bit [1:0]   io_resp_bits_status;	
  rand bit         io_resp_bits_hasData;	
  rand bit [511:0] io_resp_bits_data;	
  rand bit         io_nextCycleWb;

  function new(string name = "lsu_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
    if (starting_phase != null)
    starting_phase.raise_objection(this, {"Running sequence '",
                                          get_full_name(), "'"});

  endtask

  virtual task post_body();
    if (starting_phase != null)
    starting_phase.drop_objection(this, {"Completed sequence '",
                                         get_full_name(), "'"});

  endtask

  extern task body();

endclass : lsu_seq

task lsu_seq::body();

 	lsu_trans  req;

  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

	`uvm_create(req);

  req.io_req_bits_source   =io_req_bits_source;
  req.io_req_bits_paddr    =io_req_bits_paddr;
  req.io_req_bits_cmd      =io_req_bits_cmd;  
	req.io_req_bits_size     =io_req_bits_size;	
  req.io_req_bits_signed   =io_req_bits_signed;
	req.io_req_bits_wdata    =io_req_bits_wdata;	
  req.io_req_bits_wmask    =io_req_bits_wmask;	
  req.io_req_bits_noAlloc  =io_req_bits_noAlloc;
  req.io_req_bits_dest     =io_req_bits_dest;	
  req.io_req_bits_isRefill =0;	
  req.io_req_bits_refillWay=0;	
  req.io_req_bits_refillCoh=0;	
  req.io_s0_kill            =io_s0_kill;
  req.io_s1_kill            =io_s1_kill;	
 //req.io_resp_bits_source=io_resp_bits_source;	
 //req.io_resp_bits_dest=io_resp_bits_dest;	
 //req.io_resp_bits_status=io_resp_bits_status;	
 //req.io_resp_bits_hasData=io_resp_bits_hasData;	
 //req.io_resp_bits_data=io_resp_bits_data;	
 //req.io_nextCycleWb=io_nextCycleWb;

	`uvm_send(req);

	//get_response(rsp);

	//`uvm_info(get_type_name(), {"get one response\n",rsp.sprint}, UVM_NONE)

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)

endtask : body

//-------------------------------------------------------------------------

`endif
