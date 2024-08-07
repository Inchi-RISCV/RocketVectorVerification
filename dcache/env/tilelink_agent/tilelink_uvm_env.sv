
`ifndef WAIT_FOR_DRAIN_TIME
`define WAIT_FOR_DRAIN_TIME 1000
`endif


`ifndef GUARD_TILELINK_XVM_ENV_SV
`define GUARD_TILELINK_XVM_ENV_SV

`ifdef SCB_DIS
`else
`include "./tilelink_virtual_sequencer.sv"
`endif

class tilelink_uvm_env extends uvm_env;

  /**  Provide implementations of virtual methods such as get_type_name and create */



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

  `uvm_component_utils_begin(tilelink_uvm_env)
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
		
    sys_env  = svt_tilelink_system_env::type_id::create("sys_env", this);
    cfg  = cust_svt_tilelink_system_configuration::type_id::create("cfg", this);
		cfg.set_tilelink_cfg();
    //if(!(uvm_config_db#(cust_svt_tilelink_system_configuration)::get(this,"","cfg",cfg))) begin
    //  `uvm_fatal("build_phase","Unable to obtain a configuration from the config DB. The configuration must be applied to the environment using the uvm_config_db#(svt_tilelink_configuration)::set() command.");
    //end else begin
      tilelink_master_if = new[cfg.num_master];
      tilelink_slave_if  = new[cfg.num_slave];
    //end

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

		`uvm_info("body",$sformatf("cust_svt_tilelink_system_configuration is: \n%0s",cfg.sprint()),UVM_LOW)


    /** Construct the virtual sequencer */
    sequencer = tilelink_virtual_sequencer::type_id::create("sequencer", this);

    //Step 1: Configure the sequencer for selecting the null sequence

  endfunction : build_phase

  function void connect_phase(uvm_phase phase);

    if(!($value$plusargs("svt_tilelink_disable_vip=%0b",disable_vip)))
        disable_vip = 1'b0;
    if(disable_vip == 1'b0) begin
      super.connect_phase(phase);

      sequencer.master_sequencer[0] = sys_env.sequencer.master_sequencer[0];
      sequencer.slave_sequencer[0]  = sys_env.sequencer.slave_sequencer[0];
    end
  endfunction : connect_phase

 
  task run_phase(uvm_phase phase);
    time drain_time = `WAIT_FOR_DRAIN_TIME;
    uvm_objection objection;
  
    super.run_phase(phase);
    `uvm_info("run_phase", "Entered ...",UVM_DEBUG)
    /*
     * Declaration of Drain Time
     * After dropping all objections wait for `WAIT_FOR_DRAIN_TIME
    */

    objection = phase.get_objection();
    objection.set_drain_time(this,drain_time);

    `uvm_info("run_phase", "Exited ...",UVM_DEBUG)
  endtask : run_phase

 
endclass : tilelink_uvm_env
`endif // GUARD_TILELINK_XVM_ENV_SV
