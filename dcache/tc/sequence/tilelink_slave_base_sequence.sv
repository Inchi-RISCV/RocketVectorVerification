
`ifndef _TILELINK_SLV_BASE_SEQ_SV_
`define _TILELINK_SLV_BASE_SEQ_SV_

class tilelink_slave_base_sequence extends uvm_sequence#(svt_tilelink_slave_transaction); 

  `svt_xvm_object_utils(tilelink_slave_base_sequence) 
  `uvm_declare_p_sequencer(dcache_vsqr)
 
  extern function new(string name = "tilelink_slave_base_sequence");
  
  extern virtual task body();

	extern task tilelink_chnlB_probeblock(
		input bit [38:0] tl_b_address,
		input bit [1:0] tl_b_param,	
		input bit [2:0] tl_b_size = 6	
	);
endclass

//------------------------------------------------------------------------------
function tilelink_slave_base_sequence::new(string name="tilelink_slave_base_sequence");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
task tilelink_slave_base_sequence::body();	
	`uvm_info("body", "Entering...", UVM_LOW)

	wait(!tb_top.reset) 	//wait meta array init
	#200ns;

	`uvm_info("body", "Exiting...", UVM_LOW)
endtask

task tilelink_slave_base_sequence::tilelink_chnlB_probeblock(
	input bit [38:0] tl_b_address,
	input bit [1:0] tl_b_param,	
	input bit [2:0] tl_b_size = 6	
	);

	svt_tilelink_slave_transaction tr;

	`uvm_info("body", "Entering...", UVM_LOW)

	`svt_xvm_create_on(tr,p_sequencer.tilelink_sqr.slave_sequencer[0])
	
	if(!tr.randomize() with {
															tr.drive_chnl_B 		== 1;
                              tr.ch_b_msg_type 		== svt_tilelink_slave_transaction::CH_B_PROBE_BLOCK; 
                              tr.b_param 					== tl_b_param;
                              tr.b_size 					== tl_b_size;
                              tr.b_source 				<= 31;
                              tr.b_address 				==	tl_b_address;
															tr.b_mask[0] 				== 'hffff_ffff_ffff_ffff; 	//TODO
	}) `uvm_error("Randomization Failure","tilelink_slave_base_sequence")
	
	`svt_xvm_send(tr)

endtask

`endif
