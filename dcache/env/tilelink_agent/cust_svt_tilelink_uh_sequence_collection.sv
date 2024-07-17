`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_slave_denied_range_resp_error_callback)
`include `SVT_SOURCE_MAP_SUITE_MODULE(tilelink_svt,latest,svt_tilelink_master_identical_inflight_identifier_error_callback)

/*class for data integrity comparision*/
class uh_data_integrity;

  bit[7:0] get_data[];
  bit[7:0] backdoor_data_queue[int][];
  bit req_id[int];
  bit flag[int];
  bit flag_backdoor_id[int];
  bit flag_backdoor[int];
  bit[15:0] id_array[$];

 /*Task to capture d_data from master status and do the comparision with backdoor data*/
 task get_resp_master (svt_tilelink_master_status master_status);
  int data_size_integity;
  data_size_integity = 2**master_status.d_size;
  get_data = new[data_size_integity];

  if(master_status.d_data.size() > 0 && flag_backdoor_id.exists(master_status.d_source) == 0)
  begin

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


  /*Deleting the source ID which has been compared*/
  get_data.delete();
  backdoor_data_queue.delete(master_status.d_source);
  flag_backdoor_id[master_status.d_source] = 1;

 end

 endtask
endclass

/*class having tasks to get backdoor data, capture d_data from master status & count the total no of resp packets that has come on the bus*/
class get_backdoor_data extends uh_data_integrity; 

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  /** TILE_LINK env handle */ 
  tilelink_xvm_env env;

  bit status;
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  int resp_received;//Total RESP that has come 
  int req_resp_received;//Total REQ that has come 
  uh_data_integrity ud_i;//class handle for data integrity

  function new(svt_tilelink_system_configuration tilelink_cfg,tilelink_xvm_env env);
    ud_i = new();
    this.env = env;
    this.tilelink_cfg = tilelink_cfg;
  endfunction

  /*Task to access backdoor data of slave when READ cmd comes on BUS*/
  task backdoor_data();
   forever
   begin
    @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.a_valid == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.a_ready == 1 && (tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_GET || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA))
    begin
      env.sys_env.slave[0].backdoor_access_data(tilelink_cfg.master_cfg[0].tilelink_master_if.a_address,tilelink_cfg.master_cfg[0].tilelink_master_if.a_size);//Passing address and size to backdoor function
      temp_a_size=tilelink_cfg.master_cfg[0].tilelink_master_if.a_size;
      temp_a_source=tilelink_cfg.master_cfg[0].tilelink_master_if.a_source;
      if(ud_i.flag_backdoor.exists(temp_a_source) == 0)
      begin
        ud_i.backdoor_data_queue[tilelink_cfg.master_cfg[0].tilelink_master_if.a_source]= new[2**tilelink_cfg.master_cfg[0].tilelink_master_if.a_size];
        for(int m=0;m<(2**temp_a_size);m++)
        begin
         ud_i.backdoor_data_queue[temp_a_source][m] = env.sys_env.slave[0].slave_backdoor_queue[m]; 
        end
        ud_i.flag_backdoor[temp_a_source] = 1;
      end
    end//if
   end//forever
  endtask

  /*Task to capture d_data from master status when read resp comes on the BUS*/
  task d_data_rx();
   forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA)
    begin
       ud_i.get_resp_master(env.sys_env.master[0].master_mon.common.shared_status);
    end//if
   end//forever
  endtask

  /*To count the total no of RESPs that has come on the bus*/
  task resp_count(ref int resp_received);
  forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.d_ready == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_valid == 1 && ((tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK) || (tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_ACCESS_ACK_DATA) || (tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_opcode == svt_tilelink_slave_transaction::CH_D_HINT_ACK)))
      begin
        if(ud_i.req_id.exists(tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_source) && ud_i.flag.exists(tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_source) == 0)
        begin
         resp_received = resp_received + 1;
         ud_i.id_array.push_back(tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_source);
         ud_i.flag[tilelink_cfg.slave_cfg[0].tilelink_slave_if.d_source] = 1;
        end
      end
   end
  endtask

  /*To discriminate between the 2 unique responses, allow the resp_count task to not count the same resp with multiple beats for more than one*/
  task resp_beat;
   forever
   begin
    @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock)//waiting for every posedge of clk
    if(tilelink_cfg.master_cfg[0].tilelink_master_if.a_valid == 1 && tilelink_cfg.slave_cfg[0].tilelink_slave_if.a_ready == 1 && (tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_GET || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_INTENT || tilelink_cfg.master_cfg[0].tilelink_master_if.a_opcode == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA))
    begin
      if(ud_i.req_id.exists(tilelink_cfg.master_cfg[0].tilelink_master_if.a_source) == 0)
      begin
        ud_i.req_id[tilelink_cfg.master_cfg[0].tilelink_master_if.a_source] = 1;
      end
    end//if
   end//forever
  endtask

endclass

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_basic_uh_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_basic_uh_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_basic_uh_seq");
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

    foreach(tilelink_cfg.master_cfg[i]) tilelink_cfg.master_cfg[i].all_signals_defaultx = j;
    foreach(env.sys_env.master[i]) 
      env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              tr.a_address  == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_uh_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              tr1.a_address == tr.a_address;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_uh_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                              tr2.a_address == tr.a_address;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_uh_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              tr3.a_address == tr.a_address;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_uh_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              tr4.a_address == tr.a_address;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_uh_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              tr5.a_address == tr.a_address;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_basic_uh_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

 `ifndef DATA_INTEGRITY_DISABLE
  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1200) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
 `endif
  end//for j


 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_basic_uh_seq


//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  //uh_data_integrity ud_i;//class handle for data integrity
  get_backdoor_data backdoor_handle;
  int total_packets=1000;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_verif_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_seq")


   begin
   `svt_xvm_send(tr)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_0_delay_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=12;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_0_delay_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_0_delay_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_0_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i]) tr1.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr1.a_vld_deassert_delay[i]) tr1.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_0_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == 3;//tr.a_size;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i]) tr2.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr2.a_vld_deassert_delay[i]) tr2.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_0_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i]) tr3.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr3.a_vld_deassert_delay[i]) tr3.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_0_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i]) tr4.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr4.a_vld_deassert_delay[i]) tr4.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_0_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i]) tr5.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr5.a_vld_deassert_delay[i]) tr5.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_0_delay_verif_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_0_delay_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,tr6,tr7,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              tr.a_address == 32;
                              foreach(tr.a_corrupt[i]) (tr.a_corrupt[i] == 0);//Make corrupt zero for all beats even beats
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr1.a_size == tr.a_size;
                              tr1.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr2.a_size == tr.a_size;
                              tr2.a_address == 32;
                              foreach(tr2.a_corrupt[i]) (tr2.a_corrupt[i] == (i%2 == 0) ? 1 : 0);//Make corrupt high for even beats  
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr3.a_size == tr.a_size;
                              tr3.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              tr4.a_address == 32;
                              foreach(tr4.a_corrupt[i]) (tr4.a_corrupt[i] == (i%2 == 0) ? 1 : 0);//Make corrupt high for even beats  
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr5.a_size == tr.a_size;
                              tr5.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr6,p_sequencer.master_sequencer[0])
   if (!tr6.randomize() with {
                              tr6.a_source == source;
                              tr6.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr6.a_size == tr.a_size;
                              tr6.a_address == 32;
                              foreach(tr6.a_corrupt[i]) (tr6.a_corrupt[i] == (i%2 == 0) ? 1 : 0);//Make corrupt high for even beats
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   source++;
  `svt_xvm_create_on(tr7,p_sequencer.master_sequencer[0])
   if (!tr7.randomize() with {
                              tr7.a_source == source;
                              tr7.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr7.a_size == tr.a_size;
                              tr7.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq")

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   `svt_xvm_send(tr6)
   `svt_xvm_send(tr7)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_verif_with_acorrupt_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,tr6,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int a_address_value;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq");
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
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              tr.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr1.a_size == tr.a_size;
                              tr1.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr2.a_size == tr.a_size;
                              tr2.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              tr3.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              tr4.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              tr5.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   source++;
  `svt_xvm_create_on(tr6,p_sequencer.master_sequencer[0])
   if (!tr6.randomize() with {
                              tr6.a_source == source;
                              tr6.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr6.a_size == tr.a_size;
                              tr6.a_address == 32;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq")

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
 fork:DATA_INTEGRITY

 begin//begin for 1st fork begin
 `endif

 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   `svt_xvm_send(tr6)
   end

   begin
   `svt_xvm_send(slv_tr)
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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_verif_with_write_denied_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq");
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

    a_size_value=3;

   source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr.a_source == source;
                              tr.a_size == a_size_value;
                              tr.a_corrupt[0] == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr1.a_source == source;
                              tr1.a_size == a_size_value;
                              tr1.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")


   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside  {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr2.a_source == source;
                              tr2.a_size == a_size_value;
                              tr2.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                              slv_tr2.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr3.a_source == source;
                              tr3.a_size == a_size_value;
                              tr3.a_corrupt[0] == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                              slv_tr3.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body
endclass : svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_different_put_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr.a_source == source;
                              tr.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   source++;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr1.a_source == source;
                              tr1.a_corrupt[0] == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")


   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                              slv_tr1.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   source++;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr2.a_source == source;
                              tr2.a_corrupt[0] == 1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                              slv_tr2.d_denied == 1; //d_denied is enabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   source++;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr3.a_source == source;
                              tr3.a_corrupt[0] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                              slv_tr3.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_verif_with_write_denied_acorrupt_same_put_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_same_cycle_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_same_cycle_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_same_cycle_verif_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_same_cycle_verif_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_same_cycle_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_delay_enabled_with_0_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_delay_enabled_with_0_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_delay_enabled_with_0_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 4;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_0_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i]) tr1.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr1.a_vld_deassert_delay[i]) tr1.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_0_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i]) tr2.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr2.a_vld_deassert_delay[i]) tr2.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_0_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i]) tr3.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr3.a_vld_deassert_delay[i]) tr3.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_0_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i]) tr4.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr4.a_vld_deassert_delay[i]) tr4.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_0_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i]) tr5.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr5.a_vld_deassert_delay[i]) tr5.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_0_verif_seq")

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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_delay_enabled_with_0_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class uh_outstanding_transaction_with_num_outstanding_txn_config_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(uh_outstanding_transaction_with_num_outstanding_txn_config_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="uh_outstanding_transaction_with_num_outstanding_txn_config_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body
endclass : uh_outstanding_transaction_with_num_outstanding_txn_config_seq

//--------------------------------------------------------------------------------------------------------------------------------
class uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body
endclass : uh_outstanding_transaction_with_num_outstanding_txn_config_with_4_seq

//--------------------------------------------------------------------------------------------------------------------------------
class uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_inbw_seq

//--------------------------------------------------------------------------------------------------------------------------------
class uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i]) tr1.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i]) tr2.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i]) tr3.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i]) tr4.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr5.a_vld_2_a_vld_assert_delay[i] == 8 : tr5.a_vld_2_a_vld_assert_delay[i] == 0);
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_with_resp_seq

//--------------------------------------------------------------------------------------------------------------------------------
class uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i]) tr1.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i]) tr2.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i]) tr3.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i]) tr4.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   tr5.delay_vals.constraint_mode(0);
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr5.a_vld_2_a_vld_assert_delay[i] == 20 : tr5.a_vld_2_a_vld_assert_delay[i] == 0);
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : uh_outstanding_transaction_with_num_outstanding_txn_config_with_last_txn_after_resp_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=200;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]+tilelink_cfg.slave_cfg[0].mem_fifo_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]+tilelink_cfg.slave_cfg[0].mem_fifo_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq")

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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk;
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_fifo_enabled_with_one_fifo_range_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=200;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]+tilelink_cfg.slave_cfg[0].mem_fifo_range[1])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]+tilelink_cfg.slave_cfg[0].mem_fifo_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]+tilelink_cfg.slave_cfg[0].mem_fifo_range[1])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]+tilelink_cfg.slave_cfg[0].mem_fifo_range[1])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]+tilelink_cfg.slave_cfg[0].mem_fifo_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq")

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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk;
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body
endclass : svt_tilelink_uh_fifo_enabled_with_two_fifo_range_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_fifo_disabled_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=200;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_fifo_disabled_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_fifo_disabled_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]+tilelink_cfg.slave_cfg[0].mem_fifo_range[1])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_disabled_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]+tilelink_cfg.slave_cfg[0].mem_fifo_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_disabled_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_disabled_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_disabled_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[1]+tilelink_cfg.slave_cfg[0].mem_fifo_range[1])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_disabled_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_address inside {[tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]: (tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]+tilelink_cfg.slave_cfg[0].mem_fifo_range[0])]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_fifo_disabled_seq")

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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk;
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_fifo_disabled_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq");
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


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1024;
                              foreach(slv_tr.d_vld_2_d_vld_assert_delay[i]) slv_tr.d_vld_2_d_vld_assert_delay[i] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 0;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                              slv_tr.d_denied == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")

                             else
                             begin
                              slv_tr.d_vld_2_d_vld_assert_delay[0] = 5;
                              slv_tr.d_vld_2_d_vld_assert_delay[1] = 6;
                              slv_tr.d_vld_2_d_vld_assert_delay[2] = 7;
                              slv_tr.d_vld_2_d_vld_assert_delay[3] = 8;
                             end

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_d_vld2vld_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq");
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


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1024;
                              foreach(slv_tr.d_vld_2_d_vld_assert_delay[i]) slv_tr.d_vld_2_d_vld_assert_delay[i] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 5;
                              slv_tr.a_rdy_deassert_delay == 2;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                              slv_tr.d_denied == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")
                             else
                             begin
                              slv_tr.d_vld_2_d_vld_assert_delay[0] = 5;
                              slv_tr.d_vld_2_d_vld_assert_delay[1] = 6;
                              slv_tr.d_vld_2_d_vld_assert_delay[2] = 7;
                              slv_tr.d_vld_2_d_vld_assert_delay[3] = 8;
                             end

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_rdy2rdy_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq");
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


   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 0;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 5; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 0; //valid_ready delay value
                              slv_tr.d_denied == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_cross_channel_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq");
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



    `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 5;
                              foreach(slv_tr.d_vld_2_d_vld_assert_delay[i])slv_tr.d_vld_2_d_vld_assert_delay[i] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 0;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 5; //valid_ready delay value
                              slv_tr.d_denied == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq")


 fork

   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

   begin
   `svt_xvm_send(slv_tr)
   end

 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_valid_ready_channel_delay_using_retain_txn_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_d_vld2vld_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_d_vld_cross_channel_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq")


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
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_d_valid_d_ready_delay_using_config_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_d_valid_d_ready_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_d_valid_d_ready_delay_using_config_verif_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_valid_d_ready_delay_using_config_verif_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_d_valid_d_ready_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_d_rdy2rdy_delay_using_config_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_d_rdy2rdy_delay_using_config_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_d_rdy2rdy_delay_using_config_verif_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 0;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_rdy2rdy_delay_using_config_verif_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_d_rdy2rdy_delay_using_config_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_vld2vld_delay_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_vld2vld_delay_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_vld2vld_delay_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld2vld_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i]) tr1.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr1.a_vld_deassert_delay[i]) tr1.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld2vld_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i]) tr2.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr2.a_vld_deassert_delay[i]) tr2.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld2vld_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i]) tr3.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr3.a_vld_deassert_delay[i]) tr3.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld2vld_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i]) tr4.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr4.a_vld_deassert_delay[i]) tr4.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld2vld_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i]) tr5.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr5.a_vld_deassert_delay[i]) tr5.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld2vld_delay_verif_seq")

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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_vld2vld_delay_verif_seq


//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_verif_reconfigure_data_width_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_verif_reconfigure_data_width_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_verif_reconfigure_data_width_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_verif_reconfigure_data_width_seq")


   `svt_xvm_send(tr)

  end//for j

  repeat(1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
  wait(tilelink_cfg.master_cfg[0].tilelink_master_if.resp_num == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
  repeat(1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

  end//for i

 `ifndef DATA_INTEGRITY_DISABLE

 end

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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_verif_reconfigure_data_width_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_delay_enabled_with_test_disabled_with_reconfig_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=5;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_delay_enabled_with_test_disabled_with_reconfig_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_delay_enabled_with_test_disabled_with_reconfig_verif_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_delay_enabled_with_test_disabled_with_reconfig_verif_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_delay_enabled_with_test_disabled_with_reconfig_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class uh_outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=10;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(uh_outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="uh_outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq");
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_GET,  svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA,  svt_tilelink_master_transaction::CH_A_INTENT,  svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) tr.a_vld_2_a_vld_assert_delay[i] == 2;
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 3;
                            })
                             `uvm_error("Randomization Failure","uh_outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq")


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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : uh_outstanding_transaction_with_num_outstanding_txn_with_reconfig_seq

class svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;

  `uvm_object_utils(svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  cust_svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq");
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

    //data_width
    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

   //driving single beat transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   //checker atomic_op_a_mask_unaligned_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_param inside {[0:4]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_mask[0] = ~tr.a_mask[0]; //invert bit-wise, this will achieve 2 things. (1) wrong mask value, (2) non-contiguous mask value.
    end
   `svt_xvm_send(tr)

   //driving multi-beat transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   //checker atomic_op_a_mask_unaligned_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]}; //make sure that a_size is within TL-UH range.
                              tr.a_param inside {[0:4]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      //for each beat of burst, send bad mask value.
      foreach(tr.a_mask[i])
        tr.a_mask[i] = $urandom;
    end
   `svt_xvm_send(tr)

   //driving single beat transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   //checker atomic_op_a_mask_unaligned_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_param inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_mask[0] = ~tr.a_mask[0]; //invert bit-wise, this will achieve 2 things. (1) wrong mask value, (2) non-contiguous mask value.
    end
   `svt_xvm_send(tr)

   //driving multi-beat transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   //checker atomic_op_a_mask_unaligned_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]}; //make sure that a_size is within TL-UH range.
                              tr.a_param inside {[0:3]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      //for each beat of burst, send bad mask value.
      foreach(tr.a_mask[i])
        tr.a_mask[i] = $urandom;
    end
   `svt_xvm_send(tr)

   //driving single beat transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   //checker atomic_op_a_mask_unaligned_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_param inside {[0:1]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_mask[0] = ~tr.a_mask[0]; //invert bit-wise, this will achieve 2 things. (1) wrong mask value, (2) non-contiguous mask value.
    end
   `svt_xvm_send(tr)

   //driving multi-beat transaction with Mask such that value-1 arrives in the position of expected value-0.
   //checker invalid_mask_val_error expected.
   //checker atomic_op_a_mask_unaligned_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]}; //make sure that a_size is within TL-UH range.
                              tr.a_param inside {[0:1]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      //for each beat of burst, send bad mask value.
      foreach(tr.a_mask[i])
        tr.a_mask[i] = $urandom;
    end
   `svt_xvm_send(tr)

   //driving single beat transaction with bad a_param.
   //checker unknown_airth_op_error expected.
   //todo_g:: a_param not getting inserted in this packet somehow, which is single-beat.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_param = $urandom_range(5, 7);
    end
   `svt_xvm_send(tr)

   //driving multi-beat transaction with bad a_param.
   //checker unknown_airth_op_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_param = $urandom_range(5, 7);
    end
   `svt_xvm_send(tr)

   //driving single beat transaction with bad a_param.
   //checker unknown_log_op_error expected.
   //todo_g:: a_param not getting inserted in this packet somehow, which is single-beat.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_param = $urandom_range(4, 7);
    end
   `svt_xvm_send(tr)

   //driving multi-beat transaction with bad a_param.
   //checker unknown_log_op_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_param = $urandom_range(4, 7);
    end
   `svt_xvm_send(tr)

   //driving single beat transaction with bad a_param.
   //checker unknown_intent_op_error expected.
   //checker rsvd_a_corrupt_for_intent_op_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]}; //make sure that a_size is within TL-UL range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_param = $urandom_range(2, 7);
      tr.a_corrupt[0] = 1; //bad corrupt value in intent operation.
    end
   `svt_xvm_send(tr)

   //driving multi-beat transaction with bad a_param.
   //checker unknown_intent_op_error expected.
   //checker rsvd_a_corrupt_for_intent_op_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq")
    else begin
      tr.a_param = $urandom_range(2, 7);
      tr.a_corrupt[0] = 1; //bad corrupt value in intent operation.
    end
   `svt_xvm_send(tr)

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_atomic_mask_and_a_param_related_error_seq

class svt_tilelink_tl_uh_invalid_response_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  int a_size_val, data_width;
  int d_opc_val;
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  tilelink_slave_resp_wo_req_callback               slv_resp_wo_req;
  tilelink_slave_response_opcode_error_callback     response_opcode_err;

  `uvm_object_utils(svt_tilelink_tl_uh_invalid_response_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_invalid_response_error_seq");
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
    `uvm_info("post_body", "Entering...", UVM_DEBUG)
    super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase!=null) begin
      `uvm_info("post_body", "Drop Objection...", UVM_DEBUG)
      phase.drop_objection(this);
    end
    `uvm_info("post_body", "Exiting...", UVM_DEBUG)
  endtask: post_body
  
  //---------------------------------------------------------------------------
  /** Define task body() */
  virtual task body();
    uvm_phase phase;
    `uvm_info("body", "Entering...", UVM_DEBUG)
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(p_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg); 

    response_opcode_err     = new("response_opcode_err");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

   //add callback to insert wrong opcode during putfulldata and put partial data
   svt_tilelink_slave_callback_pool::add(my_agent.slave,response_opcode_err);
   data_width = tilelink_cfg.master_cfg[0].data_width/8;
   a_size_val = $clog2(data_width);

   //checker <msg_arithmetic_d_rsp_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[0:a_size_val]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
    else begin
    end


   //checker <msg_logical_d_rsp_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr1.a_source == 4;
                              tr1.a_size inside {[0:a_size_val]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
    else begin
    end

   //checker <msg_intent_i_rsp_error> expected.
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr2.a_source == 3;
                              tr2.a_size inside {[0:a_size_val]};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")

    fork 
      begin
        `svt_xvm_send(tr)
      end
      begin
        //EI added for Airthmetic operation
        d_opc_val = $urandom_range(0, 2);
        while(d_opc_val == 1 || d_opc_val == 3)
          d_opc_val = $urandom_range(0, 2);
        response_opcode_err.d_opcode = d_opc_val;
        `svt_xvm_send(slv_tr)
      end
    join

    fork 
      begin
        `svt_xvm_send(tr1)
      end
      begin
        //EI added for Logical operation
        d_opc_val = $urandom_range(0, 2);
        while(d_opc_val == 1 || d_opc_val == 3)
          d_opc_val = $urandom_range(0, 2);
        response_opcode_err.d_opcode = d_opc_val;
        `svt_xvm_send(slv_tr1)
      end
    join

    fork 
      begin
        `svt_xvm_send(tr2)
      end
      begin
        //EI added for Intent operation
        d_opc_val = $urandom_range(0, 2);
        while(d_opc_val == 2 || d_opc_val == 3)
          d_opc_val = $urandom_range(0, 2);
        response_opcode_err.d_opcode = d_opc_val;
        `svt_xvm_send(slv_tr2)
      end
    join

    //multi-beat operation
    //checker <msg_arithmetic_d_rsp_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[a_size_val+1:a_size_val+10]};
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
    else begin
    end


   //checker <msg_logical_d_rsp_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr1.a_source == 4;
                              tr1.a_size inside {[a_size_val+1:a_size_val+10]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
    else begin
    end

   //checker <msg_intent_i_rsp_error> expected.
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr2.a_source == 3;
                              tr2.a_size inside {[a_size_val+1:a_size_val+10]};
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")
   `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_response_error_seq")

    fork 
      begin
        a_size_val = tr.a_size;
        `svt_xvm_send(tr)
      end
      begin
        //EI added for Airthmetic operation
        d_opc_val = $urandom_range(0, 2);
        while(d_opc_val == 1 || d_opc_val == 3)
          d_opc_val = $urandom_range(0, 2);
        response_opcode_err.d_opcode = d_opc_val;
        `svt_xvm_send(slv_tr)
      end
    join

    //clocks to provide syc between 2 packets.
    repeat(2**a_size_val/data_width + 500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

    fork 
      begin
        a_size_val = tr1.a_size;
        `svt_xvm_send(tr1)
      end
      begin
        //EI added for Logical operation
        d_opc_val = $urandom_range(0, 2);
        while(d_opc_val == 1 || d_opc_val == 3)
          d_opc_val = $urandom_range(0, 2);
        response_opcode_err.d_opcode = d_opc_val;
        `svt_xvm_send(slv_tr1)
      end
    join

    //clocks to provide syc between 2 packets.
    repeat(2**a_size_val/data_width + 500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

    fork 
      begin
        `svt_xvm_send(tr2)
      end
      begin
        //EI added for Intent operation
        response_opcode_err.d_opcode = 0;
        `svt_xvm_send(slv_tr2)
      end
    join

    repeat(500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_invalid_response_error_seq

class svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;
  bit [`SVT_TILELINK_A_OPCODE_WIDTH-1:0] a_opcode, d_opcode_val;

  `uvm_object_utils(svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  cust_svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
  uvm_object my_parent;
  svt_tilelink_slave_agent  my_slv_agent;
  svt_tilelink_master_agent my_mst_agent;
  svt_tilelink_master_manipulate_control_sig_error_callback cust_callback;
  tilelink_slave_response_ctrl_sig_error_callback cust_callback_s;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq");
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

    cust_callback = new("cust_callback");
    cust_callback_s = new("cust_callback_s");

    my_parent = p_sequencer.master_sequencer[0].get_parent();
    $cast(my_mst_agent, my_parent);
    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_slv_agent, my_parent);

    //adding callback to insert error.
    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_callback);

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

 for(int i=1;i<6;i++) begin

   //checker no_intrlv_support_error expected.
   //checker burst_ctrl_sig_value_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == i;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA};
                              tr.a_size inside {['ha:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq")
    else begin
      //set EI parameters
      cust_callback.sig_type = i;
      cust_callback.beat_pos = $urandom_range(1, (2**tr.a_size)/data_width-1);
      //convert opcode value from ENUM to number
      $cast(a_opcode, tr.ch_a_msg_type);
      case (i)
        1: cust_callback.corrupt_opc_val    = a_opcode == 5 ? 0 :  a_opcode + 1;
        2: cust_callback.corrupt_src_val    = tr.a_source + 1;
        3: cust_callback.corrupt_size_val   = tr.a_size == 'hc ? tr.a_size - 1 : tr.a_size + 1;
        4: cust_callback.corrupt_addr_val   = tr.a_address + 1;
        5: cust_callback.corrupt_param_val  = tr.a_param + 1;
      endcase
    end
   `svt_xvm_send(tr)

 end//for

    //deleting callback.
    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_callback);

    //adding slave callback
    svt_tilelink_slave_callback_pool::add(my_slv_agent.slave,cust_callback_s);

 for(int i=0;i<6;i++) begin

   //checker no_intrlv_support_error expected.
   //checker burst_ctrl_sig_value_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == i;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr.a_size inside {['ha:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq")
    else begin
    end

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq")
   else begin
      //set EI parameters
      a_size_val = tr.a_size;
      cust_callback_s.d_ctrl_sig = i;
      cust_callback_s.d_ctrl_sig_beat= $urandom_range(1, (2**tr.a_size)/data_width-1);
      //convert opcode value from ENUM to number
      $cast(a_opcode, tr.ch_a_msg_type);
      if(a_opcode inside {0,1})         begin d_opcode_val = 0; while(d_opcode_val==0) d_opcode_val = $urandom_range(0,2); end
      else if(a_opcode inside {2,3,4})  begin d_opcode_val = 1; while(d_opcode_val==1) d_opcode_val = $urandom_range(0,2); end
      else if(a_opcode inside {5})      begin d_opcode_val = 2; while(d_opcode_val==2) d_opcode_val = $urandom_range(0,2); end
      case (i)
        0: cust_callback_s.d_opcode   = d_opcode_val;
        1: cust_callback_s.d_param    = 1;
        2: cust_callback_s.d_source   = tr.a_source + 1;
        3: cust_callback_s.d_size     = tr.a_size == 'hc ? tr.a_size - 1 : tr.a_size + 1;
      endcase

   end

   fork
     `svt_xvm_send(tr)
     `svt_xvm_send(slv_tr)
   join

    //clocks to provide syc between 2 packets.
    repeat(2**a_size_val/data_width + 500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

 end//for

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_invalid_control_sigs_for_burst_transfers_seq

class svt_tilelink_tl_uh_in_tl_ul_only_cfg_en_error_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;

  `uvm_object_utils(svt_tilelink_tl_uh_in_tl_ul_only_cfg_en_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  cust_svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
  uvm_object my_parent;
  svt_tilelink_slave_agent  my_slv_agent;
  svt_tilelink_master_agent my_mst_agent;

  svt_tilelink_master_corrupt_size_opcode_error_callback cust_callback;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_in_tl_ul_only_cfg_en_error_seq");
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


    cust_callback = new("cust_callback");

    my_parent = p_sequencer.master_sequencer[0].get_parent();
    $cast(my_mst_agent, my_parent);

    //adding callback to insert error sucn that a_size and a_opcodes are driven incorrectly for TL-UL only.
    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_callback);

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

 //driving errors such that airthmetic/logical/intent operations work under TL-UL config.
 //checker rsvd_a_opcode_val_in_tl_ul_error expected.
 //checker rsvd_d_opcode_val_in_tl_ul_error expected.
 cust_callback.crpt_size_opc = 1;
 for(int i=0;i<3;i++) begin

   if(i==0)
     cust_callback.corrupt_opc_val = 2; //airthmetic op
   else if(i==1)
     cust_callback.corrupt_opc_val = 3; //logical op
   else if(i==2)
     cust_callback.corrupt_opc_val = 5; //intent op

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == i;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_in_tl_ul_only_cfg_en_error_seq")
   `svt_xvm_send(tr)
 end //for

 //driving errors such that a_size is always greater than data_wdth to form multi-beat under TL-UL config.
 //checker a_size_greater_than_max_bus_size_error.
 //checker d_size_val_greater_than_max_bus_size_error.
 cust_callback.crpt_size_opc = 0;
 for(int i=0;i<3;i++) begin

    cust_callback.corrupt_size_val = $urandom_range(a_size_val+1, 'hc);

   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == i+3;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_in_tl_ul_only_cfg_en_error_seq")
   `svt_xvm_send(tr)
 end //for

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_in_tl_ul_only_cfg_en_error_seq

class svt_tilelink_tl_uh_with_random_req_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val, source_counter;

  `uvm_object_utils(svt_tilelink_tl_uh_with_random_req_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  cust_svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_with_random_req_seq");
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
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "tilelink_basic_env", env);

    //data_width
    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

    for(int j=0;j<100;j++) begin

 
      //driving first transaction with Mask such that value-1 arrives in the position of expected value-0.
      //checker invalid_mask_val_error expected.
      `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
      if (!tr.randomize() with { 
                                 tr.a_source == source_counter;
                                 tr.a_size inside {[a_size_val+1:'hC]}; //make sure that a_size is within TL-UH range.
                                 tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_tl_uh_with_random_req_seq")
       else begin
       end
      `svt_xvm_send(tr)


      source_counter++;
    end //for

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_with_random_req_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  get_backdoor_data backdoor_handle;
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq");
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

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq")

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
     repeat(12) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;
     #5ps;
    p_sequencer.reset_mp.reset = 1'b1;
     repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_dynamic_reset_inbw_req_with_timeout_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  get_backdoor_data backdoor_handle;
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq");
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

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq")

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
     repeat(20) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;
    p_sequencer.reset_mp.reset = 1'b1;
     repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
    p_sequencer.reset_mp.reset = 1'b0;
     repeat(5) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;
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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body  

endclass : svt_tilelink_uh_dynamic_reset_after_all_req_with_timeout_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_dynamic_reset_after_all_req_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  get_backdoor_data backdoor_handle;
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_uh_dynamic_reset_after_all_req_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_dynamic_reset_after_all_req_seq");
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

   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_dynamic_reset_after_all_req_seq")


   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr3)
   `svt_xvm_send(tr4)
     repeat(14) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;
    p_sequencer.reset_mp.reset = 1'b1;
     repeat(100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 2 posedge of clk;
    p_sequencer.reset_mp.reset = 1'b0;
     repeat(5) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 5 posedge of clk;
   `svt_xvm_send(tr5)


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_dynamic_reset_after_all_req_seq

class svt_tilelink_tl_uh_masks_related_checks_verif_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;

  `uvm_object_utils(svt_tilelink_tl_uh_masks_related_checks_verif_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
  tilelink_xvm_env env;
  bit status;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_masks_related_checks_verif_seq");
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
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(m_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg);
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);

    //data_width
    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);
 
   //checker invalid_mask_val_error expected.
   //checker mask_not_contiguous_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 2;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_masks_related_checks_verif_seq")
    else begin
      foreach(tr.a_mask[i]) tr.a_mask[i][4] = 0;//since mask not aligned with address and a_size, error should flash here.
    end
   `svt_xvm_send(tr)

   //checker invalid_mask_val_error expected.
   //checker invalid_low_mask_for_get_op_error expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr.a_source == 3;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_masks_related_checks_verif_seq")
    else begin
      if(data_width == 8)
        tr.a_mask[0][$urandom_range(7,0)] = 0;
      else
        foreach(tr.a_mask[i]) tr.a_mask[i] = $urandom; //since mask not aligned with address and a_size, error should flash here.
    end
   `svt_xvm_send(tr)

   //checker <atomic_op_a_mask_unaligned_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 4;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_masks_related_checks_verif_seq")
    else begin
      foreach(tr.a_mask[i]) tr.a_mask[i] = $urandom; //since mask not aligned with address and a_size, error should flash here.
    end
   `svt_xvm_send(tr)

   //checker <atomic_op_a_mask_unaligned_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr.a_source == 5;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_masks_related_checks_verif_seq")
    else begin
      foreach(tr.a_mask[i]) tr.a_mask[i] = $urandom; //since mask not aligned with address and a_size, error should flash here.
    end
   `svt_xvm_send(tr)

   //checker <invalid_low_mask_for_intent_op_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr.a_source == 6;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_masks_related_checks_verif_seq")
    else begin
      foreach(tr.a_mask[i]) tr.a_mask[i] = $urandom; //since mask not aligned with address and a_size, error should flash here.
    end
   `svt_xvm_send(tr)

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_masks_related_checks_verif_seq

class svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq extends uvm_sequence #(svt_tilelink_master_transaction); 

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1;
  int data_width;
  int a_size_val;
  uvm_object my_parent;
  svt_tilelink_master_agent my_mst_agent;
  svt_tilelink_master_identical_inflight_identifier_error_callback cust_inflight_a_source_error_callback;

  `uvm_object_utils(svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq");
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

    status = uvm_config_db#(svt_tilelink_system_configuration)::get(m_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg);
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);

    cust_inflight_a_source_error_callback = new("cust_inflight_a_source_error_callback");

    my_parent = p_sequencer.master_sequencer[0].get_parent();
    $cast(my_mst_agent, my_parent);

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

   //checker <a_address_not_alligned_to_a_size_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA; 
                              tr.a_source == 1;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              //tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              //tr.a_vld_deassert_delay.size() == 1;
                              //tr.a_vld_2_a_vld_assert_delay[0] == 4;
                              //tr.a_vld_deassert_delay[0] == 4;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = tr.a_address+1; //address not alligned to a_size, checker should flash here.
    end
   `svt_xvm_send(tr)


    svt_tilelink_master_callback_pool::add(my_mst_agent.master,cust_inflight_a_source_error_callback);
   //checker <a_address_not_alligned_to_a_size_error> expected.
   //checker <invalid_mask_val_error> expected [This error is expected since, address sent is not aligned with a_size, so checker calculation for mask is based on that, while Master is sending mask on basis of a_size=2].
   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA; 
                              tr.a_source == 1; //source id same as previous source, error should flash here
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              //tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              //tr.a_vld_deassert_delay.size() == 1;
                              //tr.a_vld_2_a_vld_assert_delay[0] == 2;
                              //tr.a_vld_deassert_delay[0] == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = tr.a_address+1; //address not aligned, checker should flash here
    end
   `svt_xvm_send(tr)

   //checker <a_address_not_alligned_to_a_size_error> expected.
   //checker <rsvd_a_corrupt_value_in_get_op_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET; 
                              tr.a_source == 2;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              //tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              //tr.a_vld_deassert_delay.size() == 1;
                              //tr.a_vld_2_a_vld_assert_delay[0] == 3;
                              //tr.a_vld_deassert_delay[0] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_corrupt[0] = 1; //since for GET msgs, a_corrupt should be 1, error should flash here
      tr.a_address = tr.a_address+1; //unaligned address, checker should flash here
    end
   `svt_xvm_send(tr)


   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == 2; //source id same as previous source, error should flash here
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              //tr.a_vld_2_a_vld_assert_delay.size() == 1;
                              //tr.a_vld_deassert_delay.size() == 1;
                              //tr.a_vld_2_a_vld_assert_delay[0] == 2;
                              //tr.a_vld_deassert_delay[0] == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
    end
   `svt_xvm_send(tr)

   //checker <a_address_not_alligned_to_a_size_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA; 
                              tr.a_source == 3;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = tr.a_address+1; //unaligned address, checker should flash here
    end
   `svt_xvm_send(tr)

   //checker <a_address_not_alligned_to_a_size_error> expected.
   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA; 
                              tr.a_source == 3;  //source id same as previous source, error should flash here
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = tr.a_address+1; //unaligned address, checker should flash here
    end
   `svt_xvm_send(tr)

   //checker <a_address_not_alligned_to_a_size_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT; 
                              tr.a_source == 4;
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
      tr.a_address = tr.a_address+1; //unaligned address, checker should flash here
    end
   `svt_xvm_send(tr)

   //checker <identical_inflight_identifier_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_source == 4; //source id asme as before
                              tr.a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq")
    else begin
    end
   `svt_xvm_send(tr)
    svt_tilelink_master_callback_pool::delete(my_mst_agent.master,cust_inflight_a_source_error_callback);

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_a_addr_crpt_inflight_msgs_checks_verif_seq

class svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  uvm_sequence_item rsp;
  svt_tilelink_master_transaction   tr[];
  svt_tilelink_slave_transaction    slv_tr[];
  svt_tilelink_master_transaction::tl_master_ch_a_msg_type_enum chnl_a_val;
  int data_width;
  int a_size_val, d_opc_val;
  int count;//to hold the total no of packets
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  tilelink_slave_resp_wo_req_callback               slv_resp_wo_req;
  tilelink_slave_response_opcode_error_callback     response_opcode_err;

  `uvm_object_utils(svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq");
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
    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

    slv_resp_wo_req         = new("slv_resp_wo_req");
    response_opcode_err     = new("response_opcode_err");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

   svt_tilelink_slave_callback_pool::add(my_agent.slave,slv_resp_wo_req);

   //create tr size
   tr     = new[6];
   slv_tr = new[6];

   //checker <resp_wo_req_error> expected.
  for(int i=0;i<6;i++) begin
    $cast(chnl_a_val, i);
   `svt_xvm_create_on(tr[i],p_sequencer.master_sequencer[0])
   if (!tr[i].randomize() with { 
                              tr[i].ch_a_msg_type == chnl_a_val;
                              tr[i].a_source == i;
                              tr[i].a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                              tr[i].a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr[i],p_sequencer.slave_sequencer[0])
   if (!slv_tr[i].randomize())
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq")
  end //for

  foreach(tr[i]) begin
    fork 
      begin
        `svt_xvm_send(tr[i])
      end
      begin
          //EI added
          slv_resp_wo_req.d_source=$urandom_range(7, 12); //source id sent from slave is wrong. Checker should flash here.
          `svt_xvm_send(slv_tr[i])
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join
    repeat(200) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
  end

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,slv_resp_wo_req);

   //added clocks to sync between above set of txns and lower.
   repeat(500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //add callback to insert wrong opcode during different cmds.
   svt_tilelink_slave_callback_pool::add(my_agent.slave,response_opcode_err);

   //create tr size
   tr     = new[3];
   slv_tr = new[3];

   //checker <resp_wo_req_error> expected.
  for(int i=0;i<3;i++) begin
    //check only putfull, putpart, and get op
    if(i==0||i==1||i==2) begin
      if(i==2)
       $cast(chnl_a_val, 4);
     else
       $cast(chnl_a_val, i);
      `svt_xvm_create_on(tr[i],p_sequencer.master_sequencer[0])
      if (!tr[i].randomize() with { 
                                 tr[i].ch_a_msg_type == chnl_a_val;
                                 tr[i].a_source == i+10;
                                 tr[i].a_size inside {[a_size_val+1:'hc]}; //make sure that a_size is within TL-UH range.
                                 tr[i].a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq")
       else begin
       end

       //slave transaction
      `svt_xvm_create_on(slv_tr[i],p_sequencer.slave_sequencer[0])
      if (!slv_tr[i].randomize())
                                `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq")
    end //if(i==0||i==1||i==4)
  end //for


  foreach(tr[i]) begin
    fork 
      begin
        `svt_xvm_send(tr[i])
      end
      begin
        //EI added for 1st Master txn
        d_opc_val = $urandom_range(0, 6);
        if(i==0||i==1) begin //putfull, putpart
          response_opcode_err.d_opcode = 2;
        end
        else begin //get
          response_opcode_err.d_opcode = 0;
        end
        `svt_xvm_send(slv_tr[i])
      end
    join
    repeat(200) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
  end //foreach

    repeat(500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_invali_d_source_and_invalid_response_error_seq

class svt_tilelink_tl_uh_bad_fifo_ordering_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr[];
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  tilelink_slave_ooo_fifo_resp_error_callback ooo_fifo_resp_error_callback;
  int data_width;
  int a_size_val;
  int a_addr_val;

  `uvm_object_utils(svt_tilelink_tl_uh_bad_fifo_ordering_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_bad_fifo_ordering_seq");
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

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

    tr = new[10];

   svt_tilelink_slave_callback_pool::add(my_agent.slave,ooo_fifo_resp_error_callback);

   for(int i=1;i<=10;i++) begin

     a_size_val = $urandom_range(0, 9);
      if(i<=5) begin
        for(int j=tilelink_cfg.slave_cfg[0].mem_fifo_range[0]+tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0]-1; j>=tilelink_cfg.slave_cfg[0].mem_fifo_base_address[0];j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end
      else if(i>5) begin
        for(int j='h20000000; j>='h10000000;j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end

      //checker <out_of_order_for_fifo_response_error> expected.
      `svt_xvm_create_on(tr[i-1],p_sequencer.master_sequencer[0])
      if (!tr[i-1].randomize() with { 
                                 tr[i-1].ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                                 tr[i-1].a_source       == i;
                                 tr[i-1].a_size         == a_size_val;
                                 tr[i-1].a_address      == a_addr_val;
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_tl_uh_bad_fifo_ordering_seq")
       else begin
       end
    end //for


    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1024;
                              foreach(slv_tr.d_vld_2_d_vld_assert_delay[i]) slv_tr.d_vld_2_d_vld_assert_delay[i] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_bad_fifo_ordering_seq")

                             else
                             begin
                              slv_tr.d_vld_2_d_vld_assert_delay[0] = 2**12/(data_width)+500;
                             end

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

    repeat(10000) @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk

    //here 3 different fifo ranges are used to verify the checker
   for(int i=1;i<=10;i++) begin

     a_size_val = $urandom_range(0, 9);
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
        for(int j='h20000000; j>='h20000000;j--) begin
          if(j%2**a_size_val == 0) begin
            a_addr_val = j;
            break;
          end
        end
      end

      //checker <out_of_order_for_fifo_response_error> expected.
      `svt_xvm_create_on(tr[i-1],p_sequencer.master_sequencer[0])
      if (!tr[i-1].randomize() with { 
                                 tr[i-1].ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                                 tr[i-1].a_source       == i;
                                 tr[i-1].a_size         == a_size_val;
                                 tr[i-1].a_address      == a_addr_val;
                               })
                                `uvm_error("Randomization Failure","svt_tilelink_tl_uh_bad_fifo_ordering_seq")
       else begin
       end
    end //for


    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1024;
                              foreach(slv_tr.d_vld_2_d_vld_assert_delay[i]) slv_tr.d_vld_2_d_vld_assert_delay[i] == 0;
                              slv_tr.a_rdy_2_a_rdy_assert_delay == 0;
                              slv_tr.a_rdy_deassert_delay == 1;
                              slv_tr.a_vld_d_vld_cross_channel_delay == 0; //cross channel delay value
                              slv_tr.a_vld_a_rdy_assert_delay == 3; //valid_ready delay value
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_bad_fifo_ordering_seq")
                             else
                             begin
                              slv_tr.d_vld_2_d_vld_assert_delay[0] = 2**12/(data_width)+500;
                             end

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

    repeat(10000) @(negedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every negedge of clk


    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_bad_fifo_ordering_seq

class svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  uvm_sequence_item rsp;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  int data_width;
  int a_size_val;
  tilelink_slave_resp_dparam_error_callback     cust_resp_dparam_error;
  tilelink_slave_resp_dsize_error_callback      cust_resp_dsize_error;
  tilelink_slave_dcorrupt_resp_error_callback   cust_dcorrupt_resp_error;
  tilelink_slave_denied_resp_error_callback     cust_denied_resp_error;

  `uvm_object_utils(svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq");
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

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_resp_dparam_error);

   //checker <rsvd_d_param_tl_c_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_size inside {[a_size_val+1:'hc]};
                              tr.a_source == 0;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <rsvd_d_param_tl_c_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr1.a_size inside {[a_size_val+1:'hc]};
                              tr1.a_source == 1;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
      end
      begin
        //EI added for 1st Master txn
        cust_resp_dparam_error.d_param=2; //d_param sent from slave is 8, but it s rsvd for tl-ul and tl-uh. Error should flash.
        `svt_xvm_send(slv_tr)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

    fork
      begin
        `svt_xvm_send(tr1)
      end
      begin
        //EI added for 2nd Master txn
        cust_resp_dparam_error.d_param=1; //d_param sent from slave is 1, but it s rsvd for tl-ul and tl-uh. Error should flash.
        `svt_xvm_send(slv_tr1)
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
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_size inside {[a_size_val+1:'hc]};
                              tr.a_source == 2;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <d_size_not_identical_to_a_size_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.a_source == 3;
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr1.a_size inside {[a_size_val+1:'hc]};
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    a_size_val = tr.a_size;
    fork 
      begin
        `svt_xvm_send(tr)
      end
      begin
        //EI added for 1st Master txn
        cust_resp_dsize_error.d_size = a_size_val-1; //for a_size as 0, d_size of 1 is sent forcefully
        `svt_xvm_send(slv_tr)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   //added clocks to sync between above set of txns and lower.
    repeat(2^(a_size_val-1)+1000) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

    a_size_val = tr1.a_size;
    fork
      begin
        `svt_xvm_send(tr1)
      end
      begin
        //EI added for 2nd Master txn
        cust_resp_dsize_error.d_size = a_size_val-1; //for a_size as 3, d_size of 0 is sent forcefully
        `svt_xvm_send(slv_tr1)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,cust_resp_dsize_error);

   //added clocks to sync between above set of txns and lower.
   repeat(2^(a_size_val-1)+1000) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //add callback to insert unmatched d_size than a_size.
   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_dcorrupt_resp_error);

    a_size_val = $clog2(data_width);

   //checker <rsvd_d_corrupt_val_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == 4;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_size inside {[a_size_val+1:'hc]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <rsvd_d_corrupt_val_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.a_source == 5;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr1.a_size inside {[a_size_val+1:'hc]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")

    fork 
      begin
        `svt_xvm_send(tr)
      end
      begin
        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

    fork
      begin
        `svt_xvm_send(tr1)
      end
      begin
        //EI added for 2nd Master txn
        `svt_xvm_send(slv_tr1)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   //added clocks to sync between above set of txns and lower.
   repeat(1500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);
   
   //checker <d_corrupt_low_while_d_denied_high_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == 6;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA}; 
                              tr.a_size inside {[a_size_val+1:'hc]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <d_corrupt_low_while_d_denied_high_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.a_source == 7;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA}; 
                              tr1.a_size inside {[a_size_val+1:'hc]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")

    fork 
      begin
        `svt_xvm_send(tr)
      end
      begin
        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

    fork
      begin
        `svt_xvm_send(tr1)
      end
      begin
        //EI added for 2nd Master txn
        `svt_xvm_send(slv_tr1)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

    //added clocks to sync between above set of txns and lower.
   repeat(1500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

   svt_tilelink_slave_callback_pool::delete(my_agent.slave,cust_dcorrupt_resp_error);
   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_denied_resp_error);
   
   //checking denied_range
   //checker <denied_resp_range_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.a_source == 8;
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              //tr.a_size inside {[a_size_val+1:'hc]};
			      tr.a_address == 'h1000;//inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]: (tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]-1)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

   //checker <denied_resp_range_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.a_source == 9;
                              tr1.a_address =='h2010000; //inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[1]: (tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[1]+tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[1]-1)]};
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              //tr1.a_size inside {[a_size_val+1:'hc]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")
    else begin
    end

    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                              //slv_tr.d_denied == 0; //d_denied is disabled
                              slv_tr.d_vld_2_d_vld_assert_delay.size() == 1;
                              slv_tr.d_vld_2_d_vld_assert_delay[0] == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq")

    fork 
      begin
        `svt_xvm_send(tr)
      end
      begin
        //EI added for 1st Master txn
        `svt_xvm_send(slv_tr)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

    fork
      begin
        `svt_xvm_send(tr1)
      end
      begin
        fork
          get_response(rsp);
        join_none
      end
    join

   //added clocks to sync between above set of txns and lower.
   repeat(5000) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_invalid_d_param_d_size_d_corpt_error_seq

class svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  int data_width;
  int a_size_val;
  uvm_object my_parent;
  svt_tilelink_slave_agent  my_slv_agent;
  svt_tilelink_master_agent my_mst_agent;
  tilelink_slave_denied_resp_error_callback cust_callback_s;

  `uvm_object_utils(svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;
   
  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq");
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

    data_width = tilelink_cfg.master_cfg[0].data_width/8;
    a_size_val = $clog2(data_width);

    cust_callback_s = new("cust_callback_s");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_slv_agent, my_parent);

    //erro inserted to send wrong d_denied
    svt_tilelink_slave_callback_pool::add(my_slv_agent.slave,cust_callback_s);

   //checker <out_of_slv_addr_boundary_error> expected.
   //checker <denied_resp_range_error> expected.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_size inside {[a_size_val+1:'hc]};
                              tr.a_source == 1;
                              tr.a_address inside {['h0:tilelink_cfg.slave_cfg[0].mem_base_address]}; //address range outside configured range. Error should flash here
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
    else begin
    end

   //checker <out_of_slv_addr_boundary_error> expected.
   //checker <denied_resp_range_error> expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr1.a_size inside {[a_size_val+1:'hc]};
                              tr1.a_source == 2;
                              tr1.a_address inside {[(tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range - 2) : 'h250000000]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin
        `svt_xvm_send(slv_tr)
      end
    join

    //erro inserted to send wrong d_denied
    svt_tilelink_slave_callback_pool::delete(my_slv_agent.slave,cust_callback_s);

    //check <burst_larger_than_4kb_error> will flash
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   tr.valid_a_size.constraint_mode(0);
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET, svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr.a_size == 'hd;
                              tr.a_source == 3;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].mem_base_address: (tilelink_cfg.slave_cfg[0].mem_base_address+tilelink_cfg.slave_cfg[0].mem_address_range)]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
    else begin
    end
    `svt_xvm_send(tr)

    repeat(500) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk

    //erro inserted to send wrong d_denied
    svt_tilelink_slave_callback_pool::add(my_slv_agent.slave,cust_callback_s);

   //checker <denied_resp_range_error> expected, bcz for TL-UL multi-beat is transmitted.
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with { 
                              tr.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA, svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA, svt_tilelink_master_transaction::CH_A_GET}; 
                              tr.a_size inside {[a_size_val+1:'hc]};
                              tr.a_source == 4;
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]:tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0]-1]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
    else begin
    end

   //checker <denied_resp_range_error> expected, bcz for TL-UL only putfull/part and get are expected.
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.ch_a_msg_type inside {svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA, svt_tilelink_master_transaction::CH_A_LOGICAL_DATA, svt_tilelink_master_transaction::CH_A_INTENT}; 
                              tr1.a_source == 5;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]:tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0]-1]};
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
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
                             `uvm_error("Randomization Failure","svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq")
    fork 
      begin
        `svt_xvm_send(tr)
        `svt_xvm_send(tr1)
      end
      begin
        `svt_xvm_send(slv_tr)
      end
    join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_tl_uh_boundry_check_a_param_rsvd_error_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_random_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=10;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_uh_random_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_random_seq");
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
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);

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
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_random_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_random_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_random_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_random_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_random_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_random_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (20) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 20 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_random_seq


//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_denied_region_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1000;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_uh_denied_region_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_master_ul_slave_seq");
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
    `uvm_info("body", $sformatf("%0s to get env handle from test",  status ? "Able" : "Unable"),UVM_LOW);
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

   /* Txn on address within address range configured as UL_ONLY*/
   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.a_size > $clog2(cfg.data_width/8);
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0] : tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0]] };
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_denied_region_verif_seq")

   /* Txn on address startung in UH address range and ending in UL-ONLY address range*/
   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.a_size > $clog2(cfg.data_width/8)+3;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]-8 : tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]-1] };
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_denied_region_verif_seq")

   /* Txn on address startung in UL-ONLY address range and ending in UH address range*/
   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type inside {2,3,5};
                              tr2.a_size > $clog2(cfg.data_width/8);
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0]-8 :tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+ tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0]] };
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_denied_region_verif_seq")

   /* Txn on address within in UH address range*/
   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              !(tr3.a_address inside {[tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0] : tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0]] });
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_denied_region_verif_seq")

   /* Txn on the last address of UL-ONLY address range*/
   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.a_address == tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]+tilelink_cfg.slave_cfg[0].d_denied_resp_address_range[0] ;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_denied_region_verif_seq")

   source++;
   /* Txn ending on the first address of UL-ONLY address range*/
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.ch_a_msg_type inside {2,3,5};
                              tr5.a_source == source;
                              tr5.a_size   <= 1;
                              tr5.a_address == tilelink_cfg.slave_cfg[0].d_denied_resp_base_address[0]-1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_denied_region_verif_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (20) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 20 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_denied_region_verif_seq



//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_master_ul_slave_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1000;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_uh_master_ul_slave_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_master_ul_slave_seq");
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
    `uvm_info("body", $sformatf("%0s to get env handle from test",  status ? "Able" : "Unable"),UVM_LOW);
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

   /* Txn on address within address range configured as UL_ONLY*/
   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.a_size > $clog2(cfg.data_width/8);
                              tr.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0] : tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0]] };
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_master_ul_slave_seq")

   /* Txn on address startung in UH address range and ending in UL-ONLY address range*/
   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.a_size > $clog2(cfg.data_width/8)+3;
                              tr1.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]-8 : tilelink_cfg.slave_cfg[0].ul_only_base_address[0]-1] };
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_master_ul_slave_seq")

   /* Txn on address startung in UL-ONLY address range and ending in UH address range*/
   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type inside {2,3,5};
                              tr2.a_size > $clog2(cfg.data_width/8);
                              tr2.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0]-8 :tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+ tilelink_cfg.slave_cfg[0].ul_only_address_range[0]] };
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_master_ul_slave_seq")

   /* Txn on address within in UH address range*/
   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              !(tr3.a_address inside {[tilelink_cfg.slave_cfg[0].ul_only_base_address[0] : tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0]] });
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_master_ul_slave_seq")

   /* Txn on the last address of UL-ONLY address range*/
   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.a_address == tilelink_cfg.slave_cfg[0].ul_only_base_address[0]+tilelink_cfg.slave_cfg[0].ul_only_address_range[0] ;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_master_ul_slave_seq")

   source++;
   /* Txn ending on the first address of UL-ONLY address range*/
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.ch_a_msg_type inside {2,3,5};
                              tr5.a_source == source;
                              tr5.a_size   <= 1;
                              tr5.a_address == tilelink_cfg.slave_cfg[0].ul_only_base_address[0]-1;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_master_ul_slave_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (20) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 20 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_master_ul_slave_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1000;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq");
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
    `uvm_info("body", $sformatf("%0s to get env handle from test",  status ? "Able" : "Unable"),UVM_LOW);
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin

   /*txn with firts beat being repeated because of missed a_vld-a_rdy handshake while a_valid was high.
     IN this txn, a_valid toggles from 1->0 & a_ready toggles from 0->1 at same posedge of clock, hence 
     handshake missed at first, the master repeats first beat*/
   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.en_msg_discard== 0;
                              tr.a_size == $clog2(tilelink_cfg.slave_cfg[0].data_width/8)+2;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i])tr.a_vld_2_a_vld_assert_delay[i]==4;
                              foreach(tr.a_vld_deassert_delay[i])tr.a_vld_deassert_delay[i]==4;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq")


  /* This txn configures a_valid & a_ready delays such that a_valid-a_ready handshake happens after the first cycle of a_valid being high & 
     before the last cycle for which a_valid can remain high for a given beat. */
   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.en_msg_discard== 0;
                              tr1.a_size == $clog2(tilelink_cfg.slave_cfg[0].data_width/8)+2;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i])tr1.a_vld_2_a_vld_assert_delay[i]==2;
                              foreach(tr1.a_vld_deassert_delay[i])tr1.a_vld_deassert_delay[i]==5;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq")


  /* THis txn configures a_valid & a_ready delayssuch that first beat of txn misses handshake but since msg_discard_en is 0,
     Master will repeat the first beat till it gets accepted by slave.
     Also, a_valid-a_ready handshake, whenever happens,  happens at the first and only clock cycle for which a_valid can remain high.
     This txn tests the a_valid-a_ready handshake happening at the first cycle of a_valid high as well as last cycle of a_valid high.*/
   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.en_msg_discard== 0;
                              tr2.a_size > $clog2(tilelink_cfg.slave_cfg[0].data_width/8);
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i])tr2.a_vld_2_a_vld_assert_delay[i]==3;
                              foreach(tr2.a_vld_deassert_delay[i])tr2.a_vld_deassert_delay[i]==3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq")

  /* This txn configures a_valid-a_valid & a_valid-a_ready delays such that first beat of txn gets accepted & 2nd beat misses a_valid-a_ready handshake.
     Since the transaction has already been accepted, expecting the 2nd beat to be repeated by master. */
   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.a_size ==  $clog2(tilelink_cfg.slave_cfg[0].data_width/8)+2;
                              tr3.a_vld_deassert_delay.size()==4;
                              tr3.en_msg_discard== 1;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i])tr3.a_vld_2_a_vld_assert_delay[i]==3;
                              foreach(tr3.a_vld_deassert_delay[i])tr3.a_vld_deassert_delay[i]==3;
                            })
                            begin
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq")
                           end else begin

                              tr3.a_vld_deassert_delay[1]=2;
                            end

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.a_size ==  $clog2(tilelink_cfg.slave_cfg[0].data_width/8)+2;
                              tr4.a_vld_deassert_delay.size()==1;
                              tr4.en_msg_discard== 1;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i])tr4.a_vld_2_a_vld_assert_delay[i]==2;
                              foreach(tr4.a_vld_deassert_delay[i])tr4.a_vld_deassert_delay[i]==1;
                            })
                            begin
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq")
                           end else begin
                              tr4.a_vld_deassert_delay[0]=2;
                              tr4.a_vld_2_a_vld_assert_delay[0]=1;
                            end

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.a_size ==  $clog2(tilelink_cfg.slave_cfg[0].data_width/8)+2;
                              tr5.a_vld_deassert_delay.size()==1;
                              tr5.en_msg_discard== 1;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i])tr5.a_vld_2_a_vld_assert_delay[i]==2;
                              foreach(tr5.a_vld_deassert_delay[i])tr5.a_vld_deassert_delay[i]==1;
                            })
                            begin
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq")
                           end else begin
                              tr5.a_vld_deassert_delay[0]=1;
                              tr5.a_vld_2_a_vld_assert_delay[0]=1;
                            end
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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (20) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 20 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_chnl_hndshk_for_diff_beats_verif_seq



//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3,slv_tr4,slv_tr5;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq");
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
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);
    status = uvm_config_db#(svt_tilelink_system_configuration)::get(m_sequencer, get_type_name(), "tilelink_cfg", tilelink_cfg);
    `uvm_info("body", $sformatf("%0s to get cfg handle from test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 for(int j=0;j<total_packets;j++)
 begin
   source = source + 1;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i])tr.a_vld_2_a_vld_assert_delay[i]==4;
                              foreach(tr.a_vld_deassert_delay[i])tr.a_vld_deassert_delay[i]==10;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")

   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                                 slv_tr.a_vld_a_rdy_assert_delay==9;
                                 slv_tr.a_rdy_deassert_delay==0;
                                 slv_tr.a_rdy_2_a_rdy_assert_delay==0;
                                 slv_tr.d_vld_2_d_vld_assert_delay.size() == 1024; 
                                 foreach(slv_tr.d_vld_2_d_vld_assert_delay[i]) slv_tr.d_vld_2_d_vld_assert_delay[i]==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")



   source = source + 1;
   `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with { 
                              tr1.a_source == source;
                              tr1.a_size == $clog2(tilelink_cfg.master_cfg[0].data_width/8)+2;
                              //tr1.en_msg_discard== 1;
                              tr1.a_vld_deassert_delay.size() == (2**tr1.a_size)/(tilelink_cfg.master_cfg[0].data_width/8);
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i])tr1.a_vld_2_a_vld_assert_delay[i]==2;
                              foreach(tr1.a_vld_deassert_delay[i])tr1.a_vld_deassert_delay[i]==10;
                            })
    begin
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")
    end else begin
      tr1.a_vld_deassert_delay[1] = 15;
    end


   `svt_xvm_create_on(slv_tr1,p_sequencer.slave_sequencer[0])
   if (!slv_tr1.randomize() with {
                                 slv_tr1.a_vld_a_rdy_assert_delay==4;
                                 slv_tr1.a_rdy_deassert_delay==0;
                                 slv_tr1.a_rdy_2_a_rdy_assert_delay==0;
                                 slv_tr1.d_vld_2_d_vld_assert_delay.size() == 1024; 
                                 foreach(slv_tr1.d_vld_2_d_vld_assert_delay[i]) slv_tr1.d_vld_2_d_vld_assert_delay[i]==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")


   source = source + 1;
   `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with { 
                              tr2.a_source == source;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i])tr2.a_vld_2_a_vld_assert_delay[i]==3;
                              foreach(tr2.a_vld_deassert_delay[i])tr2.a_vld_deassert_delay[i]==10;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")

      `svt_xvm_create_on(slv_tr2,p_sequencer.slave_sequencer[0])
   if (!slv_tr2.randomize() with {
                                 slv_tr2.a_vld_a_rdy_assert_delay ==7;
                                 slv_tr2.d_vld_2_d_vld_assert_delay.size() == 1024; 
                                 slv_tr2.a_rdy_deassert_delay==0;
                                 slv_tr2.a_rdy_2_a_rdy_assert_delay==0;
                                 foreach(slv_tr2.d_vld_2_d_vld_assert_delay[i]) slv_tr2.d_vld_2_d_vld_assert_delay[i]==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")


   source = source + 1;
   `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with { 
                              tr3.a_source == source;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i])tr3.a_vld_2_a_vld_assert_delay[i]==3;
                              foreach(tr3.a_vld_deassert_delay[i])      tr3.a_vld_deassert_delay[i]==10;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")

   `svt_xvm_create_on(slv_tr3,p_sequencer.slave_sequencer[0])
   if (!slv_tr3.randomize() with {
                                 slv_tr3.a_vld_a_rdy_assert_delay == 1;
                                 slv_tr3.a_rdy_deassert_delay==0;
                                 slv_tr3.a_rdy_2_a_rdy_assert_delay==0;
                                 slv_tr3.d_vld_2_d_vld_assert_delay.size() == 1024; 
                                 foreach(slv_tr3.d_vld_2_d_vld_assert_delay[i]) slv_tr3.d_vld_2_d_vld_assert_delay[i]==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")


   source = source + 1;
   `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with { 
                              tr4.a_source == source;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i])tr4.a_vld_2_a_vld_assert_delay[i]==3;
                              foreach(tr4.a_vld_deassert_delay[i])tr4.a_vld_deassert_delay[i]==10;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")

   `svt_xvm_create_on(slv_tr4,p_sequencer.slave_sequencer[0])
   if (!slv_tr4.randomize() with {
                                 slv_tr4.a_vld_a_rdy_assert_delay == 0;
                                 slv_tr4.a_rdy_deassert_delay==0;
                                 slv_tr4.a_rdy_2_a_rdy_assert_delay==0;
                                 slv_tr4.d_vld_2_d_vld_assert_delay.size() == 1024; 
                                 foreach(slv_tr4.d_vld_2_d_vld_assert_delay[i]) slv_tr4.d_vld_2_d_vld_assert_delay[i]==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")

   source = source + 1;
   `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with { 
                              tr5.a_source == source;
                              tr5.a_size == $clog2(tilelink_cfg.master_cfg[0].data_width/8)+2;
                              //tr1.en_msg_discard== 1;
                              tr5.a_vld_deassert_delay.size() == (2**tr1.a_size)/(tilelink_cfg.master_cfg[0].data_width/8);
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i])tr5.a_vld_2_a_vld_assert_delay[i]==2;
                              foreach(tr5.a_vld_deassert_delay[i])tr5.a_vld_deassert_delay[i]==10;
                            })
    begin
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")
    end else begin
      tr5.a_vld_deassert_delay[1] = 15;
    end


   `svt_xvm_create_on(slv_tr5,p_sequencer.slave_sequencer[0])
   if (!slv_tr5.randomize() with {
                                 slv_tr5.a_vld_a_rdy_assert_delay==4;
                                 slv_tr5.a_rdy_deassert_delay==0;
                                 slv_tr5.a_rdy_2_a_rdy_assert_delay==0;
                                 slv_tr5.d_vld_2_d_vld_assert_delay.size() == (2**tr.a_size)/(cfg.data_width/8);
                                 foreach(slv_tr5.d_vld_2_d_vld_assert_delay[i]) slv_tr5.d_vld_2_d_vld_assert_delay[i]==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq")

  end


 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 fork

   begin
   `svt_xvm_send(slv_tr)
   `svt_xvm_send(tr)
    @(test_top.tilelink_master_if[0].event_txn_complete, negedge test_top.tilelink_master_if[0].tl_clock);
   foreach(env.sys_env.master[i]) begin 
     tilelink_cfg.master_cfg[i].tl_req_transaction_timeout=15;
     env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
   end
   `svt_xvm_send(slv_tr1)
   `svt_xvm_send(tr1)
    @(test_top.tilelink_master_if[0].event_txn_complete, negedge test_top.tilelink_master_if[0].tl_clock);
   foreach(env.sys_env.master[i]) begin 
     tilelink_cfg.master_cfg[i].tl_req_transaction_timeout=6;
     env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
   end
   `svt_xvm_send(slv_tr2)
   `svt_xvm_send(tr2)
    @(test_top.tilelink_master_if[0].event_txn_complete, negedge test_top.tilelink_master_if[0].tl_clock);
   foreach(env.sys_env.master[i]) begin 
     tilelink_cfg.master_cfg[i].tl_req_transaction_timeout=1;
     env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
   end
   `svt_xvm_send(slv_tr3)
   `svt_xvm_send(tr3)
    @(test_top.tilelink_master_if[0].event_txn_complete, negedge test_top.tilelink_master_if[0].tl_clock);
   foreach(env.sys_env.master[i]) begin 
     tilelink_cfg.master_cfg[i].tl_req_transaction_timeout=10;
     env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
   end
   `svt_xvm_send(slv_tr4)
   `svt_xvm_send(tr4)
    @(test_top.tilelink_master_if[0].event_txn_complete, negedge test_top.tilelink_master_if[0].tl_clock);
   foreach(env.sys_env.master[i]) begin 
     tilelink_cfg.master_cfg[i].tl_req_transaction_timeout=6;
     env.sys_env.master[i].reconfigure_via_task(tilelink_cfg.master_cfg[i]);
   end
   `svt_xvm_send(slv_tr5)
   `svt_xvm_send(tr5)
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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body
endclass : svt_tilelink_uh_a_chnl_hndshk_with_timeout_comb_verif_seq



//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_resp_at_diff_beat_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3,slv_tr4;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=100;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_resp_at_diff_beat_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_resp_at_diff_beat_verif_seq");
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
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);

    backdoor_handle = new(tilelink_cfg,env);

 `ifndef DATA_INTEGRITY_DISABLE
fork:DATA_INTEGRITY//fork

 begin//begin for 1st fork begin
 `endif

 fork

   begin
     for(int j=0;j<total_packets;j++)
     begin
       fork
         begin
           source++;
           `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
           if (!tr.randomize() with {
                                      tr.ch_a_msg_type != 4;
                                      tr.a_source == source;
                                      tr.a_size == 5;
                                      foreach(tr.a_vld_2_a_vld_assert_delay[i])tr.a_vld_2_a_vld_assert_delay[i]==0;
                                      foreach(tr.a_vld_deassert_delay[i])tr.a_vld_deassert_delay[i]==10;
                                    })
                                     `uvm_error("Randomization Failure","svt_tilelink_uh_resp_at_diff_beat_verif_seq")
            `svt_xvm_send(tr)
         end
        begin
           `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
           if (!slv_tr.randomize() with {
                                         slv_tr.a_vld_a_rdy_assert_delay==1;
                                         slv_tr.a_vld_d_vld_cross_channel_delay==2;
                                         slv_tr.a_rdy_deassert_delay==0;
                                         slv_tr.a_rdy_2_a_rdy_assert_delay==0;
                                         slv_tr.d_vld_2_d_vld_assert_delay.size() == (2**tr.a_size)/(cfg.data_width/8);
                                         foreach(slv_tr.d_vld_2_d_vld_assert_delay[i])
                                           slv_tr.d_vld_2_d_vld_assert_delay[i]==0;
                                    })
                                     `uvm_error("Randomization Failure","svt_tilelink_uh_resp_at_diff_beat_verif_seq")
            `svt_xvm_send(slv_tr)
        end
       join

     end
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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body
endclass : svt_tilelink_uh_resp_at_diff_beat_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_burst_length_req_cmd_transition_coverage_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  int msg_type;

  `uvm_object_utils(svt_tilelink_uh_burst_length_req_cmd_transition_coverage_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_burst_length_req_cmd_transition_coverage_seq");
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

  for(int k=0;k<13;k++)
  begin

   for(int l=1;l<7;l++)
   begin

    for(int m=1;m<7;m++)
    begin

     for(int j=0;j<13;j++)
     begin

   source++;

         if (l == 1) msg_type = svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA      ;
   else  if (l == 2) msg_type = svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA   ;
   else  if (l == 3) msg_type = svt_tilelink_master_transaction::CH_A_INTENT             ;
   else  if (l == 4) msg_type = svt_tilelink_master_transaction::CH_A_GET                ;
   else  if (l == 5) msg_type = svt_tilelink_master_transaction::CH_A_LOGICAL_DATA       ;
   else  if (l == 6) msg_type = svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA    ;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.ch_a_msg_type == msg_type;
                              tr.a_source == source;
                              tr.a_size == k;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_burst_length_req_cmd_transition_coverage_seq")


   source++;

         if (m == 1) msg_type = svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA      ;
   else  if (m == 2) msg_type = svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA   ;
   else  if (m == 3) msg_type = svt_tilelink_master_transaction::CH_A_INTENT             ;
   else  if (m == 4) msg_type = svt_tilelink_master_transaction::CH_A_GET                ;
   else  if (m == 5) msg_type = svt_tilelink_master_transaction::CH_A_LOGICAL_DATA       ;
   else  if (m == 6) msg_type = svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA    ;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.ch_a_msg_type == msg_type;
                              tr1.a_source == source;
                              tr1.a_size == j;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_burst_length_req_cmd_transition_coverage_seq")





   begin
   `svt_xvm_send(tr)
   `svt_xvm_send(tr1)
   end

    end//for j
   end//for m
  end//for l
 end//for k


 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_burst_length_req_cmd_transition_coverage_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_corrupt_coverage_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,tr6,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  int total_packets=13;//total no of REQ that has to be sent
  get_backdoor_data backdoor_handle;
  int a_corrupt_enable;
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int a_address_value;

  `uvm_object_utils(svt_tilelink_uh_a_corrupt_coverage_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_corrupt_coverage_seq");
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
 fork:DATA_INTEGRITY

 begin//begin for 1st fork begin
 `endif

 for(int j=0;j<total_packets;j++)
 begin


   source++;
  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              foreach(tr.a_corrupt[i])  tr.a_corrupt[i] == 1; //a_corrupt is enabled
                              tr.a_size == j;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_corrupt_coverage_seq")



   `svt_xvm_send(tr)

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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_corrupt_coverage_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_d_corrupt_coverage_seq extends uvm_sequence;

  rand int unsigned sequence_length =1;
  tilelink_xvm_env env;
  bit status;
  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses FIFO values
  bit[63:0] alingned_address_value;//hold the value of alingned address which is finally going to be driven
  int count;//to hold the total no of packets
  get_backdoor_data backdoor_handle;
  uvm_object my_parent;
  svt_tilelink_slave_agent my_agent;
  int resp_received;//Toatal RESP that has come in total  
  bit [15:0] temp_a_source;
  bit [11:0] temp_a_size;
  tilelink_slave_dcorrupt_resp_error_callback   cust_dcorrupt_resp_error;
  bit [15:0] source;

  `uvm_object_utils(svt_tilelink_uh_d_corrupt_coverage_seq)
  `uvm_declare_p_sequencer(tilelink_virtual_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_d_corrupt_coverage_seq");
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

    cust_dcorrupt_resp_error  = new("cust_dcorrupt_resp_error");

    my_parent = p_sequencer.slave_sequencer[0].get_parent();
    $cast(my_agent, my_parent);

    status = uvm_config_db#(tilelink_xvm_env)::get(m_sequencer, get_type_name(), "env", env);
    `uvm_info("body", $sformatf("%0s to get env handle form test",  status ? "Able" : "Unable"),UVM_LOW);

   //add callback to insert unmatched d_size than a_size.
   svt_tilelink_slave_callback_pool::add(my_agent.slave,cust_dcorrupt_resp_error);



    //slave transaction
   `svt_xvm_create_on(slv_tr,p_sequencer.slave_sequencer[0])
   if (!slv_tr.randomize() with {
                                 slv_tr.d_denied == 0; //d_denied is disabled
                                })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_corrupt_coverage_seq")

 fork
  begin
    for(int i=0;i<13;i++)
    begin

    source++;
   `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
    if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr.a_size == i;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_d_corrupt_coverage_seq")
    `svt_xvm_send(tr)
    end//for
  end

  begin
   `svt_xvm_send(slv_tr)
  end
 join

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_d_corrupt_coverage_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq");
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
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 5;
                              foreach(tr.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr.a_vld_2_a_vld_assert_delay[i] == 15 : tr.a_vld_2_a_vld_assert_delay[i] == 0);
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 0;
                              tr.a_vld_2_d_rdy_delay == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                              foreach(tr1.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr1.a_vld_2_a_vld_assert_delay[i] == 15 : tr1.a_vld_2_a_vld_assert_delay[i] == 0);
                              foreach(tr1.a_vld_deassert_delay[i]) tr1.a_vld_deassert_delay[i] == 0;
                              tr1.a_vld_2_d_rdy_delay == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr2.a_vld_2_a_vld_assert_delay[i] == 15 : tr2.a_vld_2_a_vld_assert_delay[i] == 0);
                              foreach(tr2.a_vld_deassert_delay[i]) tr2.a_vld_deassert_delay[i] == 0;
                              tr2.a_vld_2_d_rdy_delay == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                              foreach(tr3.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr3.a_vld_2_a_vld_assert_delay[i] == 15 : tr3.a_vld_2_a_vld_assert_delay[i] == 0);
                              foreach(tr3.a_vld_deassert_delay[i]) tr3.a_vld_deassert_delay[i] == 0;
                              tr3.a_vld_2_d_rdy_delay == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr4.a_vld_2_a_vld_assert_delay[i] == 15 : tr4.a_vld_2_a_vld_assert_delay[i] == 0);
                              foreach(tr4.a_vld_deassert_delay[i]) tr4.a_vld_deassert_delay[i] == 0;
                              tr4.a_vld_2_d_rdy_delay == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i]) (i == 0 ? tr5.a_vld_2_a_vld_assert_delay[i] == 15 : tr5.a_vld_2_a_vld_assert_delay[i] == 0);
                              foreach(tr5.a_vld_deassert_delay[i]) tr5.a_vld_deassert_delay[i] == 0;
                              tr5.a_vld_2_d_rdy_delay == 3;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq")

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

 begin//5th fork begin
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_vld_2_d_rdy_cross_channel_delay_verif_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq");
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
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == 6;
                              tr2.a_address == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == 6;
                              tr4.a_address == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == 6;
                              tr5.a_address == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq")

   begin
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j


 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_region_based_d_vld_d_vld_delay_seq
//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source = 65535;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  bit source_flag;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq");
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


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 12;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq")


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_100_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source = 65535;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  bit source_flag;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq");
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


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 12;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq")


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_500_seq


//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source = 65535;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  bit source_flag;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq");
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


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 12;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq")


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_10000_req_meme_time_profile_outstanding_1000_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=400;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq");
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
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq")


   begin
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_rdy2rdy_delay_using_config_verif_coverage_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=400;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq");
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
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq")


   begin
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_valid_a_ready_delay_using_config_verif_coverage_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_valid_deassert_delay_coverage_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=2;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;

  `uvm_object_utils(svt_tilelink_uh_a_valid_deassert_delay_coverage_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_valid_deassert_delay_coverage_seq");
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
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_deassert_delay_coverage_seq")
   else
                             begin
                              tr2.a_vld_2_a_vld_assert_delay = new[1];
                              tr2.a_vld_deassert_delay = new[1];
                              foreach(tr2.a_vld_2_a_vld_assert_delay[i])  tr2.a_vld_2_a_vld_assert_delay[i] = 3 ;
                              foreach(tr2.a_vld_deassert_delay[i]) tr2.a_vld_deassert_delay[i] = 1;
                             end

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_deassert_delay_coverage_seq")
   else
                             begin
                              tr4.a_vld_2_a_vld_assert_delay = new[1];
                              tr4.a_vld_deassert_delay = new[1];
                              foreach(tr4.a_vld_2_a_vld_assert_delay[i])  tr4.a_vld_2_a_vld_assert_delay[i] = 3 ;
                              foreach(tr4.a_vld_deassert_delay[i]) tr4.a_vld_deassert_delay[i] = 5;
                             end

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == 2;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_valid_deassert_delay_coverage_seq")
   else
                             begin
                              tr5.a_vld_2_a_vld_assert_delay = new[1];
                              tr5.a_vld_deassert_delay = new[1];
                              foreach(tr5.a_vld_2_a_vld_assert_delay[i])  tr5.a_vld_2_a_vld_assert_delay[i] = 3 ;
                              foreach(tr5.a_vld_deassert_delay[i]) tr5.a_vld_deassert_delay[i] = 15;
                             end


   begin
   `svt_xvm_send(tr2)
   `svt_xvm_send(tr4)
   `svt_xvm_send(tr5)
   end

  end//for j

 `ifndef DATA_INTEGRITY_DISABLE

  wait(resp_received == tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num);//WAIT till all the RESP has not come
  repeat(50) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 50 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_valid_deassert_delay_coverage_seq


//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_a_vld_high_random_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=1000;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;

  `uvm_object_utils(svt_tilelink_uh_a_vld_high_random_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_a_vld_high_a_vld_high_random_seq");
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
    status = uvm_config_db#(int)::get(m_sequencer, get_type_name(), "total_packets", total_packets);
    `uvm_info("body", $sformatf("%0s to get total_packets value from test",  status ? "Able" : "Unable"),UVM_LOW);

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
                              foreach(tr.a_vld_deassert_delay[i]) tr.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_high_random_seq")

   source++;
  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              foreach(tr1.a_vld_deassert_delay[i]) tr1.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_high_random_seq")

   source++;
  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              foreach(tr2.a_vld_deassert_delay[i]) tr2.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_high_random_seq")

   source++;
  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              foreach(tr3.a_vld_deassert_delay[i]) tr3.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_high_random_seq")

   source++;
  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              foreach(tr4.a_vld_deassert_delay[i]) tr4.a_vld_deassert_delay[i] == 0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_high_random_seq")

   source++;
  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              foreach(tr5.a_vld_deassert_delay[i]) tr5.a_vld_deassert_delay[i] ==0;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_a_vld_high_random_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (20) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for 20 posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_a_vld_high_random_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=16500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source = 65535;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  bit source_flag;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq");
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


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 12;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq")


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_20_seq

//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=16500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source = 65535;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  bit source_flag;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq");
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


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 12;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq")


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_100_seq


//--------------------------------------------------------------------------------------------------------------------------------
class svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq extends uvm_sequence;

  svt_tilelink_master_transaction   tr,tr1,tr2,tr3,tr4,tr5,mst_tr;
  svt_tilelink_slave_transaction    slv_tr,slv_tr1,slv_tr2,slv_tr3;
  bit[12:0] data_size, a_size_value;//To hold the value of data_width, max value is 1024
  bit[63:0] start_address, range_address, end_address;//to hold the start and end address value which has been set in testcase for TL_UL
  bit[63:0] alingned_address[$];//queue to hold alingned addresses for the particular a_size
  int address_size;//to hold the no of total alingned addresses
  int data_width;//to hold the no of total alingned addresses
  bit[63:0] alingned_address_value, alingned_address_value_1;//hold the value of alingned address which is finally going to be driven

  get_backdoor_data backdoor_handle;
  int total_packets=16500;//total no of REQ that has to be sent
  int resp_received;//Toatal RESP that has come in total  
  int req_resp_received;//Total REQ that has come on bus in total  
  int req_sent;//Toatal REQ SENT
  bit [15:0] temp_a_source;
  bit [15:0] source = 65535;
  bit [11:0] temp_a_size;
  tilelink_xvm_env env;
  bit status;
  int temp_d_source;
  bit source_flag;

  `uvm_object_utils(svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq)
  `uvm_declare_p_sequencer(svt_tilelink_system_sequencer)

  /** TILE_LINK configuration handle */ 
  svt_tilelink_system_configuration tilelink_cfg;

  //---------------------------------------------------------------------------
  /** Constructor. */
  function new(string name="svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq");
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


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr,p_sequencer.master_sequencer[0])
   if (!tr.randomize() with {
                              tr.a_source == source;
                              tr.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_FULL_DATA;
                              tr.a_size == 12;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq")


   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr1,p_sequencer.master_sequencer[0])
   if (!tr1.randomize() with {
                              tr1.a_source == source;
                              tr1.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_PUT_PARTIAL_DATA;
                              tr1.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr2,p_sequencer.master_sequencer[0])
   if (!tr2.randomize() with {
                              tr2.a_source == source;
                              tr2.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_GET;
                              tr2.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr3,p_sequencer.master_sequencer[0])
   if (!tr3.randomize() with {
                              tr3.a_source == source;
                              tr3.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_INTENT;
                              tr3.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr4,p_sequencer.master_sequencer[0])
   if (!tr4.randomize() with {
                              tr4.a_source == source;
                              tr4.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_LOGICAL_DATA;
                              tr4.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq")

   if(source_flag == 0) source--;
   if(source_flag == 1) source++;
   if(source == 0) source_flag = 1;

  `svt_xvm_create_on(tr5,p_sequencer.master_sequencer[0])
   if (!tr5.randomize() with {
                              tr5.a_source == source;
                              tr5.ch_a_msg_type == svt_tilelink_master_transaction::CH_A_ARITHMETIC_DATA;
                              tr5.a_size == tr.a_size;
                            })
                             `uvm_error("Randomization Failure","svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq")

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

  wait(resp_received == (tilelink_cfg.master_cfg[0].tilelink_master_if.xact_num));//WAIT till all the RESP has not come
  repeat (1100) @(posedge tilelink_cfg.master_cfg[0].tilelink_master_if.tl_clock);//waiting for every posedge of clk
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
   backdoor_handle.resp_beat();
 end//5th fork end

join_any

disable DATA_INTEGRITY;

 `endif

    `uvm_info("body", "Exiting...", UVM_DEBUG)
  endtask : body

endclass : svt_tilelink_uh_put_get_cmd_100000_req_meme_time_profile_outstanding_300_seq


