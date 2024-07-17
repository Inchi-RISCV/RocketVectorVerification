`ifndef GUARD_SVT_TILELINK_MASTER_VALID_SIGNAL_DURATION_IN_RESET_ERROR_CALLBACK
`define GUARD_SVT_TILELINK_MASTER_VALID_SIGNAL_DURATION_IN_RESET_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'svt_tilelink_master_valid_signal_duration_in_reset_error_callback' is extended from svt_tilelink_master_callback class. <br>
 * It implements the post_seq_item_get method to set valid high/low driving scenario from master. <br>
 * This callback drives master's valid signals low & high for as many clock cycles as configured <br>
 * through variable valid_low_duration & valid_high_duration respectively while reset is asserted.
 * This callback is used to generate error "valid_signal_duration_in_reset_error" whenever the next reset arrives.
 */

class svt_tilelink_master_valid_signal_duration_in_reset_error_callback extends svt_tilelink_master_callback;

  /**
   * Set this variable to 1, to generate error condition for rule "valid_signal_duration_in_reset_error" whenever the next reset arrives.
   */
  bit valid_duration = 0;

  /**
   * Set this variable to any integer value greater than 0 and less than 100, <br>
   * such that the sum of this variable & valid_high_duration is less than the number of clock cycles reset will be kept asserted. <br>
   * This effect will take place only if variable valid_duration is set to 1.
   */
  int valid_low_duration = 0;

  /**
   * Set this variable to any integer value greater than 0, such that the sum of this variable & valid_high_duration <br>
   * remains less than the number of clock cycles for which reset will be kept asserted. <br>
   * This effect will take place only if variable valid_duration is set to 1.
   */
  int valid_high_duration = 0;

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
    tilelink_master_exception.error_kind = svt_tilelink_master_transaction_exception::VALID_SIGNAL_DURATION_IN_RESET;
    tilelink_master_exception.valid_duration = this.valid_duration;
    tilelink_master_exception.valid_low_duration = this.valid_low_duration;
    tilelink_master_exception.valid_high_duration = this.valid_high_duration;
    is_valid=tilelink_master_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_master_exception_list.add_exception(tilelink_master_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_master_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: svt_tilelink_master_valid_signal_duration_in_reset_error_callback
`endif //GUARD_SVT_TILELINK_MASTER_VALID_SIGNAL_DURATION_IN_RESET_ERROR_CALLBACK
