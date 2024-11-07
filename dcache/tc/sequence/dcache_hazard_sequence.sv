
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
		bit [2:0] size_t;
		bit is_signed;
		bit [63:0]  wmask;
		bit [2:0]	size_t;
		bit [4:0] cmd, cmd1, cmd2;
		string resp_status;
		string init_state;
		bit random_hazard;
		bit write_cmd_random;
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
		else begin 	//miss or lr
			length1 			= 1;
		end
		length2 			= $urandom_range(50, 500);
		
		success 	= std::randomize(tag_idx_t,set_idx_t) with {
			tag_idx_t inside {['h4_0000:'h7_ffff]};
			set_idx_t inside {[0:127]};
			((tag_idx_t<<13)+(set_idx_t<<6)+64*(length1+length2)) inside {['h8000_0000:'hffff_ffff]};
		};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);
		
		backdoor_put_data(addr_t,6,{16{'haaaa_0000}});
		
		write_cmd_random 	= $urandom_range(1);

		if(random_hazard) begin
			for(int i=0;i<length2;i++)begin
				cmd 	= $urandom_range(1);
				size_t = $urandom_range(6);
				is_signed = $urandom_range(1);
				success = std::randomize(wdata) with { wdata <= (2**512-1);};
				success = std::randomize (wmask) with {wmask <= (2**(2**6))-1;};
				
				if(cmd == 0) begin
					dcache_load(addr_t,size_t,is_signed);
				end
				else if(cmd == 1) begin
					if(!write_cmd_random) begin
						dcache_store(addr_t,wdata,size_t);
					end
					else begin
						dcache_partial_mask_store(addr_t,wdata,wmask);
					end
				end
			end
			dcache_load(addr_t,,1);
		end 
		else begin			
			if(init_state == "T") begin
				size_t = $urandom_range(6);
				dcache_store(addr_t,wdata,size_t);
			end

			for(int i=0;i<length1;i++)begin
				size_t = $urandom_range(6);
				is_signed = $urandom_range(1);

				if(cmd1 == 0) begin 	//LOAD
					dcache_load(addr_t,size_t,is_signed);
				end
				else if(cmd1 == 1) begin	//STORE/Partial_Masked_Store
					success = std::randomize(wdata) with { wdata <= (2**512-1);};
					success = std::randomize (wmask) with {wmask <= (2**(2**6))-1;};
					
					if(!write_cmd_random) begin
						dcache_store(addr_t,wdata,size_t);
					end
					else begin
						dcache_partial_mask_store(addr_t,wdata,wmask);
					end
				end
				else if(cmd1 == 2) begin	//PFR
					dcache_prefetch_read(addr_t);
				end
				else if(cmd1 == 3) begin	//PFW
					dcache_prefetch_write(addr_t);
				end
				else if(cmd1 == 4) begin	//LR
					size_t = $urandom_range(2,3);
					dcache_lr(addr_t,size_t);
				end
			end

			for(int i=0;i<length2;i++)begin
				size_t = $urandom_range(6);
				is_signed = $urandom_range(1);

				if(cmd2 == 0) begin 	//LOAD
					dcache_load(addr_t,size_t,is_signed);
				end
				else if(cmd2 == 1) begin	//STORE/Partial_Masked_Store
					success = std::randomize(wdata) with { wdata <= (2**512-1);};
					success = std::randomize (wmask) with {wmask <= (2**(2**6))-1;};
					
					if(!write_cmd_random) begin
						dcache_store(addr_t,wdata,size_t);
					end
					else begin
						dcache_partial_mask_store(addr_t,wdata,wmask);
					end
				end
				else if(cmd2 == 2) begin	//PFR
					dcache_prefetch_read(addr_t);
				end
				else if(cmd2 == 3) begin	//PFW
					dcache_prefetch_write(addr_t);
				end
				else if(cmd2 == 4) begin	//LR
					size_t = $urandom_range(2,3);
					dcache_lr(addr_t,size_t);
				end
				else if(cmd2 == 5) begin	//SC
					size_t = $urandom_range(2,3);
					success = std::randomize(wdata) with { wdata <= (2**512-1);};
					dcache_sc(addr_t,wdata,size_t);
				end
			end
		end	
		dcache_load(addr_t,,1);
  endtask
endclass : dcache_hazard_sequence

`endif
