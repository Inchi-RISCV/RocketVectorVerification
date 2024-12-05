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

`uvm_analysis_imp_decl(_slave_trans_rx)
`uvm_analysis_imp_decl(_slave_trans_chb)

class dcache_refm extends uvm_component;
  `uvm_component_utils(dcache_refm)
	uvm_blocking_get_port #(lsu_trans) lsu_port;
  uvm_analysis_port  #(svt_tilelink_master_transaction) rm2sb_tltx_port;
	uvm_analysis_port  #(lsu_trans) rm2sb_rsp_port;
  uvm_analysis_port  #(svt_tilelink_slave_transaction) rm2sb_tlc_port;

	`SVT_XVM(analysis_imp_slave_trans_rx)      #(svt_tilelink_slave_transaction,  dcache_refm) tl2rm_tlrx_port;

	`SVT_XVM(analysis_imp_slave_trans_chb)     #(svt_tilelink_slave_transaction,  dcache_refm) tl2rm_tlchb_port;

  lsu_trans lsu_tr_q[$];
	lsu_trans rsp;
  svt_tilelink_master_transaction  tlmst_tr;
  svt_tilelink_slave_transaction   tl_chd_q[$]; 
	svt_tilelink_slave_transaction   tl_chb_q[$]; 
	bit [1:0] replace_q[128][$:3];

  bit [6:0] nset;
	bit [1:0] nway;
	bit [512*4-1:0] data_arry[128]; //data 4way 
	bit [39*4-1:0]  meta_arry[128]; //26bit tag ,2bit coh ,4way
  bit        mshr_source_id_valid[8] = {1,1,1,1,1,1,1,1};
	bit        iomshr_source_id_valid[8] = {1,1,1,1,1,1,1,1};
	bit [38:0] req_addr_arry[32];
	bit [38:0] req_addr_arry_f[32];
	bit [1:0]  req_noalloc_arry[32];
  //bit [38:0]  req_source_q[$]; //addr+dest
  bit [1023:0] same_addr_info_q[$];   //size+data+mask+sign+cmd+addr+source+dest  3+512+64+1+5+39+8+6 = 635
	bit [1023:0] same_addr_info_tmp_q[$];
	bit [5:0]  req_dest_arry[32];     
	bit [7:0]  req_source_arry[32];
	bit [2:0]  req_size_arry[1024];
	bit        req_signed_arry[1024];
	bit [2:0]  req_size_store_arry[32];
  bit [63:0] req_mask_arry[32];
	bit [511:0] req_data_arry[32];
	bit [559:0] w_miss_release_data_q[$]; //addr+data 48+512
	bit [7:0]   lrsc_count;
	bit [38:0]  lrsc_addr;
	
	lsu_trans::req_cmd_enum 		req_cmd_arry[32];
	svt_tilelink_master_transaction tl_send_q[$];
  svt_tilelink_master_transaction tl_send_q_tmp[$];

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);
	extern task addr_data_align(input bit [2:0] size, input bit [38:0] addr,input bit [511:0] data,output [511:0] align_data);
	extern task data_mask_merge(input bit [2:0] size, input bit [38:0] addr,input bit [63:0] mask, input bit [511:0] r_data, input bit [511:0] w_data,output [511:0] data);
  extern task get_lsu_port();
	extern task assemble_cmd();
	extern task query_block(input bit [6:0] set_index, input bit [25:0] tag, output bit[1:0] coh, output bit [1:0] way, output bit [511:0] data );
  extern task send_rsp(input bit [7:0] source ,input bit [4:0] dest , input bit [2:0] status, input bit hasdata,input bit [511:0] data);
  extern task do_tlc_message(input bit [38:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param);
	extern task do_tlu_message(input bit [38:0] a_addr ,input bit [2:0] a_opcode,input bit [2:0] a_size,input bit [15:0] a_source,input bit [511:0] a_data,input bit [63:0] a_mask,input bit [2:0] a_param = 0);
	extern task do_release(input bit [38:0] c_addr ,input bit [2:0] c_opcode,input bit [15:0] c_source,input bit [2:0] c_param,input bit [511:0] c_data,input bit [1:0] coh);
	extern task do_refill();
	extern task replace_plru(input bit [6:0] set_index,input bit[1:0] coh, input bit [1:0] exist_way ,output bit [1:0] victim_way,output bit victim_way_valid);
	extern task update_cache(input bit [6:0] set_index,input bit [25:0] tag,input bit[1:0] coh, input bit [1:0] way ,input bit [511:0] data,output bit[1:0] victim_coh,output bit[511:0] victim_data,output bit[38:0] victim_addr);
 	extern task release_source_id(input bit [15:0] source_id);
  extern task sign_extension(input bit is_signed,input bit [2:0] size,input bit [511:0] data,output bit [511:0] sign_data);
	extern task amoalu(input bit [4:0] cmd, input bit [2:0] size ,input bit [511:0] old_data, input bit [511:0] new_data,output bit [511:0] data_out);
  extern task do_probe();
	extern task do_tl_send_q();



  /**  write for tilelink monitor */
  virtual function void write_slave_trans_rx(svt_tilelink_slave_transaction slave_trans);

	  //`uvm_info(get_type_name(), {"get tl2rm_tlrx_port\n",slave_trans.sprint}, UVM_NONE)
    if(slave_trans.status.drive_chnl_A_or_C)begin
   	  tl_chd_q.push_back(slave_trans);
			`uvm_info(get_type_name(), {"get tl2rm_tlrx_port tl_chd_q \n",slave_trans.sprint}, UVM_HIGH)
	  end

	//if(slave_trans.drive_chnl_B)begin
  //  tl_chb_q.push_back(slave_trans);
	//	`uvm_info(get_type_name(), {"get tl2rm_tlrx_port tl_chb_q\n",slave_trans.sprint}, UVM_HIGH)
	//end

  endfunction : write_slave_trans_rx

  /**  write for tilelink monitor */
  virtual function void write_slave_trans_chb(svt_tilelink_slave_transaction slave_trans);

		if(slave_trans.drive_chnl_B)begin
   	  tl_chb_q.push_back(slave_trans);
			`uvm_info(get_type_name(), {"get tl2rm_tlchb_port tl_chb_q\n",slave_trans.sprint}, UVM_HIGH)
	  end

  endfunction : write_slave_trans_chb



endclass : dcache_refm 

function dcache_refm::new(string name, uvm_component parent);

  super.new(name, parent);
	lsu_port = new("lsu_port",this);
	rm2sb_tltx_port = new("rm2sb_tltx_port",this);
  tl2rm_tlrx_port = new("tl2rm_tlrx_port",this);
	rm2sb_rsp_port = new("rm2sb_rsp_port",this);
  rm2sb_tlc_port = new("rm2sb_tlc_port",this);
  tl2rm_tlchb_port = new("tl2rm_tlchb_port",this);

endfunction : new

task dcache_refm::main_phase(uvm_phase phase);
	super.main_phase(phase);
	fork
		get_lsu_port();
		assemble_cmd();
    do_refill();
		do_probe();
    do_tl_send_q();
		
    //lrsc_count - 1
    while(1) begin
      @(posedge tb_top.clock);
      if(lrsc_count > 0)
        lrsc_count = lrsc_count - 1;
      end
	join


endtask : main_phase

task dcache_refm::get_lsu_port();
  lsu_trans tr;
	forever begin
    lsu_port.get(tr);
    `uvm_info(get_type_name(), {"rm get lsu_port item\n",tr.sprint}, UVM_NONE)
		lsu_tr_q.push_back(tr);
	end

endtask

