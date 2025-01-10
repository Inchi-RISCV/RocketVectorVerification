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

typedef enum bit[4:0] { 
	//Normal
	M_XRD 				= 	5'b0,
	M_XWR 				= 	5'b1,
	M_PWR 				= 	5'b10001, 
	//Prefetch
	M_PFR					= 	5'b00010,
	M_PFW					= 	5'b00011,
	//CMO
	M_FLUSH				= 	5'b10000,
	M_PRODUCE			= 	5'b10010,
	M_CLEAN				= 	5'b10011,
	M_FLUSH_ALL		= 	5'b00101,
	//AMO
	M_XLR					= 	5'b00110,
	M_XSC					= 	5'b00111,
	M_XA_SWAP			= 	5'b00100,
	M_XA_ADD			= 	5'b01000,
	M_XA_XOR			= 	5'b01001,
	M_XA_OR				= 	5'b01010,
	M_XA_AND			= 	5'b01011,
	M_XA_MIN			= 	5'b01100,
	M_XA_MAX			= 	5'b01101,
	M_XA_MINU			= 	5'b01110,
	M_XA_MAXU			= 	5'b01111,
	//FENCE
	M_SFENCE			= 	5'b10100,
	M_HFENCEV			= 	5'b10101,
	M_HFENCEG			= 	5'b10110
}	req_cmd_enum;
	
typedef enum bit[7:0] {
	SCALAR_INT 		= 	8'h0,
	SCALAR_FP 		= 	8'h1,
	VECTOR 				= 	8'h2,
	MATRIX 				= 	8'h3
} req_source_enum;

typedef enum bit[1:0] {
	HIT 					= 	2'h0,
	MISS 					= 	2'h1,
	REPLAY 				= 	2'h2,
	REFILL 				= 	2'h3
} resp_status_enum;

typedef enum bit[1:0] {
	NOTHING 		= 	2'h0,
	BRANCH			= 	2'h1,
	TRUNK 			= 	2'h2,
	DIRTY 			= 	2'h3
} cache_state ;



  `uvm_object_utils_begin(lsu_trans)
    `uvm_field_enum(req_source_enum,io_req_bits_source,UVM_ALL_ON)
    `uvm_field_int(io_req_bits_paddr,UVM_ALL_ON)
    `uvm_field_enum(req_cmd_enum,io_req_bits_cmd,UVM_ALL_ON)  
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
    `uvm_field_int(io_resp_bits_size,UVM_ALL_ON)
    `uvm_field_enum(resp_status_enum,io_resp_bits_status,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_hasData,UVM_ALL_ON)	
    `uvm_field_int(io_resp_bits_data,UVM_ALL_ON)	
    `uvm_field_int(io_nextCycleWb,UVM_ALL_ON)
    `uvm_field_int(io_nextSource,UVM_ALL_ON)
		//`uvm_field_int(replay_req,UVM_ALL_ON)

	`uvm_object_utils_end

  rand req_source_enum 		io_req_bits_source;
  rand bit [38:0]  				io_req_bits_paddr;
  rand req_cmd_enum 			io_req_bits_cmd;  
	rand bit [2:0]   				io_req_bits_size;	
  rand bit         				io_req_bits_signed;
	rand bit [511:0] 				io_req_bits_wdata;	
  rand bit [63:0]  				io_req_bits_wmask;	
  rand bit         				io_req_bits_noAlloc;
  rand bit [4:0]   				io_req_bits_dest;	
  rand bit         				io_req_bits_isRefill;	
  rand bit [1:0]   				io_req_bits_refillWay;	
  rand bit         				io_req_bits_refillCoh;	
  rand bit         				io_s0_kill;
  rand bit         				io_s1_kill;	
  rand bit [7:0]   				io_resp_bits_source;	
  rand bit [4:0]   				io_resp_bits_dest;	
  rand bit [2:0]   				io_resp_bits_size;
  rand resp_status_enum 	io_resp_bits_status;	
  rand bit         				io_resp_bits_hasData;	
  rand bit [511:0] 				io_resp_bits_data;	
  rand bit         				io_nextCycleWb;
  rand bit [1:0]        	io_nextSource;
  //rand bit         				replay_req;

  extern function new(string name = "lsu_trans");

  function copy (lsu_trans p);
    this.io_req_bits_source    = p.io_req_bits_source;
    this.io_req_bits_paddr     = p.io_req_bits_paddr;
    this.io_req_bits_cmd       = p.io_req_bits_cmd;  
    this.io_req_bits_size      = p.io_req_bits_size;	
    this.io_req_bits_signed    = p.io_req_bits_signed;
    this.io_req_bits_wdata     = p.io_req_bits_wdata;	
    this.io_req_bits_wmask     = p.io_req_bits_wmask;	
    this.io_req_bits_noAlloc   = p.io_req_bits_noAlloc;
    this.io_req_bits_dest      = p.io_req_bits_dest;	
    this.io_req_bits_isRefill  = p.io_req_bits_isRefill;	
    this.io_req_bits_refillWay = p.io_req_bits_refillWay;	
    this.io_req_bits_refillCoh = p.io_req_bits_refillCoh;	
    this.io_s0_kill            = p.io_s0_kill;
    this.io_s1_kill            = p.io_s1_kill;	
    this.io_resp_bits_source   = p.io_resp_bits_source;	
    this.io_resp_bits_dest     = p.io_resp_bits_dest;	
    this.io_resp_bits_size     = p.io_resp_bits_size;
    this.io_resp_bits_status   = p.io_resp_bits_status;	
    this.io_resp_bits_hasData  = p.io_resp_bits_hasData;	
    this.io_resp_bits_data     = p.io_resp_bits_data;	
    this.io_nextCycleWb        = p.io_nextCycleWb;
    this.io_nextSource         = p.io_nextSource;
    //this.replay_req            = p.replay_req;
  endfunction


endclass : lsu_trans

function lsu_trans::new(string name = "lsu_trans");
  super.new(name);
endfunction : new




`endif // LSU_TRANS_SV

