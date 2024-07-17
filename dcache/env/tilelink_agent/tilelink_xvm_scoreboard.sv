
`ifndef GUARD_TILELINK_XVM_SCOREBOARD_SV
`define GUARD_TILELINK_XVM_SCOREBOARD_SV

/** TLM Ananlysis implementation ports */
`uvm_analysis_imp_decl(_master_trans_tx) // for master mon write for tx
`uvm_analysis_imp_decl(_master_trans_rx) // for master mon write for rx
`uvm_analysis_imp_decl(_master_trans_status) // for master mon write for status

`uvm_analysis_imp_decl(_slave_trans_tx)  // for slave mon write for tx
`uvm_analysis_imp_decl(_slave_trans_rx)  // for slave mon write for rx
`uvm_analysis_imp_decl(_slave_trans_status)  // for slave mon write for status
`include "../env/svt_tilelink_null_virtual_sequence.sv"

class tilelink_xvm_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(tilelink_xvm_scoreboard)

  /**  Provide implementations of different write functions name for each port in master*/
  `SVT_XVM(analysis_imp_master_trans_tx)     #(svt_tilelink_master_transaction, tilelink_xvm_scoreboard) Master2Sb_port_tx;
  `SVT_XVM(analysis_imp_master_trans_rx)     #(svt_tilelink_master_transaction, tilelink_xvm_scoreboard) Master2Sb_port_rx;
  `SVT_XVM(analysis_imp_master_trans_status) #(svt_tilelink_master_status, tilelink_xvm_scoreboard) Master2Sb_port_status;

  /**  Provide implementations of different write functions name for each port in slave*/
  `SVT_XVM(analysis_imp_slave_trans_tx)      #(svt_tilelink_slave_transaction,  tilelink_xvm_scoreboard) Slave2Sb_port_tx;
  `SVT_XVM(analysis_imp_slave_trans_rx)      #(svt_tilelink_slave_transaction,  tilelink_xvm_scoreboard) Slave2Sb_port_rx;
  `SVT_XVM(analysis_imp_slave_trans_status)  #(svt_tilelink_slave_status,  tilelink_xvm_scoreboard) Slave2Sb_port_status;

  /** QUEUES to store data transactions from Master Monitor */
  svt_tilelink_master_transaction master_tx_queue[int];
  svt_tilelink_master_transaction master_rx_queue[$];
  svt_tilelink_master_transaction master_rx_queue_tx[int];
  svt_tilelink_master_status master_status_queue[$];

  svt_tilelink_master_transaction master_tx_debug_queue[$];
  svt_tilelink_master_transaction master_tx_debug_queue_data[$];
  int master_tx_debug_data_size[$];
  int master_tx_debug_data_size_data[$];

  /** QUEUES to store data transactions from Slave Monitor */
  svt_tilelink_slave_transaction slave_tx_queue[$];
  svt_tilelink_slave_transaction slave_tx_queue_denied[int];
  svt_tilelink_slave_transaction slave_tx_queue_final[$];
  svt_tilelink_slave_transaction slave_rx_queue_tx[int];
  svt_tilelink_slave_transaction slave_rx_queue[$];
  svt_tilelink_slave_status slave_status_queue[$];
  

  /** Configuration handle */
  cust_svt_tilelink_system_configuration cfg;
  bit status;

  bit comp2_master_status_flag ;
  bit comp2_slave_rx_flag ;
  bit comp3_slave_rx_tx_flag ;
  bit comp3_slave_tx_flag ;
  bit comp2_master_rx_flag ;
  bit comp2_slave_status_flag ; 
  bit flag_rx_second ; 

  bit new_master_rx_rcvd;
  bit new_slave_status_rcvd;
  bit new_slave_rx_rcvd;
  bit new_master_status_rcvd;

  protected bit                  disable_scoreboard = 0;
  protected int                  num_writes = 0;
  protected int                  num_init_reads = 0;

  /**  New - constructor */
  function new (string name, uvm_component parent);
    super.new(name, parent);
    Master2Sb_port_tx     = new("Master2Sb_port_tx", this);
    Master2Sb_port_rx     = new("Master2Sb_port_rx", this);
    Master2Sb_port_status = new("Master2Sb_port_status", this);

    Slave2Sb_port_tx      = new("Slave2Sb_port_tx", this);
    Slave2Sb_port_rx      = new("Slave2Sb_port_rx", this);
    Slave2Sb_port_status  = new("Slave2Sb_port_status", this);
  endfunction : new

  /** build_phase */
  function void build_phase(uvm_phase phase);
    //Step 1: Configure the sequencer for selecting the null sequence
    uvm_config_db#(uvm_object_wrapper)::set(this, " ", "default_sequence", svt_tilelink_null_virtual_sequence::type_id::get());
    `svt_trace("build_phase", "Exiting...");// Get the cfg object
    if ((!svt_config_object_db#(cust_svt_tilelink_system_configuration)::get(this, "", "cfg", cfg)) || cfg == null) 
    `svt_error("Scoreboard","cfg' is null. An svt_tilelink_configuration object or derivitive object must be set using the configuration infrastructure.");

    status = uvm_config_db#(cust_svt_tilelink_system_configuration)::get(this, "", "cfg", cfg); 
    `uvm_info("body", $sformatf("%0s to get cfg handle form test",  status ? "Able" : "Unable"),UVM_LOW);

  endfunction

  /**  write for master driver */
  virtual function void write_master_trans_tx(svt_tilelink_master_transaction master_trans);

  `ifdef SVT_TILELINK_ENABLE_SV_PRINTS
    $display($time, " sb_master_tx \n%s",master_trans.sprint());
  `endif
      master_tx_queue[master_trans.a_source] = master_trans;
  endfunction : write_master_trans_tx

  /**  write for master MOnitor */
  virtual function void write_master_trans_rx(svt_tilelink_master_transaction master_trans);
  `ifdef SVT_TILELINK_ENABLE_SV_PRINTS
    $display($time, " sb_master_rx \n%s",master_trans.sprint());
  `endif
    master_rx_queue.push_back(master_trans);
    comp2_master_rx_flag = 1;
    new_master_rx_rcvd = 1;
    master_rx_queue_tx[master_trans.a_source] = master_trans;
  endfunction : write_master_trans_rx

  /**  write for master Monitor */
  virtual function void write_master_trans_status(svt_tilelink_master_status master_trans);
  `ifdef SVT_TILELINK_ENABLE_SV_PRINTS
    $display($time, " sb_master_status \n%s",master_trans.sprint());
  `endif
    master_status_queue.push_back(master_trans);
    comp2_master_status_flag=1;
    new_master_status_rcvd = 1;
  endfunction : write_master_trans_status


  /**  write for slave monitor */
  virtual function void write_slave_trans_rx(svt_tilelink_slave_transaction slave_trans);
  `ifdef SVT_TILELINK_ENABLE_SV_PRINTS
    $display($time, " sb_slave_rx \n%s",slave_trans.sprint());
  `endif
    slave_rx_queue.push_back(slave_trans);
    comp2_slave_rx_flag = 1;
    new_slave_rx_rcvd = 1;
    slave_rx_queue_tx[slave_trans.d_source] = slave_trans;
  endfunction : write_slave_trans_rx

  /**  write for slave monitor */
  virtual function void write_slave_trans_tx(svt_tilelink_slave_transaction slave_trans);
  `ifdef SVT_TILELINK_ENABLE_SV_PRINTS
    $display($time, " sb_slave_tx \n%s",slave_trans.sprint());
  `endif
    slave_tx_queue.push_back(slave_trans);
    slave_tx_queue_denied[slave_trans.d_source] = slave_trans;
  endfunction : write_slave_trans_tx

  /**  write for slave monitor */
  virtual function void write_slave_trans_status(svt_tilelink_slave_status slave_trans);
  `ifdef SVT_TILELINK_ENABLE_SV_PRINTS
    $display($time, " sb_slave_status \n%s",slave_trans.sprint());
  `endif
    slave_status_queue.push_back(slave_trans);
    comp2_slave_status_flag = 1;
    new_slave_status_rcvd = 1;
  endfunction : write_slave_trans_status

// TASK to compare Master status and Slave rx, Properties driven by slave on the bus (rx) is compared with corresponding properties sampled by the Master (status) from the bus
  virtual task comp2_d_channel();
    bit  break_slave_rx;
    if (comp2_slave_rx_flag == 1 && comp2_master_status_flag == 1) begin
 
      foreach(slave_rx_queue[index1]) begin
        foreach(master_status_queue[index2]) begin
          if (slave_rx_queue[index1].d_source ==  master_status_queue[index2].d_source) begin
            if(slave_rx_queue[index1].ch_d_msg_type.num() != master_status_queue[index2].ch_d_msg_type.num())  `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_source =%h ---d_opcode_rx = %s --- d_opcode_status = %s",slave_rx_queue[index1].d_source,slave_rx_queue[index1].ch_d_msg_type.name(),master_status_queue[index2].ch_d_msg_type.name()))
            //if(slave_rx_queue[0].d_param != master_status_queue[0].d_param)                `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_param_rx = %h --- d_param_status = %h",slave_rx_queue[0].ch_d_msg_type,master_status_queue[0].ch_d_msg_type))
            if(slave_rx_queue[index1].d_size != master_status_queue[index2].d_size)                    `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_source =%h ---d_size_rx = %h --- d_size_status = %h",slave_rx_queue[index1].d_source,slave_rx_queue[index1].d_size,master_status_queue[index2].d_size))
            if(slave_rx_queue[index1].d_source != master_status_queue[index2].d_source)                `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_source_rx = %h --- d_source_status = %h",slave_rx_queue[index1].d_source,master_status_queue[index2].d_source))
            if(slave_rx_queue[index1].d_denied != master_status_queue[index2].d_denied)                `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_source =%h ---d_denied_rx = %b --- d_denied_status = %b",slave_rx_queue[index1].d_source,slave_rx_queue[index1].d_denied,master_status_queue[index2].d_denied))

            for(int j=0;j<master_status_queue[index2].d_data.size();j++)
            begin
            if(slave_rx_queue[index1].d_data[j] != master_status_queue[index2].d_data[j])              `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_source =%h ---d_data_rx = %h --- d_data_status = %h",slave_rx_queue[index1].d_source,slave_rx_queue[index2].d_data[j],master_status_queue[index2].d_data[j]))
            end

            for(int j=0;j<master_status_queue[index2].d_corrupt.size();j++)
            begin
            if(slave_rx_queue[index1].d_corrupt[j] != master_status_queue[index2].d_corrupt[j])        `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_D",$sformatf("d_source =%h ---d_corrupt_rx = %b --- d_corrupt_status = %b",slave_rx_queue[index1].d_source,slave_rx_queue[index1].d_corrupt[j],master_status_queue[index2].d_corrupt[j]))
            end

            slave_rx_queue.delete(index1);
            master_status_queue.delete(index2);
            //comp2_slave_rx_flag = 0;
            //comp2_master_status_flag = 0;
            if (!slave_rx_queue.size())    comp2_slave_rx_flag = 0;
            if (!master_status_queue.size()) comp2_master_status_flag = 0;

            break_slave_rx = 1;
            break;
          end
        end //index2
        if (break_slave_rx) break;
      end //index1
    end
    new_slave_rx_rcvd = 0;
    new_master_status_rcvd = 0;

  endtask //comp2_d_channel

//TASK to compare Master rx and Slave status, Properties driven by master(rx) on the bus is compared with corresponding properties sampled by the Slave (status) from the bus
  virtual task comp2_a_channel();
    bit  break_master_rx;
    if (comp2_master_rx_flag == 1 && comp2_slave_status_flag == 1) begin

      foreach(master_rx_queue[index1]) begin
        foreach(slave_status_queue[index2]) begin
          if (master_rx_queue[index1].a_source ==  slave_status_queue[index2].a_source) begin
            if(master_rx_queue[index1].ch_a_msg_type.num() != slave_status_queue[index2].ch_a_msg_type.num()) `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_opcode_rx = %s ---   a_opcode_status = %s",master_rx_queue[index1].a_source,master_rx_queue[index1].ch_a_msg_type.name(),slave_status_queue[index2].ch_a_msg_type.name()))
            if(master_rx_queue[index1].a_param != slave_status_queue[index2].a_param)                       `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_param_rx = %h ---  a_param_status = %h",master_rx_queue[index1].a_source,master_rx_queue[index1].a_param,slave_status_queue[index2].a_param))
            if(master_rx_queue[index1].a_size != slave_status_queue[index2].a_size)                         `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_size_rx = %h ---   a_size_status = %h",master_rx_queue[index1].a_source,master_rx_queue[index1].a_size,slave_status_queue[index2].a_size))
            if(master_rx_queue[index1].a_source != slave_status_queue[index2].a_source)                     `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source_rx = %h --- a_source_status = %h",master_rx_queue[index1].a_source,slave_status_queue[index2].a_source))
            if(master_rx_queue[index1].a_address != slave_status_queue[index2].a_address)                   `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_address_rx = %h --- a_address_status = %h",master_rx_queue[index1].a_source,master_rx_queue[index1].a_address,slave_status_queue[index2].a_address))

            for(int j=0;j<slave_status_queue[index2].a_mask.size();j++)
            begin
            if(master_rx_queue[index1].a_mask[j] != slave_status_queue[index2].a_mask[j])                   `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_mask_rx = %h --- a_mask_status = %h",master_rx_queue[index1].a_source,master_rx_queue[index1].a_mask[j],slave_status_queue[index2].a_mask[j]))
            end

            for(int j=0;j<slave_status_queue[index2].a_data.size();j++)
            begin
            if(master_rx_queue[index1].a_data[j] != slave_status_queue[index2].a_data[j])                   `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_data_rx = %h ---   a_data_status = %h",master_rx_queue[index1].a_source,master_rx_queue[index1].a_data[j],slave_status_queue[index2].a_data[j]))
            end

            for(int j=0;j<slave_status_queue[index2].a_corrupt.size();j++)
            begin
            if(master_rx_queue[index1].a_corrupt[j] != slave_status_queue[index2].a_corrupt[j])             `uvm_error("COMPARISION_2_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h ---a_corrupt_rx = %b --- a_corrupt_status = %b",master_rx_queue[index1].a_source,master_rx_queue[index1].a_corrupt[j],slave_status_queue[index2].a_corrupt[j]))
            end

            master_rx_queue.delete(index1);
            slave_status_queue.delete(index2);
            //comp2_master_rx_flag = 0;
            //comp2_slave_status_flag = 0;
            if (!master_rx_queue.size())    comp2_master_rx_flag = 0;
            if (!slave_status_queue.size()) comp2_slave_status_flag = 0;

            break_master_rx = 1;
            break;
          end
        end //slave_status_queue[index2]
        if (break_master_rx) break;
      end //master_rx_queue[index1]
    end
    new_master_rx_rcvd = 0;
    new_slave_status_rcvd = 0;

  endtask

//TASK to do Master tx and rx comparison, MASTER Transaction properties configured from seq (tx) are compared with the corresponding properties seen on the bus(rx)
  virtual task comp1_a_channel();
    int source;
    wait(master_rx_queue_tx.num() > 0)

         master_rx_queue_tx.first(source);
          if(master_tx_queue[source].ch_a_msg_type.num() != master_rx_queue_tx[source].ch_a_msg_type.num()) `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_opcode_tx = %s ---   a_opcode_rx = %s",master_tx_queue[source].a_source,master_tx_queue[source].ch_a_msg_type.name(),master_rx_queue_tx[source].ch_a_msg_type.name()))
          if(master_tx_queue[source].a_param != master_rx_queue_tx[source].a_param)                         `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_param_tx = %h ---  a_param_rx = %h",master_tx_queue[source].a_source,master_tx_queue[source].a_param,master_rx_queue_tx[source].a_param))
          if(master_tx_queue[source].a_size != master_rx_queue_tx[source].a_size)                           `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_size_tx = %h ---   a_size_rx = %h",master_tx_queue[source].a_source,master_tx_queue[source].a_size,master_rx_queue_tx[source].a_size))
          if(master_tx_queue[source].a_source != master_rx_queue_tx[source].a_source)                       `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source_tx = %h --- a_source_rx = %h",master_tx_queue[source].a_source,master_rx_queue_tx[source].a_source))
          if(master_tx_queue[source].a_address != master_rx_queue_tx[source].a_address)                     `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_address_tx = %h --- a_address_rx = %h",master_tx_queue[source].a_source,master_tx_queue[source].a_address,master_rx_queue_tx[source].a_address))

          for(int j=0;j<master_rx_queue_tx[source].a_mask.size();j++)
          begin
          if(master_tx_queue[source].a_mask[j] != master_rx_queue_tx[source].a_mask[j])
           begin
           `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_mask_tx = %h --- a_mask_rx = %h",master_tx_queue[source].a_source,master_tx_queue[source].a_mask[j],master_rx_queue_tx[source].a_mask[j]))
           master_tx_debug_queue.push_back(master_rx_queue_tx[source]);
           master_tx_debug_data_size.push_back(cfg.master_cfg[0].data_width);

           end
          end

          for(int j=0;j<master_rx_queue_tx[source].a_data.size();j++)
          begin
          if(master_tx_queue[source].a_data[j] != master_rx_queue_tx[source].a_data[j])
           begin
           `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_data_tx = %h ---   a_data_rx = %h",master_tx_queue[source].a_source,master_tx_queue[source].a_data[j],master_rx_queue_tx[source].a_data[j]))
           master_tx_debug_queue_data.push_back(master_rx_queue_tx[source]);
           master_tx_debug_data_size_data.push_back(cfg.master_cfg[0].data_width);
           end
          end

          for(int j=0;j<master_rx_queue_tx[source].a_corrupt.size();j++)
          begin
          if(master_tx_queue[source].a_corrupt[j] != master_rx_queue_tx[source].a_corrupt[j])               `uvm_error("COMPARISION_1_FAILS_FOR_CHANNEL_A",$sformatf("a_source =%h --- a_corrupt_tx = %b --- a_corrupt_rx = %b",master_tx_queue[source].a_source,master_tx_queue[source].a_corrupt[j],master_rx_queue_tx[source].a_corrupt[j]))
          end

          //DELAYS TO BE ADDED

          master_tx_queue.delete(source);
          master_rx_queue_tx.delete(source);

  endtask

//TASK to compare Slave tx and rx, SLAVE Transaction properties configured from seq (tx) are compared with the corresponding properties seen on the bus(rx))
  virtual task comp3_d_channel();
    int source;
    wait(slave_rx_queue_tx.num() > 0);

         slave_rx_queue_tx.first(source);

         if(slave_tx_queue_denied.exists(source))//as tx won't be created for delays with config test 
          begin
         if(slave_tx_queue_denied[source].d_denied != slave_rx_queue_tx[source].d_denied)        `uvm_error("COMPARISION_3_FAILS_FOR_CHANNEL_D",$sformatf("d_source = %h --d_denied_tx = %b --- d_denied_rx = %b",slave_rx_queue_tx[source].d_source,slave_tx_queue_denied[source].d_denied,slave_rx_queue_tx[source].d_denied))
          end
         slave_tx_queue_denied.delete(source);

         //`ifdef SCOREBOARD_DELAY_COMPARISION

          //DELAYS TO BE ADDED
          if(cfg.slave_cfg[0].slv_delay_en)
          begin
            if(slave_tx_queue.size() == 0)
            begin

              if(cfg.slave_cfg[0].slv_cross_chnl_delay_en == 0)
              begin
              //d_valid_d_valid_assert
              foreach(slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i])
               begin
                if(slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i] != -1)
                begin
              if(slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i] < cfg.slave_cfg[0].min_d_vld_d_vld_assert_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_CHANNEL_D",$sformatf(" d_source = %h --d_vld_2_d_vld_assert_delay_rx = %d --- min_d_vld_d_vld_assert_delay = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i],cfg.slave_cfg[0].min_d_vld_d_vld_assert_delay[i])) 
                end
               end
              end

              if(cfg.slave_cfg[0].slv_vld_rdy_delay_en == 0 && slave_rx_queue_tx[source].a_rdy_2_a_rdy_assert_delay != -1)
              begin
              //a_ready_a_ready_assert
              if(slave_rx_queue_tx[source].a_rdy_2_a_rdy_assert_delay < cfg.slave_cfg[0].min_a_rdy_a_rdy_assert_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_CHANNEL_A",$sformatf("d_source = %h -- a_rdy_2_a_rdy_assert_delay_rx = %d --- min_a_rdy_a_rdy_assert_delay = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_rdy_2_a_rdy_assert_delay,cfg.slave_cfg[0].min_a_rdy_a_rdy_assert_delay))  
              end

              if(cfg.slave_cfg[0].slv_cross_chnl_delay_en && slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay != -1)
              begin
               if(cfg.slave_cfg[0].same_cycle_resp_en == 1)
               begin
               if((slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay+1) < cfg.slave_cfg[0].min_a_vld_d_vld_cross_chnl_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_SLAVE_CROSS_CHANNEL_DELAY",$sformatf(" d_source = %h --a_vld_d_vld_cross_channel_delay_rx = %d --- min_a_vld_d_vld_cross_chnl_delay = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay,cfg.slave_cfg[0].min_a_vld_d_vld_cross_chnl_delay)) 
               end
               else
               begin
               //a_valid_d_valid_cross_channel
               if(slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay < cfg.slave_cfg[0].min_a_vld_d_vld_cross_chnl_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_SLAVE_CROSS_CHANNEL_DELAY",$sformatf(" d_source = %h --a_vld_d_vld_cross_channel_delay_rx = %d --- min_a_vld_d_vld_cross_chnl_delay = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay,cfg.slave_cfg[0].min_a_vld_d_vld_cross_chnl_delay)) 
               end
             end//if cross_channel

              if(cfg.slave_cfg[0].slv_vld_rdy_delay_en && slave_rx_queue_tx[source].a_vld_a_rdy_assert_delay != -1)
                begin
                //a_valid_a_ready_delay
                if(slave_rx_queue_tx[source].a_vld_a_rdy_assert_delay < cfg.slave_cfg[0].min_a_vld_a_rdy_assert_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_SLAVE_VALID_READY_DELAY",$sformatf("d_source = %h -- a_vld_a_rdy_assert_delay_rx = %d --- min_a_vld_a_rdy_assert_delay = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_vld_a_rdy_assert_delay,cfg.slave_cfg[0].min_a_vld_a_rdy_assert_delay)) 
                end
            end//no_txn

            else
            begin

            if(cfg.slave_cfg[0].retain_txn_config == 1)
             begin

              if(cfg.slave_cfg[0].slv_cross_chnl_delay_en == 0)
              begin
                //d_valid_d_valid_assert
                foreach(slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i])
                begin
                if(slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i] != -1)
                 begin
                if(slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i] < slave_tx_queue[0].d_vld_2_d_vld_assert_delay[i]) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_CHANNEL_D",$sformatf(" d_source = %h --d_vld_2_d_vld_assert_delay_rx = %d --- d_vld_2_d_vld_assert_delay_tx = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].d_vld_2_d_vld_assert_delay[i],slave_tx_queue[0].d_vld_2_d_vld_assert_delay[i])) 
                 end
                end
              end

              if(cfg.slave_cfg[0].slv_vld_rdy_delay_en == 0 && slave_rx_queue_tx[source].a_rdy_2_a_rdy_assert_delay != -1)
              begin
                //a_ready_a_ready_assert
                if(slave_rx_queue_tx[source].a_rdy_2_a_rdy_assert_delay <slave_tx_queue[0].a_rdy_2_a_rdy_assert_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_CHANNEL_A",$sformatf(" d_source = %h --a_rdy_2_a_rdy_assert_delay_rx = %d --- a_rdy_2_a_rdy_assert_delay_tx = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_rdy_2_a_rdy_assert_delay,slave_tx_queue[0].a_rdy_2_a_rdy_assert_delay))  
              end

              if(cfg.slave_cfg[0].slv_cross_chnl_delay_en && slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay != -1)
               begin
                 if(cfg.slave_cfg[0].same_cycle_resp_en == 1)
                 begin
                 if((slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay+1) < slave_tx_queue[0].a_vld_d_vld_cross_channel_delay)  `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_SLAVE_CROSS_CHANNEL_DELAY",$sformatf("d_source = %h -- a_vld_d_vld_cross_channel_delay_rx = %d --- a_vld_d_vld_cross_channel_delay_tx = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay,slave_tx_queue[0].a_vld_d_vld_cross_channel_delay))
                 end
               else
               begin
               //a_valid_d_valid_cross_channel
               if(slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay < slave_tx_queue[0].a_vld_d_vld_cross_channel_delay)  `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_SLAVE_CROSS_CHANNEL_DELAY",$sformatf("d_source = %h -- a_vld_d_vld_cross_channel_delay_rx = %d --- a_vld_d_vld_cross_channel_delay_tx = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_vld_d_vld_cross_channel_delay,slave_tx_queue[0].a_vld_d_vld_cross_channel_delay))
               end
              end//if cross_channel

              if(cfg.slave_cfg[0].slv_vld_rdy_delay_en && slave_rx_queue_tx[source].a_vld_a_rdy_assert_delay != -1)
                begin
                //a_valid_a_ready_delay
                if(slave_rx_queue_tx[source].a_vld_a_rdy_assert_delay < slave_tx_queue[0].a_vld_a_rdy_assert_delay) `uvm_error("DELAY_COMPARISION_3_FAILS_FOR_SLAVE_VALID_READY_DELAY",$sformatf("d_source = %h -- a_vld_a_rdy_assert_delay_rx = %d --- a_vld_a_rdy_assert_delay_tx = %d",slave_rx_queue_tx[source].d_source,slave_rx_queue_tx[source].a_vld_a_rdy_assert_delay,slave_tx_queue[0].a_vld_a_rdy_assert_delay)) 
                end


             end//retain if
            end//else
          end//slv_en if

        //`endif

          slave_rx_queue_tx.delete(source);

  endtask

  //---------------------------------------------------------------------------------
  /**
   * Run Phase
   * it will compare the received transactions at the negedge of the clock.
   */
  `ifdef SVT_UVM_TECHNOLOGY
  virtual task run_phase(uvm_phase phase);
    string method_name = "run_phase";
  `elsif SVT_OVM_TECHNOLOGY
  virtual task run();
    string method_name = "run";
  `endif

  fork
   forever begin
     wait (new_master_rx_rcvd==1 || new_slave_status_rcvd==1);
     comp2_a_channel();//TASK to compare Master rx and Slave status, Properties driven by master(rx) on the bus is compared with corresponding properties sampled by the Slave (status) from the bus
   end
   forever begin
     @(new_slave_rx_rcvd==1 || new_master_status_rcvd==1);
     comp2_d_channel();// TASK to compare Master status and Slave rx, Properties driven by slave on the bus (rx) is compared with corresponding properties sampled by the Master (status) from the bus
   end
   forever comp1_a_channel();//TASK to do Master tx and rx comparison, MASTER Transaction properties configured from seq (tx) are compared with the corresponding properties seen on the bus(rx)
   forever comp3_d_channel();//TASK to compare Slave tx and rx, SLAVE Transaction properties configured from seq (tx) are compared with the corresponding properties seen on the bus(rx))
  join
  endtask

  //-----------------------------------------------------------------------------------------------------------------------------------------------------   
  /**  report_phase */
  virtual function void report_phase(uvm_phase phase);
    if(!disable_scoreboard) 
    begin
      `uvm_info(get_type_name(), $sformatf("Reporting scoreboard information...\n%s", this.sprint()), UVM_LOW)
    end
  endfunction : report_phase
  //-----------------------------------------------------------------------------------------------------------------------------------------------------   

endclass : tilelink_xvm_scoreboard
`endif // GUARD_ONFI_XVM_SCOREBOARD_SV




