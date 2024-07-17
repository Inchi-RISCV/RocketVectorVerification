`ifndef GUARD_SVT_TILELINK_MASTER_MANIPULATE_CONTROL_SIG_ERROR_CALLBACK
`define GUARD_SVT_TILELINK_MASTER_MANIPULATE_CONTROL_SIG_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'svt_tilelink_master_manipulate_control_sig_error_callback' is extended from svt_tilelink_master_callback class. <br>
 * It implements the post_seq_item_get method to manipulate control signal values after the acceptanc of first beat of transaction. <br>
 * This callback is used to insert error condition for rules "burst_ctrl_sig_value_error" or "no_intrlv_support_error". <br>
 * To insert error "no_intrlv_support_error", manipulate a_source value after the acceptance of 1st beat of request. <br>
 * To insert error "burst_ctrl_sig_value_error", manipulate any control signal's (a_opcode, a_source, a_size, a_address or <br>
 * a_param) value after the acceptance of 1st beat of request message. <br>
 * Variables corrupt_size_val, corrupt_src_val, corrupt_addr_val, corrupt_opc_val & corrupt_param_val will be used to manipulate <br>
 * a_corrupt,a_source,a_address, a_opcode & a_param respectively based on the value of sig_type.
 * Variable "sig_type" will select the control signal to be manipulated. Variable "beat_pos" will select the beat position for <br>
 * which selected signal to be manipulated. <br>
 * <b> NOTE: This Callback is not applicable to GET & INTENT type requests. </b> 
 */

class svt_tilelink_master_manipulate_control_sig_error_callback extends svt_tilelink_master_callback;

  /**
   *  Set this variable to any value in range 'd1 to 'd5 to select a signal to be manipulated. <br>
   *  Signals to be manipulated as per sig_type : <br>
   *  1 : opcode <br>
   *  2 : source <br>
   *  3 : size <br>
   *  4 : address <br>
   *  5 : param
   */
  bit [2:0] sig_type = 0;

  /**
   *  Set this variable to any value greater than 0 and less than or equal to total number of beat in <br> 
   *  request message. This will select beat position for which selected control signal will be manipulated. <br> 
   *  <b> NOTE : value of beat_pos shall not exceed (2**a_size)/(cfg.data_width/8) -1 i.e. total number of beats minus 1.
   */
  int beat_pos = 0;

  /**
   * This variable holds the value of a_size to be be driven on beat "beat_pos". <br>
   * This variable will take effect when sig_type is set to 3.
   */
  bit [`SVT_TILELINK_SIZE_WIDTH-1:0]corrupt_size_val  = 0;

  /**
   * This variable holds the value of a_opcode to be driven on beat "beat_pos". <br>
   * This variable will take effect when sig_type is set to 1.
   */
  bit [`SVT_TILELINK_A_OPCODE_WIDTH-1:0] corrupt_opc_val  = 0;

  /**
   * This variable holds the value of a_source to be driven on beat "beat_pos". <br>
   * This variable will take effect when sig_type is set to 2.
   */
  bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] corrupt_src_val  = 0;

  /**
   * This variable holds the value of a_address to be driven on beat "beat_pos". <br>
   * This variable will take effect when sig_type is set to 4.
   */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] corrupt_addr_val  = 0;

  /**
   * This variable holds the value of a_param to be driven on beat "beat_pos". <br>
   * This variable will take effect when sig_type is set to 5.
   */
  bit [`SVT_TILELINK_A_PARAM_WIDTH-1:0]corrupt_param_val  = 0;


  bit is_valid=1;

    //create a local handle of exception class and exception list
    svt_tilelink_master_transaction_exception_list cust_tilelink_master_exception_list;
    svt_tilelink_master_transaction_exception      tilelink_master_exception;

  //Class Constructor
  function new(string name);
    super.new(name);
  endfunction: new
  
  //Callback method
  virtual function void post_seq_item_get(svt_tilelink_master master, svt_tilelink_master_transaction xact, ref bit drop);

    //create the exception class
    tilelink_master_exception = new("tilelink_master_cust_exception");

    //create the exception list
    cust_tilelink_master_exception_list = new("cust_tilelink_master_exception_list",tilelink_master_exception);

    //assign the type of error to be inserted in exception class
    tilelink_master_exception.error_kind = svt_tilelink_master_transaction_exception::CTRL_SIG_ERROR;
    tilelink_master_exception.sig_type = this.sig_type;
    tilelink_master_exception.beat_pos = this.beat_pos;
    tilelink_master_exception.corrupt_opc_val = this.corrupt_opc_val;
    tilelink_master_exception.corrupt_size_val = this.corrupt_size_val;
    tilelink_master_exception.corrupt_addr_val = this.corrupt_addr_val;
    tilelink_master_exception.corrupt_src_val = this.corrupt_src_val;
    tilelink_master_exception.corrupt_param_val= this.corrupt_param_val;
    is_valid=tilelink_master_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_master_exception_list.add_exception(tilelink_master_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_master_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: svt_tilelink_master_manipulate_control_sig_error_callback
`endif //GUARD_svt_tilelink_master_manipulate_control_sig_error_callback
