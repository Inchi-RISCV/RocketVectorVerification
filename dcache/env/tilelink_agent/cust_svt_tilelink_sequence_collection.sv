//inclusions
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_resp_wo_req_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_response_opcode_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_valid_values_in_reset_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_valid_signal_duration_in_reset_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_valid_assertion_post_reset_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_ooo_fifo_resp_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_resp_dparam_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_resp_dsize_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_resp_dcorrupt_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_corrupt_size_opcode_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_manipulate_control_sig_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_response_ctrl_sig_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_denied_range_resp_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_identical_inflight_identifier_error_callback)

/*class for data integrity comparision*/
class data_integrity;

  bit[7:0] get_data[];
  bit[7:0] backdoor_data_queue[int][];

 /*Task to capture d_data from master status and do the comparision with backdoor data*/
task get_resp_master (svt_tilelink_master_status master_status);
  int data_size_integity;
  data_size_integity = 2**master_status.d_size;

  get_data = new[data_size_integity];
  for(int k=0;k<data_size_integity;k++)
  begin
    get_data[k] = master_status.d_data[k];
  end

  for(int l=0;l<data_size_integity;l++)
  begin
    if(get_data[l] != backdoor_data_queue[master_status.d_source][l])
    begin
      `uvm_error("DATA_INTEGRITY_FAILS::READ_DATA NOT EQUAL TO ACTUAL STORED DATA",$sformatf(" DATA_ON_BUS = %h , DATA_IN_BACKDOOR = %h",get_data[l],backdoor_data_queue[master_status.d_source][l]))
    end
  end

  /*Deleting the source which has been compared*/
  get_data.delete();
  backdoor_data_queue.delete(master_status.d_source);

endtask
endclass

/*class having tasks to get backdoor data, capture d_data from master status & count the total no of resp packets that has come on the bus*/
class ul_get_backdoor_data extends data_integrity; 

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  /** TILE_LINK env handle */ 
  tilelink_xvm_env env;

  bit status;
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  int resp_received;//Total RESP that has come 
  int req_resp_received;//Total REQ that has come 
  int packet_sent_per_width; 
  data_integrity ud_i;//class handle for data integrity 

  function new(svt_tilelink_system_configuration tilelink_cfg,tilelink_xvm_env env);
    ud_i = new();
    this.env = env;
    this.tilelink_cfg = tilelink_cfg;
  endfunction
  
  /*Task to access backdoor data from memory*/
  task backdoor_get_data(bit[63:0] address, bit[`SVT_TILELINK_SIZE_WIDTH-1:0] size,bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_out);
    
    //Passing address and size to backdoor access function 
    env.sys_env.slave[0].backdoor_access_data(address,size);
    //collecting data from backdoor queue
    foreach(env.sys_env.slave[0].slave_backdoor_queue[i])
      data_out[(i*8)+:8] = env.sys_env.slave[0].slave_backdoor_queue[i];
    `svt_note("BACKDOOR_GET_DATA",$sformatf("backdoor get data observed at address %0h and size %0h is %0h",address,size,data_out));
  endtask

  /*Task to write backdoor data into memory*/
  task backdoor_put_data(bit[63:0] address, bit[`SVT_TILELINK_SIZE_WIDTH-1:0] size,bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_in);
    //Passing address and size to backdoor write function 
    env.sys_env.slave[0].backdoor_write_data(address,size,data_in);
  endtask

  /*Task to access backdoor data of slave when READ cmd comes on BUS*/
  task backdoor_data();
   forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.a_valid == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.a_ready == 1 && tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_GET)
    begin
      env.sys_env.slave[0].backdoor_access_data(tilelink_cfg.master_cfg[0].tilelink_master_if.a_address,tilelink_cfg.master_cfg[0].tilelink_master_if.a_size);//Passing address and size to backdoor function
      temp_a_size=tilelink_cfg.master_cfg[0].tilelink_master_if.a_size;
      temp_a_source=tilelink_cfg.master_cfg[0].tilelink_master_if.a_source;
      ud_i.backdoor_data_queue[tilelink_cfg.master_cfg[0].tilelink_master_if.a_source]= new[2**tilelink_cfg.master_cfg[0].tilelink_master_if.a_size];
      @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for negedge of the clk to get backdoor data 
      for(int m=0;m<(2**temp_a_size);m++)
      begin
       ud_i.backdoor_data_queue[temp_a_source][m] = env.sys_env.slave[0].slave_backdoor_queue[m]; 
      end
    end//if
   end//forever
  endtask

  /*Task to capture d_data from master status when read resp comes on the BUS*/
  task d_data_rx();
   forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready == 1 && tilelink_cfg.master_cfg[0].tilelink_master_if.d_valid == 1 && tilelink_cfg.master_cfg[0].tilelink_master_if.d_opcode == svt_tilelink_master_status::CH_D_ACCESS_ACK_DATA)
    begin
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for negedge of clk 
     ud_i.get_resp_master(env.sys_env.master[0].master_mon.common.shared_status);
    end//if
   end//forever
  endtask

  /*To count the total no of RESPs that has come on the bus*/
  task resp_count(ref int resp_received);
  forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid == 1 && ((tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK) || (tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA)))
      begin
        resp_received++;
      end
   end
  endtask

  task resp_count_per_data_width(ref int packet_sent_per_width);
  forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid == 1 && ((tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK) || (tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA)))
      begin
        packet_sent_per_width++;
      end
   end
  endtask
endclass


