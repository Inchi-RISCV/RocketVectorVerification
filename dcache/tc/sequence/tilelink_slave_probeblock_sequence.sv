
`ifndef _TILELINK_SLV_PROBEBLOCK_SEQ_SV_
`define _TILELINK_SLV_PROBEBLOCK_SEQ_SV_

class tilelink_slave_probeblock_sequence extends tilelink_slave_base_sequence; 

  `svt_xvm_object_utils(tilelink_slave_probeblock_sequence) 
  `uvm_declare_p_sequencer(dcache_vsqr)
 
  extern function new(string name = "tilelink_slave_probeblock_sequence");
  
  extern virtual task body();

endclass

//------------------------------------------------------------------------------
function tilelink_slave_probeblock_sequence::new(string name="tilelink_slave_probeblock_sequence");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
task tilelink_slave_probeblock_sequence::body();	
	bit [31:0] length;
	bit [38:0] b_addr_ini;
	bit [1:0]  b_param;
	
	super.body();
	`uvm_info("body", "Entering...", UVM_LOW)

	//TODO:
	length 	= 20;
	b_addr_ini = 'h8000_0000;

	for(int i=0;i<length;i++)begin
		b_param	= $urandom_range(2);

		tilelink_chnlB_probeblock(b_addr_ini+'h40*i,b_param);
	end

	`uvm_info("body", "Exiting...", UVM_LOW)
endtask

`endif
