
`ifndef _TILELINK_SLV_PROBEB_HAZARD_SEQ_SV_
`define _TILELINK_SLV_PROBEB_HAZARD_SEQ_SV_

class tilelink_slave_probe_hazard_sequence extends dcache_base_sequence; 

  `svt_xvm_object_utils(tilelink_slave_probe_hazard_sequence) 
  `uvm_declare_p_sequencer(dcache_vsqr)
 
  extern function new(string name = "tilelink_slave_probe_hazard_sequence");
  
  extern virtual task body();

endclass

function tilelink_slave_probe_hazard_sequence::new(string name="tilelink_slave_probe_hazard_sequence");
  super.new(name);
endfunction

task tilelink_slave_probe_hazard_sequence::body();	
	bit [31:0] length1, length2;
	bit [38:0] addr_t;
	bit [1:0]  b_param;
	bit [511:0] wdata;
	bit [2:0]	size_t;
	bit [4:0] cmd1, cmd2;
	bit lr_valid;
	bit success;
	int cycles;
	string resp_status;
	string init_state;

	super.body();
	`uvm_info("body", "Entering...", UVM_LOW)

	cmd1 = vmm_opts::get_int("cmd1", 0, "cmd1");
	cmd2 = vmm_opts::get_int("cmd2", 0, "cmd2");
	lr_valid = vmm_opts::get_int("lr_valid", 1, "lr_valid");
	//init_state = vmm_opts::get_string("init_state", "N", "init_state");
	resp_status = vmm_opts::get_string("resp_status", "hit", "resp_status");

	success = std::randomize(cycles) with {
		if(lr_valid) {
			cycles inside {[0:77]};
		}
		else {
			cycles inside {[78:100]};
		}
	};
	`uvm_info("RANDOM_CFG",$sformatf("cycles = %0d", cycles),UVM_LOW);

	success = std::randomize(addr_t, length1, length2) with {
		solve length1, length2 before addr_t;
			
		//TODO:
		if(resp_status == "hit"||(cmd1 == 2 && cmd2 == 3)||cmd1 == 3) {
			length1 == 20;
		}
		else { 	//miss or lr
			length1 == 1;
		}
		if(cmd2 != 2) {
			length2 == 20;
		} 
		else {
			length2 == 1;
		}
		addr_t inside {['h8000_0000:'hffff_ffff]};
		(addr_t%64) == 0;
		(addr_t+64*(length1+length2)) inside {['h8000_0000:'hffff_ffff]};
	};
	`uvm_info("RANDOM_CFG",$sformatf("length1 = %0d; length2 = %0d; addr_t = %0h", length1, length2, addr_t),UVM_LOW);
	
	backdoor_put_data(addr_t,6,{16{'h76543210}});

	for(int i=0;i<length2;i++) begin
		if(cmd2 == 3) begin 	//Replace
			dcache_load(addr_t+'h2000*i);
		end
	end

	for(int i=0;i<length1;i++)begin
		if(cmd1 == 0) begin 	//LOAD
			dcache_load(addr_t);
		end
		else if(cmd1 == 1) begin	//STORE
			success = std::randomize(wdata) with { wdata <= (2**512-1);};
			dcache_store(addr_t,wdata);
		end
		else if(cmd1 == 2) begin	//Probe
			b_param = $urandom_range(2);
			tilelink_chnlB_probeblock(addr_t,b_param);
		end
		else if(cmd1 == 3) begin 	//Replace
			dcache_load(addr_t+'h2000*i);
		end
		else if(cmd1 == 4) begin	//LR
			size_t = $urandom_range(2,3);
			dcache_lr(addr_t,size_t);
		end
	end

	for(int i=0;i<length2;i++)begin
		if(cmd2 == 0) begin 	//LOAD
			dcache_load(addr_t);
		end
		else if(cmd2 == 1) begin	//STORE
			success = std::randomize(wdata) with { wdata <= (2**512-1);};
			dcache_store(addr_t,wdata);
		end
		else if(cmd2 == 2) begin	//Probe
			b_param = $urandom_range(2);
			if(resp_status == "hit")
				wait(tb_top.m_lsu_if.io_resp_bits_status[1:0] == 'h0);
			else if(resp_status == "miss")
				wait(tb_top.m_lsu_if.io_resp_bits_status[1:0] == 'h1);
	
			//wait(tb_top.tilelink_slave_if[0].a_valid == 'h1); 	//TODO

			if(cmd1 == 3) begin 	//replace
				wait(tb_top.tilelink_slave_if[0].c_opcode[2:0] == 'h6);
			end
			else if(cmd1 == 4) begin 	//LR
				repeat(cycles) #1ns;
			end
			tilelink_chnlB_probeblock(addr_t,b_param);
		end
	end

	`uvm_info("body", "Exiting...", UVM_LOW)
endtask

`endif
