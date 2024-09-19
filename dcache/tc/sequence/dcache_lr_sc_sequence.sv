
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
		bit is_mmio_range;
		bit lr_timeout;
		string init_state;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		is_mmio_range = vmm_opts::get_int("is_mmio_range", 0, "is_mmio_range");
		init_state = vmm_opts::get_string("init_state", "N", "init_state");

		size_t 			= $urandom_range(2,3);
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
			backdoor_put_data(addr_t+'h40*i,6,{16{'h76543210}}+i);
	  end

		for(int i=0;i<length;i++)begin
			success	= std::randomize(wdata) with {wdata <= (2**512-1);};

			if(init_state == "B") begin
				dcache_load(addr_t+(2**size_t)*i,size_t);
			end
			else if(init_state == "Trunk") begin
				dcache_lr(addr_t+(2**size_t)*i,size_t);
			end
			else if(init_state == "Dirty") begin
				dcache_store(addr_t+(2**size_t)*i,wdata,size_t);
			end
		end
	
		for(int i=0;i<length;i++)begin
			lr_timeout 	= $urandom_range(1);
			success	= std::randomize(wdata) with {wdata <= (2**512-1);};
			
			dcache_sc(addr_t+(2**size_t)*i,wdata,size_t); 	//sc miss fail
			dcache_lr(addr_t+(2**size_t)*i+'h2000,size_t);
			dcache_lr(addr_t+(2**size_t)*i,size_t);
			
			if(lr_timeout) begin
				#200ns;
			end
			
			dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);	//sc hit success
			dcache_sc(addr_t+(2**size_t)*i,wdata,size_t);	//sc hit fail
		end
  
		for(int i=0;i<length;i++)begin
			dcache_load(addr_t+(2**size_t)*i,size_t);
		end
	endtask
endclass : dcache_lr_sc_sequence

`endif
