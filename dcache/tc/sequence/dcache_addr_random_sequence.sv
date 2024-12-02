
`ifndef _dcache_addr_random_sequence_SV_
`define _dcache_addr_random_sequence_SV_

class dcache_addr_random_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_addr_random_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_addr_random_sequence");
    super.new(name);
  endfunction

  virtual task body();
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

		if(is_mmio_range) begin
			success 	= std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h3_0000:'h3_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+32*1024) inside {['h6000_0000:'h7fff_ffff]};
			};
		end
		else begin
			success 	= std::randomize(tag_idx_t,set_idx_t) with {
				tag_idx_t inside {['h4_0000:'h3ff_ffff]};
				set_idx_t inside {[0:127]};
				((tag_idx_t<<13)+(set_idx_t<<6)+32*1024) inside {['h8000_0000:'h7f_ffff_ffff]};
			};
		end

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);

		for(int j=0;j<4;j++)begin 	//4 way
			for(int i=0;i<128;i++)begin	//128 set
				if(store_en) begin
					success	= std::randomize(wdata) with {wdata <= (2**512-1);};
					size_t = $urandom_range(6);
					dcache_store(addr_t+'h40*i+'h2000*j,wdata,size_t,noAlloc);
				end
				else begin
					backdoor_put_data(addr_t+'h40*i+'h2000*j,6,{16{'h76543210}}+i);
				end
	  	end
		end

		for(int j=0;j<4;j++)begin 	//4 way
			for(int i=0;i<128;i++)begin	//128 set
				dcache_load(addr_t+'h40*i+'h2000*j,,1,noAlloc);
			end
		end
  endtask
endclass : dcache_addr_random_sequence

`endif
