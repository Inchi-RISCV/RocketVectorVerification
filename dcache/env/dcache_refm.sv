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

class dcache_refm extends uvm_component;
  `uvm_component_utils(dcache_refm)
	uvm_blocking_get_port #(lsu_trans) lsu_port;
  uvm_analysis_port  #(svt_tilelink_master_transaction) rm2sb_tltx_port;
	uvm_analysis_port  #(lsu_trans) rm2sb_rsp_port;
  uvm_analysis_port  #(svt_tilelink_slave_transaction) rm2sb_tlc_port;

	`SVT_XVM(analysis_imp_slave_trans_rx)      #(svt_tilelink_slave_transaction,  dcache_refm) tl2rm_tlrx_port;

  lsu_trans lsu_tr_q[$];
	lsu_trans rsp;
  svt_tilelink_master_transaction  tlmst_tr;
  svt_tilelink_slave_transaction   tl_chd_q[$]; 
	bit [1:0] replace_q[128][$];

  bit [6:0] nset;
	bit [1:0] nway;
	bit [512*4-1:0] data_arry[128]; //data 4way 
	bit [32*4-1:0]  meta_arry[128]; //20bit tag ,2bit coh ,4way
	bit        unfinsh[32]; //0:finish 1:unfinish
  bit        req_unfinsh_arry[8];
  bit        tl_source_id_valid[8] = {1,1,1,1,1,1,1,1};
	bit [31:0] req_addr_arry[8];
  //bit [38:0]  req_source_q[$]; //addr+dest
  bit [51:0] same_addr_info_q[$];   //sign+cmd+addr+source+dest  1+5+32+8+6
	bit [51:0] same_addr_info_tmp_q[$];
	bit [5:0]  req_dest_arry[8];      
	bit [7:0]  req_source_arry[8];
	bit [2:0]  req_size_arry[32];
	bit        req_signed_arry[32];
	bit [2:0]  req_size_store_arry[8];
  bit [63:0] req_mask_arry[8];
	bit [511:0] req_data_arry[8]; 

	lsu_trans::req_cmd_enum 		req_cmd_arry[8];

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);
	extern task addr_data_align(input bit [2:0] size, input bit [31:0] addr,input bit [511:0] data,output [511:0] align_data);
	extern task data_mask_merge(input bit [2:0] size, input bit [31:0] addr,input bit [63:0] mask, input bit [511:0] r_data, input bit [511:0] w_data,output [511:0] data);
  extern task get_lsu_port();
	extern task assemble_cmd();
	extern task query_block(input bit [6:0] set_index, input bit [18:0] tag, output bit[1:0] coh, output bit [1:0] way, output bit [511:0] data );
  extern task send_rsp(input bit [7:0] source ,input bit [4:0] dest , input bit [2:0] status, input bit hasdata,input bit [511:0] data);
  extern task do_acquire(input bit [31:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param);
	extern task do_release(input bit [31:0] c_addr ,input bit [2:0] c_opcode,input bit [15:0] c_source,input bit [2:0] c_param,input bit [511:0] c_data);
	extern task do_refill();
	extern task replace_plru(input bit [6:0] set_index,input bit[1:0] coh, input bit [1:0] exist_way ,output bit [1:0] victim_way,output bit victim_way_valid);
	extern task update_cache(input bit [6:0] set_index,input bit [18:0] tag,input bit[1:0] coh, input bit [1:0] way ,input bit [511:0] data,output bit[1:0] victim_coh,output bit[511:0] victim_data,output bit[31:0] victim_addr);
 	extern task release_source_id(input bit [15:0] source_id);
  extern task sign_extension(input bit [2:0] size,input bit [511:0] data,output bit [511:0] sign_data);

  /**  write for tilelink monitor */
  virtual function void write_slave_trans_rx(svt_tilelink_slave_transaction slave_trans);
    if(slave_trans.status.drive_chnl_A_or_C)begin
   	  tl_chd_q.push_back(slave_trans);
			`uvm_info(get_type_name(), {"get tl2rm_tlrx_port\n",slave_trans.sprint}, UVM_NONE)
	  end

  endfunction : write_slave_trans_rx



endclass : dcache_refm 

function dcache_refm::new(string name, uvm_component parent);

  super.new(name, parent);
	lsu_port = new("lsu_port",this);
	rm2sb_tltx_port = new("rm2sb_tltx_port",this);
  tl2rm_tlrx_port = new("tl2rm_tlrx_port",this);
	rm2sb_rsp_port = new("rm2sb_rsp_port",this);
  rm2sb_tlc_port = new("rm2sb_tlc_port",this);


endfunction : new

task dcache_refm::main_phase(uvm_phase phase);
	super.main_phase(phase);
	fork
		get_lsu_port();
		assemble_cmd();
    do_refill();
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

task dcache_refm::do_refill();
  svt_tilelink_slave_transaction tr;
  bit [2:0]    d_opcode;
	bit [511:0]  d_data,align_data,refill_data,data_vic,update_data;
	bit [15:0]   d_source;
	bit [1:0]    d_param;
	bit [31:0]   a_addr;

	bit [1:0]    coh,coh_tmp,coh_vic;
	bit [1:0]    exist_way,victim_way;
	bit [511:0]  data;
	bit [127:0]  meta_data;
	bit [2047:0] set_data;
  bit [6:0]    nset ;
  bit [18:0]   ntag ;
  bit [31:0]   meta_tmp ;
  bit [7:0]    req_source;
  bit [31:0]   req_addr,addr_vic;	
  bit [5:0]    req_dest,req_dest_tmp;
	bit [4:0]    req_cmd_same_addr,req_cmd;
	bit [2:0]    req_size,req_size_store;
  bit          req_signed;
	bit [511:0]  d_data_arry[];
	bit [31:0]   same_addr_refill_num,tmp_num;
	bit [51:0]   same_addr_info,same_addr_info_tmp;
  bit          victim_way_valid;
  bit [63:0]   req_mask;
	bit [511:0]  req_data,merge_data;


	forever begin
		wait(tl_chd_q.size()>0);
		if(tl_chd_q.size()>0)begin
      tr = tl_chd_q.pop_front();
      //`uvm_info(get_type_name(), {"get tl_chd_q item\n",tr.sprint}, UVM_NONE)
		  d_opcode = tr.ch_d_msg_type;

			for(int i=0;i<256;i++)begin
		    d_data[i*8+:8] = tr.d_data[i];
			end
			
		  d_source = tr.d_source;
		  d_param =  tr.d_param;     
			a_addr = req_addr_arry[d_source];	
      nset = a_addr[12:6];
			ntag = a_addr[31:13];

			`uvm_info(get_type_name(),$sformatf("rm get grant,a_addr=%0h,d_source=%0h,d_param=%0h,d_opcode=%0h,d_data=%0h",a_addr,d_source,d_param,d_opcode,d_data),UVM_NONE); 


      // waiting source_id release
			fork
				release_source_id(d_source);
			join_none
			


			wait(tb_top.U_GPCDCache.mainReqArb.io_out_valid && tb_top.U_GPCDCache.mainReqArb.io_out_bits_isRefill && (tb_top.U_GPCDCache.mainReqArb.io_out_bits_paddr[31:6] == a_addr[31:6]));
			
			query_block(nset,ntag, coh ,exist_way,data);
			replace_plru(nset,coh,exist_way ,victim_way,victim_way_valid);

			case (d_param)
        2'h0 : coh_tmp = lsu_trans::DIRTY  ;// toT,cacheline DIRTY
        2'h1 : coh_tmp = lsu_trans::BRANCH ;// toB,cacheline BRANCH
        2'h2 : coh_tmp = lsu_trans::NOTHING;// toN,cacheline NOTHING
			endcase


			if(req_cmd_arry[d_source] == lsu_trans::M_XRD || req_cmd_arry[d_source] == lsu_trans::M_PFR)begin

        // refill rsp sent to scb
		    req_dest_tmp = req_dest_arry[d_source];
		    req_size = req_size_arry[req_dest_tmp];
		    addr_data_align(req_size,a_addr,d_data,align_data);
				update_data = d_data;

				//sign_extension
		    if(req_cmd_arry[d_source] == lsu_trans::M_XRD)begin
		    	sign_extension(req_size,align_data,refill_data);
		      send_rsp(req_source_arry[d_source] ,req_dest_arry[d_source] , lsu_trans::REFILL,1,refill_data);
		      `uvm_info(get_type_name(),$sformatf("rm send refill resp,req_dest=%0h,req_addr=%0h,req_source=%0h,data=%0h",req_dest_arry[d_source],a_addr,req_source_arry[d_source],refill_data),UVM_NONE);
		    end

				//same_addr_refill
		    same_addr_refill_num = same_addr_info_q.size();
		    if(same_addr_refill_num>0)begin
		      for(int i=0 ;i<same_addr_refill_num;i++)begin
            same_addr_info = same_addr_info_q.pop_front();
		    		
            req_dest = same_addr_info[5:0];
            req_source = same_addr_info[13:6];
		    		req_cmd_same_addr = same_addr_info[50:46];
		    		req_signed = same_addr_info[51:51];
		    		req_addr  = same_addr_info[45:14];
		    		`uvm_info(get_type_name(),$sformatf("rm get same addr info ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_refill_num),UVM_NONE);
		    		if(req_addr[31:6] == a_addr[31:6])begin 
  	    			addr_data_align(req_size_arry[req_dest],req_addr,d_data,align_data);
		    			sign_extension(req_size,align_data,refill_data);

		    			if(req_cmd_arry[d_source] == lsu_trans::M_XRD)begin
		            send_rsp(req_source ,req_dest , lsu_trans::REFILL,1,refill_data);
		      	    `uvm_info(get_type_name(),$sformatf("rm send same addr refill resp ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_refill_num),UVM_NONE);
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
		    		req_cmd_same_addr =    same_addr_info_tmp[50:46];
		    		req_signed = same_addr_info_tmp[51:51];
		    		req_addr  =  same_addr_info_tmp[45:14];
		    		`uvm_info(get_type_name(),$sformatf("push back same addr info ,req_dest=%0h, req_source=%0h,data=%0h,same_addr_refill_num=%0h",req_dest,req_source,refill_data,same_addr_info_tmp_q.size()),UVM_NONE);  
             
		    	end
		    end
			end//end M_XRD
			else if(req_cmd_arry[d_source] == lsu_trans::M_XWR || req_cmd_arry[d_source] == lsu_trans::M_PWR || req_cmd_arry[d_source] == lsu_trans::M_XSC)begin
					req_size_store = req_size_store_arry[d_source];
				  req_mask       = req_mask_arry[d_source];
          req_data       = req_data_arry[d_source];
				  data_mask_merge(req_size_store, a_addr,req_mask, d_data,req_data,update_data);													
					replace_plru(nset,coh,exist_way,victim_way,victim_way_valid);
					//update_cache(nset,tag,lsu_trans::DIRTY,exist_way ,update_data,coh_vic,data_vic,addr_vic);
					`uvm_info(get_type_name(),$sformatf("store miss merge data,a_addr=%0h,req_cmd=%0h,req_size=%0h,way=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",a_addr,req_cmd_arry[d_source],req_size_store,exist_way,req_mask,d_data,req_data,update_data),UVM_NONE);

			end

      //refill&replace
		  if(coh == lsu_trans::NOTHING)begin
		  	update_cache(nset,ntag,coh_tmp,victim_way,update_data,coh_vic,data_vic,addr_vic);
		  	`uvm_info(get_type_name(),$sformatf("replace cache , addr=%0h,set=%0h,tag=%0h,way=%0h,coh=%0h",a_addr,nset,ntag,victim_way,coh_tmp),UVM_NONE);
		  end
		  else begin
		  	update_cache(nset,ntag,coh_tmp,exist_way,update_data,coh_vic,data_vic,addr_vic);								
		    `uvm_info(get_type_name(),$sformatf("refresh cache , addr=%0h,set=%0h,tag=%0h,way=%0h,coh=%0h",a_addr,nset,ntag,exist_way,coh_tmp),UVM_NONE);
		  end

      if(victim_way_valid)begin
        if(coh_vic == lsu_trans::DIRTY)begin  //release_data  TtoN
          do_release(addr_vic,7,8,1,data_vic);       
		    end
		    else begin//release BtoN
		  	  do_release(addr_vic,6,8,2,data_vic);       
		    end
		  end
      //clear info for source index
		  req_addr_arry[d_source]  = 0;
		  req_source_arry[d_source]= 0;
		  req_dest_arry[d_source]  = 0;			
		end//end tl_chd_q

	end//end forever


endtask


task dcache_refm::update_cache(input bit [6:0] set_index,input bit [18:0] tag,input bit[1:0] coh, input bit [1:0] way ,input bit [511:0] data,output bit[1:0] victim_coh,output bit[511:0] victim_data,output bit[31:0] victim_addr);
	
	bit [127:0] meta_data;
	bit [2047:0] set_data;
  bit [31:0] meta_tmp ;
	bit [31:0] meta_victim_tmp ;


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
    2'h0 : meta_victim_tmp = meta_data[31:0]  ;
		2'h1 : meta_victim_tmp = meta_data[63:32] ;
		2'h2 : meta_victim_tmp = meta_data[95:64] ;
		2'h3 : meta_victim_tmp = meta_data[127:96];	
	endcase
	
	case (way)
    2'h0 : set_data[511:0]    =data;
		2'h1 : set_data[1023:512] =data;
		2'h2 : set_data[1535:1024]=data;
		2'h3 : set_data[2047:1536]=data;
	endcase

	case (way)
    2'h0 : meta_data[31:0]  =meta_tmp;
		2'h1 : meta_data[63:32] =meta_tmp;
		2'h2 : meta_data[95:64] =meta_tmp;
		2'h3 : meta_data[127:96]=meta_tmp;	
	endcase
	
			
	meta_arry[set_index] = meta_data;
	data_arry[set_index] = set_data;


	victim_coh  = meta_victim_tmp[1:0];
	victim_addr = {meta_victim_tmp[31:13],set_index,6'h0};


	`uvm_info(get_type_name(),$sformatf("update cache ,set=%0h,tag=%0h,way=%0h,coh=%0h,data=%0h,victim_addr=%0h,victim_coh=%0h,victim_data=%0h",set_index,tag,way,coh,data,victim_addr,victim_coh,victim_data),UVM_NONE)


endtask

task dcache_refm::addr_data_align(input bit [2:0] size, input bit [31:0] addr,input bit [511:0] data,output [511:0] align_data);

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


task dcache_refm::data_mask_merge(input bit [2:0] size, input bit [31:0] addr,input bit [63:0] mask, input bit [511:0] r_data, input bit [511:0] w_data,output [511:0] data);

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

  if(size == 6)begin
		wdata_tmp  =  w_data;
	end
	else begin
    wdata_tmp  =  w_data >> (addr[5:0]*8);
	end
  wdata_tmp = valid_bits & wdata_tmp;


  valid_bits  =  valid_bits << (addr[5:0]*8);
	data_tmp  =  wdata_tmp << (addr[5:0]*8);

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

  `uvm_info(get_type_name(),$sformatf("data merge ,addr=%0h,size=%0h,mask=%0h,valid_bits=%0h,wdata_tmp=%0h,data_tmp=%0h",addr,size,mask,valid_bits,wdata_tmp,data_tmp),UVM_NONE)

endtask

task dcache_refm::sign_extension(input bit [2:0] size,input bit [511:0] data,output bit [511:0] sign_data);

  case (size)
		3'h0 : sign_data = data[7:7]     ? {{504{1'b1}},data[7:0]}   : data;
		3'h1 : sign_data = data[15:15]   ? {{496{1'b1}},data[15:0]}  : data;
    3'h2 : sign_data = data[31:31]   ? {{480{1'b1}},data[31:0]}  : data;
    3'h3 : sign_data = data[63:63]   ? {{448{1'b1}},data[63:0]}  : data;
    3'h4 : sign_data = data[127:127] ? {{384{1'b1}},data[127:0]} : data;
    3'h5 : sign_data = data[255:255] ? {{256{1'b1}},data[255:0]} : data;
    3'h6 : sign_data = data;
  endcase

  `uvm_info(get_type_name(),$sformatf("sign_extension ,size=%0h,origin_data=%0h,sign_data=%0h",size,data,sign_data),UVM_NONE)


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

task dcache_refm::do_acquire(input bit [31:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param);

  svt_tilelink_master_transaction   tr_a;

  tr_a = new();
  tr_a.a_size    = 'h6;
  tr_a.a_source  = a_source;
  tr_a.a_address = {a_addr[31:6],6'h0};
  tr_a.ch_a_msg_type  = svt_tilelink_master_transaction::CH_A_ACQUIRE_BLOCK;
  tr_a.a_param   = a_param;

	rm2sb_tltx_port.write(tr_a);
	`uvm_info(get_type_name(),$sformatf("rm send acquire to sb , a_addr=%0h,a_source=%0h,a_param=%0h",tr_a.a_address,tr_a.a_source,tr_a.a_param),UVM_NONE);

