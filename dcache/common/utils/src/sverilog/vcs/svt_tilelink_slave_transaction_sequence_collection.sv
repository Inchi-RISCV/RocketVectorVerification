//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2016 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------

`ifndef GUARD_SVT_TILELINK_SLAVE_TRANSACTION_SEQUENCE_COLLECTION_SV
`define GUARD_SVT_TILELINK_SLAVE_TRANSACTION_SEQUENCE_COLLECTION_SV

// =============================================================================
/** 
 * svt_tilelink_slave_transaction_base_sequence: This is the base class for svt_tilelink_slave_transaction
 * sequences. All other svt_tilelink_slave_transaction sequences are extended from this sequence.
 *
 * The base sequence takes care of managing objections if extended classes or sequence clients
 * set the #manage_objection bit to 1.
 */
class svt_tilelink_slave_transaction_base_sequence extends svt_sequence#(svt_tilelink_slave_transaction);

  /** 
   * Factory Registration. 
   */
  `svt_xvm_object_utils(svt_tilelink_slave_transaction_base_sequence) 
 
  /** 
   * Parent Sequencer Declaration. 
   */
  `svt_xvm_declare_p_sequencer(svt_tilelink_slave_transaction_sequencer) 

  /** 
   * Constructs a new svt_tilelink_slave_transaction_base_sequence instance.
   * 
   * @param name Sequence instance name.
   */
  extern function new(string name="svt_tilelink_slave_transaction_base_sequence");

endclass

// =============================================================================

`protected
,]##<HMMVeRY4Y+JX8Q_31=2>-6VDVa)YQ<>)VG)7R(;=L3YLJU#()]:BB-aQ867
:S1SZD0,I&GXWQC9+c#PJgXOU@[:+X[]b/F003B9\[eSU?#AM#=6GffN>DQTO^^F
D36&[/_GS.\H9&f#F?KFMZ+e:SIKcLEF=WN62SN7S>#-GAB[<I6P:S;]#)WH+86g
NH;/SYgELY:,ZF(HU]7W?WG0Q/JSJ=\WTY1fTN6/FL5UfHbg#DgL(ZS0A-R4&HDS
/Q+FH>,E:,N3/5K;dDHG&bW4[]VfF-/[(=f)FDe9OJ4M36HNB^LM,44Y:4]\@2ZI
JK0]dUWK)V.SDKe+M4Yd]SO7B+d5G1TG^PS@Z76>(D_f;b=+IINJ\a4YJ$
`endprotected


// =============================================================================
/** 
 * svt_tilelink_slave_transaction_random_sequence
 *
 * This sequence creates a random svt_tilelink_slave_transaction request.
 */
class svt_tilelink_slave_transaction_random_sequence extends svt_tilelink_slave_transaction_base_sequence; 
  
  /** 
   * Factory Registration. 
   */
  `svt_xvm_object_utils(svt_tilelink_slave_transaction_random_sequence) 
  
  /** Parameter that controls the number of svt_tilelink_slave_transaction requests that will be generated */
  rand int unsigned sequence_length = 5;

  /** Constrain the sequence length to a reasonable value */
  constraint reasonable_sequence_length {
    sequence_length <= 10;
  }

  /**
   * Constructs the svt_tilelink_slave_transaction_random_sequence sequence
   * @param name Sequence instance name.
   */
  extern function new(string name = "svt_tilelink_slave_transaction_random_sequence");
  
  /** 
   * Executes the svt_tilelink_slave_transaction_random_sequence sequence. 
   */
  extern virtual task body();

endclass

//------------------------------------------------------------------------------
function svt_tilelink_slave_transaction_random_sequence::new(string name="svt_tilelink_slave_transaction_random_sequence");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
task svt_tilelink_slave_transaction_random_sequence::body();
  svt_tilelink_slave_transaction req;

  /** Get the user sequence_length. */
`ifdef SVT_UVM_TECHNOLOGY
  int status = uvm_config_db#(int unsigned)::get(m_sequencer, get_type_name(), "sequence_length", sequence_length);
`else
  int status = m_sequencer.get_config_int({get_type_name(), ".sequence_length"}, sequence_length);
`endif
  `svt_xvm_debug("body", $sformatf("sequence_length is %0d as a result of %0s.", sequence_length, status ? "the config DB" : "randomization"));

  repeat(sequence_length) begin
    `svt_xvm_create(req);
    `svt_xvm_rand_send(req)
  end
endtask

// =============================================================================
/** 
 * svt_tilelink_slave_transaction_null_sequence
 *
 * This class creates a null sequence which can be associated with a sequencer but generates no traffic.
 */
class svt_tilelink_slave_transaction_null_sequence extends svt_tilelink_slave_transaction_base_sequence;

  /** 
   * Factory Registration. 
   */
  `svt_xvm_object_utils(svt_tilelink_slave_transaction_null_sequence) 
  
  /**
   * Constructs the svt_tilelink_slave_transaction_null_sequence sequence
   * @param name Sequence instance name.
   */
  extern function new(string name = "svt_tilelink_slave_transaction_null_sequence");

  /** 
   * Executes svt_tilelink_slave_transaction_null_sequence sequence. 
   */
  extern virtual task body();

endclass

// =============================================================================

//------------------------------------------------------------------------------
function svt_tilelink_slave_transaction_null_sequence::new(string name = "svt_tilelink_slave_transaction_null_sequence");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
task svt_tilelink_slave_transaction_null_sequence:: body();
endtask

// =============================================================================

`endif // GUARD_SVT_TILELINK_SLAVE_TRANSACTION_SEQUENCE_COLLECTION_SV

