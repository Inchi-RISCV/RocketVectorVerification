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


	`SVT_XVM(analysis_imp_slave_trans_rx)      #(svt_tilelink_slave_transaction,  dcache_refm) tl2rm_tlrx_port;

  lsu_trans lsu_tr_q[$];
	lsu_trans rsp;
  svt_tilelink_master_transaction  tlmst_tr;
  svt_tilelink_slave_transaction   tl_chd_q[$]; 
	bit [1:0] replace_q[128][$];

  bit [5:0] nset;
	bit [1:0] nway;
	bit [512*4-1:0] data_arry[128]; //data 4way 
	bit [32*4-1:0] meta_arry[128]; //20bit tag ,2bit coh ,4way
	bit unfinsh[32]; //0:finish 1:unfinish
  bit tl_unfinsh[8];
  bit tl_source_busy[8];
	bit [31:0] tl_addr[8];

  extern function new(string name, uvm_component parent);
  extern task main_phase(uvm_phase phase);
	extern task addr_align_check(input bit [2:0] size, input bit [31:0] addr);
  extern task get_lsu_port();
	extern task assemble_cmd();
	//extern task send_lsu_rsp();
	extern task query_block(input bit [5:0] set_index, input bit [18:0] tag, output bit[1:0] coh, output bit [1:0] way, output bit [511:0] data );
  extern task send_rsp(input bit [7:0] source ,input bit [4:0] dest , input bit [2:0] status, input bit hasdata,input bit [511:0] data);
  extern task do_acquire(input bit [31:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param);
	//extern task do_release(input bit [31:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param,input bit [511:0] a_data);
	extern task do_refill();
	extern task replace_plru(input bit [5:0] set_index,input bit[1:0] coh, input bit [1:0] exist_way ,output bit [1:0] victim_way);
	extern task update_cache(input bit [5:0] set_index,input bit [18:0] tag,input bit[1:0] coh, input bit [1:0] way ,input bit [511:0] data);

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
    `uvm_info(get_type_name(), {"get lsu_port item\n",tr.sprint}, UVM_HIGH)
		lsu_tr_q.push_back(tr);
	end

endtask

task dcache_refm::do_refill();
  svt_tilelink_slave_transaction tr;
  bit [2:0]   d_opcode;
	bit [511:0] d_data;
	bit [15:0]  d_source;
	bit [1:0]   d_param;
	bit [31:0]  a_addr;

	bit [1:0] coh,coh_tmp;
	bit [1:0] exist_way,victim_way;
	bit [511:0] data;
	bit [127:0] meta_data;
	bit [2047:0] set_data;
  bit [5:0] nset ;
  bit [19:0] ntag ;
  bit [31:0] meta_tmp ;

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

      //wait();

			a_addr = tl_addr[d_source];
			
			tl_source_busy[d_source] = 0;
			tl_unfinsh[d_source] = 0 ;


			`uvm_info(get_type_name(),$sformatf("rm get grant ,a_addr=%0h, d_source=%0h,d_param=%0h,d_opcode=%0h,d_data=%0h",a_addr,d_source,d_param,d_opcode,d_data),UVM_NONE); 

      nset = a_addr[12:6];
			ntag = a_addr[31:13];

			query_block(nset,ntag, coh ,exist_way,data);

			replace_plru(nset,coh,exist_way ,victim_way);

			case (d_param)
        2'h0 : coh_tmp = lsu_trans::DIRTY  ;// toT,cacheline DIRTY
        2'h1 : coh_tmp = lsu_trans::BRANCH ;// toB,cacheline BRANCH
        2'h2 : coh_tmp = lsu_trans::NOTHING;// toN,cacheline NOTHING
			endcase

      //refill&replace
			if(coh == lsu_trans::NOTHING)begin
				update_cache(nset,ntag,coh,victim_way ,data);
				`uvm_info(get_type_name(),$sformatf("replace cache , addr=%0h,set=%0h,tag=%0h,way=%0h,coh=%0h",a_addr,nset,ntag,victim_way,coh_tmp),UVM_NONE);
			end
			else begin
				update_cache(nset,ntag,coh,exist_way ,data);								
		    `uvm_info(get_type_name(),$sformatf("refresh cache , addr=%0h,set=%0h,tag=%0h,way=%0h,coh=%0h",a_addr,nset,ntag,exist_way,coh_tmp),UVM_NONE);
			end


		end

	end


endtask

task dcache_refm::update_cache(input bit [5:0] set_index,input bit [18:0] tag,input bit[1:0] coh, input bit [1:0] way ,input bit [511:0] data);
	
	bit [127:0] meta_data;
	bit [2047:0] set_data;
  bit [31:0] meta_tmp ;

  meta_data = meta_arry[set_index];
  set_data  = data_arry[set_index];

	meta_tmp = {tag,11'h0,coh};

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
	
			
	meta_arry[nset] = meta_data;
	data_arry[nset] = set_data;


endtask

task dcache_refm::addr_align_check(input bit [2:0] size, input bit [31:0] addr);

  bit [5:0] addr_align;
	
  case (size)
    2'h1 : addr_align  = addr[0:0];
    2'h2 : addr_align  = addr[1:0];
    2'h3 : addr_align  = addr[2:0];
    2'h4 : addr_align  = addr[3:0];
    2'h5 : addr_align  = addr[4:0];
    2'h6 : addr_align  = addr[5:0];
  endcase


	if(size >0 )begin
		if(addr_align != 0)begin
      `uvm_error(get_type_name(),$sformatf(" addr illegal ,addr=%0h,size=%0h",addr,size));
		end
  end
  


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
  `uvm_info(get_type_name(), {"send rm2scb rsp item\n",rsp.sprint}, UVM_NONE)

endtask

task dcache_refm::do_acquire(input bit [31:0] a_addr ,input bit [15:0] a_source,input bit [2:0] a_param);

  svt_tilelink_master_transaction   tr_a;
  tr_a = new();

  tr_a.a_size    = 'h6;
  tr_a.a_source  = a_source;
  tr_a.a_address = a_addr;
  tr_a.ch_a_msg_type  = svt_tilelink_master_transaction::CH_A_ACQUIRE_BLOCK;
  tr_a.a_param   = a_param;

	rm2sb_tltx_port.write(tr_a);
	`uvm_info(get_type_name(),$sformatf("rm send acquire to sb , a_addr=%0h,a_source=%0h,a_param=%0h",tr_a.a_address,tr_a.a_address,tr_a.a_param),UVM_NONE);