task dcache_refm::amoalu(input bit [4:0] cmd, input bit [2:0] size ,input bit [511:0] old_data, input bit [511:0] new_data,output bit [511:0] data_out);
  bit         is_signed_old,is_signed_new;
	bit [511:0] sign_data_old,sign_data_new;
	bit [63:0]  new_data_tmp,old_data_tmp;

	if(size==2)begin
		is_signed_old = old_data[31];
		is_signed_new = new_data[31];
		sign_data_old = old_data[31:31]   ? {{480{1'b1}},old_data[31:0]}  : old_data[31:0];
		sign_data_new = new_data[31:31]   ? {{480{1'b1}},new_data[31:0]}  : new_data[31:0];
		new_data_tmp = new_data[31:0];
		old_data_tmp = old_data[31:0];
   
	end
	else if(size==3)begin
		is_signed_old = old_data[63];
		is_signed_new = new_data[63];
		sign_data_old = old_data[63:63]   ? {{448{1'b1}},old_data[63:0]}  : old_data[63:0];
		sign_data_new = new_data[63:63]   ? {{448{1'b1}},new_data[63:0]}  : new_data[63:0];
		new_data_tmp = new_data[63:0];
		old_data_tmp = old_data[63:0];

	end

	if(cmd == lsu_trans::M_XA_SWAP)begin
     data_out = new_data_tmp;
	end
	else if(cmd == lsu_trans::M_XA_XOR)begin
     data_out = old_data_tmp ^ new_data_tmp;
	end
	else if(cmd == lsu_trans::M_XA_OR)begin
     data_out = old_data_tmp | new_data_tmp;
	end
	else if(cmd == lsu_trans::M_XA_AND)begin
      data_out = old_data_tmp & new_data_tmp;
	end
	else if(cmd == lsu_trans::M_XA_MINU)begin
      data_out = (new_data_tmp<old_data_tmp) ? new_data_tmp : old_data_tmp ;
	end
	else if(cmd == lsu_trans::M_XA_MAXU)begin
      data_out = (new_data_tmp>old_data_tmp) ? new_data_tmp : old_data_tmp ;
	end
	else if(cmd == lsu_trans::M_XA_ADD)begin
    data_out = sign_data_old + sign_data_new;
 	end
	else if(cmd == lsu_trans::M_XA_MAX)begin
		if(is_signed_old == is_signed_new)begin
      data_out  = (new_data_tmp>old_data_tmp) ? new_data_tmp : old_data_tmp ;
	  end
		else begin
      data_out = is_signed_new ? old_data_tmp : new_data_tmp;
		end

	end
	else if(cmd == lsu_trans::M_XA_MIN)begin
		if(is_signed_old == is_signed_new)begin
      data_out  = (new_data_tmp<old_data_tmp) ? new_data_tmp : old_data_tmp ;
	  end
		else begin
      data_out = is_signed_new ? new_data_tmp : old_data_tmp;
		end
			
	end

	if(size==2)begin
    data_out = data_out[31:0];
	end
	else if(size==3)begin
    data_out = data_out[63:0];
	end


	`uvm_info(get_type_name(),$sformatf("amo alu ,cmd=%0h,size=%0h,old_data_tmp=%0h,new_data_tmp=%0h,data_out=%0h",cmd,size,old_data,new_data,data_out),UVM_NONE);	


endtask

task dcache_refm::do_probe();

  svt_tilelink_slave_transaction tr;
	bit [4:0]    b_source;
	bit [38:0]   b_addr,probe_addr;
	bit [2:0]    b_param[32];
	bit [2:0]    b_opcode;
  bit [25:0]   ntag;
  bit [6:0]    nset ;
  bit [1:0]    coh,coh_vic,coh_tmp;
	bit [1:0]    exist_way;
	bit [511:0]  data,data_vic,data_tmp;
	bit [38:0]   addr_vic;
	bit [38:0]   probe_addr_arry[32];
	bit [2:0]    c_param;
	bit [2:0]    c_opcode;
	bit          mshr_refill_first[32];

  
	fork

	while (1) begin
		#0.1;
		if(tl_chb_q.size()>0)begin
      tr = tl_chb_q.pop_front();
      //`uvm_info(get_type_name(), {"get tl_chb_q item\n",tr.sprint}, UVM_NONE)
      b_opcode = tr.ch_b_msg_type;
      b_addr= tr.b_address;
      b_source = tr.b_source;
      b_param[b_source]  = tr.b_param;

			`uvm_info(get_type_name(),$sformatf("rm get probe,b_addr=%0h,b_source=%0h,b_param=%0h,b_opcode=%0h,tl_chb_q_size=%0h",b_addr,b_source,b_param[b_source],b_opcode,tl_chb_q.size()),UVM_NONE);

			
	    probe_addr_arry[b_source]  = b_addr;

		end

	end

	while(1) begin
		@(posedge tb_top.clock);
		foreach (probe_addr_arry[i]) begin
			if(probe_addr_arry[i])begin
				`uvm_info(get_type_name(),$sformatf("probe_addr_arry=%p,req_addr_arry=%p,i=%0h", probe_addr_arry,req_addr_arry,i),UVM_NONE);
		    probe_addr = probe_addr_arry[i];

         
        //check if same addr req in MSHR,do MSHR refill first
		    foreach (req_addr_arry[j])begin
		      	if(req_addr_arry[j][38:6] == probe_addr[38:6] && j<8 )begin
					  `uvm_info(get_type_name(),$sformatf("probe has same addr in mshr ,addr=%0h,j=%0h",req_addr_arry[j],j),UVM_NONE);
						mshr_refill_first[i] = 1;
		      	end	
		    end
        
       

				foreach (mshr_refill_first[k]) begin
				  if(mshr_refill_first[k])begin
            wait ( !(tb_top.U_GPCDCache.s1_validRefill&tb_top.U_GPCDCache.s1_req_isRefill) && (tb_top.U_GPCDCache.s1_req_paddr[38:6] == probe_addr[38:6] && tb_top.U_GPCDCache.s1_req_isProbe));
            `uvm_info(get_type_name(),$sformatf("probe same addr in mshr refill done,addr=%0h,i=%0h",probe_addr_arry[k],k),UVM_NONE);
					  mshr_refill_first[k] = 0;
				  end
			  end

        nset = probe_addr[12:6];
		    ntag = probe_addr[38:13];        
			  query_block(nset,ntag,coh,exist_way,data);

        //toN
		    if(b_param[i] == 2)begin

		    	//TtoB 0; TtoN 1; BtoN 2; TtoT 3; BtoB 4; NtoN 5;
		    	case (coh)
            lsu_trans::NOTHING : c_param = 5 ;// NtoN
            lsu_trans::BRANCH  : c_param = 2 ;// BtoN
            lsu_trans::TRUNK   : c_param = 1 ;// TtoN
            lsu_trans::DIRTY   : c_param = 1 ;// TtoN
		      endcase
		    	coh_tmp = lsu_trans::NOTHING;
		    end
		    else if(b_param[i] == 1)begin//toB
		      case (coh)
            lsu_trans::NOTHING : c_param = 5 ;// NtoN	
            lsu_trans::BRANCH  : c_param = 4 ;// BtoB
            lsu_trans::TRUNK   : c_param = 0 ;// TtoB
            lsu_trans::DIRTY   : c_param = 0 ;// TtoB
		      endcase	
		    	coh_tmp = (c_param == 5) ? lsu_trans::NOTHING : lsu_trans::BRANCH;
		    end
		    else begin//toT
		      case (coh)
            lsu_trans::NOTHING : c_param = 5 ;// NtoN	
            lsu_trans::BRANCH  : c_param = 4 ;// BtoB
            lsu_trans::TRUNK   : c_param = 3 ;// TtoT
            lsu_trans::DIRTY   : c_param = 3 ;// TtoT					
		      endcase	

		      case (c_param)
            5 :  coh_tmp = lsu_trans::NOTHING ;
            4 :  coh_tmp = lsu_trans::BRANCH  ;
            3 :  coh_tmp = lsu_trans::TRUNK   ;			
		      endcase						
		    end

          if(c_param < 3)begin//NtoN  BtoB TtoT donot update cache

				    data_tmp = c_param==0 ? data : 0;
						update_cache(probe_addr[12:6],probe_addr[38:13],coh_tmp,exist_way,data_tmp,coh_vic,data_vic,addr_vic);
            `uvm_info(get_type_name(),$sformatf("probe update cacheline,addr=%0h,c_source=%0h,way=%0h,coh=%0h",probe_addr,i,exist_way,coh_tmp),UVM_NONE);
			 	  end

  			  //cacheline DIRTY probeAckData
			    c_opcode = (coh == lsu_trans::DIRTY) ? 5 : 4;
          do_release(b_addr,c_opcode,i,c_param,data,coh);
          `uvm_info(get_type_name(),$sformatf("do probeack ,addr=%0h,c_source=%0h,source_coh=%0h,b_param=%0h,c_param=%0h",b_addr,i,coh,b_param[i],c_param),UVM_NONE);
			    probe_addr_arry[i] = 0;				

		  end
		end
	end			

  join

endtask


task dcache_refm::do_refill();
  svt_tilelink_slave_transaction tr;
  bit [2:0]    d_opcode,d_opcode_arry[32];
	bit [511:0]  d_data,align_data,refill_data,data_vic,update_data;
	bit [15:0]   d_source;
	bit [1:0]    d_param[8];
	bit [38:0]   a_addr;
  bit [511:0]  d_data_arry[32];


	bit [1:0]    coh,coh_tmp,coh_vic;
	bit [1:0]    exist_way,victim_way;
	bit [511:0]  data;
	bit [39*4-1:0]  meta_data;
	bit [2047:0] set_data;
  bit [6:0]    nset ;
  bit [25:0]   ntag ;
  bit [38:0]   meta_tmp ;
  bit [7:0]    req_source,req_source_tmp;
  bit [38:0]   req_addr,addr_vic;	
  bit [5:0]    req_dest,req_dest_tmp,req_dest_1;
	bit [1:0]    req_source_1;
	bit [4:0]    req_cmd_same_addr,req_cmd;
	bit [2:0]    req_size,req_size_store;
  bit          req_signed;
	bit [38:0]   same_addr_refill_num,tmp_num;
	bit [1023:0]   same_addr_info,same_addr_info_tmp;
  bit          victim_way_valid;
  bit [63:0]   req_mask;
	bit [511:0]  req_data,merge_data,wite_miss_data;
  bit          refill_valid[8],iomshr_refill_valid[32];
	bit [559:0]  w_miss_release_data;
	
	fork

	while(1) begin
		#0.1;
		if(tl_chd_q.size()>0)begin
      tr = tl_chd_q.pop_front();
      //`uvm_info(get_type_name(), {"get tl_chd_q item\n",tr.sprint}, UVM_NONE)
		  d_opcode = tr.ch_d_msg_type;

			for(int i=0;i<256;i++)begin
		    d_data[i*8+:8] = tr.d_data[i];
			end
		  d_source = tr.d_source;
		  d_param[d_source] =  tr.d_param;
			

		  // get B write miss release data
			for(int i=0 ;i<w_miss_release_data_q.size();i++)begin
        w_miss_release_data = w_miss_release_data_q.pop_front();
		    if( w_miss_release_data[559:512] == req_addr_arry[d_source])begin
					//d_data_arry[d_source] = w_miss_release_data[511:0];
					wite_miss_data = w_miss_release_data[511:0];
					`uvm_info(get_type_name(),$sformatf("rm get write miss data,addr=%0h,d_source=%0h,d_data=%0h,q_size=%0h",w_miss_release_data[559:512],d_source,wite_miss_data,tl_chd_q.size()),UVM_NONE);
		    end
		    else begin
          w_miss_release_data_q.push_back(w_miss_release_data);
		    end
		  end

      //if ack is grant ,data = release data
			d_data_arry[d_source] = (d_opcode == 4) ? wite_miss_data : d_data ;
			d_opcode_arry[d_source] = d_opcode;


			`uvm_info(get_type_name(),$sformatf("rm get grant,a_addr=%0h,d_source=%0h,d_param=%0h,d_opcode=%0h,d_data=%0h,tl_chd_q_size=%0h",req_addr_arry[d_source],d_source,d_param[d_source],d_opcode,d_data_arry[d_source],tl_chd_q.size()),UVM_NONE); 

      //AccessAck
      if(d_opcode == 0)begin
		    req_addr_arry_f[d_source]  <= 1;
		    req_source_arry[d_source]  <= 0;
		    req_dest_arry[d_source]    <= 0;
				req_noalloc_arry[d_source] <= 0;
     end
 

      // waiting source_id release
			fork
				release_source_id(d_source);
			join_none
			
    end//end tl_chd_q
  end


	while(1) begin
		@(posedge tb_top.clock);
		foreach (req_addr_arry[i]) begin
			if(req_addr_arry[i])begin
		    a_addr = req_addr_arry[i];
				req_dest_1 = req_dest_arry[i];
        req_source_1 = req_source_arry[i];
				//wait dut mshr refill
				if(tb_top.U_GPCDCache.s1_validRefill && tb_top.U_GPCDCache.s1_req_isRefill && tb_top.U_GPCDCache.s1_canDoRefill && (tb_top.U_GPCDCache.s1_req_paddr[38:6] == a_addr[38:6]) && !tb_top.U_GPCDCache.s1_req_isProbe)begin
					refill_valid[i]=1;
          `uvm_info(get_type_name(),$sformatf("rm wait dut refill done,a_addr=%0h,canDoRefill=%0h,isrefill=%0h",a_addr,tb_top.U_GPCDCache.s1_canDoRefill,tb_top.U_GPCDCache.s1_req_isRefill),UVM_NONE);
					`uvm_info(get_type_name(),$sformatf(" req_addr_arry=%p,refill_valid=%p", req_addr_arry,refill_valid),UVM_NONE);
	        //break;
	      end
        
				//wait dut iomshr refill
				if(tb_top.U_GPCDCache.mshrs.iomshrs.io_resp_valid && tb_top.U_GPCDCache.mshrs.iomshrs.io_resp_ready && (tb_top.U_GPCDCache.mshrs.iomshrs.io_resp_bits_dest[4:0] == req_dest_1) && (tb_top.U_GPCDCache.mshrs.iomshrs.io_resp_bits_source[1:0] == req_source_1))begin
					iomshr_refill_valid[i]=1;
          `uvm_info(get_type_name(),$sformatf("rm wait dut iomshr refill done,a_addr=%0h,req_dest=%0h,req_source=%0h,d_source=%0h,valid=%0h,ready=%0h,mshr_valid=%0h",a_addr,req_dest_1,req_source_1,i,tb_top.U_GPCDCache.mshrs.iomshrs.io_resp_valid,tb_top.U_GPCDCache.mshrs.iomshrs.io_resp_ready,tb_top.U_GPCDCache.mainReqArb.io_out_valid),UVM_NONE);
					`uvm_info(get_type_name(),$sformatf(" req_addr_arry=%p,iomshr_refill_valid=%p", req_addr_arry,iomshr_refill_valid),UVM_NONE);
				end
			end
	  end
	end


  while(1)begin
    @(posedge tb_top.clock);
		foreach (iomshr_refill_valid[i]) begin
      if(iomshr_refill_valid[i])begin
		     //get put or atomic
         // if isRefill && iomshr.resp.valid && ready , mshr need first
				 if(tb_top.U_GPCDCache.mainReqArb.io_out_valid && tb_top.U_GPCDCache.mainReqArb.io_out_bits_isRefill)begin
				   repeat(2)@(posedge tb_top.clock);
			   end
				 else if(tb_top.U_GPCDCache.s1_validRefill&&tb_top.U_GPCDCache.s1_req_isRefill)begin
          @(posedge tb_top.clock);
				 end				 
				 `uvm_info(get_type_name(),$sformatf("iomshr_refill_valid=%0h,d_opcode_arry=%0h",i,d_opcode_arry[i]),UVM_NONE);

          if(d_opcode_arry[i] == 1)begin //AccessAckData
		    	  req_dest_tmp = req_dest_arry[i];
						req_source_tmp = req_source_arry[i];
		    	  sign_extension(req_signed_arry[{req_source_tmp,req_dest_tmp}],req_size_arry[{req_source_tmp,req_dest_tmp}],d_data_arry[i],refill_data);
		        send_rsp(req_source_tmp ,req_dest_tmp , lsu_trans::REFILL,1,refill_data);
		        `uvm_info(get_type_name(),$sformatf("rm send iomsr refill resp,req_dest=%0h,req_source=%0h,req_addr=%0h,d_source=%0h,data=%0h",req_dest_arry[i],req_source_tmp,req_addr_arry[i],i,refill_data),UVM_NONE);
		      end
		    	
		      //req_addr_arry_f[i]   <= 1;
					req_addr_arry[i]   <= 0;
		      req_source_arry[i] <= 0;
		      req_dest_arry[i]   <= 0;	
					iomshr_refill_valid[i] = 0;
					req_noalloc_arry[i] <=0;
		    //end
			end
		end
  end

	while(1)begin
			@(posedge tb_top.clock);
			foreach (refill_valid[i]) begin
			  if(refill_valid[i])begin
          d_source = i;
				  a_addr = req_addr_arry[d_source];	
          nset = a_addr[12:6];
		    	ntag = a_addr[38:13];

			    query_block(nset,ntag, coh ,exist_way,data);
			    replace_plru(nset,coh,exist_way ,victim_way,victim_way_valid);

		      

					case (d_param[d_source])
            2'h0 : coh_tmp = lsu_trans::DIRTY  ;// toT,cacheline DIRTY
            2'h1 : coh_tmp = lsu_trans::BRANCH ;// toB,cacheline BRANCH
            2'h2 : coh_tmp = lsu_trans::NOTHING;// toN,cacheline NOTHING
		      endcase

					if((req_cmd_arry[d_source] == lsu_trans::M_XLR || req_cmd_arry[d_source] == lsu_trans::M_PFW) && d_param[d_source] == 2'h0 )begin
            coh_tmp = lsu_trans::TRUNK;//toT,cacheline TRUNK
					end



			    if(req_cmd_arry[d_source] == lsu_trans::M_XRD || req_cmd_arry[d_source] == lsu_trans::M_PFR || req_cmd_arry[d_source] == lsu_trans::M_XLR)begin

            // refill rsp sent to scb
		        req_dest_tmp = req_dest_arry[d_source];
						req_source_tmp = req_source_arry[d_source];

		        req_size = req_size_arry[{req_source_tmp,req_dest_tmp}];
		        addr_data_align(req_size,a_addr,d_data_arry[d_source],align_data);
				    update_data = d_data_arry[d_source];

				    //sign_extension
		        if(req_cmd_arry[d_source] == lsu_trans::M_XRD)begin
		          sign_extension(req_signed_arry[{req_source_tmp,req_dest_tmp}],req_size,align_data,refill_data);
		          send_rsp(req_source_arry[d_source] ,req_dest_arry[d_source] , lsu_trans::REFILL,1,refill_data);
		          `uvm_info(get_type_name(),$sformatf("rm send refill resp,req_dest=%0h,req_source=%0h,req_addr=%0h,req_source=%0h,data=%0h",req_dest_arry[d_source],req_source_tmp,a_addr,req_source_arry[d_source],refill_data),UVM_NONE);
		        end

				    //same_addr_refill
		        same_addr_refill_num = same_addr_info_q.size();
		        if(same_addr_refill_num>0)begin
		          for(int i=0 ;i<same_addr_refill_num;i++)begin
                same_addr_info = same_addr_info_q.pop_front();
		        	
                req_dest = same_addr_info[5:0];
                req_source = same_addr_info[13:6];
		        	  req_cmd_same_addr = same_addr_info[57:53];
		        	  req_signed = same_addr_info[58:58];
		        	  req_addr  = same_addr_info[52:14];
		        	  `uvm_info(get_type_name(),$sformatf("rm get same addr info ,req_dest=%0h, req_source=%0h, req_size=%0h,data=%0h,same_addr_refill_num=%0h,req_addr=%0h,a_addr=%0h",req_dest,req_source,same_addr_info[637:635],refill_data,same_addr_refill_num,req_addr,a_addr),UVM_NONE);
		        	  if(req_addr[31:6] == a_addr[31:6])begin 

		        		  if(req_cmd_same_addr == lsu_trans::M_XRD)begin
										addr_data_align(same_addr_info[637:635],req_addr,d_data_arry[d_source],align_data);
		        		    sign_extension(req_signed,same_addr_info[637:635],align_data,refill_data);
		                send_rsp(req_source ,req_dest , lsu_trans::REFILL,1,refill_data);
		        	      `uvm_info(get_type_name(),$sformatf("rm send same addr refill resp ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_refill_num),UVM_NONE);
		        	    end
                 	if(req_cmd_same_addr == lsu_trans::M_XWR || req_cmd_same_addr == lsu_trans::M_PWR)begin
										data_mask_merge(same_addr_info[637:635], req_addr,same_addr_info[122:59],update_data, same_addr_info[634:123],merge_data);
					          `uvm_info(get_type_name(),$sformatf("store miss merge data,a_addr=%0h,req_cmd=%0h,req_size=%0h,same_addr_info_size=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",req_addr,req_cmd_same_addr,same_addr_info[637:635],same_addr_info_q.size(),req_mask,update_data,same_addr_info[634:123],merge_data),UVM_NONE);
										update_data = merge_data;
									end


		            end
		        	  else begin
                  same_addr_info_tmp_q.push_back(same_addr_info);
		        	    `uvm_info(get_type_name(),$sformatf("push back same addr info tmp ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_refill_num),UVM_NONE);   

		        	  end					
		          end
		        end
 
				    //write_back same_addr_info_q when addr not match 
		        tmp_num = same_addr_info_tmp_q.size();
		        if(tmp_num >0 ) begin
              for(int i=0 ;i<tmp_num;i++)begin
		        	  same_addr_info_tmp = same_addr_info_tmp_q.pop_back();
		          	same_addr_info_q.push_front(same_addr_info_tmp);
		        	  req_dest =   same_addr_info_tmp[5:0];
                req_source = same_addr_info_tmp[13:6];
		          	req_cmd_same_addr =    same_addr_info_tmp[57:53];
		        	  req_signed = same_addr_info_tmp[58:58];
		        	  req_addr  =  same_addr_info_tmp[52:14];
		        	  `uvm_info(get_type_name(),$sformatf("push back same addr info ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_info_tmp_q.size()),UVM_NONE);  
               
		          end
		        end
			    end//end M_XRD
			    else if(req_cmd_arry[d_source] == lsu_trans::M_XWR || req_cmd_arry[d_source] == lsu_trans::M_PWR || req_cmd_arry[d_source] == lsu_trans::M_XSC)begin
					  req_size_store = req_size_store_arry[d_source];
				    req_mask       = req_mask_arry[d_source];
            req_data       = req_data_arry[d_source];
				    data_mask_merge(req_size_store, a_addr,req_mask, d_data_arry[d_source],req_data,update_data);													
					  `uvm_info(get_type_name(),$sformatf("store miss merge data,a_addr=%0h,req_cmd=%0h,req_size=%0h,way=%0h,same_addr_info_size=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",a_addr,req_cmd_arry[d_source],req_size_store,exist_way,same_addr_info_q.size(),req_mask,d_data_arry[d_source],req_data,update_data),UVM_NONE);

			    end

					//same addr check, load need refill,store need merge data
		        same_addr_refill_num = same_addr_info_q.size();
		        if(same_addr_refill_num>0)begin
		          for(int i=0 ;i<same_addr_refill_num;i++)begin
                same_addr_info = same_addr_info_q.pop_front();
		        	
                req_dest = same_addr_info[5:0];
                req_source = same_addr_info[13:6];
		        	  req_cmd_same_addr = same_addr_info[57:53];
		        	  req_signed = same_addr_info[58:58];
		        	  req_addr  = same_addr_info[52:14];
								//data  634:123
								//mask  122:59
								//size  637:635
		        	  `uvm_info(get_type_name(),$sformatf("rm get same addr info ,req_dest=%0h, req_source=%0h, req_size=%0h,data=%0h,same_addr_refill_num=%0h,req_addr=%0h,a_addr=%0h",req_dest,req_source,same_addr_info[637:635],refill_data,same_addr_refill_num,req_addr,a_addr),UVM_NONE);
		        	  if(req_addr[31:6] == a_addr[31:6])begin 

                 	if(req_cmd_same_addr == lsu_trans::M_XWR || req_cmd_same_addr == lsu_trans::M_PWR)begin
										data_mask_merge(same_addr_info[637:635], req_addr,same_addr_info[122:59],update_data, same_addr_info[634:123],merge_data);
					          `uvm_info(get_type_name(),$sformatf("store miss merge data,a_addr=%0h,req_cmd=%0h,req_size=%0h,same_addr_info_size=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",req_addr,req_cmd_same_addr,same_addr_info[637:635],same_addr_info_q.size(),req_mask,update_data,same_addr_info[634:123],merge_data),UVM_NONE);
										update_data = merge_data;
									end		        		 
									if(req_cmd_same_addr == lsu_trans::M_XRD)begin
										addr_data_align(same_addr_info[637:635],req_addr,update_data,align_data);
		        		    sign_extension(req_signed,same_addr_info[637:635],align_data,refill_data);
		                send_rsp(req_source ,req_dest , lsu_trans::REFILL,1,refill_data);
		        	      `uvm_info(get_type_name(),$sformatf("rm send same addr refill resp ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_refill_num),UVM_NONE);
		        	    end

		            end
		        	  else begin
                  same_addr_info_tmp_q.push_back(same_addr_info);
		        	  end					
		          end
		        end	

				    //write_back same_addr_info_q when addr not match 
		        tmp_num = same_addr_info_tmp_q.size();
		        if(tmp_num >0 ) begin
              for(int i=0 ;i<tmp_num;i++)begin
		        	  same_addr_info_tmp = same_addr_info_tmp_q.pop_back();
		          	same_addr_info_q.push_front(same_addr_info_tmp);
		        	  req_dest =   same_addr_info_tmp[5:0];
                req_source = same_addr_info_tmp[13:6];
		          	req_cmd_same_addr =    same_addr_info_tmp[57:53];
		        	  req_signed = same_addr_info_tmp[58:58];
		        	  req_addr  =  same_addr_info_tmp[52:14];
		        	  `uvm_info(get_type_name(),$sformatf("push back same addr info ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_info_tmp_q.size()),UVM_NONE);  
               
		          end
		        end						

          //refill&replace
		      if(coh == lsu_trans::NOTHING)begin
		  	  update_cache(nset,ntag,coh_tmp,victim_way,update_data,coh_vic,data_vic,addr_vic);
		  	  `uvm_info(get_type_name(),$sformatf("replace cache , addr=%0h,set=%0h,tag=%0h,way=%0h,coh=%0h,coh_vic=%0h,addr_vic=%0h,data_vic=%0h",a_addr,nset,ntag,victim_way,coh_tmp,coh_vic,addr_vic,data_vic),UVM_NONE);
		      end
		      else begin
		  	  update_cache(nset,ntag,coh_tmp,exist_way,update_data,coh_vic,data_vic,addr_vic);								
		      `uvm_info(get_type_name(),$sformatf("refresh cache , addr=%0h,set=%0h,tag=%0h,way=%0h,coh=%0h",a_addr,nset,ntag,exist_way,coh_tmp),UVM_NONE);
		      end

          if(victim_way_valid & (coh_vic != lsu_trans::NOTHING))begin
            if(coh_vic == lsu_trans::DIRTY)begin  //release_data  TtoN
              do_release(addr_vic,7,8,1,data_vic,coh_vic);       
		        end
						else if(coh_vic == lsu_trans::TRUNK)begin////release TtoN 
              do_release(addr_vic,6,8,1,0,coh_vic);   
						end
		        else begin//release BtoN
		  	      do_release(addr_vic,6,8,2,0,coh_vic);       
		        end
					end

          
					//clear info for source index
		      req_addr_arry_f[d_source]   <= 1;
		      req_source_arry[d_source]  <= 0;
		      req_dest_arry[d_source]   <= 0;	
					refill_valid[d_source]    = 0;
					req_noalloc_arry[d_source]<= 0;


        end//endif
		  end//end forecah
  end

	while(1)begin
			@(posedge tb_top.clock);
			foreach (req_addr_arry_f[i]) begin
				if(req_addr_arry_f[i])begin
			    req_addr_arry[i]   <= 0;
					req_addr_arry_f[i] <= 0;
			    //`uvm_info(get_type_name(),$sformatf("release same addr info , addr=%0h,i=%0h",req_addr_arry[i],i),UVM_NONE);
		    end
		  end
	end


  join  

endtask


task dcache_refm::update_cache(input bit [6:0] set_index,input bit [25:0] tag,input bit[1:0] coh, input bit [1:0] way ,input bit [511:0] data,output bit[1:0] victim_coh,output bit[511:0] victim_data,output bit[38:0] victim_addr);
	
	bit [39*4-1:0] meta_data;
	bit [2047:0] set_data;
  bit [38:0] meta_tmp ;
	bit [38:0] meta_victim_tmp ;


  meta_data = meta_arry[set_index];
  set_data  = data_arry[set_index];

	meta_tmp = {tag,11'h0,coh};


	case (way)
    2'h0 : victim_data = set_data[511:0]    ;
		2'h1 : victim_data = set_data[1023:512] ;
		2'h2 : victim_data = set_data[1535:1024];
		2'h3 : victim_data = set_data[2047:1536];
	endcase

	case (way)
    2'h0 : meta_victim_tmp = meta_data[38:0]  ;
		2'h1 : meta_victim_tmp = meta_data[77:39] ;
		2'h2 : meta_victim_tmp = meta_data[116:78] ;
		2'h3 : meta_victim_tmp = meta_data[155:117];	
	endcase
	
	case (way)
    2'h0 : set_data[511:0]    =data;
		2'h1 : set_data[1023:512] =data;
		2'h2 : set_data[1535:1024]=data;
		2'h3 : set_data[2047:1536]=data;
	endcase

	case (way)
    2'h0 : meta_data[38:0]  =meta_tmp;
		2'h1 : meta_data[77:39] =meta_tmp;
		2'h2 : meta_data[116:78] =meta_tmp;
		2'h3 : meta_data[155:117]=meta_tmp;	
	endcase
	
			
	meta_arry[set_index] = meta_data;
	data_arry[set_index] = set_data;


	victim_coh  = meta_victim_tmp[1:0];
	victim_addr = {meta_victim_tmp[38:13],set_index,6'h0};


	`uvm_info(get_type_name(),$sformatf("update cache ,set=%0h,tag=%0h,way=%0h,coh=%0h,data=%0h,victim_addr=%0h,victim_coh=%0h,victim_data=%0h",set_index,tag,way,coh,data,victim_addr,victim_coh,victim_data),UVM_NONE)


endtask

task dcache_refm::addr_data_align(input bit [2:0] size, input bit [38:0] addr,input bit [511:0] data,output [511:0] align_data);

  bit [5:0]   addr_align;
  bit [511:0] valid_bits;
	bit [511:0] data_tmp;

  case (size)
    3'h1 : addr_align  = addr[0:0];
    3'h2 : addr_align  = addr[1:0];
    3'h3 : addr_align  = addr[2:0];
    3'h4 : addr_align  = addr[3:0];
    3'h5 : addr_align  = addr[4:0];
    3'h6 : addr_align  = addr[5:0];
  endcase

	if(size >0 )begin
		if(addr_align != 0)begin
      `uvm_fatal(get_type_name(),$sformatf(" addr illegal ,addr=%0h,size=%0h",addr,size));
		end
  end


	case (size)
		3'h0 : valid_bits  = 8'hff;
		3'h1 : valid_bits  = {2{8'hff}};
    3'h2 : valid_bits  = {4{8'hff}};
    3'h3 : valid_bits  = {8{8'hff}};
    3'h4 : valid_bits  = {16{8'hff}};
    3'h5 : valid_bits  = {32{8'hff}};
    3'h6 : valid_bits  = {64{8'hff}};
  endcase

	if(size == 6)begin
		data_tmp  =  data;
	end
	else begin
    data_tmp  =  data >> (addr[5:0]*8);
	end
  align_data = valid_bits & data_tmp;


endtask


task dcache_refm::data_mask_merge(input bit [2:0] size, input bit [38:0] addr,input bit [63:0] mask, input bit [511:0] r_data, input bit [511:0] w_data,output [511:0] data);

	bit [511:0] valid_bits,data_tmp,wdata_tmp;

	case (size)
		3'h0 : valid_bits  = 8'hff      ;
		3'h1 : valid_bits  = {2{8'hff}} ;
    3'h2 : valid_bits  = {4{8'hff}} ;
    3'h3 : valid_bits  = {8{8'hff}} ;
    3'h4 : valid_bits  = {16{8'hff}};
    3'h5 : valid_bits  = {32{8'hff}};
    3'h6 : valid_bits  = {64{8'hff}};
  endcase