endtask


task dcache_refm::do_release(input bit [31:0] c_addr ,input bit [2:0] c_opcode,input bit [15:0] c_source,input bit [2:0] c_param,input bit [511:0] c_data);
   
	svt_tilelink_slave_transaction   tr_c;

  tr_c = new();
	tr_c.status = new();

  tr_c.status.c_size         = 'h6;
  tr_c.status.c_source       = c_source;
  tr_c.status.c_address      = {c_addr[31:6],6'h0};
  tr_c.status.ch_c_msg_type  = c_opcode;
  tr_c.status.c_param        = c_param;

	for(int i=0;i<256;i++)begin
		tr_c.status.c_data[i] = c_data[i*8+:8];
  end

	rm2sb_tlc_port.write(tr_c);
	`uvm_info(get_type_name(),$sformatf("rm send release to sb,c_addr=%0h,c_opcode=%0h,c_source=%0h,c_param=%0h",tr_c.status.c_address,tr_c.status.ch_c_msg_type,tr_c.status.c_source,tr_c.status.c_param),UVM_NONE);



endtask



task dcache_refm::release_source_id(input bit [15:0] source_id); 
  
	

	case(source_id)
    0: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_0_valid);
    1: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_1_valid);
    2: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_2_valid);
    3: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_3_valid);
    4: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_4_valid);
    5: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_5_valid);
    6: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_6_valid);
    7: wait(tb_top.U_GPCDCache.mshrs.mshrs.allocateArb.io_in_7_valid);
  endcase

	tl_source_id_valid[source_id] = 1;
  `uvm_info(get_type_name(),$sformatf("release_source_id , source_id=%0h",source_id),UVM_NONE);
	`uvm_info(get_type_name(),$sformatf("release_source_id tl_source_id_valid=%p", tl_source_id_valid),UVM_NONE);



endtask

task dcache_refm::assemble_cmd();
	bit [511:0] data,data_vic;
	bit         hit;
	bit [2:0]   coh,coh_vic;
	bit [18:0]  tag;
	bit [1:0]   way,victim_way;
	bit [2:0]   req_size;
	bit [511:0] req_data;
	bit [63:0]  req_wmask,mask;
	bit [5:0]   req_dest;
	bit         req_noAlloc;
 	bit [31:0]  req_addr,addr_vic;
	bit [7:0]   req_source;
  bit         req_signed;
	bit [15:0]  a_source;
  bit [2:0]   a_param;
  bit [51:0]  same_addr_info,same_addr_info_tmp;
	bit         same_addr_exist;
	bit [511:0] align_data,refill_data,merge_data;
	bit         victim_way_valid;

    
	lsu_trans   req;
	lsu_trans::req_cmd_enum 		req_cmd;
	lsu_trans::resp_status_enum rsp_status;

	req = new();

	
  forever begin
    //`uvm_info(get_type_name(),$sformatf("lsu_tr_q size=%0h",lsu_tr_q.size()),UVM_NONE);
		wait(lsu_tr_q.size()>0); 
		if(lsu_tr_q.size()>0 )begin
			req = lsu_tr_q.pop_front();
			req_cmd    = req.io_req_bits_cmd;
		  req_data   = req.io_req_bits_wdata;
		  req_wmask  = req.io_req_bits_wmask;
		  req_noAlloc= req.io_req_bits_noAlloc;
		  req_dest   = req.io_req_bits_dest;
		  req_size   = req.io_req_bits_size;
			req_addr   = req.io_req_bits_paddr;
			req_source = req.io_req_bits_source;
			req_signed = req.io_req_bits_signed;
      
			tag  = req_addr[31:13];
      nset = req_addr[12:6];

		      
		  `uvm_info(get_type_name(),$sformatf("rm get cmd , rea_addr=%0h,set=%0h,req_cmd=%0h,req_dest=%0h,req_size=%0h",req_addr,nset,req_cmd,req_dest,req_size),UVM_NONE);
			`uvm_info(get_type_name(),$sformatf("processing addr=%p", req_addr_arry),UVM_NONE);
      `uvm_info(get_type_name(),$sformatf("tl_source_id_valid=%p", tl_source_id_valid),UVM_NONE);
     	req_size_arry[req_dest] = req_size;
			req_signed_arry[req_dest] = req_signed;

			query_block(nset,tag,coh,way,data);

			addr_data_align(req_size,req_addr,data,align_data);


	    same_addr_exist= 0;

			//Read
			if(req_cmd == lsu_trans::M_XRD || req_cmd == lsu_trans::M_PFR )begin

				//miss
				if(coh == lsu_trans::NOTHING )begin
					rsp_status = lsu_trans::MISS;
          send_rsp(req_source ,req_dest ,rsp_status,0,0);


          //check if same addr req exist
		      foreach (req_addr_arry[j])begin
		      	if(req_addr_arry[j][31:6] == req_addr[31:6])begin
				   	//load miss need refill resp
					  //req_source_q.push_back(req_source);
            same_addr_info = {req_signed,req_cmd,req_addr,req_source,req_dest};
            same_addr_info_q.push_back(same_addr_info);
					  `uvm_info(get_type_name(),$sformatf("load same addr,waiting for refill resp,addr=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,rsp_num=%0h,a_source=%0h",req_addr,req_cmd,req_dest,req_source,same_addr_info_q.size(),j),UVM_NONE);
						same_addr_exist = 1;;
						break;
		      	end	
		      end
          


          if(same_addr_exist)begin
						continue;
					end
					else begin
						//get valid sour_id
						wait (tl_source_id_valid.or >0);
					  foreach (tl_source_id_valid[j])begin
						  if(tl_source_id_valid[j])begin
                a_source = j;
							  tl_source_id_valid[j]=0;
							  break;
						  end  
				  	end
					  do_acquire(req_addr,a_source,0);//NtoB
					  req_addr_arry[a_source]  = req_addr;
					  req_dest_arry[a_source]  = req_dest;
				    req_source_arry[a_source]  = req_source;
						req_cmd_arry[a_source]  = req_cmd;
					  `uvm_info(get_type_name(),$sformatf("rm load processing,a_source=%0h, req_addr=%0h,req_dest=%0h,req_cmd=%0h",a_source,req_addr_arry[a_source],req_dest_arry[a_source],req_cmd_arry[a_source]),UVM_NONE);
					end
									
				end
				//hit
				else begin
					rsp_status = lsu_trans::HIT;
					sign_extension(req_size,align_data,refill_data);
					send_rsp(req_source ,req_dest ,rsp_status,1,refill_data);
					replace_plru(nset,coh,way,victim_way,victim_way_valid);
				end                 
			end

			//WRITE
			if(req_cmd == lsu_trans::M_XWR || req_cmd == lsu_trans::M_PWR || req_cmd == lsu_trans::M_XSC)begin

				//M_PWR size must 6  M_XWR not support mask
        mask = (req_cmd == lsu_trans::M_PWR) ? req_wmask : 0 ;
				//miss
				if(coh == lsu_trans::NOTHING || coh == lsu_trans::BRANCH )begin

					send_rsp(req_source ,req_dest ,lsu_trans::MISS,0,0);

	        //check if same addr req exist
		      foreach (req_addr_arry[j])begin
		      	if(req_addr_arry[j][31:6] == req_addr[31:6])begin
					  `uvm_info(get_type_name(),$sformatf("store has same addr load,addr=%0h,req_cmd=%0h,req_dest=%0h,req_source=%0h,a_source=%0h",req_addr,req_cmd,req_dest,req_source,j),UVM_NONE);
						same_addr_exist = 1;
						break;
		      	end	
		      end
          
          if(same_addr_exist)begin
						continue;
					end
					else begin
						wait (tl_source_id_valid.or >0);
					  foreach (tl_source_id_valid[j])begin
						  if(tl_source_id_valid[j])begin
                a_source = j;
							  tl_source_id_valid[j]=0;
							  break;
						  end  
					  end

            a_param =  (coh == lsu_trans::NOTHING) ? 1 : 2 ;//NOTHING NtoT,BRANCH BtoT
				    do_acquire(req_addr,a_source,a_param);
            req_addr_arry[a_source]  = req_addr;
						req_cmd_arry[a_source]        = req_cmd;
						req_size_store_arry[a_source] = req_size;
						req_mask_arry[a_source]       = mask;
            req_data_arry[a_source]       = req_data;

						`uvm_info(get_type_name(),$sformatf("rm store processing , req_addr=%0h,source=%0h,req_cmd=%0h,req_size=%0h,req_mask=%0h,req_data=%0h",req_addr_arry[a_source],a_source,req_cmd_arry[a_source],req_size_store_arry[a_source],req_mask_arry[a_source],req_data_arry[a_source]),UVM_NONE);		
					end
										
				end
				else begin
					// Trunk need inside Cache Upgrade Perm 
					data_mask_merge(req_size, req_addr,mask, data,req_data,merge_data);													
					replace_plru(nset,coh,way,victim_way,victim_way_valid);
					update_cache(nset,tag,lsu_trans::DIRTY,way ,merge_data,coh_vic,data_vic,addr_vic);
					send_rsp(req_source ,req_dest , lsu_trans::HIT,0,merge_data);

					`uvm_info(get_type_name(),$sformatf("store hit merge data,req_addr=%0h,req_cmd=%0h,req_size=%0h,way=%0h,req_mask=%0h,\nsource_data=%0h,\nw_data=%0h,\nmerge_data=%0h",req_addr,req_cmd,req_size,way,req_wmask,data,req_data,merge_data),UVM_NONE);
				end

			end


		end
  end
endtask


task dcache_refm::query_block(input bit [6:0] set_index, input bit [18:0] tag, output bit[1:0] coh ,output bit [1:0] way,output bit [511:0] data);

	bit [127:0] meta_data;
	bit [31:0] meta_tmp;
	bit [2047:0] set_data;
	bit [511:0] data_tmp;
	bit data_exist;

  data_exist = 0;
  meta_data = meta_arry[set_index];
  set_data  = data_arry[set_index];
  for(int i=0;i<4;i++)begin
    meta_tmp = meta_data[i*32+:32];
    data_tmp = set_data[i*512+:512];
    if(meta_tmp[31:13]==tag)begin  
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

	


endtask
`endif // DCACHE_REFM_SV


