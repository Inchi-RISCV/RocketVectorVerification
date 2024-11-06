
`ifndef _dcache_s1_kill_sequence_SV_
`define _dcache_s1_kill_sequence_SV_

class dcache_s1_kill_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_s1_kill_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_s1_kill_sequence");
    super.new(name);
  endfunction

  virtual task body();
		bit [31:0] length;
		bit [38:0] addr_t;
		bit [26:0] tag_idx_t;
		bit [6:0] set_idx_t;
		bit [511:0] wdata;
		bit [2:0] size_t;
		bit is_signed;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)
		
		length 			= $urandom_range(1, 500);
		`uvm_info("RANDOM_CFG",$sformatf("length = %0d", length),UVM_LOW);
		
		success 	= std::randomize(tag_idx_t,set_idx_t) with {
			tag_idx_t inside {['h4_0000:'h7_ffff]};
			set_idx_t inside {[0:127]};
			((tag_idx_t<<13)+(set_idx_t<<6)+64*length) inside {['h8000_0000:'hffff_ffff]};
		};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);
		
		
		for(int i=0;i<length;i++)begin
			backdoor_put_data(addr_t+'h40*i,6,{16{'h76543210}}+i);
	  end

		for(int i=0;i<length;i++)begin
			size_t = $urandom_range(6);
			is_signed = $urandom_range(1);
			success = std::randomize(wdata) with { wdata <= (2**512-1);};
		
			dcache_store(addr_t+'h40*i,wdata,size_t,,1); 	//s1_kill = 1
			dcache_load(addr_t+'h40*i,size_t,is_signed);
		end
  endtask
endclass : dcache_s1_kill_sequence

`endif
