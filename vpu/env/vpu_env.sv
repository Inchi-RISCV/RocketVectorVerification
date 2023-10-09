//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :vpu_env.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _VPU_ENV_SV_
`define _VPU_ENV_SV_

class vpu_env extends uvm_env;

  `uvm_component_utils(vpu_env)

  instr_agent m_instr_agent; 
  data_agent m_data_agent; 
	vpu_scb    m_scb;
	
  
	uvm_tlm_analysis_fifo#(data_trans) data_trans_fifo;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
	extern function void report_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
	extern task shutdown_phase(uvm_phase phase);

endclass : vpu_env 

function vpu_env::new(string name, uvm_component parent);

  super.new(name, parent);

endfunction : new

function void vpu_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  //if (!uvm_config_db #(vpu_env_config)::get(this, "", "m_env_config", m_env_config)) 
  //  `uvm_error(get_type_name(), "Unable to get vpu_env_config")
  m_instr_agent = instr_agent::type_id::create("m_instr_agent", this);

  m_data_agent = data_agent::type_id::create("m_data_agent", this);

	m_scb = vpu_scb::type_id::create("m_scb", this);

	data_trans_fifo = new("data_trans_fifo",this);



endfunction : build_phase

function void vpu_env::connect_phase(uvm_phase phase);

  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)
	m_data_agent.analysis_port.connect(data_trans_fifo.analysis_export);
  m_scb.data_agent_port.connect(data_trans_fifo.blocking_get_export);	

endfunction : connect_phase

// Could print out diagnostic information, for example

function void vpu_env::end_of_elaboration_phase(uvm_phase phase);

  //uvm_top.print_topology();

endfunction : end_of_elaboration_phase

task vpu_env::main_phase(uvm_phase phase);

super.main_phase(phase);

endtask : main_phase

task vpu_env::shutdown_phase(uvm_phase phase);
	//if(!data_trans_fifo.is_empty())begin
	//	`uvm_error(get_type_name(),"data_trans_fifo is not empty")	
	//end

endtask : shutdown_phase
	


function void vpu_env::report_phase(uvm_phase phase);
	uvm_report_server srv;
	int err_cnt;

  srv= uvm_report_server::get_server();
	err_cnt = srv.get_severity_count(UVM_FATAL)+srv.get_severity_count(UVM_ERROR);

	if(err_cnt!=0)begin
    $display("~~~~~~~~~~~~~~~~ Simulation_FAIL ~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	end
	else begin
    $display("~~~~~~~~~~~~~~~~ Simulation_PASS ~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	end


endfunction 


`endif // VPU_ENV_SV


