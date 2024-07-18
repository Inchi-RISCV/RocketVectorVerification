//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :data_agent.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DATA_AGENT_SV_
`define _DATA_AGENT_SV_

class data_agent extends uvm_agent;
  data_agent_config       m_cfg;
  data_monitor            m_monitor;

  //uvm_analysis_port #(data_trans) analysis_port;

  `uvm_component_utils_begin(data_agent)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
     `uvm_field_object(m_cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  extern function new(string name, uvm_component parent); 

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : data_agent


function  data_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  //analysis_port = new("analysis_port", this);
endfunction : new


function void data_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(m_cfg == null) begin
    if (!uvm_config_db#(data_agent_config)::get(this, "", "m_cfg", m_cfg))
    begin
      `uvm_warning("NOCONFIG", "Config not set for Rx agent, using default is_active field")
      m_cfg = data_agent_config  ::type_id::create("m_cfg", this);
    end
  end
  is_active = m_cfg.is_active;

  m_monitor     = data_monitor    ::type_id::create("m_monitor", this);
endfunction : build_phase


function void data_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  //m_monitor.analysis_port.connect(analysis_port);
endfunction : connect_phase

`endif // DATA_AGENT_SV


