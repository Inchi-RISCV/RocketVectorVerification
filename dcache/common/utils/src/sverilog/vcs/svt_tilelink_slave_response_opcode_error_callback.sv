`ifndef GUARD_TILELINK_SLAVE_RESPONSE_OPCODE_ERROR_CALLBACK
`define GUARD_TILELINK_SLAVE_RESPONSE_OPCODE_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'tilelink_slave_resp_wo_req_callback' is extended from svt_tilelink_slave_callback class.
 * It implements the post_seq_item_get method to set clk stall scenario from slave.
 * This call back is used to insert 
 */

class tilelink_slave_response_opcode_error_callback extends svt_tilelink_slave_callback;

  bit [2:0] d_opcode;

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
    tilelink_slave_exception.error_kind = svt_tilelink_slave_transaction_exception::RESPONSE_OPCODE_ERR;
    tilelink_slave_exception.d_opcode = this.d_opcode;
    is_valid=tilelink_slave_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_slave_exception_list.add_exception(tilelink_slave_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_slave_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: tilelink_slave_response_opcode_error_callback
`endif //GUARD_TILELINK_SLAVE_RESPONSE_OPCODE_ERROR_CALLBACK
