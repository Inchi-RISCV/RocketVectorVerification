//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_refm.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_REFM_SV_
`define _DCACHE_REFM_SV_

class dcache_refm extends uvm_component;
  `uvm_component_utils(dcache_refm)
	uvm_blocking_get_port #(lsu_trans) lsu_port;
  uvm_analysis_port  #(lsu_trans) rm2sb_tla_port;
	uvm_analysis_port  #(svt_tilelink_slave_transaction) rm2sb_tle_port;

  lsu_trans lsu_tr_q[$];
	lsu_trans rsp;
  svt_tilelink_master_transaction  tlmst_tr;
	svt_tilelink_slave_transaction   tlslv_tr;

  bit [5:0] nset;
	bit [1:0] nway;
	bit [511:0] data_arry[128][4]; //data 
	bit [31:0] meta_arry[128][4]; //26bit tag //2bit coh
	bit unfinsh[32]; //0:finish 1:unfinish


  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);
  extern task get_lsu_port();
	extern task assemble_cmd();
	//extern task send_lsu_rsp();
	extern task query_block(input bit [5:0] set_index, input bit [1:0] way_index, output bit hit, output bit[1:0] coh,output bit [511:0] data );
  //extern task read(input bit [31:0] addr , output bit hit, output bit [511:0] data);
  //extern task read(input bit [31:0] addr , output bit hit, output bit [511:0] data);
	//extern task tla_send();
  //extern task tla_gen(input bit [31:0] addr);



endclass : dcache_refm 

function dcache_refm::new(string name, uvm_component parent);

  super.new(name, parent);
	lsu_port = new("lsu_port",this);

endfunction : new

task dcache_refm::main_phase(uvm_phase phase);
	super.main_phase(phase);
	fork
		get_lsu_port();


	join


endtask : main_phase

task dcache_refm::get_lsu_port();
  lsu_trans tr;
	forever begin
    lsu_port.get(tr);
    `uvm_info(get_type_name(), {"get lsu_port item\n",tr.sprint}, UVM_HIGH)
		lsu_tr_q.push_back(tr);

	end

endtask

task dcache_refm::assemble_cmd();
  lsu_trans req;
	bit [511:0] data;
	bit         hit;
	bit [2:0]   coh;
  forever begin
		if(lsu_tr_q.size()>0)begin
			req = lsu_tr_q.pop_front();
			nset = req.io_req_bits_paddr[12:6];
			nway = 0; //todo
			query_block(nset,nway,hit,coh,data);

      //miss
			if(hit==0)begin
        unfinsh[req.io_resp_bits_dest]=1;
				rsp.io_resp_bits_source   = req.io_resp_bits_source;
        rsp.io_resp_bits_dest	    = req.io_resp_bits_dest; 
        rsp.io_resp_bits_status	  = lsu_trans::MISS;
        rsp.io_resp_bits_hasData	= 0;
        rsp.io_resp_bits_data     = 0;


			end
			//hit
			else begin
				rsp.io_resp_bits_source   = req.io_resp_bits_source;
        rsp.io_resp_bits_dest	    = req.io_resp_bits_dest; 
        rsp.io_resp_bits_status	  = lsu_trans::HIT;
        rsp.io_resp_bits_hasData	= 1;
        rsp.io_resp_bits_data = data_arry[nset][nway];
				


			end

		end

  end
endtask


task dcache_refm::query_block(input bit [5:0] set_index, input bit [1:0] way_index, output bit hit, output bit[1:0] coh ,output bit [511:0] data);

	bit [31:0] meta;

	if(meta_arry[set_index][way_index] == lsu_trans::NOTHING)begin
    hit = 0;
	end
	else begin
    hit = 1;
	end

	meta = meta_arry[set_index][way_index];
	coh = meta[1:0]; 

endtask
	
//task dcache_refm::tla_gen();

	//tr.ch_a_msg_type =svt_tilelink_master_transaction::CH_A_ACQUIRE_BLOCK; 
	//a_size
  //tr.a_source = 0;
  //tr.a_address == ;
	//a_mask
	//a_param



//endtask
`endif // DCACHE_REFM_SV


