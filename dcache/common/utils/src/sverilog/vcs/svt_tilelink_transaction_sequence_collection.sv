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

`ifndef GUARD_SVT_TILELINK_TRANSACTION_SEQUENCE_COLLECTION_SV
`define GUARD_SVT_TILELINK_TRANSACTION_SEQUENCE_COLLECTION_SV

// =============================================================================
/** 
 * svt_tilelink_transaction_base_sequence: This is the base class for svt_tilelink_transaction
 * sequences. All other svt_tilelink_transaction sequences are extended from this sequence.
 *
 * The base sequence takes care of managing objections if extended classes or sequence clients
 * set the #manage_objection bit to 1.
 */
class svt_tilelink_transaction_base_sequence extends svt_sequence#(svt_tilelink_transaction);

  /** 
   * Factory Registration. 
   */
  `svt_xvm_object_utils(svt_tilelink_transaction_base_sequence) 
 
  /** 
   * Parent Sequencer Declaration. 
   */
  `svt_xvm_declare_p_sequencer(svt_tilelink_transaction_sequencer) 

  /** 
   * Constructs a new svt_tilelink_transaction_base_sequence instance.
   * 
   * @param name Sequence instance name.
   */
  extern function new(string name="svt_tilelink_transaction_base_sequence");

endclass

// =============================================================================

`protected
EgPM6>)-[1;2K)Me-KYIAFdK1-\-C).E8ODJe>+5K@ZX=LUI2BIV7)C5FLef=,Db
)/Z2S.<C&Jf3I^0e+.N/&_bef)66,^^4,PX@\]28T?<G9U3DTB>84&_TG1X8)>&\
_]&a]ML]XNQ8HI(F5=HLM+7:UI-eZ33?VIf?(U[HPE?[CM2/NL_=DMcF6JQ((0X-
I>(7-N?LbA[e57SacG9KB<2/8Y\,A,I&gJY5g[?NMO]V6Y-;M&6QWfa8c^BfcJ5g
W,Re^S&]]U=H.H<Ca#>]Y1OIE@N8=NDSU9bOTg?UFYH4?CRNFfY&2T3VM;/L24\J
Ha<CEWeHX\^S(95>+1a\Pfg-RZR0XVBg>$
`endprotected


// =============================================================================
/** 
 * svt_tilelink_transaction_random_sequence
 *
 * This sequence creates a random svt_tilelink_transaction request.
 */
class svt_tilelink_transaction_random_sequence extends svt_tilelink_transaction_base_sequence; 
  
  /** 
   * Factory Registration. 
   */
  `svt_xvm_object_utils(svt_tilelink_transaction_random_sequence) 
  
  /** Parameter that controls the number of svt_tilelink_transaction requests that will be generated */
  rand int unsigned sequence_length = 5;

  /** Constrain the sequence length to a reasonable value */
  constraint reasonable_sequence_length {
    sequence_length <= 10;
  }

  /**
   * Constructs the svt_tilelink_transaction_random_sequence sequence
   * @param name Sequence instance name.
   */
  extern function new(string name = "svt_tilelink_transaction_random_sequence");
  
  /** 
   * Executes the svt_tilelink_transaction_random_sequence sequence. 
   */
  extern virtual task body();

endclass

//------------------------------------------------------------------------------
function svt_tilelink_transaction_random_sequence::new(string name="svt_tilelink_transaction_random_sequence");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
task svt_tilelink_transaction_random_sequence::body();
  svt_tilelink_transaction req;

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
 * svt_tilelink_transaction_null_sequence
 *
 * This class creates a null sequence which can be associated with a sequencer but generates no traffic.
 */
class svt_tilelink_transaction_null_sequence extends svt_tilelink_transaction_base_sequence;

  /** 
   * Factory Registration. 
   */
  `svt_xvm_object_utils(svt_tilelink_transaction_null_sequence) 
  
  /**
   * Constructs the svt_tilelink_transaction_null_sequence sequence
   * @param name Sequence instance name.
   */
  extern function new(string name = "svt_tilelink_transaction_null_sequence");

  /** 
   * Executes svt_tilelink_transaction_null_sequence sequence. 
   */
  extern virtual task body();

endclass

// =============================================================================

//------------------------------------------------------------------------------
function svt_tilelink_transaction_null_sequence::new(string name = "svt_tilelink_transaction_null_sequence");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
task svt_tilelink_transaction_null_sequence:: body();
endtask

// =============================================================================

`endif // GUARD_SVT_TILELINK_TRANSACTION_SEQUENCE_COLLECTION_SV

