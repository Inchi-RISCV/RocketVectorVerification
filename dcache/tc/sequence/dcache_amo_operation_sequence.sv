
`ifndef _dcache_amo_operation_sequence_SV_
`define _dcache_amo_operation_sequence_SV_

class dcache_amo_operation_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_amo_operation_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_amo_operation_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [2:0]	size_t;
		bit is_signed;
		bit [511:0] wdata;
		bit is_mmio_range;
		bit noAlloc;
		bit success;
		bit [4:0] req_cmd;
		
	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		req_cmd = vmm_opts::get_int("req_cmd", 0, "req_cmd");
		noAlloc = vmm_opts::get_int("noAlloc", 0, "noAlloc");

		size_t = $urandom_range(2,3);
		length = $urandom_range(1, 500);
		`uvm_info("RANDOM_CFG",$sformatf("length = %0d", length),UVM_LOW);

		if(is_mmio_range) begin
			success 	= std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h3_0000:'h3_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+64*length) inside {['h6000_0000:'h7fff_ffff]};
			};
		end
		else begin
			success 	= std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h4_0000:'h7_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+64*length) inside {['h8000_0000:'hffff_ffff]};
			};
		end

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);

		
		for(int i=0;i<length;i++)begin
			success	= std::randomize(wdata) with {wdata <= (2**512-1);};
			is_signed = $urandom_range(1);

			backdoor_put_data(addr_t+(2**size_t)*i,size_t,{16{'hffff_1111}}+i);
			dcache_amo_operation(req_cmd,addr_t+(2**size_t)*i,wdata,size_t,noAlloc); 	//init state: N
			
			if((!is_mmio_range)&&(!noAlloc)) begin
				dcache_load(addr_t+(2**size_t)*i,size_t,is_signed);
				dcache_amo_operation(req_cmd,addr_t+(2**size_t)*i,wdata,size_t); 	//init state: B

				dcache_store(addr_t+(2**size_t)*i,wdata,size_t);
				dcache_amo_operation(req_cmd,addr_t+(2**size_t)*i,wdata,size_t);		//init state: Dirty
			end
		end

		for(int i=0;i<length;i++)begin
			dcache_load(addr_t+64*i,,1);
		end
  endtask
endclass : dcache_amo_operation_sequence

`endif
