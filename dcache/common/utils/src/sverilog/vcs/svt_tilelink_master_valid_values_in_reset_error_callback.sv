`ifndef GUARD_SVT_TILELINK_MASTER_VALID_VALUES_IN_RESET_ERROR_CALLBACK
`define GUARD_SVT_TILELINK_MASTER_VALID_VALUES_IN_RESET_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'svt_tilelink_master_valid_values_in_reset_error_callback' is extended from svt_tilelink_master_callback class. <br>
 * It implements the post_seq_item_get method to set driving of invalid values of valid signals scenario from master. <br>
 * This call back is used to drive 1,x or z for Master's valid signals (a_valid) while reset is asserted. <br> 
 * This callback is used to insert error "valid_values_in_reset_error" whenever the next reset arrives. <br>
 */

class svt_tilelink_master_valid_values_in_reset_error_callback extends svt_tilelink_master_callback;

  /**
   *  Set this variable to'h1,'h2 or 'h3 to drive values 1, x or z respectively on valid signals of Master, <br>
   *  whenever the next reset arrives and generate error condition for rule "valid_values_in_reset_error".
   */
  bit [1:0] valid_val = 0;

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
    tilelink_master_exception.error_kind = svt_tilelink_master_transaction_exception::VALID_VAL_IN_RESET_ERROR;
    tilelink_master_exception.valid_val = this.valid_val;
    is_valid=tilelink_master_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_master_exception_list.add_exception(tilelink_master_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_master_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: svt_tilelink_master_valid_values_in_reset_error_callback
`endif //GUARD_SVT_TILELINK_MASTER_VALID_VALUES_IN_RESET_ERROR_CALLBACK
