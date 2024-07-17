//=======================================================================
// COPYRIGHT (C) 2013-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_FUZZY_REAL_COMPARER_SV
`define GUARD_SVT_FUZZY_REAL_COMPARER_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

// =============================================================================
/**
 * Used to extend the basic `SVT_XVM(comparer) abilities for use with SVT based VIP.
 */
class svt_fuzzy_real_comparer extends `SVT_XVM(comparer);

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Data member to control the precision of the fuzzy compare.
   */
  real fuzzy_compare_precision = `SVT_DEFAULT_FUZZY_COMPARE_PRECISION;

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_fuzzy_real_comparer class.
   */
  extern function new();

  // ---------------------------------------------------------------------------
  /**
   * Used to compare a real field.
   *
   * @param name Name of the field being compared, used for purposes of storing and printing a miscompare.
   * @param lhs The field value for the object doing the compare.
   * @param rhs The field value for the object being compared.
   * @return Indicates whether the compare was a match (1) or a mismatch (0).
   */
  extern virtual function bit compare_field_real(string name, real lhs, real rhs);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
>(1JDRI.H\A>=+H;2.DUS57<;)82DQ;J^[@&+-+[N-XVO_05??[85(EQ^GK-65W<
HG=8IeL2LBWN+FHI#Q?-+BYP7&9?+dOb5=IN<_DeeAPX6G,dbK-W)<I<f[#IW(A3
Y1aV\\SK]7E^7:0M?VSF7bb3[;049Wcf4dc]]0^,^RC1QI3T1[9.1KH+:.W>:L1N
K3R5eScDL8DKZ_d_OVeccD9d^]&g9SdAb]+F4Z>03A7#]+8@E,E5B[)D8fc;9RZ8
D18LcC.2aK^&&L(9FU#55GFb:GL[SS7V]K)QTK]]>6#H)AK58FC>d8I+,K3T3g.<
G9M25+P281J[IE+g(,#TA9K(,C)@7g22fZ13IF_Hf+]?eXD[J]#I](=6-c]g^:U1
fN^0@#?U:6@EC@RM[6FELT)1+\^)&]V^_&[K9WRe2b>WF86b7X]P^L#KNbUQ[[Z7
-XaBdR9I1&7fM-1_)S:)A]ELfO5C:K#TW]cJ9(Q/d;UFSICJb^^1MV?#HdC2\5_R
54CSd7674(C=N^1dgg8dDVF)Ce4W1:?(L#:-25/:/QIOIGGEZ<f21@1^3/MZ>;dB
3&<YSC3#5b-8=E)<M6D;e[6b]gcKZR5bfMKA>6))3b7JgFIAFI@&c1#\2.^(#3.Q
H5Z0\,Q&/;bS4,WA_Ee1VT=#]L-:3OAJ[CLJH.dF-/[@7fS;0PYT.<gP]9OTc1QV
4>A3e/<SQ].Nb0XDZf-11QV,fGfCY7VJg1CJE^Q25-5\3U4=b;N.e<MJGUZ7GYP4
78Z(+gH195>M-6SM<A>JMLB#MQ)MM(a+#QKcTIXGg6bLf&_P\FNFN:WcbE=bc?XX
<eMAYH_1#?.&5_M\a;de,9+_4FMM&c5[Z:Q5_,aR<gY<ccR]G#\#H<MZ9WVCLaV\
EOUVfRUSSZOBFf6>KAL0NDM1e.aBA_L&E1]YXBecS>3/FT;a4H+8Z]T6ZC-NV#I=
#M->-TE-KEX42D92L0B\QIRDREO#a6I:O,J,0Bg/)_c:+OBGON.KLZS-e,)gI[c7
E,Ledf4cE&RXX9b)UVMd0=)G=R4H(9Z=Fe3<P\5b,\d[0C;AQCRb,L,1#L7\e&FA
1;4bA_[(S69dNI1=S-;-BTfH\H<&f1ZQLRGK1K<]c6NR@POP]/#V8AaK)TL58HEE
,cN/(F-2[AS\8UPQc]^TFSLE6g7gDU#T6&.b_MO)[Bf0][(2[Jg(Tg]9]/ZQ&g.^
fZQKI3;Jf>e1GSVC2]QbR2?Q]5GA4D]fDNF3RJebIDYW;;X\O^SM?+Z#:YZ)O91U
E)-MNSOY@#(^5_feS:8.c18NFI5)&4V-94@&DJ^/Y7>.:]Ug<U@g?TZ#I$
`endprotected


`endif // GUARD_SVT_FUZZY_REAL_COMPARER_SV
