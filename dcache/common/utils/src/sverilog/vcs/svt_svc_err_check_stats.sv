//=======================================================================
// COPYRIGHT (C) 2016-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_SVC_ERR_CHECK_STATS_SV
`define GUARD_SVT_SVC_ERR_CHECK_STATS_SV

// =============================================================================
/**
 * Error Check Statistics Class extension for SVC interface 
 */
class svt_svc_err_check_stats extends svt_err_check_stats;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  /** Handle to associated svc_msg_mgr */
  svt_svc_message_manager svc_msg_mgr;

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_svc_err_check_stats)
`endif

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new svt_err_check_stats instance, passing the appropriate
   *             argument values to the svt_data parent class.
   *
   * @param suite_name Passed in by transactor, to identify the model suite.
   *
   * @param check_id_str Unique string identifier.
   *
   * @param group The group to which the check belongs.
   *
   * @param sub_group The sub-group to which the check belongs.
   *
   * @param description Text description of the check.
   *
   * @param reference (Optional) Text to reference protocol spec requirement
   *        associated with the check.
   *
   * @param default_fail_effect (Optional: Default = ERROR) Sets the default handling
   *        of a failed check.
   *
   * @param filter_after_count (Optional) Sets the number of fails before automatic
   *        filtering is applied.
   *
   * @param is_enabled (Optional) The default enabled setting for the check.
   */
  extern function new(string suite_name="", string check_id_str="",
                      string group="", string sub_group="", string description="",
                      string reference = "", svt_err_check_stats::fail_effect_enum default_fail_effect = svt_err_check_stats::ERROR,
                      int filter_after_count = 0, 
                      bit is_enabled = 1);

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_svc_err_check_stats)
  `svt_data_member_end(svt_svc_err_check_stats)

  // ---------------------------------------------------------------------------
  /** Returns a string giving the name of the class. */
  extern virtual function string get_class_name();

  // ---------------------------------------------------------------------------
  /**
   * Registers a PASSED check with this class. As long as the pass has not been
   * filtered, this method produces log output with information about the check,
   * and the fact that it has PASSED.
   *
   * @param override_pass_effect (Optional: Default=DEFAULT) Allows the pass
   *                             to be overridden for this particular pass.
   *                             Most values correspond to the corresponding message
   *                             levels. The exceptions are
   *                             - IGNORE - No message is generated.
   *                             - EXPECTED - The message is generated as verbose.
   *                             .    
   * @param filename Optional argument identifying the source file for the message.
   * @param line Optional argument identifying the source line number for the message. 
   */
  extern virtual function void register_pass(svt_err_check_stats::fail_effect_enum override_pass_effect = svt_err_check_stats::DEFAULT,
                                             string filename = "", int line = 0);
  
  // ---------------------------------------------------------------------------
  /**
   * Registers a FAILED check with this class.  As long as the failure has not 
   * been filtered, this method produces log output with information about the 
   * check, and the fact that it has FAILED, along with a message (if specified).
   *
   * @param message               (Optional) Additional output that will be 
   *                              printed along with the basic failure message.
   *
   * @param override_fail_effect  (Optional: Default=DEFAULT) Allows the failure
   *                              to be overridden for this particular failure.
   * @param filename Optional argument identifying the source file for the message.
   * @param line Optional argument identifying the source line number for the message. 
   */
  extern virtual function void register_fail(string message = "", 
                                             svt_err_check_stats::fail_effect_enum override_fail_effect = svt_err_check_stats::DEFAULT,
                                             string filename = "", int line = 0);
  // ---------------------------------------------------------------------------
  
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
bT:6DW(H[0=?>M&Hf]WTA1_W3DXg3T-Fb;,KeUV;7)E(,DJBeECC&(QVBgFE7TN<
VO9\bc]<)Sb7b@&G-f:1)b,D;I(c3f+_X(&#f65J0Q(7Oe6JDJ?^&CPEc[H69X@A
/UOG=.X3f2_E[5+]AL15)NE]E=0a-#)X[1#F);ggQ+0-XG-S1C_WJG?^G0;U::_:
3Q#AEX)J?4E&BT..QJ2H)43b+YR3-,9++>LGeMe>@IG,(W\,#(M..LB;IS-N\V\T
6;T>,,+Z)=d8Bf<1U>1?=MXLPW.;@(,_@NW^+J[.Tc9_/egf>b?=(:@4JTCG?fJ3
=)3[2+EPHOFOWA(6-Z..48J@IE[I+-BcTab/1]1VTfPBd83X@O,1f7.K.L?ffF6X
C]DT3@KA/=-?CD;#D59-\]UA?7d;YC47]8#ERBS,^WdJBQcK>X=KH/-EA5]H;e99
1^RR_+DB4=g/XQc[IBVG;>U@O7ZOW1b4#9-f#Q80.0Q7]e_>5Z<g4D(E.H@P:IZ?
F_[Sb^8McJ21?_aR(_;)_)8FV).VU)_:B:+A?gX8_F?G?aD-W1Gb@=bSX9<>bP7b
dCBP>d2V2/?0]F<R@J9/);fU&5LC3-OP0M^#g=^ZFNfSNYUWD^J5Ib)PgJFOeKX<
d&IdEL:)O?11]2&]YFY^VJVNXU8>Y3c=^;VAR:>@QFAcOK-Ub\Lc\@J)(A8;B7+W
fd)OLfO7[+,UgZ@NNB@(-MdB<J]8:3[0eaRcg+(S>&Q9baa4cU2(If\1?TT6<WK-
W4+RJ1Z34E5B12?@KSG8IC012c9WFf[]<^Q[;Ma8_fCU#41D#QPC]JCX#aB1@-fR
3.&AA+f&JHe@=_(g]?<VCJ?NG)P4b5abCYC-<NIM1.[>6:&R]:3]2.-&J8<6:eWE
OFUe_1:&T.\QT5Dae+]Y-7JQ)Y,CV=[2_1C.GP1()UI-a3KJ]R]:VfAJX1OSVT56
SLFROeGFIWaMN=6A9geWS2[./I:GeZ9KeG&_GM)P5A8S(_D-E7SI.&\0M^ND#@NZ
]?RFIXf:ggN7Od;1G/_RI4g;.?I>Q)gI.@AL?K55gQB2VN5_#LdA-,W7;.;Ug2VL
fWB7#Lf-J:N3#R5HbRG@Q@g;6-c19)3GCD<FF7>(ZIJ[dME(RXEYFPN<)ZNfg;.B
B-_9f_]Hdb+B=DZT?C7)@8.[:f#R?[:YNURX@(<STG,4ARGeS&V4NddV;&7&QCbQ
;#XeDMOgc-52/\&1=K-T-B^S5USE(,9G-c=0b+O9Q7aPWSCMX(6fL#MKNE>g?AL1
RT#MZ?:P#f?aN&4Q=^Vd6ZOVY#SePeeC5W9QNLWPHNI-36V2V^Z2QgDMAbU6gWTT
N-23UN.N^_cN8VgE53dF><8c+<)fHH#f)MS__b>)V?7JN1V<82I;P7UH9R^CBd.G
YZ?9:[IRTZK/a)LIa(VSbB,TZW([-^GbN3^@f>+/+#9\RIW#a/RB5LI^:^af#bRI
Fa\B7X_<0-9\,CZ7^OUFF[(a44^@AJDWP0]W>bGONBO/c;J=<.cULW)Y[D@BaD2\
<4082WI1Hb@-5?2aY^5=LKLS=G]6d-#&(8AOdWSI0dDcRJ>)W7F_[2LDb_.F],ee
O&,bSGPEfU<f-\G3,.OXJ7ec4.Y=g^aN:UPI5.?#)S;G,;+M3@@J[e8UO=\I&E7g
7D4H9Q<3Mf>GFB?W;2E,(,X+&JM^AaQHPM5:+1?UMK<^.914Q_<-+&KLBI4X98^N
6G)Md([JK(O4]Lb>Ug]FDVD@\(JT)@FP&:AP]30-D?XC]T,7/5>_9e1g\?[+?:bH
.@e)_4QJSZW5Dd&dJ,&/>GF/>Q7HMeB[GL?YI1?_0&L6dgPX[,1BQ/:Rg+bQI1@L
cBHQX3\eYfGKG\J4d#F439gPHCWQ6^V0K_4)OI8+FM)ZX0a>M7JUNg0S17[?XJ#B
JIX)EQe,=YJXdZ[MUPTR<+I6<e20QKJ8f8\XSBW@8-2YgC(]:PZ>dNY&-[MC)6H_
[HD)S2D(?\&/beebb,9ZHX0?cON[Z#H6)24Z/-56].MYd5J)GQ^SG7d6b-g,]S.\
4O:B#ZA7R^H^I@Y(JM>E)RB=Q4B(HQdI.;df83G3[f75<4,b;8ZG;IK4eOSEAK@5
]_CC((OIRQU3B/2MXQ7gP:K_X)^DOI3aG]B7\(X,#MNVK#?)=D@<faJ;?1OS)VG-
&D.),&:.E;/?5I,QV#M\cT&Kg,8-:O<0T[U]N)aMfXW_)Y#cCK_66b@T)\T?)XfP
80N<GM(e,^=D@8bgJ6@>EP?gY46P9-+7g9+CaA,-X#NAP\2[@Lf/))Y8)^GXe+CY
8S:0F5.YE0-=JH0LSS\7.gH&NcRE],MSee:(I3cS-]#N4c<)MOcW1CVE3<7UVN+H
00eNY4IDJcJ.#6,[66HXIKX].AAZL1A?BaT6X;R]]T]<_YAXZ1W4\:@6M8Z8\-35
1V+T;N8,_IPdE\QY2.([:4L)1F81UA[]3O-JI?4Z61C#ODY@/0F/3OJ1gP)D-7GQ
PD@S8#?^=0>Z[N413B+Z4>Je=d,7Z9_Q&ZLL_7HdQQ:S4DdcPIQP0@EEb9:aQJf/
3[W_<cN?7(\6,TJ&R-OGc]@5(+HF\SRRTP]HFRb]10L[75CEb6e&4+9)[U.CVXY^
=T6]PLK_KJ_4Q0)Id245bFA1cGSCOM4<H#(L1:5+YDW_g<88VHKURSgUR&Z_U=aP
5I]dN?dQ=TL8PMNFNX;E4NK>F(NEf=TE6,MVES&08P:LE1M+6D0RNYZLd4?I(AZ1
@K6&4_;CdR5TE[2H#a0;Z0KOfH\NWAANCd\LT0(7FG#+7R.FD3Kb&G+E:J5</)>D
YGZOROe>MZ<MfJ?P?9HRBV55WX^TJTVPe4TPVTH/Z+cH-aMYEBTB\:GHCQ@HMF?<
+N0a-/>bK(A->=--^3gGf<XJWbQ:=;-2X^0D0Y=3\U96U,7>PZcT8_ZJO>Z1[U-<
H90;EKSLZ[36G_L(B6>0\1L]1R5XH&HN8(ZE?-/:c#^<7Oca4/>T,<T&AHKF(6MV
Ja#e3g^S6@aSb@^7P@99<WL]5$
`endprotected


`endif // GUARD_SVT_SVC_ERR_CHECK_STATS_SV


