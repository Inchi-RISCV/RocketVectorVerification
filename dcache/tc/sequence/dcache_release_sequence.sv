
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
		int delay_cycles;
		string init_state;
		string cmd;
		bit hazard_en;
		bit success;

	 	super.body(); 
    `uvm_info(get_type_name(), "dcache sequence starting", UVM_NONE)

		init_state = vmm_opts::get_string("init_state", "N", "init_state");
		cmd = vmm_opts::get_string("cmd", "replace", "cmd");
		hazard_en = vmm_opts::get_int("hazard_en", 0, "hazard_en");
		delay_cycles	= 12; 	//TODO: 1 cycle for hazard
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
				success	= std::randomize(wdata) with {wdata <= (2**512-1);};

				if(init_state == "B") begin
					dcache_load(addr_t+'h2000*i,size_t,1);
				end
				else if(init_state == "Trunk") begin
					dcache_lr(addr_t+'h2000*i,2);
				end
				else if(init_state == "Dirty") begin
					dcache_store(addr_t+'h2000*i,wdata,size_t);
				end
			end
			
			for(int i=0;i<length;i++)begin
				dcache_load(addr_t+'h2000*i,,1);
			end
		end 
		else begin
			for(int i=0;i<4;i++)begin
				size_t = $urandom_range(6);
				dcache_load(addr_t+'h2000*i,size_t,1);
				#200ns;
			end

			fork
				if(cmd == "loadA") begin
					repeat(delay_cycles) #1;
					
					for(int i=0;i<length;i++)begin
						size_t = $urandom_range(6);
						dcache_load(addr_t,size_t,1);
					end
				end
				else if(cmd == "storeA") begin
					repeat(delay_cycles) #1;
					
					for(int i=0;i<length;i++)begin
						success	= std::randomize(wdata) with {wdata <= (2**512-1);};
						size_t = $urandom_range(6);
						dcache_store(addr_t,wdata,size_t);
					end
				end
				else if(cmd == "loadB") begin
					for(int i=0;i<length;i++)begin
						size_t = $urandom_range(6);
						dcache_load(addr_t+'h8000,size_t,1);
					end
				end
				else if(cmd == "storeB") begin
					for(int i=0;i<length;i++)begin
						success	= std::randomize(wdata) with {wdata <= (2**512-1);};
						size_t = $urandom_range(6);
						dcache_store(addr_t+'h8000,wdata,size_t);
					end
				end

				begin 	//replace
					dcache_load(addr_t+'h8000,,1);
				end
			join
		end
  endtask
endclass : dcache_release_sequence

`endif
