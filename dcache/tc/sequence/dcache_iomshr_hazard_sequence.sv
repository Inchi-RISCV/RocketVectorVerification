`ifndef _dcache_iomshr_hazard_sequence_SV_
`define _dcache_iomshr_hazard_sequence_SV_

class dcache_iomshr_hazard_sequence extends dcache_base_sequence;
	`uvm_object_utils(dcache_iomshr_hazard_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_iomshr_hazard_sequence");
		super.new(name);
	endfunction

	virtual task body();
		bit [38:0]      addr_t;
		bit [26:0]      tag_idx_t;
		bit [6:0]       set_idx_t;
		bit [4:0]       req_cmd;
		bit [4:0]       amo_cmd[];  
		bit [2:0]       req_size_t;
		bit [511:0]     wdata;
		bit [63:0]      wmask;
		bit [4:0]       cmd;
		bit             success;
		bit             is_mmio_range;
		bit [31:0]      length;

		super.body();
		`uvm_info(get_type_name(),"dcache sequence starting",UVM_NONE)

		is_mmio_range = vmm_opts::get_int("is_mmio_range",0,"is_mmio_range");
		`uvm_info("RANDOM_CFG",$sformatf("is_mmio_range = %0d",is_mmio_range),UVM_LOW);

		length 			= $urandom_range(50, 500);
		req_size_t 	= $urandom_range(2,3);

		if(is_mmio_range) begin
			success = std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h3_0000:'h3_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+64*length) inside {['h6000_0000:'h7fff_ffff]};
			};
		end
		else begin
			success = std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h4_0000:'h7_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+64*length) inside {['h8000_0000:'hffff_ffff]};
			};
		end

		//AMO:SWAP(4),ADD(8),XOR(9),OR(a),AND(b),MIN(c),MAX(d),MINU(e),MAXU(f)
		amo_cmd = '{5'b00100,5'b01000,5'b01001,5'b01010,5'b01011,5'b01100,5'b01101,5'b01110,5'b01111};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);

		backdoor_put_data(addr_t,6,{16{'haaaa_0000}});
		

		for(int i=0;i<length;i++) begin
			success = std::randomize(wdata) with {wdata <= (2**512-1);};
			if(is_mmio_range) begin    //mmio_range=1
				cmd = $urandom_range(2);
				if(cmd ==0) begin
					dcache_load(addr_t);
				end
				else if(cmd == 1) begin
					dcache_store(addr_t,wdata);
				end
				else if(cmd == 2) begin
					success = std::randomize(req_cmd) with {req_cmd inside amo_cmd;};
					dcache_amo_operation(req_cmd,addr_t,wdata,req_size_t);    
		  	end
			end
			else begin                 //mmio_range=0
				//success = std::randomize(cmd) with {cmd inside {0,3,4};};
				cmd = $urandom_range(4);
				if(cmd == 0) begin
					dcache_load(addr_t,,,1);
				end
				else if(cmd == 1) begin
					dcache_store(addr_t,wdata,,1);
				end
				else if(cmd == 2) begin
					success = std::randomize(wmask) with {wmask <= (2**64-1);};
					dcache_partial_mask_store(addr_t,wdata,wmask,1);           
				end
				else if(cmd == 3) begin
					success = std::randomize(req_cmd) with {req_cmd inside amo_cmd;};
					dcache_amo_operation(req_cmd,addr_t,wdata,req_size_t,1);
				end
				else if(cmd == 4) begin
					success = std::randomize(req_cmd) with {req_cmd inside amo_cmd;};
					dcache_amo_operation(req_cmd,addr_t,wdata,req_size_t);
				end
			end
	 end
	endtask:body

endclass :dcache_iomshr_hazard_sequence

`endif
