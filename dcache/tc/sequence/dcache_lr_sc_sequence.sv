
`ifndef _dcache_lr_sc_sequence_SV_
`define _dcache_lr_sc_sequence_SV_

class dcache_lr_sc_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_lr_sc_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_lr_sc_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [511:0] wdata;
		bit [2:0]	size_t;
		bit is_signed;
		string resp_status;
		string init_state;
		int sc_fail_scene;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		sc_fail_scene = vmm_opts::get_int("sc_fail_scene", 0, "sc_fail_scene");
		resp_status = vmm_opts::get_string("resp_status", "hit", "resp_status");
		init_state = vmm_opts::get_string("init_state", "N", "init_state");

		size_t = $urandom_range(2,3);
		if(resp_status == "hit") begin
			length = $urandom_range(50,1000);
		end
		else begin
			length = 1;
		end
		`uvm_info("RANDOM_CFG",$sformatf("length = %0d", length),UVM_LOW);

		success 	= std::randomize(tag_idx_t,set_idx_t) with {
			tag_idx_t inside {['h4_0000:'h3ff_ffff]};
			set_idx_t inside {[0:127]};
			((tag_idx_t<<13)+(set_idx_t<<6)+64*length) inside {['h8000_0000:'h7f_ffff_ffff]};
		};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);

		for(int i=0;i<length;i++)begin
			backdoor_put_data(addr_t+'h40*i,6,{16{'h76543210}}+i);
	  end

		for(int i=0;i<length;i++)begin
			success	= std::randomize(wdata) with {wdata <= (2**512-1);};
			is_signed = $urandom_range(1);

			if(init_state == "B") begin
				dcache_load(addr_t+(2**size_t)*i,size_t,is_signed);
			end
			else if(init_state == "Trunk") begin
				dcache_lr(addr_t+(2**size_t)*i,size_t);
			end
			else if(init_state == "Dirty") begin
				dcache_store(addr_t+(2**size_t)*i,wdata,size_t);
			end
		end
	
		for(int i=0;i<length;i++)begin
			success	= std::randomize(wdata) with {wdata <= (2**512-1);};
			
			if(!sc_fail_scene) begin 	//sc success
				dcache_lr(addr_t+(2**size_t)*i,size_t);
				wait(tb_top.m_lsu_if.io_resp_bits_status[1:0] == 'h0); 	//LR hit
				wait(tb_top.U_GPCDCache.lrscCount[6:0] == (4+2)); 			//lr valid range
				dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);
			end
			else begin 	//sc fail
				case(sc_fail_scene)
					1: begin
						dcache_lr(addr_t+(2**size_t)*i,size_t);
						wait(tb_top.m_lsu_if.io_resp_bits_status[1:0] == 'h0); 	//LR hit
						wait(tb_top.U_GPCDCache.lrscCount[6:0] == (3+2)); 	//lr invalid range
						dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);
					end
					2: begin
						dcache_lr(addr_t+(2**size_t)*i,size_t);
						dcache_load(addr_t+(2**size_t)*i,size_t,1);
						dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);
					end
					3: begin
						dcache_lr(addr_t+(2**size_t)*i,size_t);
						dcache_lr(addr_t+(2**size_t)*i+'h2000,size_t);
						dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);
					end
					4: begin
						dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);
					end
				endcase
			end
		end
  
		for(int i=0;i<length;i++)begin
			dcache_load(addr_t+64*i,,1);
		end

	//add for cov
	dcache_lr('h8000_0000,size_t);
	dcache_sc('h8000_0000,wdata,size_t);
	
	endtask
endclass : dcache_lr_sc_sequence

`endif
