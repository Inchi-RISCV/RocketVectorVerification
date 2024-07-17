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

`ifndef GUARD_SVT_COMPOUND_PATTERN_DATA_SV
`define GUARD_SVT_COMPOUND_PATTERN_DATA_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * Data object for storing an set of name/value pairs.
 */
class svt_compound_pattern_data extends svt_pattern_data;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** The compound set of pattern data. */
  svt_pattern_data compound_contents[$];

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_compound_pattern_data class.
   *
   * @param name The pattern data name.
   *
   * @param value The pattern data value.
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
  extern function new(string name, bit [1023:0] value, int array_ix = 0, int positive_match = 1, svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF, string owner = "",
                      display_control_enum display_control = REL_DISP, how_enum display_how = REF, how_enum ownership_how = DEEP);

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Method to add a pattern data instance to the compound pattern data instance.
   *
   * @param pd The pattern data instance to be added.
   */
  extern virtual function void add_pattern_data(svt_pattern_data pd);

  // ---------------------------------------------------------------------------
  /**
   * Method to add multiple pattern data instances to the compound pattern data instance.
   *
   * @param pdq Queue of pattern data instances to be added.
   */
  extern virtual function void add_multiple_pattern_data(svt_pattern_data pdq[$]);

  // ---------------------------------------------------------------------------
  /**
   * Method to delate a pattern data instance, or all pattern data instances, from
   * the compound pattern data instance.
   *
   * @param pd The pattern data instance to be deleted. If null, deletes all pattern
   * data instances.
   */
  extern virtual function void delete_pattern_data(svt_pattern_data pd = null);

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
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a real. Only valid if the field is of type REAL.
   *
   * @param array_ix Index into value array.
   *
   * @return The real value.
   */
  extern virtual function real get_real_array_val(int array_ix);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a realtime. Only valid if the field is of type REALTIME.
   *
   * @param array_ix Index into value array.
   *
   * @return The realtime value.
   */
  extern virtual function realtime get_realtime_array_val(int array_ix);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a string. Only valid if the field is of type STRING.
   *
   * @param array_ix Index into value array.
   *
   * @return The string value.
   */
  extern virtual function string get_string_array_val(int array_ix);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a bit vector. Valid for fields which are not of
   * type OBJECT or GRAPHIC.
   *
   * @param array_ix Index into value array.
   *
   * @return The bit vector value.
   */
  extern virtual function bit [1023:0] get_any_array_val(int array_ix);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a real field value. Only valid if the field is of type REAL.
   *
   * @param array_ix Index into value array.
   * @param value The real value.
   */
  extern virtual function void set_real_array_val(int array_ix, real value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a realtime field value. Only valid if the field is of type REALTIME.
   *
   * @param array_ix Index into value array.
   * @param value The realtime value.
   */
  extern virtual function void set_realtime_array_val(int array_ix, realtime value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a string field value. Only valid if the field is of type STRING.
   *
   * @param array_ix Index into value array.
   * @param value The string value.
   */
  extern virtual function void set_string_array_val(int array_ix, string value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a field value using a bit vector. Only valid if the fields which are not of
   * type OBJECT or GRAPHIC.
   *
   * @param array_ix Index into value array.
   * @param value The bit vector value.
   */
  extern virtual function void set_any_array_val(int array_ix, bit [1023:0] value);
  
  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
d.aBL;MR,UZe3@#GRF,.2ADa:\^34SD#IYgFc\28@0,Ad#(4#BEg2(@68c^:L(7V
;P8UR([I,H.5?.]cX&+B-B#6R,ZV#F&3?E7XNT3S]B8.LbN2c-(2Y42O?bb[<9GS
49,GT\I9QV-U]Y=7[LA),U=b<a#5RR(NQFUH-,VM_<IOLW/;J+].Qf\9&V/)/13E
:O<:\@,1/cMdHPJ]:8XdAS-1P2AC.I^41bf95WYKN^b40O<;[Jb77-R[f2VKaHEN
QedPAdX<FT]N#SN4WGLWL\DJFaAYQa@aXOZ60^GWO7:KDIN@:,OXZ.\>=:&GL?Bb
F]=EC=L,E2>2LKM([#8J]cHADC2VY/@2.4SdJZ3ASNR]--TI+M5^3H^gHegO#;L2
1PEg(D:8KfdXW,GOC[Lef&]:#<+:gF?I#0+?UR>+&a2@Rb^HM7?\LQ9GR.Ia1O^[
HfMT?dGV@@gK#XbE/]_H<(I()QfAOS8I)f;RL@2bMG\@NH[+MD@<;&8HY_EP?Rb<
=]J+HeK;);fN/I8]ZUBP>0;5B(URD.:9GcRdZ=EKL;CX4e]=42REcDcOJD8P1Q-H
4JL/(7[.gHg[@TZ>3+[\3#-.^gVW-/f,NAY(,;cTTQVG3PZ@/HSaPHc\@#>P(>2^
=(GIgOBL/+B9Y[/?1OO\:?aBC9\&)TLNc5^bd<+XUSRV5=L](?K8_,\XYM&PHaEe
65H-M[8_c77UORNQGHE].AW:3cS3e;,Q2BBI>(S#)?P@ePIE,]Kg<UV81C)OZCg1
agd0e<4#@Hf8TB.(Z6dFE1SF]00_IaY-V?V=LC3/d?&GSA<T5\U5Xg8#0@5P?50C
6IP_3\/8^@GO8\?KfJ=:V9(J@GQ.J7[10fZ=OTd1@4D-fX3SFWaX^</[-a/9OOG-
ELCTAO-#;78fZg5=O^4NP>RIR+(E]HQCE/U?>_2Gd3aO,Xc@IY)D?VA]>Xc;#Ea+
cY_(eZEcP/]L[)&ZM=Z+@?;F)3#bB>&X\#RCKH&4_^Qf=_f[&.DEY5]:FD/B?@Ra
UWZ/FabTECKR?OWU?=#]],NI9CF@9-4OI&XNC+LM[IfD;9GU.+Za--<-@GEHU8.F
ETPJ)W#K@,1^fK=0@dHKNNd=,=9,UY<#QEU6ac1</bW.L.N_L/d<W_?GH@d[2?^.
H-C9-JC3.T8::7aH==9^2;&RF=K&JPXHEP#;&)UUWaFS;ff8>PY7F3VD_#F3A@QB
0DXSd</\Q_7VcMW+VZ10YTgUB&Q<I]+1T1Q.fLF>OGg7??:2;+;RF+0M?)KKU;/f
G5cQ/QNE,D4:4U7V1\VM;4=)2+3OA+^2>MQ(4N+,:G<cY<Y#1QNYZc5.G:,QZ6?-
eCE2Z71GPDI0aE;fYXY-eA3);bYX&8)?[;.0F9e9&LV7>:YC8cLAfX24^?8N^&U<
\RKLDa?.cJS)7\a>/9-KN>=7KQ]0<IR[M&N()9)O33^0aVId9M2D/Q_G?g+YM3+I
?;V6^8FZTgLQNMMI=HC&GI\A7NRcIf.&B.-F12Y<K>3a>^NC8\9W@dbfW11,F?_@
FL@A(>,>:1Zdg2eLUR#7IUWU:Q<Qa(Z:_KKD&F<4CcILc)7^1QWA0@U1FN@J:UgA
[?<@.b#LG?V@Sc,3_.68G3U(?H0)-;N83JM]3@IY\M<&I51P#<7ea=^J)O;U)CIb
Ee(fI<)(f?C8+<GR2^:JVW8e2OJRZBU,N80ee/]#A\Z:a\S:&^55ggLNX9;dV^e&
V#]g-DO2EF/,cXWE@TEUa[]W3<V8QBbO(I766V_WWD-J\VBMI+^&0U2C+ANML+)T
1M1#L]1(]9c8YL::E1,dHAM8@cSQRB=Lg3Z.L_DN\F(RfZ=6#,F6I_]2NF8X:5CX
F,?&XQTA#OOJM;@3[\&@d.8Zc_]7S\C/)8V()EB<WP+1H<1Hdf=4>B>J#(K8YfG+
bVV2KYMWa>TXZ.c_\,O@SCDZUG?+,EGK/\2\UX5D)F[:.?K1DP[4MdP<H8>Gf]dZ
d[;\16^L^2gB[IfI\a-ff9gYY@=I=-[.[ZXX3CGd5_[C##4&FF+E@F0IV)6LKZG5
STJ^IK(;O_4ZZ9TYV6dDYG5^4.ZCFf9+bDc8F:Q)IQ#>0167NdVH>>_,UaF4WV]D
C4P@/>OTB?RgWZUAcTgCY):&.8gM86DM-145PYdL2dVH5Sef[QcHK+1@(,2HLSc-
2-/c1(Q4cSb52+@dYA&fPMbdg7BR_KcU8]\CA/<\2]ge:_X?;:Le9TZ:W+D]5=cf
eJ#/KdE>GU_U(P];&3fN6<PJLE3Tb#@b90YRX8#^,YNdDOVID>fNC6C:g_Q:9CJZ
U+WXF91Q8G;N5]:,N6^X&X=^\G;^]J>)?7##O^MagNSN3]28fQY=?IG>adAYR+V2
\g[LQFe4(&TcRHIH>bCeU,6J_M]GeBbcJQLZ+SW?H+,=5L@bJeG708=;,90/?Sf_
d1/<][K970QeGg7SfNTLQ92cEXD3GeY+Bc@-V2>=YSg\LgD1ecb)&SVf0VJVT4-B
1_N6QM)d,)>KKBbS1WQED3UXUU7)OCJG\,Og(+T8KAFM?)]?-I2/ZEN</0#:>^.<
)fdBO4P\#-&+?[_ERdC2aHKA9R+@:Z6P48SAYU3>/0OYYHOe.VW_c4ae]#dV14A9
<Efa8DYD(dABe=1@J=b13U4=MMe_7Da\J#;1+SA;\A^TPC2E:EaZ:3BLX=#^WM7I
2\;N6db[3T2X\e#?GJN<_5BBQaB)=a/@d&WCHBK7N5A;3U/))-5MIXLM(D.P0H/b
3SGg&7W8>Ub&IB7U4;K7gXGQ1Y0?<C)@W^8W,CO+QKC([Q;CdOgBTAO?C/(;S##M
^IYY@1C@TR48YTN4CTAfASJ3f[F-29&@U@OI0>)3/LFT23)RM2cE>8]+_C26B<GT
a\PO[ZFccb#S:@DD>=XJOcg/d@>c5MGeGR;:_A3GI9TKSXB)(1>JQEZ[@T8fWOM,
1a0<+fB;T@CQe9dBGU\Sc.JV\a;,^/@F,7LSGI4CZ(>?9H_dD?:W),fL_RIc+@QR
f7AgG1=VOCf<U9WXP?#0a#C,YZ0_X569af[.0MWO>F8e&GB4,#d.]:eTZEeQ[KCb
?2/,MRK#_QV^b+L8WV3PbYV2Sb),3X[4^@,S]=MQFXMUcfC:D8;c]-1LBcb/0fMM
f:JA(^<YcP:<8f\a<_JH7+#/?7fT83G3>XR\G5=17=&>cJ-&B-[BJ#[IPH>?][6U
aXJ?7&_XP_:J6MCSRI_T&R7/7e#M@\#2#C\TcIQS\bT@Pb/c:de7,KQF(RR1&d28
bF]cW]b+N:X4O:E#F8@[080N6L3>GR0@=eF\RH.?)3;1&T7bTR:;[U7HG[1M]F^L
7;T&\[5(WLG9SS77K>FN[F/K7#T<.UaA?R4O6VJJ6#a_]?FQ5O#.(<<S]I6Z/\1+
5MF_BWM5D8,?E.8#_4=[8g]+B6T6MR&,0;BVg1FNG_#X@+JH[C<8IbE?UfIFNJ_;
FM(VVU+ZBgg3LB_/M56,deI[,Z#5X<@M3-B^?WXCJ1WPS<aMePe]][UdH2UX0I0-
TI6Q=0Z]Qf&B<_6?:S380]2228H^gA?S]56@:S&ILOBFXSVVb>K4DWFM>+],\VA\
a&#I.T9A)_<H5F\/66=B2-\_-,JH?\P,GLJ_Wf?<LS<gKF>=.e;[#f7f?2FA3RQ[
T\7K4@F,^D)LYJ&bWb8<ea4C4?FKUX-6YZ)/6faA_0A>S^^M_GQaY;/K3GR1(DJH
KSa?AO<L]TRB(R8VZ>+Y,_3f9D8HTCI?D-ZBFR7C1\g+e?RWW[)e6B@+I/:<Z5Wb
7M,=X\Q[-c99Of11+O1M_Z7H28K(eMH8.HIE68g7>[N5f1d)Id=JU&S[104MS)M>
,7IeK0EVEAMeYaMdB>;/<=[XD>Q<Tbb0L<4:SXR:D/EW40[SY=M7:IeNUUVdg:5C
?Rg2Y:14V-AY^W1-CCDCGLPJ>9Z,M:6E^>e<-Le<>Afa&W@@#eQ?ROOY)ZBbgM@B
B_MK<a9(<9)Q8&)=L#7TX267be45FLC25<FTN4LUe#N=UVYKY,B/f,eE,WB&T4c+
BbCbCF5-KV,<QUOS2g?R#P&U/;-VGab^9-5-H8]13D#:I7&MWU][[7J,&g]&-DaB
@-J]\5gT_O<OUW)#L.If3(>2--)\R\B=[DX.+<M?PMF;B61123N^]U.2(@O\(EOS
9GaQeGRU&d@DS8O>PSO(54?g=M\=Q(9E:041FLGaXGdT9/8R.ZAU.RV>#(\Q)49D
+3G;8G[a#X5[?P8E;ZE@Te4DSS@A.=O0=I&&2U;V\@UJD7[FaLfGeCMS>8?E>>T(
OI>GSS2G/Ia61Ye>XK/2NC[e@ML8bS=gg9^966-1EOGBfH3?P23K@R1KNP)ee(?A
#T?S;dPgG_(=6DcM^U<6:TE7HE=Y.?LM]0KUSL<e[=cAefVYcdEfQQB7,4D?MIO[
MH_#O-A5RO.CgG)2W]]f]a2ECWLFaD&-#PeaXU7>Y4f^<?C10[0;>:OI<e/#DC^d
T[O;+D/;G6K7D\#EQ63<A;ITB96CJ\A8XDTA87M&2L9JWT>e8?K)-@]g(:]NY;_;
,^Z]1d-2H1K-5JGd2R8JYHc/:c>bCXaa#d[]PF5-.ZW>eaONb^E@Jf6\c\L5C>87
LIR,a?S9-5g^DN>I.]7HgM>TV_V_4B\)Gb9]H;ET1YL9[bH8-75AQB/8H[T8.bLV
(V-O]MDN,Mg:BQ4RT2Z4Bf6[Ea]:?H[R<3<5)BGa;H^N8#0Fb8-_)+8[Q7VeS34^
AE24H/D9UcB>-@1QJDOMY&SXYaDTa&Q7:+X2A9(<G=/XMG?/BKE:2CP2),WA969]
JFKMX/1@D0W&WeN11G#CTgW<@9=7W;Z^U[(JF7<H0(1/=E+6.e3XYSZ75BVg.>N?
C]6K9>O><g&Y(3C]B._ECOg@U[0&WdP@Jb5M(f5NHGb31KEO+W#17Q^&7V\g;?3P
f(XP(79+JZeTcVKE.,S(PPJ5B\;DLOd?\.F7_K421YT?REMbO;Y^C7A9W1=^Jf8K
,(^1cW=b\VB4G\UPZE<-VT<2IBRXQ3=Zf=RSNET3cB>\3?.3Me7(@.aB).Wc<?[;
]6c<]T8Y&LSMR?dD<TEVKX,\P)9g@/GSB6HJRa>G5M1?V@(6c#L[6RcKg:(d2SP8
M(3M#0=&G;E4PS(P0V4OTc6EL@g_UQ5.<(H1BOG+_7b]L4,GAd<e=YXc7900HV_(
HOFD&d\R#76UWHF92)b6?3&2Y[>Qb;=dE1P8caa\f.3]?=+W1_&@X0.ICa@R3KO.
.Xb=A/)7e[,cRcI/44G+OT)JI6:VOA(>;B23P^-O@(I<F5\^RgAG8MWO7IZ5VRUU
e4(:++N.0+?+065BGE-MSYcQV@M.=>.3ePS)I\gBCe58X?6c-C#I@K8JIA]deUJ_
CTMM]@M]<1(cNWY:Z]@KBSMd&CIfRF(8Lb4U1EI:-?8-gC,5=:6^F/2dKIRYQHMB
?1OT&f_R.L=CB=\.MDL9ZS&=@NMW-?M9+;0eXK&J>-N,gd>C#.[F-53KPT#D,\DS
(DLLG<+E.].3(D;G);HM5Cg3ZP1;,P(fYC\IP<#8YB-cV-8=6)?7CB-^=#DJS5Ld
Q]O?EO:[Z5/<e/L5>^>=dQ>+Q)MfO<9,E?e9(?M7)MDWHUK&1UQJfgD4RC+bA:K.
/@=[K6MHMS;c-X-Tgf&NESXGYYgeV4@efK:1(AH#R3U]NcBDH7M>/d1]Ba2<+>gH
JDH6-<.\NLP=O;CS\Y7WRa=WXB@K3K<8g?&27O]OP4]DFdU>58BQ^BV=(-eI#^Q=
S8R.OG.,88+,_fJ9X,@8]/g>H[[6\&+dHgJ)A?[IELd].d3KOF):Z27e.3[^2bG5
Q^^eJJeE[\D(8E[3]e/Z84HJ(#?PS.C3)U@V?B<7fb]6Z>OeFC3,4Q(LJ7-L:)U[
<T?g,d>(3U\BO@:Z5NL6TYI6]C[]HL3_(.&H?d7BN@I+@g(I=3XIea.-bPR1=3_g
H[4Xec.Bd+&6<X=/-P[be+=FW7Z[a14\B8e)3W@;>fe@]d+ZOe1dR,S@5=0FL@GY
(eMfcc&8:W-CFPWJ)X00@O0SWK.ENRZdL9(J[ZB<-L30PQCA+D011L;e:27SC57e
UV/IYXd^)TP+]&Y(X@T1@d8#FdaNC];+VeHg(=O,X/X72G:HDCZ/N0?fEFK.8=2b
016A^P4U?1f__6CQ-9\U3f;J/KZQ<XQZ4IW6=A[P3[L0OG(6O)73U8M-&8gG+J2G
\4?UDR=S\VLLCSGZ[K#&SD3OD36QbJcGW6@AB#cMTTe6RPMc48]_LN5Ib]cdLbVL
R(fX<K-465a#S7f_+LcG35N=&.BXA#,8Ug&PP&XEW]@91WaCY0)eN_E[1.T^M6R-
KC837JEg4JP_SGX&>P_#I;eLTgARWYEWcV;QMQF+#J&BU&]([Xc5W#/1VSQ3WXfD
<<a@4?b48aX;&.2400;-0^JaS:ZPUa:9gJDc9)&S4JcaNJZCQ/LDESV:UcI+>-_Q
,5+E(@Ga\FWPL+YQZ0AO>NESX>]>0;>_R;HP9KI:DL[6]W#6XKNGfXEG?g.MVF?L
A;,UO6V,^0RP[MK#&QDW\C3BP4.a@4=[]Y4V.U>P?B<(GfY[b=;;N\;1SQJA7U6/
._Cae,USHDbIB#@Q.[[AR6ZS;E(C)3[8(OI9f9TN];Za:1Qgf6MM4J5:[OA2ZJ^.
?H9W\R]bbN[VJ?eZM1fB#1WOL-cJIbT@#Z8PA_FJa/\Ka:g=W^cLDEbM5)6d6:>O
NcU1+@,N<3+XR2F^8@VW1)(1Og.IAK0L@&O#/M4G/LD2+]R0(3VTE2LHd;KFH:3U
)YC.47D-A;K,THB_dGJN^f9Qff&HB78WJB7Da)AYZYCTBg,=EcQ@G);8;)_E1Ugf
4)PP4WLOAeVSL^2)\\4&0>+E5=8#Z)VI<<C-F:[Ce<GB=8::fgAfKdZ8??K9&,HQ
f3&M&56H,>PS4_DM<B^K:#=C^GOJ_201,)W7Y<c66RMeI?/CgbA7Hbe,32JR&,7J
3/MBL\,E3F?S@LHHL&]_)6PUG6]//[Nc(2cH7RPPT^VIQ<Sf/7^a-f1Z]4D2RTVb
YFX^I,3U,d2/^1-)b2e=&W4\>/>+&08K[3\dJGKS_4EE_P^?^[Qb+-S/-+LEVMLW
2:(GU&O1NG+-eO.N&B=<gQ,+83c-/1R)M0(AE/bFA[>]RH2XZ]X]D.F(&=f,ES97
<=XVe8+Z/JXSIfVZ[T8F/EbU[,-R7\2(Q?#X18I/)491=9Z+?^1OOY;-?0^e4b20
,^\.?:4&@O]]-_1e[GM=Ua5PA5SMOGAaM7^:PHG2baM-2GV?c9+S_fPLdF38ZPd0
CGd5;X7HS\Q.-KfXaRHVVNggD:/?/EP;S]252]f?=?RaUU&)==\fM._]aRI:6XZ]
TH/6d5,f-GE:,M\D>_S&eec(Q1H&a,,KL3WLGK_996CgMTC[5LD9ML)G)V>SLI3.
+fa\S_fgU0cfeQ]P,K5P?QOH1@..G8]B>V1>RZ&CdC0.(&/TS1GXVb;UU50c1eUA
e[Y7CGKeG2g_L6eE&=c&\)/K@,+gS)<CX,UaJH3::^JA:]O(2R&HIb-S.Z2/&(Fa
@7[PYDGfgV4+;g@>\.:]Je4e,I93-Y7\E9I]32^Xa5EE0R+R>3H.\KVe/[XKETgC
.f_MZFGH907bL^2-a/&6M>_SVRZT(5_LJ1S,H1Qc>[Y@)=M-Re(9B<+Uf?3PY2_W
IT=f:D^g_D1#C;GI81@A.DL/]XBc@E_N\PD,QMEG(Q.WOeZ-O:+0ETCSQF_U>9,6
43>5/9D(c;OI1EV/8<9JJQC7cLF4,.G9H^K.JOKKMZ9_=1?1::]:7VCEAW]?f#7[
[^HNOW\e-3[&8+<L1[I.d0&A2(G#YEG?2MVcd5[#-fXX?N+_b5P>Zb^3)XMSND_S
IAAEA^7\R<9D[??25R-LT<V@^K2U;#<55bYXeHa&eaQVLcM;Q^C2Y&-\H+e5D[ZZ
Y7LIJ:C6dI>MNMM@OWYcL1Gd+]YI2Kb-[4^B3?]9b\59G1Ac):SX7BU[R28M4f#3
8SM87W3FK=]JN_1g<#D0D+=XM7&[g)Y1R@[Dd9&4C?IC?V<4)VgO:OHL(TP9;@OE
PO=WCZYG2^-J.8.K/5O0;=e8SC6N4V0WF^B=\ILHZbScL1bZ6_N4IM8WLd_fe3>e
9)2AeF_Z#e77ZcWQ[3F=da6KY2YSe@/R99=3-QD6dMC4#Y74FX+5)TDLLEg7\-2H
B#LUPYVeS,Z)<.c&RP\4ZTdNdbI>XTf@5_W@f/?B7GQH43=JAB550M0cJgA7+_KB
FG]d,g[<d5#Z3^>&NK<cC7-fPYf>JS#J?DgS[Mba7ZSeF_8Xg?8A-ZG[.a)?+OUT
&_U>9dL8&^;>UUONQMGMT]g>OTb1TeE?H,O;E?NIVRQZUINZO6[+Z#Y+E[L-2;H1
BC^=Fe:APL22J9ZVT_UAC49&\ODP9X<OA4eQLE/6SI9D.[J0W4>/-2Q1[3MKUCI<
AR(R6bE?Ua4b]KMf[\e@aI06J3F4KWA(aFJ0g^/XBR#:D/C/=(VB)3?W<PFG#\A#
>=32#MD]):G5Db7bE2Q=UVf69)N[:R?FTaIVRTb6RI<DDd-[6^gO1>G&W+37+KZ.
]H#N/&-G:(EG0Y^/(,S&adQ,#3O.=\X9@UfBU3^5JQUJKZY4Z6,0]d=c<N[ZX31g
W5D.a@9Hc)J+]^7^]93U&DYbEbXI^<1E[Y&[;TIJd7FG]I6\3[<_-\0D7TU@;\9,
T_K0c)b=OP/ddZX9>)0#;0_HODZE,,OQIbfaA^c4P;^0=F0-g61#UPPd4gaNPJfS
BKa([eUc/SCZC79ATN[.J\LS8=_ER,Pc)J0)[\J#W\7+9L&T+HPS-&YADUOWC9;.
9dJ(Z.HWc6DB7e-S^Ad:#3aGE8M..SNcUA<5IX2>??NM3eg:C@+d/Y=?B)[C,44L
e#.H]7g^[PTCK+F:YbPd@Q/)91-?2^0,D/,dA;])G9=/QJc-]A4(7?IcTGKX6N<M
6gc@)I<cC4OdTgN</#7A/DEdJJAIJ<H>LS&cJ)9^eK/^O_fPYeD-:dL)P+3EU.SD
e-1W]7(S0B+@F1>@L2<46B13f)S19g3ML/UL+Q5EOHYgb6A484#MDb\cd1E;G>Rb
O6JTF8EBT#(_X35@N,gELNb#7BV>a?2M@2=53J&_2N;A+Hg.Z2I4^g2+4=W=d5-8
##ZE<.:G3;f9c62)W<35A6MbL#&f2:SA]JP&>4O3,aD=PfK=CEVMD1FFR&D;DBZb
>[G^e?5QbWC@7;M,eO<5:.-S[<-WgI0/M&^;I.,1=-Bb.JB6f+GDL)9[,)3W+=M5
^4G;F?(X03Vb7>S:4UP3T7H8WR)N8:e.([NG,3P[ea2[D9^;e:fH_UDG@Z-K<I6K
3GeL@=4TVZ9(;+R:/W+N>H/,9M2@S2=^9Q#g5HcM<,^9Dd?6DK,L=:NH<1):d]+O
Z/FH>W3a4-B_.8C=]K-be0bDFMQd<62dSWO;_]:O7-OL.:SP,aY[LV]:KG;@HA9S
Q(32;ZWN-0V+P0HS#3,)4>+CFb5/9DPRCT?G]&8cWF]#@^b;bf5,7O02YaM&A/0D
&E9=;:8P0>#+WPBF4_DCF,eC>b=8(\.ga]cVD7V7(a^#HAMN41E3WBAQ^MJJ+S<9
@IgX?U]AK0O+QL82IJ@]+XYJY7+PRB_K22[D805TdHU7@WO8C8e>M#0G:&>L_\Ff
G](g:WT.cV852bN;F;S-X(TRb+&E#=KGY1.<8a>D;#2ZB.P0LAN&5Pe[(HD.RPXO
R47XW#\06Ze3)&2\aX@#^61-Q-.G,eLS@(54>d<M3+eaR^XN,EU6\_=#geZZF0RZ
T>=Z;,<c>=^T<VA]KSF&>;.dN>a/)Jg#Gb6JQQ7=@2+gDBKL[AKKT_&TdZ+LMFFM
eZ0K)&,[Ec->)C^[[+P;a57ZJ#<^NEH2&d-aPSK@>:>P=@&80)?-.e]MBQBf-eN.
4G-#-?R[]aF@cLdMURS/fVaJQWZg@XI(VX78O3R:;#@aSRJE[RWHQfaZa/a0YG8]
3\L#1G.@(Fc[AE#/?U8EJ\19=P4P4[[WB,dMT_GT4M^d->/UVSHNSCCgOdOOe?#0
OA9WeCCP&639ZW37AZ#_fE,)d)Qg/J:&gEB/BIcRCBLX=K(8bG59C?CgK$
`endprotected


`endif // GUARD_SVT_COMPOUND_PATTERN_DATA_SV
