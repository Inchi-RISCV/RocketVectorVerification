
`ifndef _dcache_release_sequence_SV_
`define _dcache_release_sequence_SV_

class dcache_release_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_release_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)

	function new(string name = "dcache_release_sequence");
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
		string init_state;
		string cmd1, cmd2;
		bit hazard_en;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		init_state = vmm_opts::get_string("init_state", "N", "init_state");
		cmd1 = vmm_opts::get_string("cmd1", "replace", "cmd1");
		cmd2 = vmm_opts::get_string("cmd2", "replace", "cmd2");
		hazard_en = vmm_opts::get_int("hazard_en", 0, "hazard_en");

		length	= $urandom_range(50, 500);
		`uvm_info("RANDOM_CFG",$sformatf("length = %0d", length),UVM_LOW);
		
		success = std::randomize(tag_idx_t,set_idx_t) with {
			tag_idx_t inside {['h4_0000:'h7_ffff]};
			set_idx_t inside {[0:127]};
			((tag_idx_t<<13)+(set_idx_t<<6)+2000*length) inside {['h8000_0000:'hffff_ffff]};
		};

		dcache_random_cfg(addr_t,tag_idx_t,set_idx_t);

		for(int i=0;i<length;i++)begin
			backdoor_put_data(addr_t+'h2000*i,6,{16{'h76543210}}+i);
	  end

		if(!hazard_en) begin
			for(int i=0;i<length;i++)begin
				size_t = $urandom_range(6);
				is_signed = $urandom_range(1);
				success	= std::randomize(wdata) with {wdata <= (2**512-1);};

				if(init_state == "B") begin
					dcache_load(addr_t+'h2000*i,size_t,is_signed);
				end
				else if(init_state == "Trunk") begin
					dcache_lr(addr_t+'h2000*i,2);
				end
				else if(init_state == "Dirty") begin
					dcache_store(addr_t+'h2000*i,wdata,size_t);
				end
			end
		end 
		else begin
			if(cmd1 == "replace") begin
				for(int i=0;i<5;i++)begin
					size_t = $urandom_range(6);
					is_signed = $urandom_range(1);
					dcache_load(addr_t+'h2000*i,size_t,is_signed);
				end
			end
			else if(cmd1 == "loadA") begin
				for(int i=0;i<length;i++)begin
					size_t = $urandom_range(6);
					is_signed = $urandom_range(1);
					dcache_load(addr_t,size_t,is_signed);
				end
			end
			else if(cmd1 == "loadB") begin
				size_t = $urandom_range(6);
				is_signed = $urandom_range(1);
				dcache_load(addr_t,size_t,is_signed);
			end
			else if(cmd1 == "storeA") begin
				for(int i=0;i<length;i++)begin
					success	= std::randomize(wdata) with {wdata <= (2**512-1);};
					size_t = $urandom_range(6);
					dcache_store(addr_t,wdata,size_t);
				end
			end
			else if(cmd1 == "storeB") begin
				success	= std::randomize(wdata) with {wdata <= (2**512-1);};
				size_t = $urandom_range(6);
				dcache_store(addr_t,wdata,size_t);
			end

			if(cmd2 == "replace") begin
				for(int i=1;i<4;i++)begin
					size_t = $urandom_range(6);
					is_signed = $urandom_range(1);
					dcache_load(addr_t+'h2000*i,size_t,is_signed);
				end
				for(int i=0;i<length;i++)begin
					size_t = $urandom_range(6);
					is_signed = $urandom_range(1);
					dcache_load(addr_t+'h8000,size_t,is_signed);
				end
			end
			else if(cmd2 == "loadA") begin
				for(int i=0;i<length;i++)begin
					size_t = $urandom_range(6);
					is_signed = $urandom_range(1);
					dcache_load(addr_t,size_t,is_signed);
				end
			end
			else if(cmd2 == "loadB") begin
				for(int i=0;i<length;i++)begin
					size_t = $urandom_range(6);
					is_signed = $urandom_range(1);
					dcache_load(addr_t+'h8000,size_t,is_signed);
				end
			end
			else if(cmd2 == "storeA") begin
				for(int i=0;i<length;i++)begin
					success	= std::randomize(wdata) with {wdata <= (2**512-1);};
					size_t = $urandom_range(6);
					dcache_store(addr_t,wdata,size_t);
				end
			end
			else if(cmd2 == "storeB") begin
				for(int i=0;i<length;i++)begin
					success	= std::randomize(wdata) with {wdata <= (2**512-1);};
					size_t = $urandom_range(6);
					dcache_store(addr_t+'h8000,wdata,size_t);
				end
			end
		end
  endtask
endclass : dcache_release_sequence

`endif
