//=======================================================================
// COPYRIGHT (C) 2009-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_PATTERN_SV
`define GUARD_SVT_PATTERN_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * Simple data object for describing patterns as name/value pairs along with
 * match characteristics. In addition to the name/value information this includes
 *  - match_min and match_max
 *    - Used to define whether the match should repeat
 *    - Typical matches:
 *      - If match_min == 1 and match_max == 1 then the match must occur once and
 *        only once
 *      - If match_min == 0 and match == n for some positive n then the match
 *        is expected to occur for "up to n" contiguous instances.
 *      .
 *    .
 *  - positive_match (pattern_data)
 *    - Stored with each name/value pair this indicates whether the individual
 *      name/value pair defines a match or mismatch request.
 *    .
 *  - positive_match (pattern)
 *    - Stored with the pattern, indicating whether the overall pattern defines
 *      a match or mismatch request.
 *    .
 *  - gap_pattern
 *    - Patterns can sometimes need to describe non-contiguous sequences. In
 *      these situations the non-contiguous nature of the match must be
 *      described by defining the gaps between the desired match elements.
 *      Each gap is itself stored as a pattern, but with the gap_pattern flag
 *      set. When set to true the pattern is used to do the match, but is not
 *      stored in the match results.
 *    .
 *  .
 */
class svt_pattern;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** Pattern contents, consisting of multiple name/value pairs, stored as a svt_pattern_data. */
  svt_pattern_data contents[$];

  /** The minimum number of times this pattern must match. */
  int match_min = 1;

  /** The maximum number of times this pattern must match. */
  int match_max = 1;

  /** Indicates whether this is part of the basic pattern or part of a gap within the pattern. */
  bit gap_pattern = 0;

  /**
   * Indicates whether the pattern should be the same as (positive_match = 1)
   * or different from (positive_match = 0) the actual svt_data values when the
   * pattern match occurs.
   */
  bit positive_match = 1;

  /**
   * Flag that indicates that the pattern values have been populated.
   */
  bit populated = 0;

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_pattern class.
   *
   * @param gap_pattern Indicates if this is part of the pattern or a gap within the pattern.
   *
   * @param match_min The minimum number of times this pattern must match.
   *
   * @param match_max The maximum number of times this pattern must match.
   *
   * @param positive_match Indicates whether entire pattern match (positive_match == 1) or
   * mismatch (positive_match == 0) is desired.
   */
  extern function new(bit gap_pattern = 0, int match_min = 1, int match_max = 1, bit positive_match = 1);

  // ---------------------------------------------------------------------------
  /**
   * Displays the contents of the object to a string. Each line of the
   * generated output is preceded by <i>prefix</i>.
   *
   * @param prefix String which specifies a prefix to put at the beginning of
   * each line of output.
   */
  extern virtual function string psdisplay(string prefix = "");
  
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of same type.
   *
   * @return Returns a newly allocated svt_pattern instance.
   */
  extern virtual function svt_pattern allocate ();

  // ---------------------------------------------------------------------------
  /**
   * Copies the object into to, allocating if necessay.
   *
   * @param to svt_pattern object is the destination of the copy. If not provided,
   * copy method will use the allocate() method to create an object of the
   * necessary type.
   */
  extern virtual function svt_pattern copy(svt_pattern to = null);
  
  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Method to add a new name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   *
   * @param value Value portion of the new name/value pair.
   *
   * @param array_ix Index into value when value is an array.
   *
   * @param positive_match Indicates whether match (positive_match == 1) or
   * mismatch (positive_match == 0) is desired.
   * 
   * @param typ Type portion of the new name/value pair.
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
  extern virtual function void add_prop(string name, bit [1023:0] value, int array_ix = 0, bit positive_match = 1, svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF,
                                        string owner = "", svt_pattern_data::display_control_enum display_control = svt_pattern_data::REL_DISP,
                                        svt_pattern_data::how_enum display_how = svt_pattern_data::REF, svt_pattern_data::how_enum ownership_how = svt_pattern_data::DEEP);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding an bit name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   */
  extern virtual function void add_bit_prop(string name, bit value);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding an bitvec name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   * @param field_width Field bit width used by common data class operations. 0 indicates "not set".
   */
  extern virtual function void add_bitvec_prop(string name, bit [1023:0] value, int unsigned field_width = 0);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding an int name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   */
  extern virtual function void add_int_prop(string name, int value);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding a real name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   */
  extern virtual function void add_real_prop(string name, real value);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding a realtime name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   */
  extern virtual function void add_realtime_prop(string name, realtime value);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding a time name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   */
  extern virtual function void add_time_prop(string name, time value);

  // ---------------------------------------------------------------------------
  /**
   * Specialized method for adding a string name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   */
  extern virtual function void add_string_prop(string name, string value);

  // ---------------------------------------------------------------------------
  /**
   * Method to add a new name/value pair to the current set of name/value pairs
   * included in the pattern specifically for adding information about display
   * properties.
   *
   * @param name Name portion of the new attribute.
   * @param title Title portion of the attribute.
   * @param width Witdh of the attribute.
   *
   * @param alignment Type portion of the new name/value pair.
   */
  extern virtual function void add_disp_prop(string name, string title, int width, 
                                             svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF,
                                             svt_pattern_data::align_enum alignment = svt_pattern_data::LEFT);

  // ---------------------------------------------------------------------------
  /**
   * Method to copy an existing property data instance and add it to this pattern.
   *
   * @param src_pttrn Source pattern to be used to find the desired property data.
   * @param name Indicates the name of the property data instance to be found.
   *
   * @return Indicates success (1) or failure (0) of the add.
   */
  extern virtual function bit add_prop_copy(svt_pattern src_pttrn, string name);

  // ---------------------------------------------------------------------------
  /**
   * Method to copy an existing property data instance and add it to this pattern,
   * but with a new value.
   *
   * @param src_pttrn Source pattern to be used to find the desired property data.
   * @param name Indicates the name of the property data instance to be found.
   * @param value Value to be placed in the property data.
   *
   * @return Indicates success (1) or failure (0) of the add.
   */
  extern virtual function bit add_prop_copy_w_value(svt_pattern src_pttrn, string name, bit [1023:0] value);

  // ---------------------------------------------------------------------------
  /**
   * Utility method provided to simplify trimming a pattern down based on a
   * specific keyword.
   *
   * @param keyword The keyword to look for.
   * @param keyword_match Indicates whether the elements left in the pattern
   * should be those that match (1) or do not match (0) the keyword.
   */
  extern virtual function void keyword_filter(string keyword, bit keyword_match);

  // ---------------------------------------------------------------------------
  /**
   * Finds the indicated pattern data.
   *
   * @param name Name attribute of the pattern data element to find.
   *
   * @return Requested pattern data instance.
   */
  extern virtual function svt_pattern_data find_pattern_data(string name);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a real. Only valid if the field is of type REAL.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   *
   * @return The real value.
   */
  extern virtual function real get_real_val(string name, int array_ix = 0);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a realtime. Only valid if the field is of type REALTIME.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   *
   * @return The real value.
   */
  extern virtual function realtime get_realtime_val(string name, int array_ix = 0);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a string. Only valid if the field is of type STRING.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   *
   * @return The string value.
   */
  extern virtual function string get_string_val(string name, int array_ix = 0);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a bit vector. Valid for fields which are not of
   * type OBJECT or GRAPHIC.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   *
   * @return The bit vector value.
   */
  extern virtual function bit [1023:0] get_any_val(string name, int array_ix = 0);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a real field value. Only valid if the field is of type REAL.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   * @param value The real value.
   */
  extern virtual function void set_real_val(string name, int array_ix = 0, real value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a realtime field value. Only valid if the field is of type REALTIME.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   * @param value The realtime value.
   */
  extern virtual function void set_realtime_val(string name, int array_ix = 0, realtime value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a string field value. Only valid if the field is of type STRING.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   * @param value The string value.
   */
  extern virtual function void set_string_val(string name, int array_ix = 0, string value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a field value using a bit vector. Only valid if the fields which are not of
   * type OBJECT or GRAPHIC.
   *
   * @param name Name attribute of the pattern data element to access.
   * @param array_ix Index into value when value is an array.
   * @param value The bit vector value.
   */
  extern virtual function void set_any_val(string name, int array_ix = 0, bit [1023:0] value);
  
  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
-0;ZKWP7QCV3PfRFN./_6XNC;XP&O/U];+0E365=R8.1PFJZWZL1&(Z6;2_=4&Md
f^&&3)W@]QC^d&fQY85F>b[K#@<YV(69C3VK7aT__?-,C3<#_P.BMPI:7@F+Tf;A
QEFDbG@^:IX-7@agXY)::>RM9QTS0#,((c5V[Z(=(SF/FPK&<aFI/2YH7]]-X1I4
QU)dcW=I1#Ie#OXg4>W3AZI<44]]dY[SF6?<9W;]-3^D5=7DGU0ZNLd.D_D8CB+I
U>eT],V\SF/e^>@[XcN;;/IS-2#]B#4=&X#WOB7?E8RfU20TG@..>AD2ffE\\Uc_
f6fE/;dMf+K_B7XF8B[G;>O57N+FZUO;(MaeO#@=H2eTF9]VCW9c>-5J?9G.)>aC
X\11]ZYE.92;<(7If_SO;^7[PRO;SW@_.7GY:HaV/_SVLg>D-L5JGIME.VT]KW[-
3AQKARO_-:;E+YA^8_Q-c@+Q?N4)ae@C7_EM=B_\;&Z#&d2Yg-PP2GcIKV[VR_?H
T9Q?;877=ZdB>=D8ZGNSFJcaF;RE[#22gWM7.BNX1/;]GQ>Ad:;>XF?1R[e/TRWU
RRdPNZV8XNI\Ja^/D\68dP=Y>(3X^WLV3QE^Kc]eZH@68,X4^9\3W,f_;Xba@UA9
f[&P4YFe)fe_SD_R=^Od;7P(=?;+U_/H\-NXg53GD\X<V6\E4=eCZ;f9H#B/AI7N
6^L+#]=a[\)e6,5IXURDZX7c;@_O?V3JZ2:6O1.23K90KRbcBU6=-WROOP.-][Kd
IQGYZ&JeMQQHb(&1.>ADS,5#?c<-\<]+,K4_Z</Z7U-E#:CS^R6DfceY7@PBV+5X
KOe1RcW(7VPU3dM7HX4AOB=1[W.8N@MGTF)CH9NcS+G:QXBPc,#)C^TIRA&b9&PB
ST7]9PPJL,IMd^f8BR\G.0RJJ[GaM)g40aP3:S\M,9/gNLN4-FFW(/RSH-R1=EC^
NERcK/ZZ,Z&E#7J66:&HfCO\^H7Y]G\H0YY,>)V4^78L7PMK7Z?cTGV6(W6R&5;5
X;1(XY7,DSdVc8&QT>>3;eG,=ZFK-U-[VJ[SCVN9L#_S)cJ00T#I8LW#?4ZT.0<<
.e7;_2<MK,f5[PH<YYXV24S1#W_JPb/YQ15C)1<F>EV&TfOS&GRJbP1NdCa64I?<
/fK65SJ^O_YV@fdQ^eN&[]XTPQW,VKQP<VQ-?3\&SdXZ;,@O&K>8O.\V#3=f#E3+
5/F]P;6&:8]ZKOQgHa3^,0SgP>;BSY\9gSbKNLBV<&PG5abCH-ACG>+DSc82YN?9
QDZ?L[B#bAJ@ILFFSQgceL32:a&Fa?&@98KW92F-F^76QWO+=eKO#-WV7(c?X0(8
]F5d9f44O#=-.^3UV-ZbJ@bg@Z_?1b5AV,eWPa<EIIZ&3ZDR\R-S,9,4Y4S.^f0;
AN_AC=W\HXF]@P1.9g\YNWMD&TG::DUU7_LLILI#BHUT)UF)fb#H\g9FS09I:B5>
Lg.C;eP?BZQ9TAEBU;=6a;4dXU4fRSRQ)SOMMIEU>:V<9Jbd)G4e4aV)H=QQTegM
&WW]bB&N<EYOfHXdDQJ:IIbB8GBE<=J[5:cV6LR:K8K^7,Y5RH5X+C\1L[K00PA-
W2Ec.9G68AF_;JH1NHD4V#BN:6P95D.Qc=W#H\F3MVg3(W2)QJFI:E9-O5V\2]?(
fPF;cc8>DOVcO[7NFD55EcD_\UfHWg7ME3U30\bBH?OKW5#U<JGV-NW;&a55#2dZ
fVbU88\4b03B)Pc)Hc<@@VVWEF_)KH3)=U-+e/AUFf:=1A&P)TSHY,3]Z/@E,0YK
gY43,4M1HbgI.eBd(9Q2M@U7A7NN_L03=X1VZMSI-9d@THG/IWbb[0=dN3dRE,J(
1P_HO9Rg#cgT8\:fZaHJSMOPZG?e9X).FQU/BgZ#VZS:CC/J=>[@7;P?cH[O:gO-
,J?A9dOe@#DQ-ME_c,P(U;_B-R3WL1g(?HW6DF4W^[5KbZP#0S6>]B_D\PcO+@c.
VLMS0/VRF=OPS0608?Y,Z-)RZ=FV8:TG+eb7X7EIeW8N>TbG-O6gZEMF(;:.P\:/
O?^H#V;+Id05gA]#U+c8(N?b-5#Y=ZTWMXKM?[I-]DdVR+B\QBHF1XE_UJ^X^R>b
.-W1.^@_[ZMS<Y=.J#f<4.VK(AR3@L0YM_0#)9GS-)JD9bD1Z0YD\1<d/FUSB)7V
Qg1I_A\S9a>F-]=_;0;B/J)dc)f)dM>b^7GGGLD=?NO&g>33427O<[<(Q3H0YV2V
&19d;B3Z2O#,W2CTFc[Dg?(:IL+;^V/b0+HHBf3YPLQAf#1R7V;#;>/_T.N&W\WG
CCZISJE]\CV?V0S?I)D=db1)&EV:KZ(HW-Ff@9e7_AddB/&K<6LH2b=ET9-1R@X.
(B-\I<cQ(QJ;3(;X8G/c4B)SF.8IU2dKME5eDQd4;-=/#)Rb5HE3/K?1<#<V>EJR
#I<?)=HYf#OFXS[\_[YYEeY<aKL#EaLJJW,.1&Y_H8e7J2bWLeJ\@>PS9I;YPeP_
4O(GOF9/R/c=;TV5><+Z;),B0[Y=2bX/fe@PQ[bKIV>S.#XBe/V;dVbc\(dD^;Q-
F=Ud:3#R_HB=X<WL[LfO_-5ZP&bF/+)1==3CJAMeU:0X/#d#S=4J<1W=^OR_V945
e)g]:Q6S8M?S56XfN#^YaPEQ&M[GBa2]YJX.V:gc-5bB6ZXO(FQ<(].JTe=RMQ>&
>2T9bRHTDVN#+QcD-:5?XQf+DS9@I92e=2>/1ZYV024U47:4cFfcP@VS58bYGN,V
U0e70SBVO4&#QBNcUacL5C96YaTbLSJdQN(#Sb\e24@eJ#Q06PYP/6d7?:\V>1bZ
QeC7UZ1HceZBTWNc4ZH,<+A.4,XJff_-\9)ef/LAJ/=A5.BI[a.-0UNZORFFYF@>
]TU[V,,J/^RXea.=FGRfJ&cPB\JT?5c6[.c91,<?+6#^C#H:EKA;E5V@GKJO#\5Q
JI2cNV=/X6aTLS+Xf4cJD-EX;4Cb9VJ?KB@TOA?a@R@:N7,HY_/_9ZUAL+5P(;]8
\=.0T;+70P=[PW9I/DW-2_[1f07837]QGSC-5Qf-.JV_E/V-TD;gU/[E2_-PX7=Y
0da+SDXBa]fN^7GFg4GNZ+K.eXLgcE2F?W)ZEff7D6[1A/.g7N?.gH-7^WAJK#@U
b@,7?C1ZFb2ce3S;A[LQ<15BC)Z-GE.X,IPQd.b8TAEHIX,D2Y0bD\2;HZ:g/-SB
dC]9S99AG/[DGAW>c+\_d#@Z<<\,-/Xc2KLN6+2F?QPTeMO@45<]0CJ1eF?K;WgO
-/I>HGag3[J,RdQPg@;F28=Le10?98Xb-@74_IQfM0/R)^BQ\U96K3B\PBSJFH)[
XP=g[.AgKZ&?H;,\/<LV#VW5J;ZK+U@Qf([YCTDZ=6c6LX/Q.AMN)gL-7,.cbIcc
GJ5dFTe@FeM,2VGUPU[@_G62gbg,LAW\@-F1^CCdC097^4AXW[>=V_.-Ie=g+G;O
6a8_d9bU(PbYFF-9c7A[P[6O?2dCg#gXUGL#&.MdH06ZEF;^Ze4Bg/_]cY&F,H</
0S/cCeWJcCgJR48dR+AcSN;WeGa-9aW=+Q>g+B.Z@3,LbU+@?W1#;X\<AH(QF)bF
a[:\Nd7,cVGE]LMOd#&.90d9/8FLLZP\Yb^_C(P\F.NP;Fa0g23+R4[,WKcLeB#(
P8A)Z=Q>/],Z:Sf@C4\bdd<<QAY?;ZQIXQ+OB+-RD9;MG^4f974E<Eb?/TfYN<2]
XN+3d80-V?(WeR\0:b&ZMZW1XA[MDJ@(+W4_+I=R;3)<9MDecY(I:LDL-aES9[c-
O9+_Q^HfQOE73,;S]YG05ZOgGE)MZ.8CMgfD:7dDZ@FaH6>@(X=4AOR,3<U&<=]G
KB(IH7c5SZD^NCOf;74#9V[1>2GP90\?OM6VO+-dO6#MP(6#a\#<(4S?+D07VIQ;
7L]JWCAN9R<?^BC4U(:g8FHbO#N.A[(>]NLHL?:If\KC)g]FdR89:(WZJ8DOCHCH
W#3f\2PRVH\W+JQT_V43=bB])dc\57R&<EL.<U.VHXb893OOe-Q>0SM9A=J9V45R
gY#4>U:;=VY>D2.bO2<Mg1V&1GJ(&A9O[dZH-_W8E;#JHc:NA(f,=\>L2@L\(g/N
[<IN92_^4@Y]X42&N+@WB\\W:VdD.?LgCAV&FR^1[.E3HFJY-(G-16+M4]2\@5V\
X2PeO#5IHH8RUX,W)Y?4ZR&^dGD:2e,NZ_XX,gKe[Y[F2F,Ng6@\BC:VENeQKaY8
699aabR@b3/B\OO2=<fGXWZX]VFD@_C@WGKBY3YKM[48T7<K4bT.Q1#9J_#XHJ9D
dT@]A7c2V,5L[88\M?<1[1^NEV?N:]cZPMSI]BC.G:-?2?.0+Z6JI\g&;3K3]VYY
X:]JOF8d/4HMG<RF]F[T5U>:A03N=S#ETB;aHJD1I2\0/-eb)4(#K/f-eZY\+VF/
;Vae8^&e[^7FC+BA^Id7gVQ=0(3>C\b_0WX>ZB[HNZUYH8fLOc0QA4W3JI\/<3E6
.3>=4XT-.PIHEO<1fWBb:Z^aYB?7_/f,_]Yc^M1ZJCA/8P9cRK/^.=,G]KK,^FPP
W@(:Z:a(g7^aB.NFN]dOBEY@28/G@8F(C[X\72^WcPEd5V5HYf^WJ)+4XJ89_U[\
B58^TB6G-0L;0I9L^#PPIQ0?gC@f_HN8/bD&3P4Q@\N^54\])V,NK1GcNQ+gG88#
9.\PR_ICaEYYf<6+CITa03D-_#?:f=>T\9P1#gdZJTTAec[1#&BM@f[QZF]_)b+B
2(c+IdADS]4eT6:_VR,^aX5/8YY5M@=f/:^(egP;]+5@P.ZKR+)8Lb-g#8MbHG@;
&MO5#Q4(P.gc,&1eCe;/dYf3<.O@LUb6_@8M5H_2DEJEJOJP;Y,?a>?L:>R8)/-/
[C?(1S;I^SHfBCQR_M[geIH)=(+e-9X(.-[,7[OY\^1G\Z[Fd0VdFG:>EA>)b7;f
b;dR\Td_QP4cWTTMTH>D+@[R3^)2-.]&@)@BL^cOIAI#F=#A]PM=ZK5&)f5+;?Z?
0<aTT>[ADS?g\F1;GB0;@gfN?_S\FF/-A:GKAZ]V^b[VH1V4WTKO/5H2QdA.36_=
<J0=+UT9:NVX&_DMY;gSCTNPgFZMPd1O)<C/d[W4deDad\#g7FD;UM(Y)fD04(#M
LCP03C.@&a>7:Y85ggN=bSB3VQBL2:g>)[#RR5CbM;cDbKCWDIHX8UZ7EHcZCV#2
UAc9/Ef5f_F)ae]--N3GKGeP-5P#YWTTG(R3,SEP_RVKP_G0YNV:,8L:3V>#AZB&
S]8IJ\:?Y.S-IE#=(EYH+Jg5I>f+VU#b5;8_N\Q\GP<940&B+E^;?=XQ6bgV3O.#
[W5a_A<1=.4RB.HWLfDc;M^PPDMQ&S?5cKA22(OGM&XP_a7N8YMc9_-URLDgF_^e
g\<MP=@:@<_645N-636L]9P2e[f)?.ZXf[A166V326D#VafCfN3fWb8=4@/QJf#A
&@B#+cSOSUD8AHEX^??9NTgVZURP[HB#-[ZeACF>fB.&?#Ng_N7dfeK<>)7cT,\a
Lbeg86]AH2N>;]BH+:\B@RS<Jb&gW#B8GW^PFRAI2(5a2:Pd6KV72,&S88/g>FI+
[)c07P-_f=<#8+E[,f_UE4D@Kg8(S6d+]c#AT./D:FD5]<MefFJbGfU7dg0#.L+X
3e/\fg&[S6Lc/Xe<8\:TeaXM&_IHJLU:>6<ZRAWgIfJ?&&B0EaN8.UOaW-ZYM?5#
Ka?@&8,+\&PHCG(cJdgA@536WW4<9?NHGCKe.9]GLebW7&WZBVeQTg6^3Ecf+/I]
6#g:IeYD15AEO[5AC>9DF>;3UOW6_W8[A6edM]33H8Ef3\]=(50dURQc-WOQV+,^
^;-0IZ##YQ).6;SSRd;26IJe1-e#WHQ+0F^;UOTQ@S]X3f=U^W^D^,(Jc>ETJEdE
-g+E9A4Ra,Y_(]S5O9(^9/X[I(5&g@]fO0NN/Q]Q2CEKJdW=;UCWK=0=X>Z[P\[R
efa3RESQLP7;DBB_A6[A.7@^Z4&J\9N&b-7FCWSS1G;#E&^_c?XG@a:9L9:f4@Cd
B;U75fBG7/d-QN.9/3>1\@:N?aOOXROMFWZNUFg(?^0B3MP9IY?b]Sb&G/,[3(=e
Q@D>P75eILJ9T#8Ka#dD)b.+#V/M\#(?5G=PJOe2.3F7.:HW30C&1Z/dVV<)5=8(
WDQcadX.P3B5FTcCb82GM-8?cS#]LY_E?S^KS>&6FNF8N.e<0?(2AQe)4WBL3bR)
+Bg,7X(Sca;\g-6.4[4V6_O&:YW:cN^>?9_^(.56(ORQ\YO/A[HSL#M\+c2]1CP-
8D=:DDJSQD#?8K.FfMLMT>Y]\GBJM8a8]HKD6KI8\=XfOUR(VfF\J9D65D+32Qa0
Fa@_J/bg89=HcIITcP=Nf@Z9SZ&+2[N^K&&6,IcH?N()?,-L42ReHJ.Y=5AA^YfX
=ID_eN\XZ((ARa^P7K7_R_UMC9(XYgLE:?Mg\/c9^UMfa^AF8CO4F.QAQUa9]aHM
R]_5I-1_STGZWET/Dc763f[8,+aHc7[I@Vb@;TZ/>R@K??\SeI)QVT2M=:\,D+8(
9CXKE<P64RDH>,S)77LWS@9@gI8OX:S?+/4,1&^G3G+^G+Lc60+&9MEAL5Ab6H?L
_^A7f0ZCY;\AQTESda+AB[1Q=dZLKH^8aO]fN=T<JJ?_3[LS(eWY8)7SGgN4g9&N
,/eOKL/.6FK@A3EC&?\<PI(IBMVUTU&:]fQFeHL4<28TXdF?=NU-781?eJ8>>\N+
]g(cJCbPc\Kf]:8?EA5H+G66Qbe1P0_BK<dJ</SW(8W_<TYG\UVNXOc=<N2<>FXH
<A>L)H9+89B>KCI]K-/a2@2Yd(Oc)b:?[W#>,[E/W/GJ1=fC9X#[e5Te9KE)9a2H
,da?D&]-59J?KW.IL^gI0(;>0<f_;SVU.VVLfWZYDE[Qd1]R8^H7.J#,87g).Ag)
a7H9bf.VZ-abQZFXR74Yc6f-;#c#OG46+09ON2MWHcgW#O2AOW]MA\=2ZE7YEJUO
^J#1aO7E4Q#QeTTfQa],Y79>fJ)M4W&043MX/B)Nfcfga7<(/NW4<e4fP1B,J,7G
?WXLSF25)A<_O>AMfA71f0JW\IPdfXM+#]7aBfW-EFGeE)(OLL>fa^3-_(g5TTPQ
(F>3Y8T8&ET8QNUfNYH#05NdA-9=&A>/<)C20#c=9e?8@=c959^UK8>5VQDO].-K
[DRb\[.A7OdH4fCdS821a]SJNSS0aWN+g(2\5@eYc8.Rg>]9g(dc6>UE8]_1]Q_]
HUN=GPa?^>FgN?bd3Q/@_G:-VN^#QbL=U&a>B<d?,OY0JC;egBe7.:T/gOc#4&;C
)f+8FB,&OF<1b1gGI;0)__?-gXHG;a:277+QHDKO=Kg?2;B#?4SKYQK__AUgRa2g
9P:B]Oc6b4e4=G[CEKE5SJAB8#&E[#8Q.PVaADOQf]dK&P.1V6/E@<eC:>b:g\#0
K?-^+[6dXC9FP7\Qa)=Hb>c0L6Qa.^M:FR\X::BR&W^#[<_9(S6&D\-gd2&IDOWf
c3,,K;/LP-K,[+D\cgWb;UW\=J.,bV/?M\&(F\K9^JW:We1FC4b#b5KA5dg&MCTW
aDBJV@aW7J3QIZ0dX+a?,>7X.V]@b>TR-VRfV5<7Wf:E<Ha7LNX91=Z@Q.S>Q;Md
L,T0-13\#2IO=4Ta0>]G[=b+7cQNE&K)G/NG6]-\g5FND/<P.:+SPXP<U>e^41Ma
]AZ;>Wf>,+-IfTEMK61\AN.-=:g]6ZS]>2;87(5;<6_J,S7)4&#ZU\0UTUXS^+d/
C-DD[#F)5F0S_#e:[B;7L1LWc41V:&RPB^M7\d^2d(.,_)gOF6RZ];Y:OOFRW:&S
>3E&3XBT_E/71A//gB_A?g(]\:1@7A71dXc:9-W<07?]5d+\;@I3^MGE=4;3E</J
+P>>N&Db?\9]B+-)ICU02J&9G0)d6CU;e5\8A3C)a4K.cBZW8bWAB(TBbP8GaY>c
>gJ(I#HRE/RP<[aVgL.2=R4X&,P/C^8_]FA7@bIZ:E=-Ea]2<D>0[Q5Lc;NRG&7X
D;6c)ZY?G^3NBFdH)BGIN2eHK52BYU]SQSBC=;G3&+(D.F@FJU)2dL^aX+;]T-)Z
@OM@fbM]_Q2B-c_d+X\EF\,c[47d9MDVgB-7#/Y0UYIF6F-RgADe65VAG6:^UVDP
B2^UEAgG:,,#VJ:QQQ.V<@JNF(XcV++fe:4;BBRJ(9\@<W[4A^07c2/cZ\3)2YFg
3=7OeKb]&5NNXRRJP(NS/f3JRJG)\6]&UG&XWcS)KE/W=]4GS4:egX;dNbDa90a6
2VK4E57VHD0D<e)L@PcHdN)DO;?TE^9^1/&+T7cMSdfFQZM,L(XQG+)YU80Y)QI+
\G5SGV(?gDGU;,U]f?Q)H7@A<=:I#9bU(1^1(=dOX>,)U)G@B?>E<7V-5-33Y_#L
N2;37HQWL345IIWCN=c>M..Q:6(#54GJaI>7I>_+dg6ZR1>07.OC\afb[?4)b>,b
+FL,=R4+1+N,?)+a6J]/NDFPSQUJ)5/]2.0a.c?a9Q1aZ0.9G^G7R_cL=):#(S\/
/H].)+]H1Z(&MbM_BLZ[(S>g2?=DEX[@J)@]HV<YR8_KYAXN=B4Y_S^QQG;,A5g@
JC<0:QJ+H+F807SOI^NR[R#QYfdJ_>RPP:+[_3Td@W,8CN6FGWa;J@GD>fWb(=Ya
-V80cO94(cGHEP5fF@+9=0YPSFQ7,Z>F^TCg:/^&6H,J1aM1<Pd??(^\c+:\9fLJ
^ANQg:E#I6SW7?<,G.8baDf1d#eG:^eD.741[e>KMT^^[,IV=/QUL+AM#R14?30Y
]@?=I>O99=4J)Q;18)EXL&NS1?R4R=?-XD=<\7YIW9Q31Y(Q\cJ9ZT^2<VW6.\0)
1#+g:_H_KT24.>#&3BO>:XUf5J3-e)HIH>bI;Q7V-KS2W5RXI&3bfLaH1[,fUN&.
LK(fS+g>L?O[&(W?@a<eC;T,b#QFa,V(?<P#D91WfIaPg=[QdMKFGIA<A^WELTdK
(9I)eU6,J&,U@NS<,8N/#<06@WE=1L:DdL(dT\?5B9MbcR[6&YXCE&SLEJZ?&<.D
AEF=;>8,egb<?K)OLUX[_1N.7Q=B>)/,)07^bDH3Gef\XfbaF^]1M6H-QL7=D(FH
<587Fdcce;-1Z-2H?cCaFGXc[D(4/E?2gP.e?_UOfdA2=@&S\;&NH9UV?g-<N0:1
B;&\_#P8]8Kc@b33)5RX>R7@GgR=72M:,86F6e<6459-0P\f&I^1COEf:)2)C]8:
I2,@W@\@B0Y8@6OaJ?O>73eDRH7^DRgISRM/#\P/5N6Q12bOK3^-cf#^SA8.&=<+
_1gRa+XeOd(48D??9AAD6JOI:)(I[GE[I0,:6=Qa4=]fSS^(;@@a73=P)M.1^SK<
4c,5XWaLbc753ZdL#PYXN8OT-d?^HIH&2\6LD<>3c#VROSP1c\(FGT&<&M8g@^X5
NCd\>I6RC=+[(4:GZ,)U]1:)]L(f#_PVN<_(,KH-f(M=3M5eaaZ]MI7-E;/_(U7F
U_TQabP#G#?f1>[FZFR;f43Z[?0TLgPHe>CA:L0=H(/J9Ta-,1X\Pd6eL\ZFQK_0
:B9X#NOW8HcAY,P?LX0ff?:Y6b;Qg+>60S)RX#NX@?.PY?.Lb3bSNZ&]8.\B?J.d
]_a(cM],b)fWE&I,g2<^TK<RT@FC57@L]Pg5,R@^Z8e2Q&&g93K]OR@ER,9Y-aZS
<J?B^Kb+PO5WK7<g5(>C08&CT]BEJ]R><LB<1IbTE;fG/.1=_KL,:K-:,_/@a;dY
]4&P-:44#IOY5_/:U^SK0_/C/W(YP+>14>e>.a=0UXe85UHcU<MN:NGb);E?(.f:
0,H-\/fVD<5HWg&?#0_]aEf.DTL=fTIc.H)5H.(\R/IIEdJXOK&DIf;d@5Bf;JCd
(#FgL\9VQ5<O,[ZSa8R19L2=#2^6b#0@W\<U7.N?&OD2G(RIY3WH.J-E4+=feCFV
&[5.-\.>SO)FCYW^F@ZM\+7_=K5WF4OKfRBAZ,NL(XEHb(bQ3QSc+UGIHXTE/+K8
G<USQ]8K5LL?QGJ;BUL<YO(@9^HMcGG5-&^a_VF1[[g-_AT9.fP+0c&++_2>4X6Z
]2;Q9^3[9ID\Tf[.SDWEF@:dHIQf\A\H1SS\V4d0:&8?AJ&1RWJ;HFDM]Y@VWbfF
)Z0I-&8b\@P\W:KYN#g1BD.fQ>]Rce9AVY4-CITI,&^>5A\N4:;4CFNH&?J_[8TM
&JG4.Qd):EebWN^<3+F::_A0IWdg1gHbdVd,S2c8UdKBMB20VgUQW<fggOH:6GCU
>f\OIc7O5ID-78FVMO/CTK\S6;1@)ZYX4LD_D9JCRY\7;fADDe_)DXO9+9AHR4?H
c-;_H>\55YX\c6C11gd-O4ZUAf:R6G<>0#XUQSdd<b?A32\IbKEN20=QgOd+-.J<
4WZLJ9Hg<TcX>C:dF[VMe]SNXOJ6bYScZ.6efdDDf3^CXCPa2ATQ/Q03A4]D6_=Q
F3_+<27VQe3G=,5L7R?ZWce6N>=8<Z6XUY>M7De)1ec7#YF;/C9-.W&aXTUL<;+3
ER,JL3W5(EVg4(N#WV)Q\J9.77^]6gc?ACa69WU\HBGa]1-AM18aadE\fdgIfAGM
3QdG&ac)U^9FCETUPA=Ia,4FVX2#fZD54WZWU<&BS1O^g[6e(Y)Q1B3MfFC)P5@a
&IgN;VY;22N1BPV#CN,aPV2eT#\52]/>CRBMLPHG)(FGa_<C7>FaO8&1V_]R,94d
#7Tg(&Ia<;1AS)fba+?E;MIV.Z0R,Uc^dGQ-YOfNaMDHSTEC,X];US:Y]FfY6S0<
_6/1]CFY0Q)PTW2RU.f7=^+_;SWg;-R/H#8T=Dd-YPfTG+I\LR8#BO;+LD[W6:8)
8L7&bL\LTU#1W4BdBbQ7?CTB+U@?(GP/RGg)6URX<)GXd.V<]2JK)APN2d]CS+dZ
)>MJ76/P>)GMB(5Q;\cDfQ;O8E.8DU8YL=AMa?gS>e41d9&)Lf#PRD&[b^D;/b6Q
B_<cIcA_ET5V_A08OAM?)LIX@:+]5P=SH6]+f:A9;eScFJ(LK^#6ZQU=O[QO,DES
8_?QM3ZZE_7ENZ6H168C3^<BX3b26@4KOR);V8X4IA@VZYVW5;)caIdF)T)egaGb
Rf54dRLa6E9e-H^4&2Z[DEc(a@J/GUMT)d[g;ZA79D3EE;aVOJ<.e/)^9P0MM_\8
:@ZaP]56]6#TCQDT[GWBHB4DA/C(YXBT9YGbTXDW7@ZgPT(KPH=ec+cFF4F8?\?D
(D3-0f>G=D\K#,JGOeBD=B(\0f.,2VF7U=Y5U@(RMG>8+3EZ9.[2KN51)b0^eAO)
-S)A6,7WTSO+)QBTLYLG2Z6a+CYA-P@BXY:2.]]-Q?1I\UA<=Yb-[^5Bd,0SV_/@
_L7ELFF97c;5?,H_e[8.BA6:c>B\g=3U(f>3NC]7_OY,;:RT.:cBIDVMZ7B\WW2d
NE#M=,F+/ZUc=\eX#@3\KCg#&WS=U+H2a0/:[8VUA;:X>H&<VX;6aT?54P_?):A^
ZEJY;IL+EONEB+IK\a]+)>VLL8c,JB4GCPL[K[fHC>0I6bJAQI()@^f/\6K.E[;>
:K_OWacIVd:9e,E]_^?A=??4g)LQV6GG;B9K)T@P++(@+Q;@R_[>fF5KbQ/Qe=M0
(LDVf2[0R&[NH_KVSUY_=.XG(S_QURb>GV#)R)\0&;ERBaH2]BTFeNOF9CLZ;YD+
bN:7ER8OO+0>+(-3E@R^D\=DD+<eL)4_9&\S:9BWf(dJ^C8^[,fYO69/?FS5@=#3
ER#4+cS#R-@c<<d(&0RC0<K]TLD@DfOgP=0C\V9M&AFIaQAI@GY#V;.:4=_9J#a;
GYZUIH.XX_^4cPN=6V]X.<A=a=@c[N9TD6NVbg+2DG_f8GfBVYf#^(1@L2]VVULN
dAQ.\=TD_H5]g=aPGE1cF]AA,]?.bQWSIdX):f6aDg@U(AdMP-433.P8AeJ#DNb4
HH3(aZ^&36UH##;SI#I]O=WCE@]eVEAT&f0J9+TYT=Nc9La;[Ba[>=I0eB0#0)_0
e=T3aU34E\)LE_D?T[5d8&>ZecC+B.5IFR2OPb]9,E0:Y.+^b\M_MGUI@K.8^2]H
EZMJ^dK:3543BPMYZA]Q[M\&9<C\480fA^9g3c\;P(GPa>,R?BLf6JS-4@I_KMVP
g2U:SINU_[,=)&LG<O579L;H-aB=>\-]e0CWBf9D78c3P5AaUS>RO\)XO;V\V=33
;DB0Z6>^b=Z64#F(<RJX/3[f<E]>fLD&KM]))DVQ0+9S1]5;9Pd85>8V.:Lcb,+>
bV4J:)ZbP_R#_6I(>VH#gEX4T9?BAF7D4;?_Z0E36/:df0[OCTY06D9DN1/@9-82
@4b=+NS8C:XUgfdUeg&Q[dH0,;K<V<L,>/A-P6K6aM0E8++?UODD90ATcZYF#;<@
7G8#VF]+G(5,#ZGKBZ:&Q>?PQ,05J#bN\.V.;[Z/D/.KA5TP-4V4I^9^gDQ[L^/d
C7,@7cb,T]NY\,=+,JRH;9?\8JJ&\J=a@=)dS-DEFZ+IAWf@F/Z.5H9VXRYb(3PK
/_]A0#NP>.Egd\6IV,80F4GL#\b;7P5AMG@A81C?=a.T[M,g(^Y823GPT.W5E4GO
F[L#S+WS=LN4Q5CMRF_>-1][N0KXS)AbH3MEC:e<^g6Ee?]+2eM2=[>@e9?UcL,?
a/B;dK&3@fOQHDGDa;9SDEV2.K8C6d-C/4B3;/T,T/aI-E(5N<7\#31)2)9847g-
&L6HTa<B,M:JFaNfe[c^4/KB^/:=&X@f^c6b,,bY6K<Fg@?/R3e9A-,]9@,MYFRD
YUW04@FY]M2S>GTOP;HUPd\/>S\_I)0(Qd#^FGT?/U\]\ZU/?PSZ5LJ+[Y=SFT^&
S-B&7HD?[9<O[aeP>Ee+AW,Gg/09eMa9?MO3g:/6Y^U;Y>>#We]]>b)7X9#a1YA]
CQA9P7&Yf&P934ECf&H<eaF5+Y9LcL/Y7EC@>I&+XZ4>Hg>\Og?T?]?&&4K?D9e\
bLOY;V8\C>GSU:NG7AC[fKWFMQ]DNX@]2(R(bbQ]R3JLf?C8/Uec?X4\N.#1^RfH
D[1FSbIQ=f]S(>DMPNAMg32IIc(]^DS5U70&eaVBE[/Y_Q+:aZ.N-\d.UQ+c&22I
B+=OR36PC7MLTS,Age(:?=TgAAa75N&e]e9VI^^[4bY>eY5BTDS8:VK\O6Lb#KA9
H4A9)AW&/<c>F<@9XJY[ARgI[4I.V<Q4\acdP#U<?7A#1(==f#BYNWXT\F:+03>V
:7Nb9cKE?@A>5GNX:R3PO[Y,)_]ZHAB+]5d-H8_G,:HO+JC[D/[5,,bO/eU5;>>2
72U#E^Qf6+eCP(9#WQbJ#9?QS#X-V#97HBO/KHSCgP[9@DNPG6eXA1JgdLeC8D=+
Ab5UU(QGNBCW:9Q#J1JM5(#(bKaEY_F^]:3S8G4+(Y5:fFI[&DPH>cO<Za)MH.-Z
MU7BNU62YaC[I,LJFc>G\\&/<XHORKVF=(FEC+>/7fPBbbJ;PVMWMML8-/W&HHJ1
.:5YD(FH<O)E9UL5=3f,KY=>[[RFYLRFO&2H];B.LD[F58XNT2.TBBDKVJ;C1dDC
.2HYVD)f\dL_S3VD?1)K/N4YZRJV^6@V>C1O5<,G@023HKZNR0X.Y&0cUWcS--g]
BNR[M@/:GILX&BV/)2]A^Ee5B.>+gI234A]=Ic9P;S1([?IIL;CK7#&Mc@<@<CA]
L1E>HM6IW5^#294=^#]AUKYNNbC;J3VFbJ83A.J6KO?CTJGGd23;_Z?2,\6=f[Z;
9dB^<KFTd96?DQfVYFe,:g5Oge5<Z)Bg3MC>R8Q,SVEEMZ8++++>?7&ROAU9RWHH
2T4DHU&QD<_WB^]O\c#8+a;IB71?]:W-fgH>E&KME>Q]fNJef#<68TR);=,T)+)2
^K?4]KbDQX.Y.R?=cbIV#NR2T-;JW?d9gZG5P?VW4?b@;(d_YD1bJSJ/Y)07W0,=
MP[)&23MP[)<PgM>F2F)Y<L7HgaFSbS-D]5BabQ53[##JS96,A_P@>Y_f9G>+UK[
[9/U)B<(d+^S]X-\fZ@,]#8#^1S5[7=;eE.[3@O8\YFC=K.g;dH]#a>d:=57?-Y(
aQg48?G3c#=?Z^],.aMBOPXg(O6dP4<d#JW:bY?M6)8Sb[W(QQ0W<&N+cP\JKDRD
(78E\7b#fX8P=TO>?A1DLL-@P4dM]CI_N_L\F^b8TL9WbI^+Q3I]T=[3+9T&4XR5
C5[d:A8&@6,E(T[Z??YT>/4JYI3UB:8F3D)&UaN3#S^b,T<eAH5B.2[,((3KNYJF
)V>Va??SG5QX<+WUL4^[bOfUDNKcCZJdPS._K?Y_A/GaFW-BT7.+HE?X_0G8#.gH
LDSGT#Ma5RF2],OCH>3^b^V.=RVM24:U8(XIPSc352g=U,SQ,QbVIc?E#&d=V8=e
&T1->WW;c@IG)SHdST?7&(#Ng.R\)PZ904=T:f4\^L=];K@g/2E<+PDVI46aN5U2
-&17)JRCC1B-,@aJ7Rb-);VD70?T#GZ<&]TSF#]2I12^[Ub1Vg@N.[@R]/f+?][Q
+-K1T<C^1c]MGU88?Z<;P^.-/YC+X0ZV:cYd3;D=),(LVX[fda(>,2W.F\4R_8C\
:NS41fS][e(dOG<^;DS&cYVa>83&/SNdge13@<][a5[1PXK_)fK_@6DOF;:)\;gK
WUf)&5JVYMX7dQ0a<&OR-8@W:Hb[HS4#NKM<J^-UHAa36/\1SeUeWOda4D:MY26:
;V^)^/XU6Qa_S<N\\XUBD0K[)dO?aWCV)56a,+XY(LV#B(Y<<=Dd0b0=OD[XK8bM
CK0^H8WI]^bN:W@II@T3DMTE-b=U^]?/[U5X0P-)B_[TO;5F1Q?IFGK6\IC/PV4?
9YLKS,-)X)VJK\ZL]^A-P9#V8FG(VA[Y3B:U<M(FJaU\GTGOa?_Y>G?4R6J>O-e4
:/c5U5Y/A/ZCe>8CWH0E(TRX\0CW8@JL]];_#,RdG&TLYBS9NRM4E,EM,S5T7:WF
_Q_&UcQ=>g=X9P(H,Y2Q.X1RB2][8<#:JFXAPWNf=HUO6W_HAZR@E@AcU2TZ,DZ?
2X+N./TPa,-d[cgQPAbR](8FFMA._@fF8K>:>dZNc#?S:QaXOQd6<0.c1He=MOcG
H@?^6#)U-e6[:^FAeIH[bfg85a->L?UX2NOZX+F\W)D(;^DdGa?3fbL4TV\KSM2Q
3VPf?F)S8:-GR+;UUe5>82/I5_^eFgd)UFaUQM-d4<IB\c;JbPHNg_Y86e4fIR=T
\a&BHT4[.EM(5fAS)/SOWEd]-;+YCG5RM[/LNZc#1L22);D)N9<TH#O<9GbVK7VB
^Z=LOY^4&fd5GY2./2BV=F16KcbWO@F#fbC=A9XL?+X=fT:bH5PIQ3IWKeLFODd=
/QV6W]>\bWYJ9U&FdVfUFJC)M=cc;fbVQ]YT.b7cN&)E^G9cN.J=a_aD,IH&ca\R
M]FS17<Q#EHO3eTPZ?6E+=6TTPcf^Q7/J:\gG:;_+5-;)f8U1V,a0T\[&SZ4d.0#
B@T@b#./>Yb5+,5JT^=XFTH][J#WVJHO(8_G0RY<^(_1eG^-XN3JQV7UMERF##8f
0;-;M._06W^GNI:1\R&dcC(;e(DYO->+5YbR2Q==\>_[:[Q(#YNF:@=&\9)Z,:4&
V&1ScYI:@7eX>H^Z/\c-H)TVPb=MT<DEIYO<cRLM#B/VHD6Mf0.E,U:aY6U?5[J6
>7f0>&P^K;,/7YIQN>N2UF&B@-R/MV4V&GQC.HSZb(KCW)=M6>S^T4SUJCQPZ_(8
Y09Lb0+@&L&3CQUOGaU^NREMX&]f\WOUUM2R;P/NBd+/IJIeD[e3ECc[P(QegA+/
42C,-JY<HLJWW,Z0VJ(UID9R3&W,>CMJ=05ZDI?&cXd[U9GQ-,Q<G0>]=9U1)=:#
UU<0XfI/HZF-EV:VNf7Dbcf?fL?HC[eZBF:8BRS[gM2[W00LX/&Fb67KIgfSD;WW
B/)?5X_Qg_F8Dd84W/-;\2>X2Z>G44QIgae_KBZ6YK,.,[XCNEa)\U10DQf#X_C[
L9K0dccaD4L0=gC<_#7]+.OSfFTc#bdPX3W1)X@S(SJSJ#G=KQ[@Q9,S^U)1MPbT
+^ePSg9N?gF>\eXY25fYF[WW25.,IGF8;N]I5,VBd-cKRTE3#PYW8;JEEG1/LU27
X+:CHbbRDO18GM)d>LB\,HQ#QX48(:8)4@(YL6-PWfG^C&g#E_78J)P])Te:NE&9
OQ>T3,.]A\ULO=Yag(A9P1d<>Gb\)#.D#gKEK1DgRFA[)=-JUW.&R3<NY6YI1-7_
g4ZFaBcN2^G4J]LFQ7;c/ea.=bE=IY,/:4<BN)RbD/H5M]]LNI)Ab;943)1CDBBX
<R:D_U(PaP/g59V&cYX/4EPSFC-RPAc67R+H_CDQJ-T1UGMG3H_JVfVDJ&6D\)KI
ZD6aC<U,PbdcX@ag7F5#XJ5PCcHEU2a>AHXY_Q_]TS;6(I#TBW^7PY/]\8Oa&8)O
,BZ29_cB\Lb;134[DgWC.G??XZ+JLgR/EES/QOE6)P,F)6W14?]baPRbS&Q(2QBA
9;VIKEG4/fbIQBG>I8g:1#)cLfT\LF>]4MIXd,/+Z4DL5O)2#-aT7F&,1WfaD1b,
KZI,XGF2+f?F1XL-JN=fBg+bLcRfZO16=JC:@[4D60MZFBgTU4FZFbCXA_75(aV&
OW=]3Y>+f[_N>@CgV+UNgbc]QK5?KIL/M0BD[cQ>N6Y:e0CVE=T8dS2/5FH)fDcN
3QDB#SCS2Ie3L]AVR_5B#0a)Q;c5UWUcW&0Sb-=-VMG:B$
`endprotected


`endif // GUARD_SVT_PATTERN_SV
