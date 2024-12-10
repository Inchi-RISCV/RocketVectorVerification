`ifndef _dcache_iomshr_hazard_test_SV_
`define _dcache_iomshr_hazard_test_SV_

class dcache_iomshr_hazard_test extends dcache_base_test;
	`uvm_component_utils(dcache_iomshr_hazard_test)

	dcache_iomshr_hazard_sequence		m_seq;

	extern function new(string name,uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);

endclass

function dcache_iomshr_hazard_test::new(string name,uvm_component parent=null);
	super.new(name,parent);
endfunction


function void dcache_iomshr_hazard_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	m_seq = dcache_iomshr_hazard_sequence::type_id::create("m_seq",this);
endfunction

task dcache_iomshr_hazard_test::main_phase(uvm_phase phase);
	super.main_phase(phase);
	phase.raise_objection(this);
	`uvm_info(get_type_name(),"start m_vsqr",UVM_NONE)
	m_seq.start(m_vsqr);
	#1ms;
	phase.drop_objection(this);
endtask

`endif
