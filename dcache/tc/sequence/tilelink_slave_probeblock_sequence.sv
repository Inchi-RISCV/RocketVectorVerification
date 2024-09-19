
`ifndef _TILELINK_SLV_PROBEBLOCK_SEQ_SV_
`define _TILELINK_SLV_PROBEBLOCK_SEQ_SV_

class tilelink_slave_probeblock_sequence extends dcache_base_sequence; 

  `svt_xvm_object_utils(tilelink_slave_probeblock_sequence) 
  `uvm_declare_p_sequencer(dcache_vsqr)
 
  extern function new(string name = "tilelink_slave_probeblock_sequence");
  
  extern virtual task body();

endclass

function tilelink_slave_probeblock_sequence::new(string name="tilelink_slave_probeblock_sequence");
  super.new(name);
endfunction

task tilelink_slave_probeblock_sequence::body();	
	bit [31:0] length;
	bit [38:0] addr_t;
	bit [1:0]  b_param;
	bit [511:0] wdata;
	bit success;
	string init_state;

	super.body();
	`uvm_info("body", "Entering...", UVM_LOW)

	success = std::randomize(addr_t,length) with {
		solve length before addr_t;
				
		//length inside {[1:100]};
		length == 10;
		addr_t inside {['h8000_0000:'hffff_ffff]};
		(addr_t%64) == 0;
		(addr_t+64*length) inside {['h8000_0000:'hffff_ffff]};
	};
	`uvm_info("RANDOM_CFG",$sformatf("length = %0d; addr_t = %0h", length, addr_t),UVM_LOW);
	
	b_param = vmm_opts::get_int("b_param", 0, "b_param");
	init_state = vmm_opts::get_string("init_state", "N", "init_state");


	if(init_state == "N") begin
		for(int i=0;i<length;i++)begin
			tilelink_chnlB_probeblock(addr_t+'h40*i,b_param);
		end
	end
	else if(init_state == "B") begin
		for(int i=0;i<length;i++)begin
			dcache_load(addr_t+'h40*i);
		end
		#100ns;
		for(int i=0;i<length;i++)begin
			tilelink_chnlB_probeblock(addr_t+'h40*i,b_param);
		end
	end
	else if(init_state == "Trunk") begin
		for(int i=0;i<length;i++)begin
			dcache_lr(addr_t+'h40*i,3);
		end
		#100ns;
		for(int i=0;i<length;i++)begin
			tilelink_chnlB_probeblock(addr_t+'h40*i,b_param);
		end
	end
	else if(init_state == "Dirty") begin
		for(int i=0;i<length;i++)begin
			success	= std::randomize(wdata) with {wdata <= (2**512-1);};
			dcache_store(addr_t+'h40*i,wdata);
		end
		#100ns;
		for(int i=0;i<length;i++)begin
			tilelink_chnlB_probeblock(addr_t+'h40*i,b_param);
		end
	end

	`uvm_info("body", "Exiting...", UVM_LOW)
endtask

`endif
