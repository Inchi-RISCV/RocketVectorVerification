
`ifndef _dcache_prefetch_read_sequence_SV_
`define _dcache_prefetch_read_sequence_SV_

class dcache_prefetch_read_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_prefetch_read_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_prefetch_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [511:0] wdata;
		string init_state;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)
		
		init_state = vmm_opts::get_string("init_state", "N", "init_state");

		length 			= $urandom_range(1,1000);
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

			if(init_state == "B") begin
				dcache_load(addr_t+'h40*i);
			end
			else if(init_state == "Trunk") begin
				dcache_lr(addr_t+'h40*i,2);
			end
			else if(init_state == "Dirty") begin
				dcache_store(addr_t+'h40*i,wdata);
			end
		end

		for(int i=0;i<length;i++)begin
			dcache_prefetch_read(addr_t+'h40*i);
		end
  endtask
endclass : dcache_prefetch_read_sequence

`endif
