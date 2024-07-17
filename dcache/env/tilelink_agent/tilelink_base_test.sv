//=============================================================================
//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//
//It configures the ENV. 
//Creates the ENV handles.
//And sets the configuration of master & slave configuration classes.
//==================================================================================================//

`ifndef GUARD_TILELINK_BASE_TEST_SV
`define GUARD_TILELINK_BASE_TEST_SV
`include "../env/cust_svt_tilelink_system_configuration.sv"
`include "../env/tilelink_system_error_catcher.sv"
`include "../env/tilelink_uvm_env.sv"
`include "../env/cust_svt_tilelink_sequence_collection.sv"
`include "../env/tilelink_default_mst_sequence.sv"
`include "../env/tilelink_simple_reset_sequence.sv"


class tilelink_base_test extends uvm_test;
  
  `uvm_component_utils(tilelink_base_test)
  /**
   * Instance of tilelink_system_error_catcher. 
   */
  tilelink_system_error_catcher error_catcher;
  uvm_report_server report_server;
  int error_count;
  int fatal_count;
  int total_severity_count;
  int timeout_value = 50ms;
  /** Path variable for the Config file created through vcc to configure the vip */
  string tilelink_cfg_file = "";
  string part_number_f     = "";
  /**
   * Captures the value passed in from the command line by +test_limit=n.
   * This value used to drive multiple passes through the test sequence.
   */
  int plusarg_test_limit = 1;
  bit success; 
  /** Variable used to disable I3C VIP*/
  bit disable_vip;
   

  tilelink_uvm_env                 tilelink_basic_env;
  cust_svt_tilelink_system_configuration  cfg;

  function new(string name = "tilelink_base_test", uvm_component parent = null);
    super.new(name,parent);
    //EXit if there UVM_ERROR count is '1'
    report_server = uvm_report_server::get_server();
    report_server.set_max_quit_count(0);
  endfunction: new        
   
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    /**
     * Set the updated TILELINK Configuration class.
     */
    if(!($value$plusargs("svt_tilelink_disable_vip=%0b",disable_vip)))
        disable_vip = 1'b0;
    if ($value$plusargs("test_limit=%d", plusarg_test_limit)) begin
      `svt_debug("build_phase", $sformatf("build_phase()- Set max test count from +test_limit=%0d", plusarg_test_limit));
    end

    cfg = cust_svt_tilelink_system_configuration::type_id::create("cfg");
        //Master & Slave are configured for cov_enable to 0.
    `ifdef SVT_TILELINK_COV_ENABLE         cfg.master_cfg[0].enable_cov = 1;           cfg.slave_cfg[0].enable_cov = 1;  
    `else                                  cfg.master_cfg[0].enable_cov = 0;           cfg.slave_cfg[0].enable_cov = 0;  
    `endif
    `ifdef SVT_TILELINK_CHECKER_COV_ENABLE cfg.master_cfg[0].enable_chk_pass_cov = 1;  cfg.slave_cfg[0].enable_chk_fail_cov = 1;
    `else                                  cfg.master_cfg[0].enable_chk_pass_cov = 0;  cfg.slave_cfg[0].enable_chk_fail_cov = 0;
    `endif
    foreach(cfg.slave_cfg[i]) cfg.slave_cfg[i].mem_address_range= '1;

    uvm_config_db#(cust_svt_tilelink_system_configuration)::set(this, "tilelink_basic_env", "cfg", this.cfg);
    tilelink_basic_env = tilelink_uvm_env::type_id::create("tilelink_basic_env", this);

    /** Apply the default virtual sequence */
    uvm_config_db#(uvm_object_wrapper)::set(this, "tilelink_basic_env.sys_env.sequencer.main_phase", "default_sequence", tilelink_default_mst_sequence::type_id::get());
    uvm_config_db#(uvm_object_wrapper)::set(this, "tilelink_basic_env.sys_env.master[0].master_transaction_seqr.main_phase", "default_sequence", null);
    
    /** Apply the default reset sequence */
    uvm_config_db#(uvm_object_wrapper)::set(this, "tilelink_basic_env.sequencer.reset_phase", "default_sequence", tilelink_simple_reset_sequence::type_id::get());

    uvm_config_db#(cust_svt_tilelink_system_configuration)::set(this, "tilelink_basic_env.sequencer.*", "cfg", cfg);
    // Create the handle of tilelink_system_error_catcher class.
    error_catcher = tilelink_system_error_catcher::type_id::create("error_catcher");
    `ifdef SVT_UVM_TECHNOLOGY
       uvm_report_cb::add(null, error_catcher);
    `elsif SVT_OVM_TECHNOLOGY
       error_catcher.append();
    `endif
  endfunction: build_phase

  //---------------------------------------------------------------------------
  /** This is the pre_rest_phase */ 
  task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);
    if(disable_vip == 1'b0) begin
    end
  endtask

  `ifdef SVT_UVM_TECHNOLOGY
  extern virtual function void check_phase(uvm_phase phase);
  `elsif SVT_OVM_TECHNOLOGY
  extern virtual function void check();
  `endif

  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
  endfunction : connect_phase

  `ifdef SVT_UVM_TECHNOLOGY
  function void end_of_elaboration_phase(uvm_phase phase);
    string method_name = "end_of_elaboration_phase";
    super.end_of_elaboration_phase(phase);
  `elsif SVT_OVM_TECHNOLOGY
  function void end_of_elaboration();
    string method_name = "end_of_elaboration";
  `endif
    `uvm_info("end_of_elaboration_phase", "Entered ...", UVM_DEBUG)
    // Check for all the ids
    `uvm_info(get_full_name(), "Printing test topology", UVM_NONE)
    cfg.print();
    `uvm_info("end_of_elaboration_phase", "Exited ...", UVM_DEBUG)
  endfunction : end_of_elaboration_phase 

  task run_phase(uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this); 
     #10000
     phase.drop_objection(this);
  endtask

  function void final_phase(uvm_phase phase);
    uvm_report_server svr;
    `uvm_info("final_phase", "Entered ...",UVM_DEBUG)
    super.final_phase(phase);
    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL) +
        svr.get_severity_count(UVM_ERROR) >0)
      `uvm_info("final_phase", "\nSvtTestEpilog: Failed\n", UVM_NONE)
    else
      `uvm_info("final_phase", "\nSvtTestEpilog: Passed\n", UVM_NONE)
      `uvm_info("final_phase", "Exited ...",UVM_DEBUG)
  endfunction : final_phase
