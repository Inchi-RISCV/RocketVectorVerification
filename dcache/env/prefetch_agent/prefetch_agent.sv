//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :prefetch_agent.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _PREFETCH_AGENT_SV_
`define _PREFETCH_AGENT_SV_

class prefetch_agent extends uvm_agent;
  prefetch_agent_config       m_cfg;
  prefetch_sequencer          m_sequencer;
  prefetch_driver             m_driver;
  prefetch_monitor            m_monitor;

  uvm_analysis_port #(prefetch_trans) analysis_port;

  `uvm_component_utils_begin(prefetch_agent)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
     `uvm_field_object(m_cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  extern function new(string name, uvm_component parent); 

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : prefetch_agent


function  prefetch_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


function void prefetch_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(m_cfg == null) begin
    if (!uvm_config_db#(prefetch_agent_config)::get(this, "", "m_cfg", m_cfg))
    begin
      `uvm_warning("NOCONFIG", "Config not set for Rx agent, using default is_active field")
      m_cfg = prefetch_agent_config  ::type_id::create("m_cfg", this);
    end
  end
  is_active = m_cfg.is_active;

  m_monitor     = prefetch_monitor    ::type_id::create("m_monitor", this);
  if (is_active == UVM_ACTIVE) begin
    m_driver    = prefetch_driver     ::type_id::create("m_driver", this);
    m_sequencer = prefetch_sequencer  ::type_id::create("m_sequencer", this);
  end
endfunction : build_phase


function void prefetch_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  m_monitor.analysis_port.connect(analysis_port);
  if (is_active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // PREFETCH_AGENT_SV


