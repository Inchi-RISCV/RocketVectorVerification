`ifndef GUARD_SVT_TILELINK_MASTER_CORRUPT_SIZE_OPCODE_ERROR_CALLBACK
`define GUARD_SVT_TILELINK_MASTER_CORRUPT_SIZE_OPCODE_ERROR_CALLBACK

/**
 * Abstract: 
 * class 'svt_tilelink_master_corrupt_size_opcode_error_callback' is extended from svt_tilelink_master_callback class. <br>
 * It implements the post_seq_item_get method to set driving of a_size values greater than log2 of bus width<br>
 * or driving of opcodes forbidden in TL-UL mode. <br>
 * This callback is used to insert error "a_size_greater_than_max_bus_size_error" when crpt_size_opc is set to 0 & <br>
 * "rsvd_a_opcode_val_in_tl_ul_error" when crpt_size_opc is set to 1.
 */

class svt_tilelink_master_corrupt_size_opcode_error_callback extends svt_tilelink_master_callback;

  /**
   *  Set this variable to any value greater than log2 of data_width (in bytes) <br>
   *  to insert error condition for rule "a_size_greater_than_max_bus_size_error" .
   */
  bit [`SVT_TILELINK_SIZE_WIDTH-1:0] corrupt_size_val  = 0;

  /**
   *  Set this variable to any opcode which is forbidden in TL-UL & allowed in TL-UH(a_opcode within 2,3,5) <br>
   *  to insert error condition fo rule "rsvd_a_opcode_val_in_tl_ul_error".
   */
  bit [`SVT_TILELINK_A_OPCODE_WIDTH-1:0] corrupt_opc_val  = 0;

  /**
   * 0 : Inserts error condition for rule "a_size_greater_than_max_bus_size_error". <br>
   * 1 : Inserts error condition for rule "rsvd_a_opcode_val_in_tl_ul_error". 
   */
  bit crpt_size_opc = 0;

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
    tilelink_master_exception.error_kind = svt_tilelink_master_transaction_exception::SIZE_OPC_ERROR;
    tilelink_master_exception.corrupt_size_val = this.corrupt_size_val;
    tilelink_master_exception.corrupt_opc_val = this.corrupt_opc_val;
    tilelink_master_exception.crpt_size_opc = this.crpt_size_opc;
    is_valid=tilelink_master_exception.do_is_valid();

    if (is_valid) begin
      //Add the exception class to the exception list
      cust_tilelink_master_exception_list.add_exception(tilelink_master_exception);

      //write the handle of the exception list on the trans class handle
      xact.exception_list = cust_tilelink_master_exception_list;
    end

  endfunction: post_seq_item_get
  
endclass: svt_tilelink_master_corrupt_size_opcode_error_callback
`endif //GUARD_SVT_TILELINK_MASTER_CORRUPT_SIZE_OPCODE_ERROR_CALLBACK
