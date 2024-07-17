//=======================================================================
// COPYRIGHT (C) 2011-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_TOGGLE_COV_BIT_SV
`define GUARD_SVT_TOGGLE_COV_BIT_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * Single bit coverage variable used to support coverage of individual or
 * bused signals.
 */
class svt_toggle_cov_bit;

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

  /** The value being covered */
  protected bit bit_val;

  // ****************************************************************************
  // Coverage Groups
  // ****************************************************************************

  covergroup toggle_cov_bit;
    option.per_instance = 1;
    option.goal = 100;
    coverpoint bit_val {
      bins b0_to_b1 = (0 => 1);
      bins b1_to_b0 = (1 => 0);
    }
  endgroup

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_toggle_cov_bit class.
   */
  extern function new();

  //----------------------------------------------------------------------------
  /**
   * Provide a new bit_val to be recognized and sampled.
   */
  extern function void bit_cov(bit bit_val);

  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
[CPW.[LNDW@H:4\^:KLVEUc@+:W5dP6YeWYVKE,Y>>Q@gePcJ+-24(4O1RV2[@D-
G#7HBQ(?&MF5J2OF0GQe@VW8\,:c@9f+[9G=UT=/9K&XC5O6RJI(a?7O2eQA?NZ2
GFE90I7/R19O+g@0@OLCR.3^6WS<M7DRZ0PO[)@FZ;DDgD<8<QBPCIa2.Z6C;NAX
L&,EXGQ#+f0\\C.BKa.D3J1/f&99+@TRYEd;M6S:R#D/fHMWCCV)73Fd9G^7B_^d
#<eW/3BJcQPT_5c0d8d4BA&\N;cMUcH6M3.7fEaVa-Oc]G1?C]DU#Jb8bL@B/DbG
b4e:U\b@Zc(QU\X6MB7\+Z9BJ<-&Da]fR4RX-E#06?[fE)@Q4MEZDZ\:+>4N+X2)
>+9PYD&<I+STg?,IOW?+5fJL0L7Q7K#8gUJ2\Q_U+O[>dFV2W[25[_?EWQX+GRO;
H24Be;]/<,]SP.gS&fb^-?RH^?VEK_f0SEE5AMQ2L1X8#-]BE4YRMM8^3;;e[3PY
3N90[781Xdf&^:D3AUf=-AZ2d8b[0&\(\[/6g#O,CQ\KZ_PSaCd4f@1E9/T\7^S<
4#W3GOCX]\53]_[bPD\[](R^88;eM\cV+38^B/2&9:ZUgY(.d>>G(Z6BBc4/N3-f
+8d)#aF=M4]^\WKda(([VDF[FMOc1HL#K(OcX=0IOD#D:T5eD@MF_Vb>0S)Z#18=
>(]P.a_A2L^BOPB1@C2D9(ZA69/I4O1HcGdJ?;(c9GF[]a2.a(ECc^AfU9R\&4;b
CUK.VRGZO\[)\d3/H(KE7A>F?=DI)-?7=fVLQ<IT2#&I:@7c8fA-\AA(#IIcK1BW
?EJTQ)f?7AgC-F238[^NME/)+HZV>S\J@$
`endprotected


`endif // GUARD_SVT_TOGGLE_COV_BIT_SV
