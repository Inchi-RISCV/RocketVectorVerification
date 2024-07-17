`ifndef GUARD_TILELINK_SLAVE_RESP_DPARAM_ERROR_CALLBACK
`define GUARD_TILELINK_SLAVE_RESP_DPARAM_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'tilelink_slave_resp_dparam_error_callback' is extended from svt_tilelink_slave_callback class.
 * It implements the post_seq_item_get method to set invalid d_param value from slave.
 */

class tilelink_slave_resp_dparam_error_callback extends svt_tilelink_slave_callback;

  rand bit [2:0] d_param;

  bit is_valid=1;

    //create a local handle of exception class and exception list
    svt_tilelink_slave_transaction_exception_list cust_tilelink_slave_exception_list;
    svt_tilelink_slave_transaction_exception      tilelink_slave_exception;

  //Class Constructor
  function new(string name);
    super.new(name);
  endfunction: new
  
  //Callback method
  virtual function void post_seq_item_get(svt_tilelink_slave slave, svt_tilelink_slave_transaction xact, ref bit drop);

    //create the exception class
    tilelink_slave_exception = new("tilelink_slave_cust_exception");

    //create the exception list
    cust_tilelink_slave_exception_list = new("cust_tilelink_slave_exception_list",tilelink_slave_exception);

    //assign the type of error to be inserted in exception class
    tilelink_slave_exception.error_kind = svt_tilelink_slave_transaction_exception::RESP_D_PARAM_ERR;
    tilelink_slave_exception.d_param = this.d_param;
    is_valid=tilelink_slave_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_slave_exception_list.add_exception(tilelink_slave_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_slave_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: tilelink_slave_resp_dparam_error_callback
`endif //GUARD_TILELINK_SLAVE_RESP_DPARAM_ERROR_CALLBACK
