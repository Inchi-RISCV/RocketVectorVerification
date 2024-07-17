//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_trans.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_TRANS_SV_
`define _LSU_TRANS_SV_

class lsu_trans extends uvm_sequence_item; 
  `uvm_object_utils_begin(lsu_trans)
    `uvm_field_int(io_req_bits_source,UVM_ALL_ON)
    `uvm_field_int(io_req_bits_paddr,UVM_ALL_ON)
    `uvm_field_int(io_req_bits_cmd,UVM_ALL_ON)  
    `uvm_field_int(io_req_bits_size,UVM_ALL_ON)	
    `uvm_field_int(io_req_bits_signed,UVM_ALL_ON)
    `uvm_field_int(io_req_bits_wdata,UVM_ALL_ON)	
    `uvm_field_int(io_req_bits_wmask,UVM_ALL_ON)	
    `uvm_field_int(io_req_bits_noAlloc,UVM_ALL_ON)
    `uvm_field_int(io_req_bits_dest,UVM_ALL_ON)	
    `uvm_field_int(io_req_bits_isRefill,UVM_ALL_ON)	
    `uvm_field_int(io_req_bits_refillWay,UVM_ALL_ON)	
    `uvm_field_int(io_req_bits_refillCoh,UVM_ALL_ON)	
    `uvm_field_int(io_s0_kill,UVM_ALL_ON)
    `uvm_field_int(io_s1_kill,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_source,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_dest,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_status,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_hasData,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_data,UVM_ALL_ON)	
    `uvm_field_int(io_nextCycleWb,UVM_ALL_ON)
	`uvm_object_utils_end

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

  extern function new(string name = "lsu_trans");

endclass : lsu_trans

function lsu_trans::new(string name = "lsu_trans");
  super.new(name);
endfunction : new

`endif // LSU_TRANS_SV

