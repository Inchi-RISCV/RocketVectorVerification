//=======================================================================
// COPYRIGHT (C) 2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_OBJECT_PATTERN_DATA_SV
`define GUARD_SVT_OBJECT_PATTERN_DATA_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * Data object that stores an individual name/value pair, where the value is
 * an `SVT_DATA_TYPE instance.
 */
class svt_object_pattern_data extends svt_compound_pattern_data;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  /** The object stored with this pattern data instance. */
  `SVT_DATA_TYPE obj;

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_object_pattern_data class.
   *
   * @param name The pattern data name.
   *
   * @param obj The pattern data object.
   *
   * @param array_ix Index associated with the object when the object is in an array.
   *
   * @param positive_match Indicates whether match (positive_match == 1) or
   * mismatch (positive_match == 0) is desired.
   * 
   * @param owner Class name where the property is defined
   * 
   * @param display_control Controls whether the property should be displayed
   * in all RELEVANT display situations, or if it should only be displayed
   * in COMPLETE display situations.
   * 
   * @param display_how Controls whether this pattern is displayed, and if so
   * whether it should be displayed via reference or deep display.
   * 
   * @param ownership_how Indicates what type of relationship exists between this
   * object and the containing object, and therefore how the various operations
   * should function relative to this contained object.
   */
  extern function new(string name, `SVT_DATA_TYPE obj, int array_ix = 0, int positive_match = 1, string owner = "",
                      display_control_enum display_control = REL_DISP, how_enum display_how = REF, how_enum ownership_how = DEEP);

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Extensible method for getting the compound contents.
   */
  extern virtual function void get_compound_contents(ref svt_pattern_data compound_contents[$]);

  // ---------------------------------------------------------------------------
  /**
   * Copies this pattern data instance.
   *
   * @param to Optional copy destination.
   *
   * @return The copy.
   */
  extern virtual function svt_pattern_data copy(svt_pattern_data to = null);
  
  // ---------------------------------------------------------------------------
  /**
   * Returns a simple string description of the pattern.
   *
   * @return The simple string description.
   */
  extern virtual function string psdisplay(string prefix = "");
  
endclass
/** @endcond */

// =============================================================================

