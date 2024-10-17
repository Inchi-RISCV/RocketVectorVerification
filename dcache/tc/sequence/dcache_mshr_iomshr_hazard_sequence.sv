
`ifndef _dcache_mshr_iomshr_hazard_sequence_SV_
`define _dcache_mshr_iomshr_hazard_sequence_SV_

class dcache_mshr_iomshr_hazard_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_mshr_iomshr_hazard_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_mshr_iomshr_hazard_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length1, length2;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [2:0]	size_t;
		bit [63:0] 	req_wmask;
		bit [511:0] wdata;
		bit [4:0] cmd1, cmd2;
		bit [4:0] cmd_1, cmd_2;
		bit [4:0] amo_cmd, bypass_cmd;
		string resp_status;
		string init_state;
		bit random_hazard;
		bit delay_en;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)
		
		cmd1 = vmm_opts::get_int("cmd1", 0, "cmd1");
		cmd2 = vmm_opts::get_int("cmd2", 0, "cmd2");
		random_hazard = vmm_opts::get_int("random_hazard", 0, "random_hazard");
		resp_status = vmm_opts::get_string("resp_status", "hit", "resp_status");
		init_state = vmm_opts::get_string("init_state", "N", "init_state");

		if((resp_status == "hit")&&((cmd1 == 0)||(cmd1 == 1))) begin
			length1 = 20;
		end
		else begin
			length1 = 1;
		end
		length2 	= $urandom_range(50, 500);
		success 	= std::randomize(tag_idx_t,set_idx_t) with {
			tag_idx_t inside {['h4_0000:'h7_ffff]};
			set_idx_t inside {[0:127]};
			((tag_idx_t<<13)+(set_idx_t<<6)+64*(length1+length2)) inside {['h8000_0000:'hffff_ffff]};
		};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);
		
		backdoor_put_data(addr_t,6,{16{'haaaa_0000}});
		
		if(random_hazard) begin
			for(int i=0;i<length2;i++)begin
				cmd_1 		= $urandom_range(1);
				cmd_2 		= $urandom_range(4);
				size_t 		= $urandom_range(2,3);
				delay_en	= $urandom_range(1);
				success 	= std::randomize(amo_cmd) with {amo_cmd inside {5'b00100, 5'b01000, 5'b01001, 5'b01010, 5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111};};
				success		= std::randomize(wdata) with {wdata <= (2**512-1);};
				success 	= std::randomize (req_wmask) with {req_wmask <= (2**(2**6))-1;};
				
				fork
					begin
						if(delay_en) #1;

						if(cmd_1 == 0) begin
							dcache_load(addr_t+'h40*i);
						end
						else if(cmd_1 == 1) begin
							dcache_store(addr_t+'h40*i,wdata);
						end
					end

					begin
						if(cmd_2 == 0) begin
							dcache_amo_operation(amo_cmd,addr_t+'h40*i,wdata,size_t);
						end
						else if(cmd_2 == 1) begin
							dcache_load(addr_t+'h40*i,,,1);
						end
						else if(cmd_2 == 2) begin
							dcache_store(addr_t+'h40*i,wdata,,1);
						end
						else if(cmd_2 == 3) begin
							dcache_partial_mask_store(addr_t+'h40*i,wdata,req_wmask,1);
						end
						else if(cmd_2 == 4) begin
							dcache_amo_operation(amo_cmd,addr_t+'h40*i,wdata,size_t,1);
						end
					end
				join
			end	
		end 
		else begin		
			for(int i=0;i<20;i++)begin
				if(init_state == "T") begin
					dcache_store(addr_t,0);
				end
				else if(init_state == "B") begin
					dcache_load(addr_t);
				end
			end

			for(int i=0;i<length1;i++)begin
				size_t 	= $urandom_range(2,3);
				success = std::randomize(amo_cmd) with {amo_cmd inside {5'b00100, 5'b01000, 5'b01001, 5'b01010, 5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111};};
				success	= std::randomize(wdata) with {wdata <= (2**512-1);};
				success = std::randomize (req_wmask) with {req_wmask <= (2**(2**6))-1;};

				if(cmd1 == 0) begin 	//LOAD
					dcache_load(addr_t);
				end
				else if(cmd1 == 1) begin	//STORE
					dcache_store(addr_t,wdata);
				end
				else if(cmd1 == 2) begin	//AMO
					dcache_amo_operation(amo_cmd,addr_t,wdata,size_t);
				end
				else if(cmd1 == 3) begin	//BYPASS
					bypass_cmd = $urandom_range(3);

					if(bypass_cmd == 0) begin
						dcache_load(addr_t,,,1);
					end
					else if(bypass_cmd == 1) begin
						dcache_store(addr_t,wdata,,1);
					end
					else if(bypass_cmd == 2) begin
						dcache_partial_mask_store(addr_t,wdata,req_wmask,1);
					end
					else if(bypass_cmd == 3) begin
						dcache_amo_operation(amo_cmd,addr_t,wdata,size_t,1);
					end
				end
			end

			for(int i=0;i<length2;i++)begin
				size_t 		= $urandom_range(2,3);
				success 	= std::randomize(amo_cmd) with {amo_cmd inside {5'b00100, 5'b01000, 5'b01001, 5'b01010, 5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111};};
				success	= std::randomize(wdata) with {wdata <= (2**512-1);};
				success = std::randomize (req_wmask) with {req_wmask <= (2**(2**6))-1;};

				if(cmd2 == 0) begin 	//LOAD
					dcache_load(addr_t);
				end
				else if(cmd2 == 1) begin	//STORE
					dcache_store(addr_t,wdata);
				end
				else if(cmd2 == 2) begin	//AMO
					dcache_amo_operation(amo_cmd,addr_t,wdata,size_t);
				end
				else if(cmd2 == 3) begin	//BYPASS
					bypass_cmd = $urandom_range(3);

					if(bypass_cmd == 0) begin
						dcache_load(addr_t,,,1);
					end
					else if(bypass_cmd == 1) begin
						dcache_store(addr_t,wdata,,1);
					end
					else if(bypass_cmd == 2) begin
						dcache_partial_mask_store(addr_t,wdata,req_wmask,1);
					end
					else if(bypass_cmd == 3) begin
						dcache_amo_operation(amo_cmd,addr_t,wdata,size_t,1);
					end
				end
			end
		end	
  endtask
endclass : dcache_mshr_iomshr_hazard_sequence

`endif
