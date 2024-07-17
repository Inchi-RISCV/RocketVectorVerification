//=======================================================================
// COPYRIGHT (C) 2007-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_LOG_CALLBACKS_SV
`define GUARD_SVT_LOG_CALLBACKS_SV

// =============================================================================
// DECLARATIONS & IMPLEMENTATIONS: svt_log_callbacks class
/**
 * This class is an extension used by the verification environment to catch the
 * pre_abort() callback before the simulator exits.  In the callback extension,
 * the vmm_env::report() method is called in order to provide context to the
 * events that lead up to the fatal error.
 */
 class svt_log_callbacks extends vmm_log_callbacks;

  /** ENV backpointer that is used used by the pre_abort() method. */
  protected vmm_env env;

  // --------------------------------------------------------------------------
  /** CONSTRUCTOR: Creates a new instance of the svt_log_callbacks class.  */
  extern function new(vmm_env env = null);

  // --------------------------------------------------------------------------
  /**
   * This virtual method is extended to catch situations when the simulator is
   * about to abort after the stop_after_n_errors limit has been reached or
   * a fatal error has been generated.  The only objective is to put out an
   * appropriate Passed/Failed message based on this event.
   */
  extern virtual function void pre_abort(vmm_log log);

endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
_.aHLNB3e)Nca@M=RGF];R<]B5(;\egE>4N;0[L4+I-AXMDU:I6(&(H0&efMbZPa
/^IV8OM5\aU#eD5d4P?.Z8J5d@PaeGbcXK(M,XOI5UQ#>S.5[UN^f(4+/?YRUT0a
7L_B[BQM[1FI5f3cL4J]8Z6YF]?SSMZ/f8D]&?/X_K#c5b3@HL@,&;)Fe&[C/R[2
9_.f5N2AA3=Wf;,.<CbK<1e6O+<>U/+>MJ0V495)]Z/K+?\OI=FGFRO,CL\a3?>C
K>>9#BG</d>[#;AD6_M_8(a335.3O>3MA;WaUe0M/PMTUFfL^bBW>]O0E<FD:G=<
#Z91UXbP__&I9c8DO]Ccb7a/fT9Q5K78N)c[UOVY>(<45<TWgO<[c_1+J;d:@I27
;fVcd,)SMVQG8K2[+)HNU?MOfHC[D_PQ8]?,WbQV5fb?VM_SE#Z[3Sg@97__U[[]
](dWF,a5::Nf>6L;7cX-FN]9]^+R,#&[?);H9?4a7JGd6&I.5??BgYP]N82cS<=d
,SEc)&;KR>1^3&(I\P:gMEQS=#TU>bW\SM5acM]N5e)1NKZN<R8?7IZ8059GU:HM
.DM8USUV3,9Z>9LRPKfR^/64g1O8e>EEdLSOIc.c)MNI<XM4@[5IY,F8Ta#:2+::
]^709XB4#Gd.+.OX=O9>Sa[f24)2+7#2aEZIg#SZ-A0.S:.f_H5M@]JYJ23c]<U/
PZ#DGBa5<+YCOfNYM+W=&IVB6VG;<DMJ58JD\M4(Ia<:>?YV@dS?N4GZA<g_NE#K
+IG3T;_/O=(O);>P_a@Ca,c34McJ#dHW6;bK/g_5IRK-4MRAP)NBK#^4.g.5)N:Q
\]cV:0Y:e/c/N^9S_5B&__Z?_2<1I<BK_d^b72P#\M-=9I\GUJW0YE0bf0S_[AB_
E:Bd)(STKG^&KTN<C\)ILWL>03C+YFL<U7>D#?M=?7)G3_:.\QAPS=>/.W7.B@]U
.\PdPOH^SI3&0$
`endprotected


`endif // GUARD_SVT_LOG_CALLBACKS_SV
