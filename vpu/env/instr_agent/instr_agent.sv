//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :vpu
// File Name         :instr_agent.sv
// Author            :=huangxiaogang
// Email             :=huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2023-09-04 14:45:34
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _INSTR_AGENT_SV_
`define _INSTR_AGENT_SV_

class instr_agent extends uvm_agent;
  instr_agent_config       m_cfg;
  instr_sequencer          m_sequencer;
  instr_driver             m_driver;
  instr_monitor            m_monitor;

  uvm_analysis_port #(instr_trans) analysis_port;

  `uvm_component_utils_begin(instr_agent)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
     `uvm_field_object(m_cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  extern function new(string name, uvm_component parent); 

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : instr_agent


function  instr_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


function void instr_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(m_cfg == null) begin
    if (!uvm_config_db#(instr_agent_config)::get(this, "", "m_cfg", m_cfg))
    begin
      `uvm_warning("NOCONFIG", "Config not set for Rx agent, using default is_active field")
      m_cfg = instr_agent_config  ::type_id::create("m_cfg", this);
    end
  end
  is_active = m_cfg.is_active;

  m_monitor     = instr_monitor    ::type_id::create("m_monitor", this);
  if (is_active == UVM_ACTIVE) begin
    m_driver    = instr_driver     ::type_id::create("m_driver", this);
    m_sequencer = instr_sequencer  ::type_id::create("m_sequencer", this);
  end
endfunction : build_phase


function void instr_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  m_monitor.analysis_port.connect(analysis_port);
  if (is_active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // INSTR_AGENT_SV