class svt_tilelink_basic_sequence extends uvm_sequence; 

  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven

  `uvm_object_utils(svt_tilelink_basic_sequence)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  tilelink_xvm_env tilelink_basic_env;
  bit status;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_basic_sequence");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();

    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "tilelink_basic_env", tilelink_basic_env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   begin
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_sequence")
   `svt_xvm_send(tr)

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 2;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_sequence")
   `svt_xvm_send(tr)

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 6;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_sequence")
   `svt_xvm_send(tr)


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr.a_source == 1;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_sequence")
   `svt_xvm_send(tr)


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 2;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_sequence")
   `svt_xvm_send(tr)
  end

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_basic_sequence

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_backdoor_sequence extends uvm_sequence; 

  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[1023:0] data_out;
  
  ul_get_backdoor_data backdoor_handle;
  
  `uvm_object_utils(svt_tilelink_backdoor_sequence)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  tilelink_xvm_env tilelink_basic_env;
  bit status;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_backdoor_sequence");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();

    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "tilelink_basic_env", tilelink_basic_env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);
    
    backdoor_handle = new(tilelink_cfg,tilelink_basic_env);

   begin
   //STEP - 1: Write random data from normal txn using PUT PARTIAL DATA 
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 5;
                              tr.a_address == 'h10;
			      tr.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_backdoor_sequence")
   `svt_xvm_send(tr)
   
   //STEP - 2: Read back the data written in previous step using backdoor task
   backdoor_handle.backdoor_get_data('h10,2,data_out);

   //STEP - 3: Write random data from normal txn using PUT FULL DATA 
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 2;
                              tr.a_address == 'h200;
			      tr.a_size == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_backdoor_sequence")
   `svt_xvm_send(tr)
   
   //STEP - 4: Read back the data written in previous step using backdoor task
   backdoor_handle.backdoor_get_data('h200,3,data_out); 
   
   //STEP - 5: Write data using backdoor task
   backdoor_handle.backdoor_put_data('h100, 2,'h01234567);
   
   //STEP - 6: Read back the data written in previous step by sending normal txn using GET
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr.a_source == 1;
                              tr.a_address == 'h100;
			      tr.a_size == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_backdoor_sequence")
   `svt_xvm_send(tr)
  end

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_backdoor_sequence

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=200;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  /** Define task body() */
  virtual task body();

    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_seq")


   begin
   `svt_xvm_send(tr)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_0_delay_verif_seq extends uvm_sequence; 

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=50;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_0_delay_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_0_delay_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 source++;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_0_delay_verif_seq")

   begin
   `svt_xvm_send(tr)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_0_delay_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=20;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit corrupt_val;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == 5;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq")

 corrupt_val          = $urandom_range(0,1);

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == 6;
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_corrupt[0] == corrupt_val;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq")

 corrupt_val          = $urandom_range(0,1);

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == 7;
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_corrupt[0] == corrupt_val;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq")


  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == 8;
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_with_acorrupt_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=20;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_corrupt.size() == 1;
                              tr.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr.d_source == 5;
                              slv_tr.d_corrupt.size() == 1;
                              slv_tr.d_corrupt[0] == 0; //d_corrupt is disabled 
                              slv_tr.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])

   if (!slv_tr1.randomize() with {
                              slv_tr1.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr1.d_source == 6;
                              slv_tr1.d_corrupt.size() == 1;
                              slv_tr1.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr1.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_corrupt.size() == 1;
                              tr2.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                              slv_tr2.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr2.d_source == 7;
                              slv_tr2.d_corrupt.size() == 1;
                              slv_tr2.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr2.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                              slv_tr3.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr3.d_source == 8;
                              slv_tr3.d_corrupt.size() == 1;
                              slv_tr3.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr3.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq")


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

   begin
   `svt_xvm_send(slv_tr)
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for negedge of clk
   `svt_xvm_send(slv_tr1)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for negedge of clk
   `svt_xvm_send(slv_tr2)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for negedgee of clk
   `svt_xvm_send(slv_tr3)
   end

 join_any

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_with_write_denied_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=20;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);



 `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_corrupt.size() == 1;
                              tr.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr.d_source == 5;
                              slv_tr.d_corrupt.size() == 1;
                              slv_tr.d_corrupt[0] == 0; //d_corrupt is disabled 
                              slv_tr.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])

   if (!slv_tr1.randomize() with {
                              slv_tr1.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr1.d_source == 6;
                              slv_tr1.d_corrupt.size() == 1;
                              slv_tr1.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr1.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_corrupt.size() == 1;
                              tr2.a_corrupt[0] == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                              slv_tr2.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr2.d_source == 7;
                              slv_tr2.d_corrupt.size() == 1;
                              slv_tr2.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr2.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                              slv_tr3.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr3.d_source == 8;
                              slv_tr3.d_corrupt.size() == 1;
                              slv_tr3.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr3.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

   begin
   `svt_xvm_send(slv_tr)
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   `svt_xvm_send(slv_tr1)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   `svt_xvm_send(slv_tr2)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   `svt_xvm_send(slv_tr3)
   end

 join_any

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=20;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


 `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_corrupt.size() == 1;//a_corrupt is enabled
                              tr.a_corrupt[0] == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr.d_source == 5;
                              slv_tr.d_corrupt.size() == 1;
                              slv_tr.d_corrupt[0] == 0; //d_corrupt is disabled 
                              slv_tr.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])

   if (!slv_tr1.randomize() with {
                              slv_tr1.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr1.d_source == 6;
                              slv_tr1.d_corrupt.size() == 1;
                              slv_tr1.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr1.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_corrupt.size() == 1;
                              tr2.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                              slv_tr2.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr2.d_source == 7;
                              slv_tr2.d_corrupt.size() == 1;
                              slv_tr2.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr2.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                              slv_tr3.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr3.d_source == 8;
                              slv_tr3.d_corrupt.size() == 1;
                              slv_tr3.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr3.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

   begin
   `svt_xvm_send(slv_tr)
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for negedge of clk
   `svt_xvm_send(slv_tr1)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for negedge of clk
   `svt_xvm_send(slv_tr2)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for negedge of clk
   `svt_xvm_send(slv_tr3)
   end

 join_any

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=20;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


 `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_corrupt.size() == 1;
                              tr.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr.d_source == 5;
                              slv_tr.d_corrupt.size() == 1;
                              slv_tr.d_corrupt[0] == 0; //d_corrupt is disabled 
                              slv_tr.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])

   if (!slv_tr1.randomize() with {
                              slv_tr1.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr1.d_source == 6;
                              slv_tr1.d_corrupt.size() == 1;
                              slv_tr1.d_corrupt[0] == 1; //d_corrupt is enabled 
                              slv_tr1.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_corrupt.size() == 1;
                              tr2.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                              slv_tr2.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK; 
                              slv_tr2.d_source == 7;
                              slv_tr2.d_corrupt.size() == 1;
                              slv_tr2.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr2.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                              slv_tr3.ch_d_msg_type == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA; 
                              slv_tr3.d_source == 8;
                              slv_tr3.d_corrupt.size() == 1;
                              slv_tr3.d_corrupt[0] == 0; //d_corrupt is disabled
                              slv_tr3.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq")

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

   begin
   `svt_xvm_send(slv_tr)
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   `svt_xvm_send(slv_tr1)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   `svt_xvm_send(slv_tr2)
     @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
     @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
   `svt_xvm_send(slv_tr3)
   end

 join_any

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_with_dcorrupt_read_denied_seq

//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_seq")

  source++;

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_seq")

  source++;

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_seq")


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_seq


//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_config_with_timeout_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_config_with_timeout_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_config_with_timeout_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

 for(int i=1;i<2;i++)
 begin
 
   case(i)
     0:data_size = 2**5;//4 BYTE DATA BUS
     1:data_size = 2**6;//8 BYTE DATA BUS
     2:data_size = 2**7;//16 BYTE DATA BUS
     3:data_size = 2**8;//32 BYTE DATA BUS
     4:data_size = 2**9;//64 BYTE DATA BUS
     5:data_size = 2**10;//128 BYTE DATA BUS
   endcase

 a_size_value = $urandom_range(0,(i+2));//TOTAL BYTES TRANSFERRED SHOULD BE EQUAL OR SMALLER THAN THE DATA SIZE WIDTH IN TL_UL CASE
 
 start_address = tilelink_cfg.slave_cfg[0].ul_only_base_address[0];
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_size == a_size_value;//4 Bytes of DATA
                              tr.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_timeout_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_size == a_size_value;//4 Bytes of DATA
                              tr2.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_timeout_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   end

 end//for
    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_config_with_timeout_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_a_vld2vld_delay_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_a_vld2vld_delay_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_a_vld2vld_delay_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 2;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_vld2vld_delay_verif_seq")


   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 3;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_vld2vld_delay_verif_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 4;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_vld2vld_delay_verif_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_a_vld2vld_delay_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_config_with_4_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_config_with_4_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_config_with_4_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

 
    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int l=0;l<total_packets;l++)
 begin

 source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address  inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")


 source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address  inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")


 source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")


 source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_source == source;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr3.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr3.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")


 source++;
   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr4.a_source == source;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr4.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr4.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   end

  end//for 

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_config_with_4_seq

//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3,slv_tr4;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int l=0;l<total_packets;l++)
 begin

 source++;

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_source == source;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr3.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr3.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr4.a_source == source;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr4.a_vld_2_a_vld_assert_delay[0] == 4;//INSERTING DELAY CYCLES
                              tr4.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   end

  end//for 

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq

//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3,slv_tr4;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int l=0;l<total_packets;l++)
 begin

 source++;

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

 source++;

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

 source++;

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

 source++;

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_source == source;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr3.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr3.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

 source++;

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr4.a_source == source;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr4.a_vld_2_a_vld_assert_delay[0] == 8;//INSERTING DELAY CYCLES
                              tr4.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   end

  end//for 

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq

//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3,slv_tr4;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int l=0;l<total_packets;l++)
 begin

 source++;

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_source == source;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr3.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr3.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

 source++;

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr4.a_source == source;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr4.a_vld_2_a_vld_assert_delay[0] == 12;//INSERTING DELAY CYCLES
                              tr4.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   end

  end//for 

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif 

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq")



    source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq")

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)

 `ifndef DATA_INTEGRITY_DISABLE
   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_d_vld2vld_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq extends uvm_sequence;// #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type  inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq")



    source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_d_vld_cross_channel_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq extends uvm_sequence;// #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_a_rdy2rdy_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq extends uvm_sequence;// #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq")



    source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif 

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_a_valid_a_ready_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq")
   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_d_valid_d_ready_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq")


    source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq")



    source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq")
   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

 `uvm_info("body", "Exiting...", UVM_DEBUG)

  endtask : body

endclass : svt_tilelink_ul_d_rdy2rdy_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_fifo_enabled_with_one_fifo_range_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_fifo, range_address_fifo, end_address_fifo;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  bit[63:0] alingned_address_fifo[$];//queue to hold alingned addresses for the particular a_size for FIFO range
  int address_size;//to hold the no of total alingned addresses FIFO values
  int address_size_fifo;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[63:0] alingned_address_value_fifo;//hold the value of alingned address in FIFO range which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_fifo_enabled_with_one_fifo_range_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_fifo_enabled_with_one_fifo_range_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

 start_address = tilelink_cfg.slave_cfg[0].mem_fifo_range[0];
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 start_address_fifo = tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0];
 range_address_fifo = tilelink_cfg.slave_cfg[0].mem_fifo_range[0];
 end_address_fifo   = (start_address_fifo + range_address_fifo);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 for(int k=start_address_fifo;k<end_address_fifo;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_fifo.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

 address_size_fifo = alingned_address_fifo.size()-1;
 alingned_address_value_fifo = alingned_address_fifo[$urandom_range(0,address_size_fifo)];
 

   source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_one_fifo_range_seq")


   source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == source;
                              tr1.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_one_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_one_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == source;
                              tr3.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_one_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == source;
                              tr4.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_one_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == source;
                              tr5.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_one_fifo_range_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j

  `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_fifo_enabled_with_one_fifo_range_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_fifo_enabled_with_two_fifo_range_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address_fifo, range_address_fifo, end_address_fifo;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_fifo_1, range_address_fifo_1, end_address_fifo_1;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  bit[63:0] alingned_address_fifo[$], alingned_address_fifo_1[$];//queue to hold alingned addresses for the particular a_size for FIFO range
  int address_size;//to hold the no of total alingned addresses FIFO values
  int address_size_fifo;//to hold the no of total alingned addresses
  int address_size_fifo_1;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[63:0] alingned_address_value_fifo;//hold the value of alingned address in FIFO range which is finally going to be driven
  bit[63:0] alingned_address_value_fifo_1;//hold the value of alingned address in FIFO range which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_fifo_enabled_with_two_fifo_range_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_fifo_enabled_with_two_fifo_range_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


 start_address_fifo_1 = tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1];
 range_address_fifo_1 = tilelink_cfg.slave_cfg[0].mem_fifo_range[1];
 end_address_fifo_1   = (start_address_fifo_1 + range_address_fifo_1);

 start_address = end_address_fifo_1;
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 start_address_fifo = tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0];
 range_address_fifo = tilelink_cfg.slave_cfg[0].mem_fifo_range[0];
 end_address_fifo   = (start_address_fifo + range_address_fifo);

 backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 for(int k=start_address_fifo;k<end_address_fifo;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_fifo.push_back(k);
 end

 for(int k=start_address_fifo_1;k<end_address_fifo_1;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_fifo_1.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

 address_size_fifo = alingned_address_fifo.size()-1;
 alingned_address_value_fifo = alingned_address_fifo[$urandom_range(0,address_size_fifo)];
 
 address_size_fifo_1 = alingned_address_fifo_1.size()-1;
 alingned_address_value_fifo_1 = alingned_address_fifo_1[$urandom_range(0,address_size_fifo_1)];

   source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_two_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == source;
                              tr1.a_address == alingned_address_value_fifo_1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_two_fifo_range_seq")


   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_two_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == source;
                              tr3.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_two_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == source;
                              tr4.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_two_fifo_range_seq")

   source++;
   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == source;
                              tr5.a_address == alingned_address_value_fifo_1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_enabled_with_two_fifo_range_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

 end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_fifo_enabled_with_two_fifo_range_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_fifo_disabled_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_fifo, range_address_fifo, end_address_fifo;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_fifo_1, range_address_fifo_1, end_address_fifo_1;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  bit[63:0] alingned_address_fifo[$], alingned_address_fifo_1[$];//queue to hold alingned addresses for the particular a_size for FIFO range
  int address_size;//to hold the no of total alingned addresses FIFO values
  int address_size_fifo;//to hold the no of total alingned addresses
  int address_size_fifo_1;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[63:0] alingned_address_value_fifo;//hold the value of alingned address in FIFO range which is finally going to be driven
  bit[63:0] alingned_address_value_fifo_1;//hold the value of alingned address in FIFO range which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_fifo_disabled_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_fifo_disabled_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

 start_address_fifo_1 = tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1];
 range_address_fifo_1 = tilelink_cfg.slave_cfg[0].mem_fifo_range[1];
 end_address_fifo_1   = (start_address_fifo_1 + range_address_fifo_1);

 start_address = end_address_fifo_1;
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 start_address_fifo = tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0];
 range_address_fifo = tilelink_cfg.slave_cfg[0].mem_fifo_range[0];
 end_address_fifo   = (start_address_fifo + range_address_fifo);

 backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 for(int k=start_address_fifo;k<end_address_fifo;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_fifo.push_back(k);
 end

 for(int k=start_address_fifo_1;k<end_address_fifo_1;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_fifo_1.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

 address_size_fifo = alingned_address_fifo.size()-1;
 alingned_address_value_fifo = alingned_address_fifo[$urandom_range(0,address_size_fifo)];
 
 address_size_fifo_1 = alingned_address_fifo_1.size()-1;
 alingned_address_value_fifo_1 = alingned_address_fifo_1[$urandom_range(0,address_size_fifo_1)];

   source++;

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_disabled_seq")
   source++;

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == source;
                              tr1.a_address == alingned_address_value_fifo_1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_disabled_seq")
   source++;

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_disabled_seq")

   source++;

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == source;
                              tr3.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_disabled_seq")
   source++;

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == source;
                              tr4.a_address == alingned_address_value_fifo;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_disabled_seq")

   source++;

   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == source;
                              tr5.a_address == alingned_address_value_fifo_1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_fifo_disabled_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

 end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif 

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_fifo_disabled_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 
    `uvm_info("body", $sformatf("%0s to get cfg handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq")


   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq")

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == 9;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq")

   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == 10;
                              tr5.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq")


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
     repeat(5) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;
     #5ps;
     p_sequencer.reset_mp.reset = 1'b1;
     repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 100 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b0;
     repeat(5) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;

 `ifndef DATA_INTEGRITY_DISABLE

 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif 

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_dynamic_reset_inbw_req_with_timeout_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 
    `uvm_info("body", $sformatf("%0s to get cfg handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq")


   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq")

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == 9;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq")

   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == 10;
                              tr5.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq")

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
     repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 10 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b1;
     repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 100 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b0;
     repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
   `svt_xvm_send(tr5)

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_dynamic_reset_after_all_req_with_timeout_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_dynamic_reset_after_all_req_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_dynamic_reset_after_all_req_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_dynamic_reset_after_all_req_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 
    `uvm_info("body", $sformatf("%0s to get cfg handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_seq")


   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_seq")

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_seq")

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 8;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_seq")

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == 9;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_seq")

   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == 10;
                              tr5.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_dynamic_reset_after_all_req_seq")


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
     repeat(3) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 3 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b1;
     repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 100 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b0;
   `svt_xvm_send(tr5)

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif 

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_dynamic_reset_after_all_req_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_delay_enabled_with_0_verif_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets = 20;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_delay_enabled_with_0_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_delay_enabled_with_0_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                              tr.a_vld_2_d_rdy_delay == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_enabled_with_0_verif_seq")

   begin
   `svt_xvm_send(tr)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_delay_enabled_with_0_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_masks_related_checks_verif_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;

  `uvm_object_utils(svt_tilelink_ul_masks_related_checks_verif_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  cust_svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_masks_related_checks_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(cust_svt_tilelink_system_configuration)::get(m_sequencer, get_type_name(), "cfg", tilelink_cfg);
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);

 for(int i=0;i<8;i++)
 begin

   foreach(tilelink_cfg.master_cfg[j]) tilelink_cfg.master_cfg[j].data_width = (2**i)*8;
   foreach(tilelink_cfg.slave_cfg[j]) tilelink_cfg.slave_cfg[j].data_width = (2**i)*8;

   //reconfigure
    foreach(env.sys_env.master[k]) 
      env.sys_env.master[k].reconfigure_via_task(tilelink_cfg.master_cfg[k]);
    foreach(env.sys_env.slave[k]) 
      env.sys_env.slave[k].reconfigure_via_task(tilelink_cfg.slave_cfg[k]);

    //data_width
    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

 
   //driving first transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_masks_related_checks_verif_seq")
    else begin
      tr.a_mask[0][tr.a_size+:`SVT_TILELINK_DATA_WIDTH/8-1] = $urandom; //since mask not aligned with address and a_size, error should flash here.
    end
   `svt_xvm_send(tr)

   //checker invalid_mask_val_error expected.
   //checker mask_not_contiguous_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 2;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_masks_related_checks_verif_seq")
    else begin
      if(tr.a_size == a_size_val)
        tr.a_mask[0][a_size_val] = 1'b0;
      else begin
        tr.a_mask[0][tr.a_size+1+:`SVT_TILELINK_DATA_WIDTH/8-1] = $urandom;
      end
    end
   `svt_xvm_send(tr)

   //checker invalid_mask_val_error expected.
   //checker invalid_low_mask_for_get_op_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr.a_source == 1;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_masks_related_checks_verif_seq")
    else begin
      tr.a_mask[0][tr.a_size] = 1'b0;
      tr.a_mask[0][tr.a_size+1+:`SVT_TILELINK_DATA_WIDTH/8-1] = $urandom;
    end
   `svt_xvm_send(tr)

   //checker a_mask_not_high_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 2;
                              tr.a_size == a_size_val; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_masks_related_checks_verif_seq")
    else begin
      if(tr.a_size == a_size_val)
        tr.a_mask[0][a_size_val] = 1'b0;
    end
   `svt_xvm_send(tr)

 end//for

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_masks_related_checks_verif_seq

class svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  uvm_object my_parent;
  svt_tilelink_master_agent my_mst_agent;
  svt_tilelink_master_identical_inflight_identifier_error_callback cust_inflight_a_source_error_callback;

  `uvm_object_utils(svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)

    cust_inflight_a_source_error_callback = new("cust_inflight_a_source_error_callback");

    my_parent = p_sequencer.master_sequencer[0].get_parent();
    $cast(my_mst_agent, my_parent);
    

   //checker <a_address_not_alligned_to_a_size_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size == 1; //2 bytes sent, addr should be aligned to this
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                              tr.a_vld_2_a_vld_assert_delay[0] == 4;
                              tr.a_vld_deassert_delay[0] == 4;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = 'h3; //address not alligned to a_size, checker should flash here.
    end
   `svt_xvm_send(tr)

    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_inflight_a_source_error_callback);

   //checker <a_address_not_alligned_to_a_size_error> expected.
   //checker <invalid_mask_val_error> expected [This error is expected since, address sent is not aligned with s_size, so checker calculation for mask is based on that, while Master is sending mask on basis of a_size=2].
   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5; //source id same as previous source, error should flash here
                              tr.a_size == 2; //4 bytes 
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                              tr.a_vld_2_a_vld_assert_delay[0] == 2;
                              tr.a_vld_deassert_delay[0] == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = 'h33; //address not aligned, checker should flash here
    end
   `svt_xvm_send(tr)
    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_inflight_a_source_error_callback);

   //checker <a_address_not_alligned_to_a_size_error> expected.
   //checker <rsvd_a_corrupt_value_in_get_op_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr.a_source == 1;
                              tr.a_size == 3; //8 bytes required
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                              tr.a_vld_2_a_vld_assert_delay[0] == 3;
                              tr.a_vld_deassert_delay[0] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_corrupt[0] = 1; //since for GET msgs, a_corrupt should be 1, error should flash here
      tr.a_address = 'h9; //unaligned address, checker should flash here
    end
   `svt_xvm_send(tr)


    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_inflight_a_source_error_callback);

   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 1; //source id same as previous source, error should flash here
                              tr.a_size == 3;
                              tr.a_address == 'h8;
                              tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr.a_vld_deassert_delay.size() == 1;
                              tr.a_vld_2_a_vld_assert_delay[0] == 2;
                              tr.a_vld_deassert_delay[0] == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
    end
   `svt_xvm_send(tr)

    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_inflight_a_source_error_callback);

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_a_addr_crpt_inflight_msgs_checks_verif_seq

class svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  tilelink_slave_resp_wo_req_callback               slv_resp_wo_req;
  tilelink_slave_response_opcode_error_callback     response_opcode_err;

  `uvm_object_utils(svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 

    slv_resp_wo_req         = new("slv_resp_wo_req");
    response_opcode_err     = new("response_opcode_err");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

   svt_tilelink_slave_callback_pool::add(my_agent.slave,slv_resp_wo_req);

   //checker <resp_wo_req_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end


   //checker <resp_wo_req_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr1.a_source == 4;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end

   //checker <resp_wo_req_error> expected.
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 2;
                              tr2.a_size inside {[0:3]};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end

   //checker <msg_put_full_rsp_error> expected.
   //Since d_source is set to 4 via EI, and 4 source is for put_full data in above sequence, the error will flash.
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == 1;
                              tr3.a_size inside {[0:3]};
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")


    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
        `svt_xvm_send(tr2)
        `svt_xvm_send(tr3)
      end
      begin

        //EI added for 1st Master txn
        slv_resp_wo_req.d_source=8; //source id sent from slave is 8, but Master sent the source id as 5. Checker should flash here.
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        slv_resp_wo_req.d_source=6; //source id sent from slave is 6, but Master sent the source id as 6. Checker should flash here.
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

        //EI added for 3rd Master txn
        slv_resp_wo_req.d_source=10; //source id sent from slave is 10, but Master sent the source id as 6. Checker should flash here.
        `svt_xvm_send(slv_tr2)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

        //EI added for 4th Master txn
        slv_resp_wo_req.d_source=4; //source id sent from slave is 4, and Master sent the source id as 1 but since source id 4 is also sent by Master in above txn, so no checker should flash here.
        `svt_xvm_send(slv_tr3)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
      end
    join

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,slv_resp_wo_req);

   //added clocks to sync between above set of txns and lower.
   repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //add callback to insert wrong opcode during putfulldata and put partial data
   svt_tilelink_slave_callback_pool::add(my_agent.slave,response_opcode_err);

   //checker <msg_put_part_rsp_error> expected.
   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end


   //checker <msg_put_full_rsp_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr1.a_source == 4;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end

   //checker <msg_put_full_rsp_error> expected.
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 3;
                              tr2.a_size inside {[0:3]};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq")

    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
        `svt_xvm_send(tr2)
      end
      begin

        //EI added for 1st Master txn
        response_opcode_err.d_opcode=1; //opcode sent wrong
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        response_opcode_err.d_opcode=1; //opcode sent wrong
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

        //EI added for 3nd Master txn
        response_opcode_err.d_opcode=0; //opcode sent wrong for get
        `svt_xvm_send(slv_tr2)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
    join


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_invali_d_source_and_invalid_response_error_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_verif_reconfigure_data_width_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  int total_packets=200;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int packet_sent_per_width;//Toatal RESP that has come in total for each data width  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_verif_reconfigure_data_width_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_verif_reconfigure_data_width_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);
    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

  backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   for(int i=0;i<6;i++)//FOR 16 BYTES DATA BUS WIDTH
   begin
       case(i)
       0:data_size = 2**5;//4 BYTE DATA BUS
       1:data_size = 2**6;//8 BYTE DATA BUS
       2:data_size = 2**7;//16 BYTE DATA BUS
       3:data_size = 2**8;//32 BYTE DATA BUS
       4:data_size = 2**9;//64 BYTE DATA BUS
       5:data_size = 2**10;//128 BYTE DATA BUS
       endcase

    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].data_width = data_size;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].data_width = data_size;
    foreach(env.sys_env.master[i]) 
      env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
    foreach(env.sys_env.slave[i]) 
      env.sys_env.slave[i].reconfigure_via_task(tilelink_cfg.slave_cfg[i]);

 for(int j=0;j<total_packets;j++)
 begin

 source++;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_verif_reconfigure_data_width_seq")

   begin
   `svt_xvm_send(tr)
   end

 end//for j

  wait(tilelink_cfg.master_cfg[0].tilelink_master_if.resp_num == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
  repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

 end//for i
 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

 begin//5th fork begin
   backdoor_handle.resp_count_per_data_width(packet_sent_per_width);
 end//5th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_verif_reconfigure_data_width_seq

//--------------------------------------------------------------------------------------------------------------------------------
class outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit [15:0] source;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].num_outstanding_txn = 3;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].outstanding_txn_timeout = 3;
    foreach(env.sys_env.slave[i])
      env.sys_env.slave[i].reconfigure_via_task(tilelink_cfg.slave_cfg[i]);

  source++;

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq")

  source++;

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == source;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq")

  source++;

   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq")
  source++;

   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == source;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq")
  source++;

   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr4.a_source == source;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq")


    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  int total_packets=50;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].slv_delay_en = 0;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].slv_vld_rdy_delay_en = 0;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].slv_cross_chnl_delay_en = 0;

    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].mst_delay_en = 0;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].mst_vld_rdy_delay_en = 0;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].mst_cross_chnl_delay_en = 0;

    foreach(env.sys_env.slave[i])
      env.sys_env.slave[i].reconfigure_via_task(tilelink_cfg.slave_cfg[i]);
    foreach(env.sys_env.master[i]) 
      env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_size == a_size_value;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq")


   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq")


   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq")



   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_delay_enabled_with_test_disabled_with_reconfig_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  int total_packets=50;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].min_a_rdy_a_rdy_assert_delay = 'h3;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].max_a_rdy_a_rdy_assert_delay = 'h7;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].min_a_rdy_deassert_delay = 'h3;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].max_a_rdy_deassert_delay = 'h7;


    foreach(env.sys_env.slave[i])
      env.sys_env.slave[i].reconfigure_via_task(tilelink_cfg.slave_cfg[i]);
    foreach(env.sys_env.master[i]) 
      env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq")

 source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq")

 source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq")

 source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr3.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr3.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_delay_0_with_test_enabled_with_reconfig_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].min_d_rdy_d_rdy_assert_delay = 'h3;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].max_d_rdy_d_rdy_assert_delay = 'h7;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].min_d_rdy_deassert_delay = 'h3;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].max_d_rdy_deassert_delay = 'h7;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].min_d_vld_d_rdy_assert_delay = 'h3;
    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].max_d_vld_d_rdy_assert_delay = 'h7;

    foreach(env.sys_env.master[i]) 
      env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == 5;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq")


  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == 6;
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq")

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == 7;
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq")

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == 8;
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr3.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr3.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif
 

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_delay_0_with_test_master_enabled_with_reconfig_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_d_vld2vld_delay_using_retain_txn_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_d_vld2vld_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_d_vld2vld_delay_using_retain_txn_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 2;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 0;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_verif_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_verif_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_d_vld2vld_delay_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_d_vld2vld_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 5;
                              slv_tr.a_rdy_deassert_delay == 3;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_a_rdy2rdy_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=50;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 2;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 3;
                              slv_tr.a_rdy_deassert_delay == 4;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_cross_channel_delay_using_retain_txn_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_cross_channel_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_cross_channel_delay_using_retain_txn_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 0;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 3; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_cross_channel_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_valid_ready_channel_delay_using_retain_txn_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_valid_ready_channel_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_valid_ready_channel_delay_using_retain_txn_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 0;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")

   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr1.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr2.a_vld_deassert_delay[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_same_channel_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_valid_ready_channel_delay_using_retain_txn_verif_seq


class svt_tilelink_reset_checks_verify_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;

  `uvm_object_utils(svt_tilelink_reset_checks_verify_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  cust_svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
  uvm_object my_parent;
  svt_tilelink_slave_agent  my_slv_agent;
  svt_tilelink_master_agent my_mst_agent;

  svt_tilelink_master_valid_values_in_reset_error_callback            cust_valid_values_in_reset_error_callback;
  svt_tilelink_master_valid_signal_duration_in_reset_error_callback   cust_valid_signal_duration_in_reset_error_callback;
  svt_tilelink_master_valid_assertion_post_reset_error_callback       cust_valid_assertion_post_reset_error_callback;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_reset_checks_verify_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(cust_svt_tilelink_system_configuration)::get(m_sequencer, get_type_name(), "cfg", tilelink_cfg);
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);


    cust_valid_values_in_reset_error_callback           = new("cust_valid_values_in_reset_error_callback");
    cust_valid_signal_duration_in_reset_error_callback  = new("cust_valid_signal_duration_in_reset_error_callback");
    cust_valid_assertion_post_reset_error_callback      = new("cust_valid_assertion_post_reset_error_callback");

    my_parent = p_sequencer.master_sequencer[0].get_parent();
    $cast(my_mst_agent, my_parent);

    //adding callback to insert error sucn that a_valid becomes anything but 0 during reset assertion period.
    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_valid_values_in_reset_error_callback);

    for(int i=1;i<4;i++)
    begin

       cust_valid_values_in_reset_error_callback.valid_val = i;
       //driving random a_opcode
      `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
      if (!tr.randomize() with { 
                                 tr.a_source == 5;
                                 tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                                 tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_reset_checks_verify_seq")
      `svt_xvm_send(tr)

      repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
      p_sequencer.reset_mp.reset = 1'b1;
      repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 100 posedge of clk;
       p_sequencer.reset_mp.reset = 1'b0;
      repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;

    end//for
    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_valid_values_in_reset_error_callback);

    //adding callback for error valid_values_in_reset_error
    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_valid_signal_duration_in_reset_error_callback);

    for(int i=1;i<4;i++)
    begin

        cust_valid_signal_duration_in_reset_error_callback.valid_duration= 1;
        if(i==1)
          cust_valid_signal_duration_in_reset_error_callback.valid_low_duration= 1; //low for 1 clock
        else if(i==2)
          cust_valid_signal_duration_in_reset_error_callback.valid_low_duration= 98; //low for 98 clocks
        else if(i==3)
          cust_valid_signal_duration_in_reset_error_callback.valid_low_duration= 100; //low for 100 clocks

        cust_valid_signal_duration_in_reset_error_callback.valid_high_duration= 1; //high for 1 clock cycle only

       //driving random a_opcode
      `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
      if (!tr.randomize() with { 
                                 tr.a_source == 5;
                                 tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                                 tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_reset_checks_verify_seq")
      `svt_xvm_send(tr)

      repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
      p_sequencer.reset_mp.reset = 1'b1;
      repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 100 posedge of clk;
       p_sequencer.reset_mp.reset = 1'b0;
      repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;

    end//for

    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_valid_signal_duration_in_reset_error_callback);

    //adding callback to insert error such that *_valid's arrive before reset de-assertion.
    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_valid_assertion_post_reset_error_callback);

    cust_valid_assertion_post_reset_error_callback.valid_assert = 1;

     //driving random a_opcode
    `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
    if (!tr.randomize() with { 
                               tr.a_source == 5;
                               tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                               tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                             })
                              `uvm_error("Randomization Failure","svt_tilelink_reset_checks_verify_seq")
    `svt_xvm_send(tr)

    repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
    p_sequencer.reset_mp.reset = 1'b1;
    repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 100 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b0;
    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_valid_assertion_post_reset_error_callback);
    repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;


     //driving random a_opcode
    `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
    if (!tr.randomize() with { 
                               tr.a_source == 5;
                               tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                               tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                             })
                              `uvm_error("Randomization Failure","svt_tilelink_reset_checks_verify_seq")
    `svt_xvm_send(tr)

    //insert dynamic reset for 10 clock only
    repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
    p_sequencer.reset_mp.reset = 1'b1;
    repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 10 posedge of clk;
     p_sequencer.reset_mp.reset = 1'b0;
    repeat(2) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;

     //driving random a_opcode
    `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
    if (!tr.randomize() with { 
                               tr.a_source == 5;
                               tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                               tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                             })
                              `uvm_error("Randomization Failure","svt_tilelink_reset_checks_verify_seq")
    `svt_xvm_send(tr)

    repeat(2000) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 10 posedge of clk;

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_reset_checks_verify_seq

class svt_tilelink_bad_fifo_ordering_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr[];
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] a_size_val;//To hold the value of data_width, max value is 1024
  int a_addr_val;
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  tilelink_slave_ooo_fifo_resp_error_callback ooo_fifo_resp_error_callback;

  `uvm_object_utils(svt_tilelink_bad_fifo_ordering_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_bad_fifo_ordering_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 

    ooo_fifo_resp_error_callback = new("ooo_fifo_resp_error_callback");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

    tr = new[10];

   svt_tilelink_slave_callback_pool::add(my_agent.slave,ooo_fifo_resp_error_callback);

   for(int i=1;i<=10;i++) begin

     a_size_val = $urandom_range(0, 3);
      if(i<=5) begin
        for(int j=tilelink_cfg.slave_cfg[0].mem_fifo_range[0]-1; j>=tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0];j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end
      else if(i>5) begin
        for(int j='h199; j>='h130;j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end

      //checker <out_of_order_for_fifo_response_error> expected.
      `svt_xvm_create_on(tr[i-1],p_sequencer.master_sequencer[0])
      if (!tr[i-1].randomize() with { 
                                 tr[i-1].ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                                 tr[i-1].a_source       == i;
                                 tr[i-1].a_size         == a_size_val;
                                 tr[i-1].a_address      == a_addr_val;
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_bad_fifo_ordering_seq")
       else begin
       end
    end //for


    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_bad_fifo_ordering_seq")

    fork 
      begin
        int i;
        for(i=0;i<tr.size;i++)
          `svt_xvm_send(tr[i])
      end
      begin

        //EI added to send wrong fifo order.
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

      end
    join

    tr.delete();
    tr = new[10];

    repeat(500) @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

    //here 3 different fifo ranges are used to verify the checker
   for(int i=1;i<=10;i++) begin

     a_size_val = $urandom_range(0, 3);
      if(i==1 ||i == 3 || i == 5) begin
        for(int j=tilelink_cfg.slave_cfg[0].mem_fifo_range[0]+tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]-1; j>=tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0];j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end
      else if(i==2 ||i == 8) begin
        for(int j=tilelink_cfg.slave_cfg[0].mem_fifo_range[1]+tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]-1; j>=tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1];j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end
      else if(i==6 ||i == 9) begin
        for(int j=tilelink_cfg.slave_cfg[0].mem_fifo_range[2]+tilelink_cfg.slave_cfg[0].mem_fifo_base_address[2]-1; j>=tilelink_cfg.slave_cfg[0].mem_fifo_base_address[2];j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end
      else begin
        for(int j='h249; j>='h156;j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end

      //checker <out_of_order_for_fifo_response_error> expected.
      `svt_xvm_create_on(tr[i-1],p_sequencer.master_sequencer[0])
      if (!tr[i-1].randomize() with { 
                                 tr[i-1].ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                                 tr[i-1].a_source       == i;
                                 tr[i-1].a_size         == a_size_val;
                                 tr[i-1].a_address      == a_addr_val;
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_bad_fifo_ordering_seq")
       else begin
       end
    end //for


    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_bad_fifo_ordering_seq")

    fork 
      begin
        int i;
        for(i=0;i<tr.size;i++)
          `svt_xvm_send(tr[i])
      end
      begin

        //EI added to send wrong fifo order.
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

      end
    join


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_bad_fifo_ordering_seq

class svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  tilelink_slave_resp_dparam_error_callback     cust_resp_dparam_error;
  tilelink_slave_resp_dsize_error_callback      cust_resp_dsize_error;
  tilelink_slave_dcorrupt_resp_error_callback   cust_dcorrupt_resp_error;
  tilelink_slave_denied_resp_error_callback     cust_denied_resp_error;
  uvm_sequence_item rsp;

  `uvm_object_utils(svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 

    cust_resp_dparam_error    = new("cust_resp_dparam_error");
    cust_resp_dsize_error     = new("cust_resp_dsize_error");
    cust_dcorrupt_resp_error  = new("cust_dcorrupt_resp_error");
    cust_denied_resp_error    = new("cust_denied_resp_error");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_resp_dparam_error);

   //checker <rsvd_d_param_tl_c_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <rsvd_d_param_tl_c_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr1.a_source == 6;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 0; //d_denied is disabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr1.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr1.a_rdy_deassert_delay == 1;
                              slv_tr1.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr1.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        //EI added for 1st Master txn
        cust_resp_dparam_error.d_param=2; //d_param sent from slave is 8, but it s rsvd for tl-ul and tl-uh. Error should flash.
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        cust_resp_dparam_error.d_param=1; //d_param sent from slave is 1, but it s rsvd for tl-ul and tl-uh. Error should flash.
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,cust_resp_dparam_error);

   //added clocks to sync between above set of txns and lower.
   repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //add callback to insert unmatched d_size than a_size.
   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_resp_dsize_error);

   //checker <d_size_not_identical_to_a_size_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr.a_source == 5;
                              tr.a_size   == 0;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <d_size_not_identical_to_a_size_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr1.a_source == 6;
                              tr1.a_size   == 3;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 0; //d_denied is disabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr1.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr1.a_rdy_deassert_delay == 1;
                              slv_tr1.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr1.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        //EI added for 1st Master txn
        cust_resp_dsize_error.d_size = 1; //for a_size as 0, d_size of 1 is sent forcefully
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        cust_resp_dsize_error.d_size = 0; //for a_size as 3, d_size of 0 is sent forcefully
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,cust_resp_dsize_error);

   //added clocks to sync between above set of txns and lower.
   repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //add callback to insert unmatched d_size than a_size.
   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_dcorrupt_resp_error);

   //checker <rsvd_d_corrupt_val_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA}; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <rsvd_d_corrupt_val_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA}; 
                              tr1.a_source == 6;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 0; //d_denied is disabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr1.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr1.a_rdy_deassert_delay == 1;
                              slv_tr1.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr1.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   //added clocks to sync between above set of txns and lower.
   repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //checker <d_corrupt_low_while_d_denied_high_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <d_corrupt_low_while_d_denied_high_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr1.a_source == 6;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 1; //d_denied is enabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 1; //d_denied is enabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr1.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr1.a_rdy_deassert_delay == 1;
                              slv_tr1.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr1.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,cust_dcorrupt_resp_error);

    //added clocks to sync between above set of txns and lower.
   repeat(10) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_denied_resp_error);
   
   //checking denied_range
   //checker <denied_resp_range_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == 15;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]: (tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0]-1)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <denied_resp_range_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.a_source == 16;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[1]: (tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[1]+tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[1]-1)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")

   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 0; //d_denied is disabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
    join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_invalid_d_param_d_size_d_corpt_error_seq

class svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;

  `uvm_object_utils(svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 

   //checker <rsvd_a_param_value_tl_ul_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
    else begin
      tr.a_param = 1;
    end

   //checker <rsvd_a_param_value_tl_ul_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr1.a_source == 6;
                              tr1.a_size inside {[0:3]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
    else begin
      tr1.a_param = 2;
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 0; //d_denied is disabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr1.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr1.a_rdy_deassert_delay == 1;
                              slv_tr1.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr1.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        //EI added for 2nd Master txn
        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
    join

   //checker <out_of_slv_addr_boundary_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA}; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:3]};
                              tr.a_address inside {['h0:tilelink_cfg.slave_cfg[0].mem_base_address]}; //address range outside configured range. Error should flash here
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
    else begin
    end

   //checker <out_of_slv_addr_boundary_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA}; 
                              tr1.a_source == 6;
                              tr1.a_size == 3;
                              tr1.a_address inside {[(tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range - 2) : 'h250]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 0; //d_denied is disabled
                              slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr1.d_vld_2_d_vld_assert_delay[0] == 3;
                              slv_tr1.a_rdy_2_a_rdy_assert_delay == 2;
                              slv_tr1.a_rdy_deassert_delay == 1;
                              slv_tr1.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr1.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin

        `svt_xvm_send(slv_tr)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

        `svt_xvm_send(slv_tr1)
        while(!(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready === 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid === 1))
          @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk
        @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

      end
    join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_boundry_check_a_param_rsvd_error_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_100000_req_meme_time_profile_seq extends uvm_sequence;

  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  int total_packets=17000;//total no of 100000 REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int packet_sent_per_width;//Toatal RESP that has come in total for each data width  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_100000_req_meme_time_profile_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_100000_req_meme_time_profile_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);
    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

  backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

   for(int i=0;i<6;i++)//FOR 16 BYTES DATA BUS WIDTH
   begin
       case(i)
       0:data_size = 2**5;//4 BYTE DATA BUS
       1:data_size = 2**6;//8 BYTE DATA BUS
       2:data_size = 2**7;//16 BYTE DATA BUS
       3:data_size = 2**8;//32 BYTE DATA BUS
       4:data_size = 2**9;//64 BYTE DATA BUS
       5:data_size = 2**10;//128 BYTE DATA BUS
       endcase

    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].data_width = data_size;
    foreach(tilelink_cfg.slave_cfg[i]) tilelink_cfg.slave_cfg[i].data_width = data_size;
    foreach(env.sys_env.master[i]) 
      env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
    foreach(env.sys_env.slave[i]) 
      env.sys_env.slave[i].reconfigure_via_task(tilelink_cfg.slave_cfg[i]);

 for(int j=0;j<total_packets;j++)
 begin

 source++;
 if(source == 65535) source = 0;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_100000_req_meme_time_profile_seq")


   begin
   `svt_xvm_send(tr)
   end

 end//for j

   wait(packet_sent_per_width == total_packets);
   packet_sent_per_width = 0;

 end//for i
 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

 begin//5th fork begin
   backdoor_handle.resp_count_per_data_width(packet_sent_per_width);
 end//5th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_100000_req_meme_time_profile_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_resp_delay, range_address_resp_delay, end_address_resp_delay;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  bit[63:0] alingned_address_resp_delay[$];//queue to hold alingned addresses for the particular a_size for RESP delay range
  int address_size;//to hold the no of total alingned addresses values
  int address_size_resp_delay;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[63:0] alingned_address_value_resp_delay;//hold the value of alingned address in RESP DELAY range which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

 start_address = tilelink_cfg.slave_cfg[0].resp_delay_address_range[0];
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 start_address_resp_delay = tilelink_cfg.slave_cfg[0].resp_delay_base_address[0];
 range_address_resp_delay = tilelink_cfg.slave_cfg[0].resp_delay_address_range[0];
 end_address_resp_delay   = (start_address_resp_delay + range_address_resp_delay);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 for(int k=start_address_resp_delay;k<end_address_resp_delay;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_resp_delay.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

 address_size_resp_delay = alingned_address_resp_delay.size()-1;
 alingned_address_value_resp_delay = alingned_address_resp_delay[$urandom_range(0,address_size_resp_delay)];
 

   source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              //tr.a_address == alingned_address_value_resp_delay;
                              tr.a_address == 'h60;
                              tr.a_vld_2_a_vld_assert_delay[0] == 13;
                              tr.a_vld_deassert_delay[0] == 4;
                              tr.a_size                   == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq")


   source++;
//   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
//   if (!tr1.randomize() with { 
//                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
//                              tr1.a_source == source;
//                              tr1.a_address == alingned_address_value_resp_delay;
//                              tr1.a_vld_2_a_vld_assert_delay[0] == 16;
//                              tr1.a_vld_deassert_delay[0] == 0;
//                            })
//                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq")
//
   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_address == 'h60;
                              tr2.a_vld_2_a_vld_assert_delay.size() == 1;
                              tr2.a_vld_2_a_vld_assert_delay[0] == 11;
                              tr2.a_vld_deassert_delay.size() == 1;
                              tr2.a_vld_deassert_delay[0] == 16;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq")

   source++;
//   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
//   if (!tr3.randomize() with { 
//                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
//                              tr3.a_source == source;
//                              tr3.a_address == alingned_address_value;
//                              tr3.a_vld_2_a_vld_assert_delay[0] == 16;
//                              tr3.a_vld_deassert_delay[0] == 0;
//                            })
//                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq")
//
//   source++;
//   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
//   if (!tr4.randomize() with { 
//                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
//                              tr4.a_source == source;
//                              tr4.a_address == alingned_address_value;
//                              tr4.a_vld_2_a_vld_assert_delay[0] == 16;
//                              tr4.a_vld_deassert_delay[0] == 0;
//                            })
//                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq")
//
//   source++;
//   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
//   if (!tr5.randomize() with { 
//                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
//                              tr5.a_source == source;
//                              tr5.a_address == alingned_address_value;
//                              tr5.a_vld_2_a_vld_assert_delay[0] == 16;
//                              tr5.a_vld_deassert_delay[0] == 0;
//                            })
//                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq")
//


   begin
   `svt_xvm_send(tr)
//   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
//   `svt_xvm_send(tr3)
//   `svt_xvm_send(tr4)
//   `svt_xvm_send(tr5)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_region_based_a_vld_d_vld_cross_channel_delay_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_resp_delay, range_address_resp_delay, end_address_resp_delay;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  bit[63:0] alingned_address_resp_delay[$];//queue to hold alingned addresses for the particular a_size for RESP delay range
  int address_size;//to hold the no of total alingned addresses values
  int address_size_resp_delay;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[63:0] alingned_address_value_resp_delay;//hold the value of alingned address in RESP DELAY range which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


 start_address = tilelink_cfg.slave_cfg[0].resp_delay_address_range[0];
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 start_address_resp_delay = tilelink_cfg.slave_cfg[0].resp_delay_base_address[0];
 range_address_resp_delay = tilelink_cfg.slave_cfg[0].resp_delay_address_range[0];
 end_address_resp_delay   = (start_address_resp_delay + range_address_resp_delay);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 for(int k=start_address_resp_delay;k<end_address_resp_delay;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_resp_delay.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

 address_size_resp_delay = alingned_address_resp_delay.size()-1;
 alingned_address_value_resp_delay = alingned_address_resp_delay[$urandom_range(0,address_size_resp_delay)];
 

   source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_size == a_size_value;
                              tr.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq")


   source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == source;
                              tr1.a_size == a_size_value;
                              tr1.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq")

   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == source;
                              tr2.a_size == a_size_value;
                              tr2.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq")

   source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr3.a_source == source;
                              tr3.a_size == a_size_value;
                              tr3.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq")

   source++;
   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr4.a_source == source;
                              tr4.a_size == a_size_value;
                              tr4.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq")

   source++;
   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == source;
                              tr5.a_size == a_size_value;
                              tr5.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_region_based_d_vld_d_vld_delay_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_region_based_denied_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] start_address_resp_delay, range_address_resp_delay, end_address_resp_delay;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  bit[63:0] alingned_address_resp_delay[$];//queue to hold alingned addresses for the particular a_size for RESP delay range
  int address_size;//to hold the no of total alingned addresses values
  int address_size_resp_delay;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  bit[63:0] alingned_address_value_resp_delay;//hold the value of alingned address in RESP DELAY range which is finally going to be driven
  int count;//to hold the total no of packets
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_region_based_denied_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_region_based_denied_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


 start_address = tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0];
 range_address = tilelink_cfg.slave_cfg[0].ul_only_address_range[0];
 end_address   = (start_address + range_address);
 
 start_address_resp_delay = tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0];
 range_address_resp_delay = tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0];
 end_address_resp_delay   = (start_address_resp_delay + range_address_resp_delay);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 for(int k=start_address;k<end_address;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address.push_back(k);
 end

 for(int k=start_address_resp_delay;k<end_address_resp_delay;k++) begin
   if(k % (2**a_size_value) == 0) alingned_address_resp_delay.push_back(k);
 end

 address_size = alingned_address.size()-1;
 alingned_address_value = alingned_address[$urandom_range(0,address_size)];

 address_size_resp_delay = alingned_address_resp_delay.size()-1;
 alingned_address_value_resp_delay = alingned_address_resp_delay[$urandom_range(0,address_size_resp_delay)];
 

   source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == source;
                              tr.a_size == a_size_value;
                              tr.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_denied_seq")


   source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr1.a_source == source;
                              tr1.a_size == a_size_value;
                              tr1.a_address == alingned_address_value;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_denied_seq")

   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr2.a_source == source;
                              tr2.a_size == a_size_value;
                              tr2.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_denied_seq")

   source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr3.a_source == source;
                              tr3.a_size == a_size_value;
                              tr3.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_denied_seq")

   source++;
   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr4.a_source == source;
                              tr4.a_size == a_size_value;
                              tr4.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_denied_seq")

   source++;
   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr5.a_source == source;
                              tr5.a_size == a_size_value;
                              tr5.a_address == alingned_address_value_resp_delay;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_region_based_denied_seq")


   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_region_based_denied_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_put_get_cmd_same_cycle_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int total_packets=20;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_ul_put_get_cmd_same_cycle_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_put_get_cmd_same_cycle_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body

  /** Define task body() */
  virtual task body();

    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
     p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

 source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_put_get_cmd_same_cycle_verif_seq")


   begin
   `svt_xvm_send(tr)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

   wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
 end//end of 1st fork begin

 begin//2nd fork begin
   backdoor_handle.backdoor_data();
 end//2nd fork end

 begin//3rd fork begin
   backdoor_handle.d_data_rx();
 end//3rd fork end

 begin//4th fork begin
   backdoor_handle.resp_count(resp_received);
 end//4th fork end

join_any

disable DATA_INTEGRITY; 

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_put_get_cmd_same_cycle_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  ul_get_backdoor_data backdoor_handle;//class handle for data integrity
  int address_size;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;

  `uvm_object_utils(svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq");
    super.new(name);
  endfunction 

  //---------------------------------------------------------------------------
  /** Raise an objection if this is the parent sequence */
  virtual task pre_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Raise Objection...", UVM_DEBUG)
      phase.raise_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask : pre_body
  
  /** Drop an objection if this is the parent sequence */
  virtual task post_body();
    uvm_phase phase;
    `uvm_info("pre_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("pre_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("pre_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    /** SVT configuration handle */ 
    svt_configuration cfg;
    `uvm_info("body", "Entering...", UVM_DEBUG)

    /** Get the SVT configuration */
    p_sequencer.get_cfg(cfg);

    /** Cast the SVT configuration handle on the local i3c configuration handle */
    if (!$cast(tilelink_cfg, cfg)) 
    begin
      `svt_xvm_fatal("body", "Unable to cast the configuration to a svt_tilelink_system_configuration class");
    end

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);


   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 5;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr.a_vld_2_a_vld_assert_delay[0] == 0;
                              tr.a_vld_deassert_delay[0] == 0;
                              tr.a_vld_2_d_rdy_delay == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq")



   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr1.a_source == 6;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr1.a_vld_2_a_vld_assert_delay[0] == 16;
                              tr1.a_vld_deassert_delay[0] == 0;
                              tr1.a_vld_2_d_rdy_delay == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq")


   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr2.a_source == 7;
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]: (tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0])]};
                              tr2.a_vld_2_a_vld_assert_delay[0] == 16;
                              tr2.a_vld_deassert_delay[0] == 0;
                              tr2.a_vld_2_d_rdy_delay == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq")



   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   end


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_ul_a_vld_2_d_rdy_cross_channel_delay_verif_seq