//if(size == 6)begin
//	wdata_tmp  =  w_data;
//end
//else begin
//  wdata_tmp  =  w_data >> (addr[5:0]*8);
//end

	//`uvm_info(get_type_name(),$sformatf("data merge debug1 ,addr=%0h,size=%0h,valid_bits=%0h,wdata_tmp=%0h,w_data=%0h",addr[5:0],size,valid_bits,wdata_tmp,w_data),UVM_NONE)
	
  wdata_tmp = valid_bits & w_data;


  valid_bits  =  valid_bits << (addr[5:0]*8);
	data_tmp  =  wdata_tmp << (addr[5:0]*8);
	//`uvm_info(get_type_name(),$sformatf("data merge debug2 ,addr=%0h,size=%0h,valid_bits=%0h,wdata_tmp=%0h,shift=%0h,data_tmp=%0h",addr[5:0],size,valid_bits,wdata_tmp,w_data >> (addr[5:0]*8),data_tmp),UVM_NONE)


	if(mask !=0 )begin
		for(int i=0;i<64;i++)begin
			if(mask[i])begin 
        data[i*8+:8] = w_data[i*8+:8];
			end
			else begin
        data[i*8+:8] = r_data[i*8+:8];
			end
		end
	end
	else begin
    data = (~valid_bits & r_data) | data_tmp;
	end

  `uvm_info(get_type_name(),$sformatf("data merge ,addr=%0h,size=%0h,mask=%0h,valid_bits=%0h,source_data=%0h,data_tmp=%0h,data=%0h",addr,size,mask,~valid_bits,r_data,data_tmp,data),UVM_NONE)

endtask

task dcache_refm::sign_extension(input bit is_signed ,input bit [2:0] size,input bit [511:0] data,output bit [511:0] sign_data);

	if(is_signed)begin
    case (size)
    	3'h0 : sign_data = data[7:7]     ? {{504{1'b1}},data[7:0]}   : data;
    	3'h1 : sign_data = data[15:15]   ? {{496{1'b1}},data[15:0]}  : data;
      3'h2 : sign_data = data[31:31]   ? {{480{1'b1}},data[31:0]}  : data;
      3'h3 : sign_data = data[63:63]   ? {{448{1'b1}},data[63:0]}  : data;
      3'h4 : sign_data = data[127:127] ? {{384{1'b1}},data[127:0]} : data;
      3'h5 : sign_data = data[255:255] ? {{256{1'b1}},data[255:0]} : data;
      3'h6 : sign_data = data;
    endcase
  end
	else begin
    sign_data = data;
	end

  `uvm_info(get_type_name(),$sformatf("sign_extension ,is_signed=%0h,size=%0h,origin_data=%0h,sign_data=%0h",is_signed,size,data,sign_data),UVM_NONE)