endclass: tilelink_base_test


//--------------------------------------------------------------------------
`ifdef SVT_UVM_TECHNOLOGY
  function void tilelink_base_test::check_phase(uvm_phase phase);
    string method_name = "check_phase";
`elsif SVT_OVM_TECHNOLOGY
  function void check();
    string method_name = "check";
`endif

    //---------------------------------------------------------------------- 
    // If we didn't received any of expected ERROR/WARNING shout the error 
    //---------------------------------------------------------------------- 
    //// Check for all the messages 
    //foreach(error_catcher.messages[msg_num]) begin
    //  if(!error_catcher.observed_error.exists(error_catcher.messages[msg_num])) begin
    //    `svt_error(method_name, $sformatf("Did not received expected Error : %0s",error_catcher.messages[msg_num]));
    //  end
    //end

    //// Check for all the ids
    //foreach(error_catcher.ids[id_num]) begin
    //  if(!error_catcher.observed_error.exists(error_catcher.ids[id_num])) begin
    //    `svt_error(method_name, $sformatf("Did not received expected Error for ID : %0s",error_catcher.ids[id_num]));
    //  end
    //end
  endfunction

  `endif //GUARD_TILELINK_BASE_TEST_SV

// ---------------------------------------------------------------------------------
// End of Declarations of BASE Test Class
// ---------------------------------------------------------------------------------
//------------END OF LINE ----------------------------------------------------------//
