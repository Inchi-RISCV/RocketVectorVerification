

//--------------------------------------------------------------------------
/** 
 * Abstract:
 * This class is used by the testbench to provide default master 
 * transaction sequence which is initiated on the default virtual
 * sequence through the virtual sequencer.
 */ 

class tilelink_default_mst_sequence extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;

  `uvm_object_utils(tilelink_default_mst_sequence)
  `uvm_declare_p_sequencer(svt_tilelink_master_transaction_sequencer)

  /** tilelink configuration handle */ 
  svt_tilelink_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Class constructor. */
  function new(string name="tilelink_default_mst_sequence");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      phase.raise_objection(this);
    end
  endtask : pre_body
  
  //---------------------------------------------------------------------------
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      phase.drop_objection(this);
    end
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    bit status;
    int local_sequence_length;
    `uvm_info("body", "Entering...", UVM_DEBUG)
     
    status = uvm_config_db#(int unsigned)::get(null, get_full_name(), "sequence_length", sequence_length);
    `uvm_info("body", $sformatf("sequence_length is %0d as a result of %0s.", sequence_length, status ? "config DB" : "randomization"), UVM_LOW);
    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);
    
    local_sequence_length = sequence_length;
    /** Cast the SVT configuration handle on the local tilelink configuration handle */
    if (!$cast(tilelink_cfg, cfg)) begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_configuration class");
    end

    `uvm_info("body", "Master requesting Put_FULL_DATA on SLV...", UVM_LOW)
    `ifdef SVT_UVM_1800_2_2017_OR_HIGHER
      `else
      `uvm_do_with( req,
                { req.ch_a_msg_type      == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                  req.a_address          == 4                               ;
                  req.a_size             == 0                               ;
                  req.a_source           == 2;
                 })
      `endif
    `uvm_info("body", "Master requesting GET on SLV...", UVM_LOW)
    
    `ifdef SVT_UVM_1800_2_2017_OR_HIGHER
    `else
      `uvm_do_with( req,
                { req.ch_a_msg_type      == svt_tilelink_master_transaction::CH_A_GET;
                  req.a_address          == 'hAAAA                               ;
                  req.a_size             == 0                               ;
                  req.a_source           == 4;
                 })
    `endif
    /** 
     * Call get_response only if configuration attribute,
     * enable_put_response is set 1.
     */
    //if(tilelink_cfg.enable_put_response == 1)
    //  get_response(rsp);
    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : tilelink_default_mst_sequence