endtask

task dcache_refm::send_rsp(input bit [7:0] source ,input bit [4:0] dest , input bit [2:0] status, input bit hasdata,input bit [511:0] data);

  lsu_trans rsp;

  rsp = new();

	rsp.io_resp_bits_source   = source;
  rsp.io_resp_bits_dest	    = dest; 
  rsp.io_resp_bits_status	  = status;
  rsp.io_resp_bits_hasData	= hasdata;
  rsp.io_resp_bits_data     = data;
	 
	rm2sb_rsp_port.write(rsp);
  `uvm_info(get_type_name(), {"send rm2scb rsp item\n",rsp.sprint}, UVM_HIGH)
	`uvm_info(get_type_name(),$sformatf("rm send resp,dest=%0h,status=%0h,data=%0h",dest,status,data),UVM_NONE);


endtask

task dcache_refm::do_tlc_message(input bit [38:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param);

  svt_tilelink_master_transaction   tr_a;

  tr_a = new();
  tr_a.a_size    = 'h6;
  tr_a.a_source  = a_source;
  tr_a.a_address = {a_addr[38:6],6'h0};
  tr_a.ch_a_msg_type  = svt_tilelink_master_transaction::CH_A_ACQUIRE_BLOCK;
  tr_a.a_param   = a_param;

	
	//rm2sb_tltx_port.write(tr_a);
	tl_send_q.push_back(tr_a);

	`uvm_info(get_type_name(),$sformatf("rm send acquire to send_q , a_addr=%0h,a_source=%0h,a_param=%0h,send_q_size=%0h",tr_a.a_address,tr_a.a_source,tr_a.a_param,tl_send_q.size()),UVM_NONE);

endtask


task dcache_refm::do_tlu_message(input bit [38:0] a_addr ,input bit [2:0] a_opcode,input bit [2:0] a_size,input bit [15:0] a_source,input bit [511:0] a_data,input bit [63:0] a_mask,input bit [2:0] a_param = 0);

  svt_tilelink_master_transaction   tr_a;

  tr_a = new();

  if((a_opcode == 0) || (a_opcode == 1) )begin
    tr_a.a_data = new[2**a_size];
		tr_a.a_mask = new[1];

	  for(int i=0;i<64;i++)begin
		  tr_a.a_data[i] = a_data[i*8+:8];
    end
		tr_a.a_mask[0] = a_mask;

  end

  tr_a.a_size    = a_size;
  tr_a.a_source  = a_source;
  tr_a.a_address = a_addr;
  tr_a.ch_a_msg_type  = a_opcode;
  tr_a.a_param   = a_param;

	tl_send_q.push_back(tr_a);

	//rm2sb_tltx_port.write(tr_a);
	`uvm_info(get_type_name(),$sformatf("rm send tlu message to send_q , a_addr=%0h,a_source=%0h,a_mask=%0h,a_data=%0h,a_param=%0h,send_q_size=%0h",tr_a.a_address,tr_a.a_source,a_mask,a_data,a_param,tl_send_q.size()),UVM_NONE);

endtask

task dcache_refm::do_tl_send_q();

  svt_tilelink_master_transaction   tr_a;

  while(1)begin
		@(posedge tb_top.clock);
		tr_a = new();
		if(tb_top.tilelink_slave_if[0].a_valid & tb_top.tilelink_slave_if[0].a_ready)begin
			#0.1;
			tr_a = tl_send_q.pop_front();
      rm2sb_tltx_port.write(tr_a);
	    `uvm_info(get_type_name(),$sformatf("rm send_q , a_addr=%0h,a_source=%0h,a_opcode=%0h,a_param=%0h,send_q_size=%0h",tr_a.a_address,tr_a.a_source,tr_a.ch_a_msg_type,tr_a.a_param,tl_send_q.size()),UVM_NONE);

		end
  end


endtask


task dcache_refm::do_release(input bit [38:0] c_addr ,input bit [2:0] c_opcode,input bit [15:0] c_source,input bit [2:0] c_param,input bit [511:0] c_data,input bit [1:0] coh);
   
	svt_tilelink_slave_transaction   tr_c;

  tr_c = new();
	tr_c.status = new();

//if(coh == lsu_trans::DIRTY)begin
//  tr_c.status.c_data = new[64];
//end

  //ReleaseData ProbeAckData
  if(c_opcode==7 || c_opcode==5 )begin
    tr_c.status.c_data = new[64];
	end

  tr_c.status.c_size         = 'h6;
  tr_c.status.c_source       = c_source;
  tr_c.status.c_address      = {c_addr[38:6],6'h0};
  tr_c.status.ch_c_msg_type  = c_opcode;
  tr_c.status.c_param        = c_param;

	for(int i=0;i<64;i++)begin
		tr_c.status.c_data[i] = c_data[i*8+:8];
  end

	rm2sb_tlc_port.write(tr_c);
	`uvm_info(get_type_name(),$sformatf("rm send channel_c message to sb,c_addr=%0h,c_opcode=%0h,c_source=%0h,c_param=%0h,data=%0h",tr_c.status.c_address,tr_c.status.ch_c_msg_type,tr_c.status.c_source,tr_c.status.c_param,c_data),UVM_NONE);

	`uvm_info(get_type_name(),$sformatf("release_data=%p",tr_c.status.c_data),UVM_NONE);



endtask



task dcache_refm::release_source_id(input bit [15:0] source_id); 
  
	bit [15:0] source_id_tmp;

	case(source_id)
    0: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_0_valid);
    1: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_1_valid);
    2: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_2_valid);
    3: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_3_valid);
    4: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_4_valid);
    5: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_5_valid);
    6: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_6_valid);
    7: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_7_valid);
    16:  wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_0_valid);
    17:  wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_1_valid);
    18: wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_2_valid);
    19: wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_3_valid);
    20: wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_4_valid);
    21: wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_5_valid);
    22: wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_6_valid);
    23: wait(tb_top.U_GPCDCache.mshrs.iomshrs.allocArb.io_in_7_valid);

  endcase

	if(source_id >= 0 && source_id <= 7)begin
		source_id_tmp = source_id;
	  mshr_source_id_valid[source_id_tmp] = 1;
  end
	else if(source_id >= 16 && source_id <= 23) begin
		source_id_tmp = source_id -16;
	  iomshr_source_id_valid[source_id_tmp] = 1;
	end
  `uvm_info(get_type_name(),$sformatf("release_source_id , source_id=%0h",source_id),UVM_NONE);
	`uvm_info(get_type_name(),$sformatf("release_source_id mshr_source_id_valid=%p,iomshr_source_id_valid=%p", mshr_source_id_valid,iomshr_source_id_valid),UVM_NONE);



endtask

task dcache_refm::assemble_cmd();
	bit [511:0] data,data_vic;
	bit         hit;
	bit [2:0]   coh,coh_vic;
	bit [25:0]  tag;
	bit [1:0]   way,victim_way;
	bit [2:0]   req_size;
	bit [511:0] req_data;
	bit [63:0]  req_wmask,mask,mask_tlu;
	bit [5:0]   req_dest; 
	bit         req_noAlloc;
 	bit [38:0]  req_addr,addr_vic;
	bit [7:0]   req_source;
  bit         req_signed;
	bit [15:0]  a_source;
  bit [2:0]   a_param;
	bit [2:0]   a_opcode;
  bit [1023:0] same_addr_info,same_addr_info_tmp;
	bit         same_addr_exist;
	bit [511:0] align_data,refill_data,merge_data,amo_data;
	bit         victim_way_valid;
  bit [5:0]   mask_addr;
  bit [31:0]  send_q_num;
   
	lsu_trans   req;
	lsu_trans::req_cmd_enum 		req_cmd;
	lsu_trans::resp_status_enum rsp_status;

	svt_tilelink_master_transaction   tr_a;

	req = new();

	
  forever begin
    //`uvm_info(get_type_name(),$sformatf("lsu_tr_q size=%0h",lsu_tr_q.size()),UVM_NONE);
		@(posedge tb_top.clock);
		//wait(lsu_tr_q.size()>0); 
		if(lsu_tr_q.size()>0 )begin
			req = lsu_tr_q.pop_front();
			req_cmd    = req.io_req_bits_cmd;
		  req_data   = req.io_req_bits_wdata;
		  req_wmask  = req.io_req_bits_wmask;
		  req_noAlloc= req.io_req_bits_noAlloc;
		  req_size   = req.io_req_bits_size;
			req_addr   = req.io_req_bits_paddr;
			req_source = req.io_req_bits_source;
			req_signed = req.io_req_bits_signed;
		  req_dest   = req.io_req_bits_dest;
      
			tag  = req_addr[38:13];
      nset = req_addr[12:6];

      //#0.4
			if(tb_top.U_GPCDCache.io_resp_bits_status[1:0] == 2 && req_cmd!=lsu_trans::M_XLR && !(req_cmd == lsu_trans::M_XA_SWAP || req_cmd == lsu_trans::M_XA_ADD || req_cmd == lsu_trans::M_XA_XOR || req_cmd == lsu_trans::M_XA_OR  || req_cmd == lsu_trans::M_XA_AND  || req_cmd == lsu_trans::M_XA_MIN || req_cmd == lsu_trans::M_XA_MAX || req_cmd == lsu_trans::M_XA_MINU ||req_cmd == lsu_trans::M_XA_MAXU))begin
			 `uvm_info(get_type_name(),$sformatf("replay cmd rm donot accept ,addr=%0h,dest=%0h,cmd=%0h",req_addr,req_dest,req_cmd),UVM_NONE)
       continue;

			end

     	req_size_arry[{req_source,req_dest}] = req_size;
			req_signed_arry[{req_source,req_dest}] = req_signed;

		  `uvm_info(get_type_name(),$sformatf("rm get cmd,real_addr=%0h,set=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,req_size=%0h",req_addr,nset,req_cmd,req_dest,req_source,req_size_arry[{req_source,req_dest}]),UVM_NONE);
			`uvm_info(get_type_name(),$sformatf("processing addr=%p", req_addr_arry),UVM_NONE);
      `uvm_info(get_type_name(),$sformatf("mshr_source_id_valid=%p,iomshr_source_id_valid=%p", mshr_source_id_valid,iomshr_source_id_valid),UVM_NONE);


			query_block(nset,tag,coh,way,data);
      `uvm_info(get_type_name(),$sformatf("query cache,addr=%0h,req_dest=%0h,set=%0h,way=%0h,tag=%0h,coh=%0h,data=%0h",req_addr,req_dest,nset,way,tag,coh,data),UVM_NONE);
			addr_data_align(req_size,req_addr,data,align_data);


	    same_addr_exist= 0;

		  if(lrsc_count>3 && (req_cmd == lsu_trans::M_XRD || req_cmd == lsu_trans::M_PWR || req_cmd == lsu_trans::M_XWR))begin
         lrsc_count <=3;
         `uvm_info(get_type_name(),$sformatf("load or store after LR,addr=%0h,req_dest=%0h,lrsc_count=%0h",req_addr,req_dest,lrsc_count),UVM_NONE);
			end
			

			//****Read****
			if(req_cmd == lsu_trans::M_XRD || req_cmd == lsu_trans::M_PFR )begin

				//miss
				if(coh == lsu_trans::NOTHING )begin
	        send_rsp(req_source ,req_dest ,lsu_trans::MISS,0,0);
          
          //check if same addr req exist, 0-7 MSHR
		      foreach (req_addr_arry[j])begin
		      	if(req_addr_arry[j][38:6] == req_addr[38:6] && !((req_addr[38:13]>='h3_0000) && (req_addr[38:13]<='h3_ffff)) && j<8 )begin
				   	//load miss need refill resp
					  //req_source_q.push_back(req_source);
            same_addr_info = {req_signed,req_cmd,req_addr,req_source,req_dest};
						same_addr_info[637:635] = req_size;
            same_addr_info_q.push_back(same_addr_info);
					  `uvm_info(get_type_name(),$sformatf("same addr load info,waiting for refill resp,addr=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,rsp_num=%0h,a_source=%0h",req_addr,req_cmd,req_dest,req_source,same_addr_info_q.size(),j),UVM_NONE);
						same_addr_exist = 1;
						break;
		      	end	
		      end
          


          if(same_addr_exist)begin
						continue;
					end
					else begin
						if(req_noAlloc || ((req_addr[38:13]>='h3_0000) && (req_addr[38:13]<='h3_ffff)))begin
						  //get iomshr valid sour_id
						  wait (iomshr_source_id_valid.or >0);
					    foreach (iomshr_source_id_valid[j])begin
						    if(iomshr_source_id_valid[j])begin
                  a_source = j+16;
							    iomshr_source_id_valid[j]=0;
							    break;
						    end  
				  	  end							

							do_tlu_message(req_addr ,4,req_size,a_source,0,0);// get
							req_addr_arry[a_source]  = req_addr;
							req_noalloc_arry[a_source] = req_noAlloc;
							//req_addr_arry_f[a_source] = req_addr_arry[a_source];

						end
						else begin
						  //get mshr valid sour_id
						  wait (mshr_source_id_valid.or >0);
					    foreach (mshr_source_id_valid[j])begin
						    if(mshr_source_id_valid[j])begin
                  a_source = j;
							    mshr_source_id_valid[j]=0;
							    break;
						    end  
				  	  end

					    do_tlc_message(req_addr,a_source,0);//NtoB
							req_addr_arry[a_source]  = req_addr;
						  req_noalloc_arry[a_source] = req_noAlloc;
							//req_addr_arry_f[a_source] = req_addr_arry[a_source];

						end

					  req_dest_arry[a_source]  = req_dest;
				    req_source_arry[a_source]  = req_source;
						req_cmd_arry[a_source]  = req_cmd;

					  `uvm_info(get_type_name(),$sformatf("rm load processing,a_source=%0h, req_addr=%0h,req_dest=%0h,req_cmd=%0h",a_source,req_addr_arry[a_source],req_dest_arry[a_source],req_cmd_arry[a_source]),UVM_NONE);
					end
									
				end
				//hit
				else begin
					rsp_status = lsu_trans::HIT;
					sign_extension(req_signed,req_size,align_data,refill_data);
					send_rsp(req_source ,req_dest ,rsp_status,1,refill_data);
					replace_plru(nset,coh,way,victim_way,victim_way_valid);
				end                 
			end

			//****WRITE****
			if(req_cmd == lsu_trans::M_XWR || req_cmd == lsu_trans::M_PWR || req_cmd == lsu_trans::M_XLR || req_cmd == lsu_trans::M_XSC)begin

				//M_PWR size must 6  M_XWR not support mask
        mask = (req_cmd == lsu_trans::M_PWR) ? req_wmask : 0 ;
        //store_mask_arry[{req_addr,req_source,req_dest}] = mask;
			  //store_data_arry[req_addr] = req_data;
				//store_data_arry['h40] = req_data;
				//`uvm_info(get_type_name(),$sformatf("store miss data , addr=%0h, req_source=%0h,req_dest=%0h,index=%0h,data=%0h",req_addr,req_source,req_dest,store_data_arry['h40],store_data_arry[req_addr]),UVM_NONE);


				//miss
				if(coh == lsu_trans::NOTHING || coh == lsu_trans::BRANCH )begin

					a_param =  (coh == lsu_trans::NOTHING) ? 1 : 2 ;//NOTHING NtoT,BRANCH BtoT
										
					if(req_cmd != lsu_trans::M_XLR)begin
						if(req_cmd == lsu_trans::M_XSC)begin
              send_rsp(req_source ,req_dest ,lsu_trans::MISS,1,1);// sc hasdata=1;sc success data=0;sc fail data=1;
							// sc fail donot acquire 
							continue;
						end
						else begin
              send_rsp(req_source ,req_dest ,lsu_trans::MISS,0,0);
						end
				  end


					//B write miss need release cache
          if(coh == lsu_trans::BRANCH && req_cmd != lsu_trans::M_XLR)begin
		         update_cache(nset,0,lsu_trans::NOTHING,way ,0,coh_vic,data_vic,addr_vic);
						 w_miss_release_data_q.push_back({addr_vic,data_vic});
						 `uvm_info(get_type_name(),$sformatf("write miss release cache, set=%0h, q_size=%0h,way=%0h",nset,replace_q[nset].size(),way),UVM_NONE);
					end

	        //check if same addr exist , same addr must do not be iomshr, not mmio 
		      foreach (req_addr_arry[j])begin
		      	if(req_addr_arry[j][38:6] == req_addr[38:6] && !((req_addr[38:13]>='h3_0000) && (req_addr[38:13]<='h3_ffff)) && j<8)begin

						if(req_cmd != lsu_trans::M_XLR)begin
						  same_addr_info = {req_size,req_data,mask,req_signed,req_cmd,req_addr,req_source,req_dest};
              same_addr_info_q.push_back(same_addr_info);
					    `uvm_info(get_type_name(),$sformatf("same addr store info,waiting for refill resp,addr=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,rsp_num=%0h,a_source=%0h",req_addr,req_cmd,req_dest,req_source,same_addr_info_q.size(),j),UVM_NONE);	
					  end
						same_addr_exist = 1;
						break;
		      	end	
		      end
          
          if(same_addr_exist)begin
						//if same addr is load and acquire donot send , secondary miss need Upgrade Perm 
						tr_a = new();
			      send_q_num = tl_send_q.size();
						if(send_q_num)begin
							for (int i =0;i<send_q_num;i++)begin
								tr_a = tl_send_q.pop_front();
								if(tr_a.a_address == req_addr & tr_a.a_param == 0)begin
									tr_a.a_param = 1;
								  `uvm_info(get_type_name(),$sformatf("store secondary miss upgrade perm,addr=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,a_source=%0h",req_addr,req_cmd,req_dest,req_source,tr_a.a_source),UVM_NONE);
								end
                tl_send_q_tmp.push_back(tr_a);
							end
						end

						send_q_num = tl_send_q_tmp.size();
						if(send_q_num>0)begin
							for (int i =0;i<send_q_num;i++)begin
								tr_a = tl_send_q_tmp.pop_front();
                tl_send_q.push_back(tr_a);
							end
						end

						continue;
					end
					else begin
						if((req_noAlloc && coh == lsu_trans::NOTHING)|| ((req_addr[38:13]>='h3_0000) && (req_addr[38:13]<='h3_ffff)))begin
						  //get iomshr valid sour_id
						  wait (iomshr_source_id_valid.or >0);
					    foreach (iomshr_source_id_valid[j])begin
						    if(iomshr_source_id_valid[j])begin
                  a_source = j+16;
							    iomshr_source_id_valid[j]=0;
							    break;
						    end  
				  	  end	
							a_opcode = (req_cmd == lsu_trans::M_PWR) ? 1 : 0 ;
							
							mask_addr = req_addr[5:0];
							mask_tlu = 0;
							for(int i=0;i<2**req_size;i++)begin
                mask_tlu[mask_addr+i] = 1;
							end
							mask_tlu = (req_cmd == lsu_trans::M_PWR) ? req_wmask : mask_tlu;
							do_tlu_message(req_addr ,a_opcode,req_size,a_source,req_data,mask_tlu);
						end
            else begin
							//get mshr valid sour_id
					    wait (mshr_source_id_valid.or >0);
					    foreach (mshr_source_id_valid[j])begin
					      if(mshr_source_id_valid[j])begin
                  a_source = j;
					    	  mshr_source_id_valid[j]=0;
					    	  break;
					      end  
				      end
							do_tlc_message(req_addr,a_source,a_param);
							req_addr_arry[a_source]  = req_addr;
						  req_noalloc_arry[a_source] = req_noAlloc;
							//req_addr_arry_f[a_source] = req_addr_arry[a_source];

				  	end

 						req_cmd_arry[a_source]        = req_cmd;
						req_size_store_arry[a_source] = req_size;
						req_mask_arry[a_source]       = mask;
            req_data_arry[a_source]       = req_data;

						`uvm_info(get_type_name(),$sformatf("rm store processing , req_addr=%0h,req_dest=%0h,source=%0h,req_cmd=%0h,req_size=%0h,req_mask=%0h,req_data=%0h",req_addr_arry[a_source],req_dest,a_source,req_cmd_arry[a_source],req_size_store_arry[a_source],req_mask_arry[a_source],req_data_arry[a_source]),UVM_NONE);		
					end
										
				end
				else begin // write hit
					if(req_cmd == lsu_trans::M_XLR)begin //LR
            //lr resp need replay
						if(lrsc_count >= 1 && lrsc_count <=3 || tb_top.U_GPCDCache.io_resp_bits_status[1:0] == 2)begin
              continue;
						end
						else begin
					    sign_extension(req_signed,req_size,align_data,refill_data);
					    send_rsp(req_source ,req_dest ,lsu_trans::HIT,1,refill_data);
					    replace_plru(nset,coh,way,victim_way,victim_way_valid);

						  lrsc_count <= 'h4f ;
						  lrsc_addr = req_addr;
						  `uvm_info(get_type_name(),$sformatf("LR hit ,req_addr=%0h,req_dest=%0h,req_cmd=%0h,req_size=%0h,lrsc_count=%0h,data=%0h",req_addr,req_dest,req_cmd,req_size,lrsc_count,refill_data),UVM_NONE);
						end
	
					end
					else if(req_cmd == lsu_trans::M_XSC)begin//SC

						if(req_addr == lrsc_addr && lrsc_count>3)begin//sc success
					    data_mask_merge(req_size, req_addr,mask, data,req_data,merge_data);													
					    replace_plru(nset,coh,way,victim_way,victim_way_valid);
					    update_cache(nset,tag,lsu_trans::DIRTY,way ,merge_data,coh_vic,data_vic,addr_vic);
					    send_rsp(req_source ,req_dest , lsu_trans::HIT,1,0);
						  `uvm_info(get_type_name(),$sformatf("SC success ,req_addr=%0h,req_dest=%0h,req_cmd=%0h,req_size=%0h,lrsc_count=%0h,lrsc_addr=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",req_addr,req_dest,req_cmd,req_size,lrsc_count,lrsc_addr,req_wmask,data,req_data,merge_data),UVM_NONE);
							lrsc_count <= 3;
						end
						else begin //sc fail
							send_rsp(req_source ,req_dest , lsu_trans::HIT,1,1);
						  `uvm_info(get_type_name(),$sformatf("SC fail ,req_addr=%0h,req_dest=%0h,req_cmd=%0h,req_size=%0h,lrsc_count=%0h,lrsc_addr=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",req_addr,req_dest,req_cmd,req_size,lrsc_count,lrsc_addr,req_wmask,data,req_data,merge_data),UVM_NONE);

						end

					end
				  else begin //store						
					  // Trunk need inside Cache Upgrade Perm 
					  data_mask_merge(req_size, req_addr,mask, data,req_data,merge_data);													
					  replace_plru(nset,coh,way,victim_way,victim_way_valid);
					  update_cache(nset,tag,lsu_trans::DIRTY,way ,merge_data,coh_vic,data_vic,addr_vic);
					  send_rsp(req_source ,req_dest , lsu_trans::HIT,0,merge_data);
						//req_data_arry[a_source]       = req_data;
						`uvm_info(get_type_name(),$sformatf("store hit merge data,req_addr=%0h,req_dest=%0h,req_cmd=%0h,req_size=%0h,way=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",req_addr,req_dest,req_cmd,req_size,way,req_wmask,data,req_data,merge_data),UVM_NONE);
				  end

				end

			end//end write

	    //****AMO****
			if(req_cmd == lsu_trans::M_XA_SWAP || req_cmd == lsu_trans::M_XA_ADD || req_cmd == lsu_trans::M_XA_XOR || req_cmd == lsu_trans::M_XA_OR  || 
				 req_cmd == lsu_trans::M_XA_AND  || req_cmd == lsu_trans::M_XA_MIN || req_cmd == lsu_trans::M_XA_MAX || req_cmd == lsu_trans::M_XA_MINU || 
				 req_cmd == lsu_trans::M_XA_MAXU)begin

				 //miss
				if(coh == lsu_trans::NOTHING || coh == lsu_trans::BRANCH)begin
									 
          //check if same addr req exist, iomsr need replay,mshr need replay until mshr deallocate, B still need replay until release 
		      foreach (req_addr_arry[j] )begin
		      	if((req_addr_arry[j][38:6] == req_addr[38:6] && j<8)  ||  (req_addr_arry[j][38:2] == req_addr[38:2] && req_size==2 && j>=8) || (req_addr_arry[j][38:3] == req_addr[38:3] && req_size==3 && j>=8) )begin
					  `uvm_info(get_type_name(),$sformatf("amo same addr,need replay,addr=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,a_source=%0h",req_addr,req_cmd,req_dest,req_source,j),UVM_NONE);
						same_addr_exist = 1;
						break;
		      	end	
		      end

          if(same_addr_exist)begin
						continue;
					end
					else begin
						if(coh == lsu_trans::BRANCH )begin  //B need release		      
							update_cache(nset,0,lsu_trans::NOTHING,way ,0,coh_vic,data_vic,addr_vic);
						  do_release({req_addr[38:6],6'h0},6,8,2,data,coh);
						  `uvm_info(get_type_name(),$sformatf("AMO B miss release cache, addr=%0h,set=%0h, q_size=%0h,way=%0h",req_addr,nset,replace_q[nset].size(),way),UVM_NONE);
						end

						// replay
						if(tb_top.U_GPCDCache.io_resp_bits_status[1:0] == 2) begin
              continue;
						end

						send_rsp(req_source ,req_dest ,lsu_trans::MISS,0,0);

						//get iomshr valid sour_id
					  wait (iomshr_source_id_valid.or >0);
					  foreach (iomshr_source_id_valid[j])begin
						  if(iomshr_source_id_valid[j])begin
                a_source = j+16;
							  iomshr_source_id_valid[j]=0;
							  break;
						  end  
				  	end									
					  a_opcode = (req_cmd == lsu_trans::M_XA_SWAP || req_cmd == lsu_trans::M_XA_XOR || req_cmd == lsu_trans::M_XA_OR || req_cmd == lsu_trans::M_XA_AND  ) ? 3 : 2 ;
          
					  if(a_opcode == 3)begin //logicaldata
						  case (req_cmd)
                lsu_trans::M_XA_XOR : a_param = 0;
                lsu_trans::M_XA_OR  : a_param = 1;
                lsu_trans::M_XA_AND : a_param = 2;
						    lsu_trans::M_XA_SWAP: a_param = 3;
		          endcase
					  end
					  else begin
					    case (req_cmd)
                lsu_trans::M_XA_MIN : a_param = 0;
                lsu_trans::M_XA_MAX : a_param = 1;
                lsu_trans::M_XA_MINU: a_param = 2;
						    lsu_trans::M_XA_MAXU: a_param = 3;
					      lsu_trans::M_XA_ADD : a_param = 4;							
		          endcase
					  end
					  
					  do_tlu_message(req_addr ,a_opcode,req_size,a_source,req_data,mask_tlu,a_param);
          
					  req_addr_arry[a_source]  = req_addr;
					  req_dest_arry[a_source]  = req_dest;
				    req_source_arry[a_source]  = req_source;
				    req_cmd_arry[a_source]  = req_cmd;
					  req_noalloc_arry[a_source] = req_noAlloc;
						//req_addr_arry_f[a_source] = req_addr_arry[a_source];
					  `uvm_info(get_type_name(),$sformatf("rm amo processing,a_source=%0h, req_addr=%0h,req_dest=%0h,req_cmd=%0h,a_param=%0h",a_source,req_addr_arry[a_source],req_dest_arry[a_source],req_cmd_arry[a_source],a_param),UVM_NONE);

				  end

        end
				else begin
					amoalu(req_cmd, req_size ,align_data,req_data,amo_data);

          data_mask_merge(req_size, req_addr,0, data,amo_data,merge_data);
					replace_plru(nset,coh,way,victim_way,victim_way_valid);
					update_cache(nset,tag,lsu_trans::DIRTY,way ,merge_data,coh_vic,data_vic,addr_vic);

					sign_extension(req_signed,req_size,align_data,refill_data);
					send_rsp(req_source ,req_dest , lsu_trans::HIT,1,refill_data);
          `uvm_info(get_type_name(),$sformatf("amo hit merge data,req_addr=%0h,req_dest=%0h,req_cmd=%0h,req_size=%0h,way=%0h,\nsource_data=%0h,\nreq_data=%0h,\namo_data=%0h,\nmerge_data=%0h,\nold_data=%0h",req_addr,req_dest,req_cmd,req_size,way,data,req_data,amo_data,merge_data,align_data),UVM_NONE);

				end

			end//end amo

		end//lsu_tr_q
  end//forver
endtask


task dcache_refm::query_block(input bit [6:0] set_index, input bit [25:0] tag, output bit[1:0] coh ,output bit [1:0] way,output bit [511:0] data);

	bit [39*4-1:0] meta_data;
	bit [38:0] meta_tmp;
	bit [2047:0] set_data;
	bit [511:0] data_tmp;
	bit data_exist;

  data_exist = 0;
  meta_data = meta_arry[set_index];
  set_data  = data_arry[set_index];
  for(int i=0;i<4;i++)begin
    meta_tmp = meta_data[i*39+:39];
    data_tmp = set_data[i*512+:512];
    if(meta_tmp[38:13]==tag)begin  
      data_exist =1;
			coh = meta_tmp[1:0];
			data = data_tmp;
			way  = i;
			`uvm_info(get_type_name(),$sformatf("data exist , set=%0h,way=%0h,tag=%0h,coh=%0h,data=%0h",set_index,way,tag,coh,data),UVM_NONE);
			break;
		end
	end
	
	if(!data_exist)begin
    coh = lsu_trans::NOTHING;
		`uvm_info(get_type_name(),$sformatf("data donot exist , set=%0h,tag=%0h",set_index,tag),UVM_NONE);
	end

endtask
	

task dcache_refm::replace_plru(input bit [6:0] set_index,input bit [1:0] coh,input bit [1:0] exist_way,output bit [1:0] victim_way,output bit  victim_way_valid);

  bit [1:0] way_tmp,coh_tmp;
	bit [511:0] data;

	//query_block(set_index, tag, coh_tmp, way_tmp,data )

	if(coh==lsu_trans::NOTHING)begin
		if(replace_q[set_index].size()<4)begin      			 
			 victim_way = 3-replace_q[set_index].size();
       `uvm_info(get_type_name(),$sformatf("replace_q not full, set=%0h, q_size=%0h,way=%0h",set_index,replace_q[set_index].size(),victim_way),UVM_NONE);
			 replace_q[set_index].push_back(victim_way);
			 victim_way_valid = 0;
		end
		else begin
       victim_way = replace_q[set_index].pop_front();
       replace_q[set_index].push_back(victim_way);
			 victim_way_valid = 1;
       `uvm_info(get_type_name(),$sformatf("replace_q replace, set=%0h, q_size=%0h,way=%0h",set_index,replace_q[set_index].size(),victim_way),UVM_NONE); 
		end

	end 
	else begin // update PLRU when hit
		foreach (replace_q[set_index][i])
			if(replace_q[set_index][i] == exist_way)begin
				replace_q[set_index].delete(i);
        replace_q[set_index].push_back(exist_way);
				victim_way_valid = 0;
        `uvm_info(get_type_name(),$sformatf("replace_q refresh, set=%0h, q_size=%0h,way=%0h",set_index,replace_q[set_index].size(),exist_way),UVM_NONE);	
				break;
		  end
	end

  `uvm_info(get_type_name(),$sformatf("replace_q info, set_index=%0h,q_size=%0h,first=%0d,secend=%0d,third=%0d,last=%0d",set_index,replace_q[set_index].size(),replace_q[set_index][0],replace_q[set_index][1],replace_q[set_index][2],replace_q[set_index][3]),UVM_NONE);

	//`uvm_info(get_type_name(),$sformatf("replace_q info, q_size=%0h,replace_q=%p",replace_q[set_index].size(),replace_q),UVM_NONE);


endtask
`endif // DCACHE_REFM_SV


