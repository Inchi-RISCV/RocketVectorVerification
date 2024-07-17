`ifndef GUARD_TILELINK_SYSTEM_ERROR_CATCHER_SV 
`define GUARD_TILELINK_SYSTEM_ERROR_CATCHER_SV

//========================================================================
/**
 * This file creates a error catcher class for TILELINK to demote expected error.
 * User can either set message in messges[$] (queue)  set ID in ids[$] to demote errors.
 * observed_err_cnt will be incremented by one on the catch of every
 * ERROR/WARNING, and ERROR/WARNING will be converted to INFO.
 */
class tilelink_system_error_catcher extends svt_report_catcher;
   
  /** Observed error count */
  int observed_err_cnt;

  /** 
   *  Strings related to checkers are added in this queue.These strings will be checked in final phase to make sure
   *  that related checkers have failed. If checkers related to strings added in this queue will not fail then
   *  testcase will fail saying that expected checker didn't fail.
   */
  string messages[$];

  /** Errors/Warnings to be demoted based on ID.
   *  Checker IDs are added in this queue will be checked in final phase to make sure
   *  that they are failed. If checker ID added in this queue will not fail then
   *  testcase will fail saying that expected checker didn't fail.
   */
  string ids[$];

  /** This queue will contain list of checkers which may or may not fail.
   *  User has to add those checkers into this queue which may fail because of 
   *  side effect of actual violation that user want to do. strings added
   *  in this queue will not be checked in final phase. This queue will help user to
   *  randomize failing scenario.
   */
  string may_fail_checks[$];

  /** Array to store observed ERRORS/WARNING.
   *  This will be used in testcase to check whether it received all the expected
   *  ERRORS/WARNING or not.
   */
  int observed_error[string];

  /** XVM Component Utility macro */
  `svt_xvm_object_utils(tilelink_system_error_catcher)

  //---------------------------------------------------------------------------------
  /** 
   * Constructor : To create a new instance of the TILELINK ERROR catcher
   */
  function new(string name="tilelink_system_error_catcher");
    super.new(name);
  endfunction :new

  function pattern_match(string str1, str2);
    int l1, l2;
    l1 = str1.len();
    l2 = str2.len();
    pattern_match = 0 ;
    if(l2 > l1) begin
      return 0;
    end
    for(int i = 0;i < l1-l2+1;i++) begin
      if(str1.substr(i,i+l2-1) == str2) begin
         return 1;
      end
    end
  endfunction

  /** 
   * Method to demote expected errors from test. It will increase error count on 
   * detection of every ERROR/WARNING and convert it to INFO.
   */
  function action_e catch();
    string msg;
    string id;

    //if(pattern_match(get_id(),"tDVW Timings Error")) begin  // message for which error needs to demoted to warning
    //   if(test_top.enable_log_catcher)
    //     set_action(UVM_NO_ACTION);
    //end 
    //return THROW;

    // Only demote ERROR and WARNING
    if(get_severity() == `SVT_XVM_UC(ERROR) || get_severity() == `SVT_XVM_UC(WARNING)) begin
      msg = get_message();
      id = get_id();

      // Check phase will shout for error if it did not receive any of expected ERROR/WARNING,

      // Demote based on message
      foreach(messages[msg_num]) begin
`ifdef SVT_UVM_TECHNOLOGY
        if(!uvm_re_match(messages[msg_num] , msg) && id != "check_phase") begin
`elsif SVT_OVM_TECHNOLOGY
        if(ovm_is_match(messages[msg_num] , msg) && id != "check") begin
`endif
          set_severity(`SVT_XVM_UC(INFO)); 
          set_id({id, " <Demoted>"});
          observed_err_cnt++;
          observed_error[messages[msg_num]] += 1;
        end
      end // foreach 

      // Demote based on ID 
      foreach (ids[id_num]) begin
 `ifdef SVT_UVM_TECHNOLOGY
        if(!uvm_re_match(ids[id_num] , id) && id != "check_phase") begin
 `elsif SVT_OVM_TECHNOLOGY
        if(ovm_is_match(ids[id_num] , id) && id != "check") begin
 `endif
          set_severity(`SVT_XVM_UC(INFO)); 
          set_id({id, " <Demoted>"});
          observed_err_cnt++;
          observed_error[ids[id_num]] += 1;
         end
      end // foreach 

      // Demote may fail checkers 
      foreach (may_fail_checks[id_num]) begin
 `ifdef SVT_UVM_TECHNOLOGY
        if((!uvm_re_match(may_fail_checks[id_num] , id) || !uvm_re_match(may_fail_checks[id_num] , msg)) && id != "check_phase") begin
 `elsif SVT_OVM_TECHNOLOGY
        if((ovm_is_match(may_fail_checks[id_num] , id) || ovm_is_match(may_fail_checks[id_num] , msg)) && id != "check") begin
 `endif
          set_severity(`SVT_XVM_UC(INFO)); 
          set_id({id, " <Demoted>"});
          observed_err_cnt++;
          observed_error[may_fail_checks[id_num]] += 1;
         end
      end // foreach 
    end
    return THROW;  
  endfunction : catch

endclass : tilelink_system_error_catcher 
`endif //GUARD_TILELINK_SYSTEM_ERROR_CATCHER_SV