`protected
K3_-W5O:VC\-UM+Xd(L+)&_LDA8UNg:Fe8P</UTL>^;V==De/SU?3)eFUJe+OMg#
cATQ,+I3B]/9KcQW15,KeLPDNV=Ze)@1^e.XOQX__\8::039LX3bX>7a\Ra/\D?H
2d\A&=fD<WLJb;e5-1>RQ2&aTY5QBRd?#6FC#b^(bD]bT3gFgHO;:RE1bJFdccRX
A_Wbd/b^I24B]aJH6?3->MX6)@X[UbAU^[7Q0aE[T?0:FCXIf9L&Q>RbUYM-M\K+
E:T?]7OR\1/KOY16A]\V#<\eY+c7TcGUJ,N/T8621D_ZKT=+UPa)b_HaQQ;=;GRA
,4]SY#N.,Y,OM>E_R0?TeGUESJRTb(92,NAWXLCJ9WWca?)F&&,DS3@,I-J)B[-2
[Z+<>_e#.<4/)fR4OfTOE6?AI@dJPY/6CVEe&Hd.IB\8#5NH7D&Le#-5ePPbNf.Q
?1S@e7\d+g)afB<0A:B96S8(C:33?;a7J(#&-70B:c4[KWAT>K1D6UV.Ce;.a0@b
B2+@]\R7.C;bGNCZg(QgK-ATfT2F,#JA>8A@+K@L[,J6E]DQ2]S>59\>?9f@U&a4
bFfbg4:];C_gf<NgUC9P&^>H4<BI-1+>b64.Kc3V>a0\(PMG)YX4)W9fF6a-_9Z=
9J<L/8QEPQ(5>P.BP-P_5Y#;I#(?2JCS_1Z1A<<1323S/_<2_/BeRg,BDg87Vb02
/6[W/[_F>V90?f8[^(]G9LfS<Q4[D9\>QcJ;BIN2G?+=6/F_5e<eX=-W9a/^:;&+
=0&QJ<(]7]FWRORK9<XE7.^<9:@Mc2,g.T>Y+c18(;b<;,W[_bJ9L/3^-(E1>IEF
+<L3JcFSX-FeQ;??R0c4DRaY&+(I6P2WceU>)GXd,F18O0A)#D<,I&AD[0fE^98P
;.;W<G)G>)3N2LD#5OR=G(gcH_Fa.SS\O4&?dS<?^\6:[J@C)L()3a)<cO+>g+I&
AFADSP\[.SWOg:[;_\G\Y7NTGI=)5__XSXI/U70WR)VO.F^>@+E[2L]aI@(0cT@S
E>PX\W>43eee5I6Z&0UTNE[Md/=7HcR:dN6b51[317O@3^3+O;;N_\CBN4Y:d79Y
0;D0H&DD0R?\cI[/^\8J#V83(39(+V(99<d3G^^7H\QK=d479XW_(W[<NC.#<NTI
&@\D/2eO>.3:H\@N1-=;MX6f<>L=7320@[LI/^;@LaZVN;eZ)/2NF]S>U3-A&,?,
5L[;RDY)g6]b;43\F/UZ]?Sg+,MU13>e\=K_O3[_J2Q,+9ACE0(,6?c6/,X9L?7c
::MSMA>&(^4I^B&A0M,M_-V\.I5CQ8)<dH6FXc89+\\VA7\+8bfK]KC^S>d:Rc^4
-A:1JR6\]XX1Q0O1=Q-6V263/.P2-;@f4QcWQ:T?)WQDP(bEg4fLQY?c+8cA/(5E
KYZdP6=aa,I^(E4QJ6=+UGa<44KgX?ad^8#LI:=C1(N4=S8f\NG[O5VcL,?6JBOb
0SO7ESC=5W_J9U)U+SPO1Jd-b7J8_:Y[Gf+g(O[-D;.35AO2)4^G&_)NIb9/3H3Y
Z@MGVbE8b=>KJ&10Y-<-G+?Z;#TF<L?7gMIDFY+gK#@=Q:EMM\f/^+OWeea\)F(>
P).N>g&TIHJXVId;R#Y0@.B9@N+6g:LC#J0X5VA5QZ=>?VYJ/(PbR5;V[Zed&=PR
KW0;E4;JA2e#9#Ub]5aL3/Se<#?CFSLNL^MQ^Q646BXS2d47@/Gbc@DaaJ8AaN]7
,5.&L9<VfdV0)@1g]a<30bW\_ACO@3.=22W&MaI:dYb(,BKLfHTK>G/e43H5E/fN
>Z7Vf>BIDT<U4O.-)6.e0T8I(>D\+7>2MbM+CTUI\e#:SNSHNBa56=2)IR3e:,Lg
B4;RXB@^?V+@46QADI]_AL=XM?:+[_g3Y=5f)S<EGD?[D]&U-><#=>3#(F@]TTUK
<B4Y8+_9B9C(9(3IOKT>gLZ9fa^^)d7ZB&)YG6ZP5DD(><VgIcc<1>-^,S_>YGSQ
1ZASYUC7ZJ1Q5(,I2(5DY9)US#NFKPNa+F74UNQ108;NOC=aV:IGTQ^K&@Y-\#3&
VOXgL(BOBEH8gF3Y55S)U_.^bEff/9[bV>(Z4AeH?;Z=A>]Lfed/ML:YG+:65aU.
_4IDGYD#1)(eV6M=B,?#,)L,ca71TI0TG6=ZWG\d/S\[C&<-e6)?<=7.R[JBg]68
b:^.;8]cRT1&_9NW>BFP?a.S2M])\-NOSa<eG#_g600PYDReb;g(0GbM\P#OSKL.
CRH9W<_a0)RR6]]=LR3NVH/Kc1TbD0Z#CXcZ](B/ALVJ9B68b9,V,(FLA.[:^9/^
5]Q)AJ:7Gc4&76WVM18824O(;:L[C?4d>RTeC[:M9e+F+8<=Ad\,<UFLK$
`endprotected


`endif // GUARD_SVT_OBJECT_PATTERN_DATA_SV