endtask



task dcache_refm::assemble_cmd();
	bit [511:0] data;
	bit         hit;
	bit [2:0]   coh;
	bit [18:0]  tag;
	bit [1:0]   way;
	bit [2:0]   req_size;
	bit [511:0] req_data;
	bit [63:0]  req_wmask;
	bit [5:0]   req_dest;
	bit         req_noAlloc;
 	bit [31:0]  req_addr;
	bit [7:0]   req_source;
  bit         req_signed;
	bit [15:0]  a_source;
  bit [2:0]   a_param;
	bit same_addr_inprocess;
    
	lsu_trans   req;
	lsu_trans::req_cmd_enum 		req_cmd;
	lsu_trans::resp_status_enum rsp_status;

	req = new();

	
  forever begin
		wait(lsu_tr_q.size()>0); 
		if(lsu_tr_q.size()>0)begin
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

      addr_align_check(req_size,req_addr);

			query_block(nset,tag,coh,way,data);
		
			//Read
			if(req_cmd == lsu_trans::M_XRD || req_cmd == lsu_trans::M_PFR )begin

				//miss
				if(coh == lsu_trans::NOTHING )begin
					rsp_status = lsu_trans::MISS;
          send_rsp(req_source ,req_dest ,rsp_status,0,0);

					a_param =  0;//NtoB

					foreach (tl_source_busy[j])begin
						if(!tl_source_busy[j])begin
              a_source = j;
							tl_source_busy[j]=1;
							break;
						end  
					end

					foreach (tl_addr[j])begin
						if(tl_addr[j][31:6] == req_addr[31:6])
							same_addr_inprocess = 1;
						 `uvm_info(get_type_name(),$sformatf("same addr exist , addr=%0h, same_addr_inprocess=%0h,source=%0h",req_addr,tl_addr[j],j),UVM_NONE);
						  break;
					end
          
					if(!same_addr_inprocess)begin
					  do_acquire(req_addr,a_source,a_param);
					  tl_addr[a_source]    = req_addr;
					  tl_unfinsh[a_source] = 1 ;
					  `uvm_info(get_type_name(),$sformatf("rm tilelink unfinish , addr=%0h,source=%0h",tl_addr[a_source],a_source),UVM_NONE);
						same_addr_inprocess = 0;
				  end
					
				end
				//hit
				else begin
					rsp_status = lsu_trans::HIT;
					send_rsp(req_source ,req_dest ,rsp_status,1,data);
				end                 
			end

			//WRITE
			if(req_cmd == lsu_trans::M_XWR     || req_cmd == lsu_trans::M_PWR    || req_cmd == lsu_trans::M_XSC     || req_cmd == lsu_trans::M_XA_SWAP ||
			   req_cmd == lsu_trans::M_XA_ADD  || req_cmd == lsu_trans::M_XA_XOR || req_cmd == lsu_trans::M_XA_OR   || req_cmd == lsu_trans::M_XA_AND  ||
			   req_cmd == lsu_trans::M_XA_MIN  || req_cmd == lsu_trans::M_XA_MAX || req_cmd == lsu_trans::M_XA_MINU || req_cmd == lsu_trans::M_XA_MAXU )begin

				//miss
				if(coh == lsu_trans::NOTHING || coh == lsu_trans::BRANCH )begin

					send_rsp(req_source ,req_dest ,lsu_trans::MISS,0,0);

					a_param =  (coh == lsu_trans::NOTHING) ? 1 : 2 ;//NOTHING NtoT,BRANCH BtoT

					foreach (tl_source_busy[j])begin
						if(!tl_source_busy[j])begin
              a_source = j;
							tl_source_busy[j]=1;
							break;
						end  
					end

					///a_source = 0;//todo
					do_acquire(req_addr,a_source,a_param);
					
					tl_addr[a_source]    = req_addr;
					tl_unfinsh[a_source] = 1 ;
					`uvm_info(get_type_name(),$sformatf("rm tilelink unfinish , addr=%0h,source=%0h",tl_addr[a_source],a_source),UVM_NONE);									
				end
				else begin
					//rsp_status = lsu_trans::HIT;

					// Branch need inside Cache Upgrade Perm 
					if(coh == lsu_trans::BRANCH)begin
            //todo
  
					end
					send_rsp(req_source ,req_dest , lsu_trans::HIT,1,data);					
				end

			end


		end
  end
endtask


task dcache_refm::query_block(input bit [5:0] set_index, input bit [18:0] tag, output bit[1:0] coh ,output bit [1:0] way,output bit [511:0] data);

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
			`uvm_info(get_type_name(),$sformatf("data exist , set=%0h,tag=%0h,coh=%0h,data=%0h",set_index,tag,coh,data),UVM_NONE);
			break;
		end
	end
	
	if(!data_exist)begin
    coh = lsu_trans::NOTHING;
		`uvm_info(get_type_name(),$sformatf("data donot exist , set=%0h,tag=%0h",set_index,tag),UVM_NONE);
	end

endtask
	

task dcache_refm::replace_plru(input bit [5:0] set_index,input bit [1:0] coh,input bit [1:0] exist_way,output bit [1:0] victim_way);

  bit [1:0] way_tmp,coh_tmp;
	bit [511:0] data;

	//query_block(set_index, tag, coh_tmp, way_tmp,data )

	if(coh==lsu_trans::NOTHING)begin
		if(replace_q[set_index].size()<3)begin
       victim_way = 3-replace_q[set_index].size();
			 replace_q[set_index].push_back(victim_way);
       `uvm_info(get_type_name(),$sformatf("replace_q not full, set=%0h, q_size=%0h,way=%0h",set_index,replace_q[set_index].size(),victim_way),UVM_NONE);
		end
		else begin
       victim_way = replace_q[set_index].pop_front();
       replace_q[set_index].push_back(exist_way);
       `uvm_info(get_type_name(),$sformatf("replace_q replace, set=%0h, q_size=%0h,way=%0h",set_index,replace_q[set_index].size(),victim_way),UVM_NONE); 
			 //do_rerease();//todo

		end

	end 
	else begin // update PLRU when hit
		foreach (replace_q[set_index][i])
			if(replace_q[set_index][i] == exist_way)begin
				replace_q[set_index].delete(i);
        replace_q[set_index].push_back(exist_way);
        `uvm_info(get_type_name(),$sformatf("replace_q refresh, set=%0h, q_size=%0h,way=%0h",set_index,replace_q[set_index].size(),victim_way),UVM_NONE);				
		  end
	end

	


endtask
`endif // DCACHE_REFM_SV


