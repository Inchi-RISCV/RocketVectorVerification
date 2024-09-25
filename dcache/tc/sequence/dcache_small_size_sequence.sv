
`ifndef _dcache_small_size_sequence_SV_
`define _dcache_small_size_sequence_SV_

class dcache_small_size_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_small_size_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_small_size_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [38:0] addr_t;
		bit [7:0] wdata;
		bit [511:0] wdata_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit is_mmio_range;
		bit noAlloc;
	 	bit success;

		super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		noAlloc = vmm_opts::get_int("noAlloc", 0, "noAlloc");

		if(is_mmio_range) begin
			success 	= std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h3_0000:'h3_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+64*128) inside {['h6000_0000:'h7fff_ffff]};
			};
		end
		else begin
			success 	= std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h4_0000:'h7_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+64*128) inside {['h8000_0000:'hffff_ffff]};
			};
		end

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);

		
		backdoor_put_data(addr_t,6,{16{'h76543210}});
		
		for(int j=0;j<6;j++) begin
			for(int i=0;i<(64/2**j);i++)begin
				wdata = $urandom_range(255);
				//wdata_t = wdata << (8*(2**j*i));
				dcache_store(addr_t+2**j*i,wdata,j,noAlloc);
			end

			for(int i=0;i<(64/2**j);i++)begin
				dcache_load(addr_t+2**j*i,j,,noAlloc);
			end
		end
	endtask
endclass : dcache_small_size_sequence

`endif
