
`ifndef _TILELINK_SLV_PROBECOHMSHR_STATE_SEQ_SV_
`define _TILELINK_SLV_PROBECOHMSHR_STATE_SEQ_SV_

class tilelink_slave_probecohmshr_state_sequence extends dcache_base_sequence; 

  `svt_xvm_object_utils(tilelink_slave_probecohmshr_state_sequence) 
  `uvm_declare_p_sequencer(dcache_vsqr)
 
  extern function new(string name = "tilelink_slave_probecohmshr_state_sequence");
  
  extern virtual task body();

endclass

function tilelink_slave_probecohmshr_state_sequence::new(string name="tilelink_slave_probecohmshr_state_sequence");
  super.new(name);
endfunction

task tilelink_slave_probecohmshr_state_sequence::body();	
	bit [31:0] length;
	bit [38:0] addr1,addr2,addr3;
	bit [1:0] b_param1,b_param2,b_param3;
	bit [511:0] wdata;
	bit [2:0] size_t;
	bit is_signed;
	bit success;
	bit cmd1,cmd2,cmd3;
	string init_state1,init_state2,init_state3;

	super.body();
	`uvm_info("body", "Entering...", UVM_LOW)

	length = 1;
	success = std::randomize(addr1,addr2,addr3) with {
		addr1 inside {['h8000_0000:'h7f_ffff_ffff]};
	  addr2 inside {['h8000_0000:'h7f_ffff_ffff]};
		addr3 inside {['h8000_0000:'h7f_ffff_ffff]};
		(addr1%64) == 0;
		(addr1+64*length) inside {['h8000_0000:'h7f_ffff_ffff]};
		(addr2%64) == 0;
		(addr2+64*length) inside {['h8000_0000:'h7f_ffff_ffff]};
		(addr3%64) == 0;
		(addr3+64*length) inside {['h8000_0000:'h7f_ffff_ffff]};
	};
	
	init_state1 = vmm_opts::get_string("init_state1", "N", "init_state1");
	init_state2 = vmm_opts::get_string("init_state2", "N", "init_state2");
	init_state3 = vmm_opts::get_string("init_state3", "N", "init_state3");
	cmd1 = vmm_opts::get_int("cmd1",0,"cmd1");
	cmd2 = vmm_opts::get_int("cmd2",0,"cmd2");
	cmd3 = vmm_opts::get_int("cmd3",0,"cmd3");

	for(int i=0;i<length;i++)begin
		backdoor_put_data(addr1+'h40*i,6,{16{'h76543210}}+i);
    backdoor_put_data(addr2+'h40*i,6,{16{'h76543210}}+i);
		backdoor_put_data(addr3+'h40*i,6,{16{'h76543210}}+i);
	end
//1
	for(int i=0;i<length;i++)begin
		if(init_state1 == "B") begin
			size_t = $urandom_range(6);
			is_signed = $urandom_range(1);
			dcache_load(addr1+'h40*i,size_t,is_signed);
		end

		if(cmd1 == 0)begin
			size_t = $urandom_range(6);
			is_signed = $urandom_range(1);
			dcache_load(addr1,size_t,is_signed);
		end
		else if(cmd1 == 1)begin
			success =std::randomize(wdata)with{wdata<=(2**512-1);};
			size_t = $urandom_range(6);
			dcache_store(addr1,wdata,size_t);
		end

	end

	for(int i=0;i<length;i++)begin
		b_param1=2;
		if(init_state1 == "B")begin
    	wait((tb_top.tilelink_slave_if[0].a_param[2:0]==2));
	  	tilelink_chnlB_probeblock(addr1+'h40*i,b_param1);
	  end
	  else begin
      wait((tb_top.tilelink_slave_if[0].a_param[2:0]==0)||(tb_top.tilelink_slave_if[0].a_param[2:0]==1));
	  	tilelink_chnlB_probeblock(addr1+'h40*i,b_param1);
	  end
	end

	#150;
//2
	for(int i=0;i<length;i++)begin
		if(init_state2 == "B") begin
			size_t = $urandom_range(6);
			is_signed = $urandom_range(1);
			dcache_load(addr2+'h40*i,size_t,is_signed);
		end
		if(cmd2 == 0)begin
			size_t = $urandom_range(6);
			is_signed = $urandom_range(1);
			dcache_load(addr2,size_t,is_signed);
		end
		else if(cmd2 == 1)begin
			success =std::randomize(wdata)with{wdata<=(2**512-1);};
			size_t = $urandom_range(6);
			dcache_store(addr2,wdata,size_t);
		end

	end

	for(int i=0;i<length;i++)begin
	  b_param2=1;
		if(init_state2 == "B")begin
    	wait((tb_top.tilelink_slave_if[0].a_param[2:0]==2));
	  	tilelink_chnlB_probeblock(addr2+'h40*i,b_param2);
	  end
	  else begin
      wait((tb_top.tilelink_slave_if[0].a_param[2:0]==0)||(tb_top.tilelink_slave_if[0].a_param[2:0]==1));
	  	tilelink_chnlB_probeblock(addr2+'h40*i,b_param2);
	  end
	end
 
	#150;

//3	
  if(cmd3 == 0)begin
  	size_t = $urandom_range(6);
  	is_signed = $urandom_range(1);
  	dcache_load(addr3,size_t,is_signed);
  end
  else if(cmd3 == 1)begin
  	success =std::randomize(wdata)with{wdata<=(2**512-1);};
  	size_t = $urandom_range(6);
  	dcache_store(addr3,wdata,size_t);
  end
    
  for(int i=0;i<length;i++)begin
	  b_param3=2;
    wait((tb_top.tilelink_slave_if[0].a_param[2:0]==0)||(tb_top.tilelink_slave_if[0].a_param[2:0]==1));
  	tilelink_chnlB_probeblock(addr3+'h40*i,b_param3);
	end

	
`uvm_info("body", "Exiting...", UVM_LOW)
endtask

`endif
