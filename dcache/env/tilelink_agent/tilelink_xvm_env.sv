
`ifndef WAIT_FOR_DRAIN_TIME
`define WAIT_FOR_DRAIN_TIME 100000
`endif


`ifndef GUARD_TILELINK_XVM_ENV_SV
`define GUARD_TILELINK_XVM_ENV_SV

`ifdef SCB_DIS
`else
`include "./tilelink_xvm_scoreboard.sv"
`endif
`include "./tilelink_virtual_sequencer.sv"

class tilelink_xvm_env extends uvm_env;

  /**  Provide implementations of virtual methods such as get_type_name and create */

  /**  Scoreboard to check the memory operation. */
`ifdef SCB_DIS
`else
  tilelink_xvm_scoreboard scoreboard;
`endif

  /** Instantiate a pointer to the Memory Core inside the Slave agent */
  //svt_mem_backdoor mem_back_door;

  /** TileLink System Env **/
  svt_tilelink_system_env sys_env;

  /** Virtual Sequencer */
  tilelink_virtual_sequencer sequencer;

  /** Variable used to disable TileLink VIP*/
  bit disable_vip;

  /** Instantiate a pointer to the Memory Core inside the Memory Agent */  
  //svt_mem_backdoor mem_backdoor;

  /**
   * Configuration data object reference.
   * 
   * This object is of a custom type, which contains sub-objects for the
   * configuration of the TILELINK protocol for both the Host and Device.
   *
   * In the example as delivered, this object contains master_cfg 
   * and master_cfg sub-objects, each of which is of type 
   * svt_tilelink_slave_agent_configuration,which defines the entire configuration 
   * for TILELINK protocol.
   */
   cust_svt_tilelink_system_configuration                cfg;

  `uvm_component_utils_begin(tilelink_xvm_env)
    `uvm_field_object(cfg, UVM_ALL_ON|UVM_REFERENCE);
  `uvm_component_utils_end

  /**  New */
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /**  build_phase */
  virtual function void build_phase(uvm_phase phase);
    /** TILELINK interface, for updating configuration virtual interface */    
    svt_tilelink_master_vif tilelink_master_if[];
    svt_tilelink_slave_vif  tilelink_slave_if[];

    super.build_phase(phase);
    
    if(!(uvm_config_db#(cust_svt_tilelink_system_configuration)::get(this,"","cfg",cfg))) begin
      `uvm_fatal("build_phase","Unable to obtain a configuration from the config DB. The configuration must be applied to the environment using the uvm_config_db#(svt_tilelink_configuration)::set() command.");
    end else begin
      tilelink_master_if = new[cfg.num_master];
      tilelink_slave_if  = new[cfg.num_slave];
    end
    for(int i=0; i<cfg.num_master;i++) begin
      if(!(uvm_config_db#(svt_tilelink_master_vif)::get(this,"",$sformatf("tilelink_master_if[%0d]", i), tilelink_master_if[i]))) begin
        `uvm_warning("build_phase", "Unable to obtain a TILELINK_MASTER_IF interface from the config DB. The interface must be provided to the environment using the uvm_config_db#(TILELINK_MASTER_IF)::set() command");
      end 
      else begin
        uvm_config_db#(svt_tilelink_master_vif)::set(this,"sys_env",$sformatf("tilelink_master_if[%0d]", i), tilelink_master_if[i]);
      end
    end
    
    for(int i=0; i<cfg.num_slave;i++) begin
      if(!(uvm_config_db#(svt_tilelink_slave_vif)::get(this,"",$sformatf("tilelink_slave_if[%0d]", i), tilelink_slave_if[i]))) begin
        `uvm_warning("build_phase", "Unable to obtain a TILELINK_SLAVE_IF interface from the config DB. The interface must be provided to the environment using the uvm_config_db#(TILELINK_SLAVE_IF)::set() command");
      end else begin
        uvm_config_db#(svt_tilelink_slave_vif)::set(this,"sys_env",$sformatf("tilelink_slave_if[%0d]", i), tilelink_slave_if[i]);
      end
    end
      uvm_config_db#(svt_tilelink_system_configuration)::set(this,"sys_env","cfg", cfg);
       sys_env  = svt_tilelink_system_env::type_id::create("sys_env", this);

        /** Construct the virtual sequencer */
         sequencer = tilelink_virtual_sequencer::type_id::create("sequencer", this);

    //Step 1: Configure the sequencer for selecting the null sequence

    `ifdef SCB_DIS
    `else
      if (this.cfg.enable_scoreboard) begin
        scoreboard = tilelink_xvm_scoreboard::type_id::create("scoreboard", this);
        uvm_config_db#(cust_svt_tilelink_system_configuration)::set(this, "scoreboard", "cfg", cfg);
      end
      else `svt_trace("tilelink_xvm_env",$psprintf("build_phase::scoreboard config disabled = %0b",this.cfg.enable_scoreboard));
    `endif
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);

    if(!($value$plusargs("svt_tilelink_disable_vip=%0b",disable_vip)))
        disable_vip = 1'b0;
    if(disable_vip == 1'b0) begin
      super.connect_phase(phase);

      //sequencer.master_sequencer[0] = sys_env.sequencer.master_sequencer[0];
      sequencer.slave_sequencer[0]  = sys_env.sequencer.slave_sequencer[0];
    end
`ifdef SCB_DIS
`else

   if (this.cfg.enable_scoreboard) begin
     sys_env.master[0].master_mon.tx_xact_observed_port.connect(scoreboard.Master2Sb_port_tx);
     sys_env.master[0].master_mon.rx_xact_observed_port.connect(scoreboard.Master2Sb_port_rx);
     sys_env.master[0].master_mon.status_xact_observed_port.connect(scoreboard.Master2Sb_port_status);

     sys_env.slave[0].slave_mon.tx_xact_observed_port.connect(scoreboard.Slave2Sb_port_tx);
     sys_env.slave[0].slave_mon.rx_xact_observed_port.connect(scoreboard.Slave2Sb_port_rx);
     sys_env.slave[0].slave_mon.status_xact_observed_port.connect(scoreboard.Slave2Sb_port_status);

    /**  Connect monitor to scoreboard */
    // Get a pointer to the mem_backdoor to send to the sequencer so that the sequence 
    // can use it to get an instance of the backdoor into the memory.
    //mem_backdoor      = slave_agent.sequencer.get_backdoor();
    //scoreboard.mem_backdoor = mem_backdoor;


    // Get a pointer to the mem_back_door to send to the sequencer so that the sequence can use it to get an instance of the backdoor into the memory.
    //if(slave_agent.sequencer!=null)
    //mem_back_door= slave_agent.sequencer.get_backdoor();
  end
  else `svt_trace("tilelink_xvm_env",$psprintf("connect_phase::scoreboard config disabled = %0b",this.cfg.enable_scoreboard));
`endif
  endfunction : connect_phase

 
  task run_phase(uvm_phase phase);
    time drain_time = `WAIT_FOR_DRAIN_TIME;
    uvm_objection objection;
  
    super.run_phase(phase);
    `uvm_info("run_phase", "Entered ...",UVM_LOW)
    /*
     * Declaration of Drain Time
     * After dropping all objections wait for `WAIT_FOR_DRAIN_TIME
    */

    objection = phase.get_objection();
    objection.set_drain_time(this,drain_time);

    `uvm_info("run_phase", "Exited ...",UVM_LOW)
  endtask : run_phase

 
endclass : tilelink_xvm_env
`endif // GUARD_TILELINK_XVM_ENV_SV
