
`ifndef _dcache_signed_sequence_SV_
`define _dcache_signed_sequence_SV_

class dcache_signed_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_signed_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_signed_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [511:0] wdata;
		bit [2:0] size_t;
		bit store_en;
		bit is_mmio_range;
		bit noAlloc;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		store_en = vmm_opts::get_int("store_en", 0, "store_en");
		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		noAlloc = vmm_opts::get_int("noAlloc", 0, "noAlloc");

		length 			= $urandom_range(1, 500);
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
			size_t = $urandom_range(6);

			if(store_en) begin
				dcache_store(addr_t+'h40*i,wdata,size_t,noAlloc); 	//not extend bits
			end
			else begin
				backdoor_put_data(addr_t+'h40*i,6,'hffff_ff00+i);		//extend bits
			end
		end
	
		for(int i=0;i<length;i++)begin
			dcache_load(addr_t+'h40*i,,1,noAlloc);
		end
  endtask
endclass : dcache_signed_sequence

`endif
