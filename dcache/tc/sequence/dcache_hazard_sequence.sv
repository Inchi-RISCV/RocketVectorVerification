
`ifndef _dcache_hazard_sequence_SV_
`define _dcache_hazard_sequence_SV_

class dcache_hazard_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_hazard_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_hazard_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length1, length2;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [511:0] wdata;
		bit [4:0] cmd, cmd1, cmd2;
		string resp_status;
		string init_state;
		bit random_hazard;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)
		
		cmd1 = vmm_opts::get_int("cmd1", 0, "cmd1");
		cmd2 = vmm_opts::get_int("cmd2", 0, "cmd2");
		random_hazard = vmm_opts::get_int("random_hazard", 0, "random_hazard");
		resp_status = vmm_opts::get_string("resp_status", "hit", "resp_status");
		init_state = vmm_opts::get_string("init_state", "N", "init_state");

		if(resp_status == "hit") begin
			length1 			= 50;
		end
		else if(resp_status == "miss") begin
			length1 			= 1;
		end
		length2 			= $urandom_range(50, 500);
		
		success 	= std::randomize(tag_idx_t,set_idx_t) with {
			tag_idx_t inside {['h4_0000:'h7_ffff]};
			set_idx_t inside {[0:127]};
			((tag_idx_t<<13)+(set_idx_t<<6)+64*(length1+length2)) inside {['h8000_0000:'hffff_ffff]};
		};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);
		

		cmd 	= $urandom_range(1);
		success	= std::randomize(wdata) with {wdata <= (2**512-1);};
		backdoor_put_data(addr_t,6,{16{'haaaa_0000}});
		
		if(random_hazard) begin
			for(int i=0;i<length2;i++)begin
				cmd 	= $urandom_range(1);
				if(cmd == 0) begin
					dcache_load(addr_t);
				end
				else if(cmd == 1) begin
					dcache_store(addr_t,wdata);
				end
			end
		end 
		else begin			
			if(init_state == "T") begin
				dcache_store(addr_t,wdata);
			end

			for(int i=0;i<length1;i++)begin
				if(cmd1 == 0) begin 	//LOAD
					dcache_load(addr_t);
				end
				else if(cmd1 == 1) begin	//STORE
					dcache_store(addr_t,wdata);
				end
				else if(cmd1 == 2) begin	//PFR
					dcache_prefetch_read(addr_t);
				end
				else if(cmd1 == 3) begin	//PFW
					dcache_prefetch_write(addr_t);
				end
			end

			for(int i=0;i<length2;i++)begin
				if(cmd2 == 0) begin 	//LOAD
					dcache_load(addr_t);
				end
				else if(cmd2 == 1) begin	//STORE
					dcache_store(addr_t,wdata);
				end
				else if(cmd2 == 2) begin	//PFR
					dcache_prefetch_read(addr_t);
				end
				else if(cmd2 == 3) begin	//PFW
					dcache_prefetch_write(addr_t);
				end
			end
		end	
  endtask
endclass : dcache_hazard_sequence

`endif
