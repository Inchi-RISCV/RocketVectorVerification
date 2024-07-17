`ifndef GUARD_TILELINK_MASTER_RESPONSE_OPCODE_ERROR_CALLBACK
`define GUARD_TILELINK_MASTER_RESPONSE_OPCODE_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'tilelink_master_resp_wo_req_callback' is extended from svt_tilelink_master_callback class.
 * It implements the post_seq_item_get method to set clk stall scenario from master.
 * This call back is used to insert 
 */

class tilelink_master_response_opcode_error_callback extends svt_tilelink_master_callback;

  bit [2:0] c_opcode;

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
    tilelink_master_exception.error_kind = svt_tilelink_master_transaction_exception::RESPONSE_OPCODE_ERR;
    tilelink_master_exception.c_opcode = this.c_opcode;
    is_valid=tilelink_master_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_master_exception_list.add_exception(tilelink_master_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_master_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: tilelink_master_response_opcode_error_callback
`endif //GUARD_TILELINK_MASTER_RESPONSE_OPCODE_ERROR_CALLBACK
