//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_sanity_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_SANITY_SEQUENCE_SV_
`define _DCACHE_SANITY_SEQUENCE_SV_

class dcache_sanity_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_sanity_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	lsu_seq   seq;  

  bit [7:0]   req_bits_source;
  bit [38:0]  req_bits_paddr;
  bit [4:0]   req_bits_cmd;  
	bit [2:0]   req_bits_size;	
  bit         req_bits_signed;
	bit [511:0] req_bits_wdata;	
  bit [63:0]  req_bits_wmask;	
  bit         req_bits_noAlloc;
  bit [4:0]   req_bits_dest;	
  bit         req_bits_isRefill;	
  bit [1:0]   req_bits_refillWay;	
  bit         req_bits_refillCoh;	
  bit         s0_kill;
  bit         s1_kill;	
  bit [7:0]   resp_bits_source;	
  bit [4:0]   resp_bits_dest;	
  bit [1:0]   resp_bits_status;	
  bit         resp_bits_hasData;	
  bit [511:0] resp_bits_data;	
  bit         nextCycleWb;

  function new(string name = "dcache_sanity_sequence");
    super.new(name);
  endfunction


  virtual task body();
	  
	bit [38:0] addr;

    `uvm_info(get_type_name(), "dcache sanity sequence starting", UVM_NONE)
		wait(!tb_top.reset)
		//wait meta array init
		#200ns;

		for(int i=0;i<20;i++)begin
			backdoor_put_data('h1000+'h40*i,6,'ha5a5a5a5_a5a5a5a5+i);
	  end

	 //for(int i=0;i<20;i++)begin
	 //	backdoor_get_data('h1000+'h40*i,6,resp_bits_data);
	 //	`uvm_info(get_type_name(),$sformatf("backdoor_get_data  %0h",resp_bits_data),UVM_NONE);
	 //end

		
		for(int i=0;i<20;i++)begin
			req_bits_dest = $urandom_range(31);
			`uvm_do_on_with(seq,p_sequencer.lsu_sqr,{seq.io_req_bits_source   ==0;
                                               seq.io_req_bits_paddr    =='h1000+'h40*i;
                                               seq.io_req_bits_cmd      =='h0;
                                               seq.io_req_bits_size     =='h6;	
                                               seq.io_req_bits_signed   ==0;
                                               seq.io_req_bits_wdata    =='ha5a5a5a5_a5a5a5a5+i;	
                                               seq.io_req_bits_wmask    ==64'hffff_ffff_ffff_ffff;
                                               seq.io_req_bits_noAlloc  ==0;
                                               seq.io_req_bits_dest     ==req_bits_dest;
                                               seq.io_req_bits_isRefill ==0;	
                                               seq.io_req_bits_refillWay==0;	
                                               seq.io_req_bits_refillCoh==0;	
                                               seq.io_s0_kill           ==0;
                                               seq.io_s1_kill           ==0;
                                               //seq.io_resp_bits_source  ==0;	
                                               //seq.io_resp_bits_dest    ==0;
                                               //seq.io_resp_bits_status  ==0;	
                                               //seq.io_resp_bits_hasData ==0;	
                                               //seq.io_resp_bits_data    ==0;	
                                               //seq.io_nextCycleWb       ==0;
																							 })


		end
		

  endtask


endclass : dcache_sanity_sequence


//-------------------------------------------------------------------------

`endif
