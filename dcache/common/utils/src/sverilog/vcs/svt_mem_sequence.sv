//=======================================================================
// COPYRIGHT (C) 2012-2017 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
//-----------------------------------------------------------------------

`ifndef GUARD_SVT_MEM_SEQUENCE_SV
`define GUARD_SVT_MEM_SEQUENCE_SV

`ifndef SVT_VMM_TECHNOLOGY

typedef class svt_mem_sequence;

// =============================================================================
/**
 * Base class for all SVT mem sequences. Because of the mem nature of the
 * protocol, the direction of requests (REQ) and responses (RSP) is reversed from the
 * usual sequencer/driver flow.
 */
virtual class svt_mem_sequence extends svt_reactive_sequence#(svt_mem_transaction);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************
   
   
  /** CONSTRUCTOR: Create a new SVT sequence object */
  extern function new (string name = "svt_mem_sequence", string suite_spec = "");

  // =============================================================================

endclass


//svt_vcs_lic_vip_protect
`protected
0_F3L:]+2=5U+=[ZH<E)<>U^VA]gE7IF\f/6\I<OdE.FMUL(C?.E2(B?(;V[H;,G
ZIfD/^]WN&9[GAR.,aH/gLF@==GO=C3_G6ZZF>,]#.0fIH#JKH8WGHNPWLVKJbGP
RTgG\#C^Bf_PF52/X)W[SFJ57_=B^[4N6/bfUHM3UUCJZBU6R.]Y#V1T1eEV(Y\(
9^;XUJYJ.-c0]VF31P&GW.>EB0JMCS,,]VfV1SBEMD3=RNB>[\MUQ+:M91V4:a[T
GgZ&1.N@]R[F?A)0/16:9FD+\Q?S=)7O)T4DY/_885(JT)LBL.<Bg-M^E@4Qgc8F
@,VZQHBT05F4X7H&28OB@.g\D351AK6WQ&a>Yg95e2WW:FBF<&M_5AM(P3QD/OZ;
&&1D2a:Mf?>LIg<HP\Cf-d:YXIF<.K&]?$
`endprotected


`endif // !SVT_VMM_TECHNOLOGY

`endif // GUARD_SVT_MEM_SEQUENCE_SV
