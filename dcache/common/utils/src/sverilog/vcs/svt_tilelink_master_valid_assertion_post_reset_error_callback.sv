
`ifndef GUARD_SVT_TILELINK_MASTER_VALID_ASSERTION_POST_RESET_CALLBACK
`define GUARD_SVT_TILELINK_MASTER_VALID_ASSERTION_POST_RESET_CALLBACK

/**
 * Abstract: 
 * class 'svt_tilelink_master_valid_assertion_post_reset_error_callback' is extended from svt_tilelink_master_callback class. <br>
 * It implements the post_seq_item_get method to set illegal assertion of valid signals of Master after reset. <br>  
 * This call back is used to drive Master's valid signals( a_valid) high on the clock edge where reset is deasserting itself. <br>
 * This callback is used to generate error "valid_assertion_post_reset_error" whenever the next reset arrives. <br>
 * <b> NOTE : a_ready needs to be driven low while using thi callback and shall be driven high only after the completion </b> <br>
 * <b>        the completion of this EI. </b> 
 */

class svt_tilelink_master_valid_assertion_post_reset_error_callback extends svt_tilelink_master_callback;

  /**
   * Set variable valid_assert to 1 to generate error condition for rule "valid_assertion_post_reset_error", <br>
   * whenever the next reset arrives.
   */
  bit valid_assert = 0;

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
    tilelink_master_exception.error_kind = svt_tilelink_master_transaction_exception::VALID_ASSERTION_POST_RESET;
    tilelink_master_exception.valid_assert = this.valid_assert;
    is_valid=tilelink_master_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_master_exception_list.add_exception(tilelink_master_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_master_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: svt_tilelink_master_valid_assertion_post_reset_error_callback
`endif //GUARD_SVT_TILELINK_MASTER_VALID_ASSERTION_POST_RESET_ERROR_CALLBACK
