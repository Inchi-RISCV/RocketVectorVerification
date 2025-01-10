//============================================================================
// Copyright(c) 2022 ; Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :lsu_if.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _LSU_IF_SV_
`define _LSU_IF_SV_

interface lsu_if(input clk, input rst_n);


  logic         io_req_valid;
  logic [7:0]   io_req_bits_source;
  logic [38:0]  io_req_bits_paddr;
  logic [4:0]   io_req_bits_cmd;  
	logic [2:0]   io_req_bits_size;	
  logic         io_req_bits_signed;
	logic [511:0] io_req_bits_wdata;	
  logic [63:0]  io_req_bits_wmask;	
  logic         io_req_bits_noAlloc;
  logic [4:0]   io_req_bits_dest;	
  logic         io_req_bits_isRefill;	
  logic [1:0]   io_req_bits_refillWay;	
  logic         io_req_bits_refillCoh;	
  logic         io_s0_kill;
  logic         io_s1_kill;	
  logic         io_req_ready;	
  logic         io_resp_valid;	
  logic [7:0]   io_resp_bits_source;	
  logic [4:0]   io_resp_bits_dest;	
  logic [1:0]   io_resp_bits_status;	
  logic [2:0]   io_resp_bits_size;
  logic         io_resp_bits_hasData;	
  logic [511:0] io_resp_bits_data;	
  logic         io_nextCycleWb;
  logic [1:0]   io_nextSource;
  logic         replay_req;

  clocking drv_cb@(posedge clk);

    output  io_req_bits_source;
    output  io_req_bits_paddr;
    output  io_req_bits_cmd;  
    output  io_req_bits_size;	
    output  io_req_bits_signed;
    output  io_req_bits_wdata;	
    output  io_req_bits_wmask;	
    output  io_req_bits_noAlloc;
    output  io_req_bits_dest;	
    output  io_req_bits_isRefill;	
    output  io_req_bits_refillWay;	
    output  io_req_bits_refillCoh;	
    output  io_s0_kill;
    output  io_s1_kill;	
    input   io_resp_bits_source;	
    input   io_resp_bits_dest;	
    input   io_resp_bits_status;	
    input   io_resp_bits_size;
    input   io_resp_bits_hasData;	
    input   io_resp_bits_data;	
    input   io_nextCycleWb;
    input   io_nextSource;
	  output  io_req_valid;
    input   io_req_ready;	
    input   io_resp_valid;
  endclocking

  clocking mon_cb@(posedge clk);

    input  io_req_bits_source;
    input  io_req_bits_paddr;
    input  io_req_bits_cmd;  
    input  io_req_bits_size;	
    input  io_req_bits_signed;
    input  io_req_bits_wdata;	
    input  io_req_bits_wmask;	
    input  io_req_bits_noAlloc;
    input  io_req_bits_dest;	
    input  io_req_bits_isRefill;	
    input  io_req_bits_refillWay;	
    input  io_req_bits_refillCoh;	
    input  io_s0_kill;
    input  io_s1_kill;	
    output io_resp_bits_source;	
    output io_resp_bits_dest;	
    output io_resp_bits_status;	
    output io_resp_bits_size;
    output io_resp_bits_hasData;	
    output io_resp_bits_data;	
    output io_nextCycleWb;
    output io_nextSource;
		input  io_req_valid;
    output io_req_ready;	
    output io_resp_valid;

  endclocking

	modport master(clocking drv_cb );
	modport slave(clocking mon_cb );


endinterface : lsu_if

`endif // LSU_IF_SV
