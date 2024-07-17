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

`ifndef GUARD_SVT_LOG_FORMAT_SV
`define GUARD_SVT_LOG_FORMAT_SV

//svt_vcs_lic_vip_protect
`protected
\<0@?67R6,6W^Q2DVCMVG96EaFUEO)RE)5Y5P\_Y)V+J0FF02?LT-(g=BYAa4GR0
RJET-&d<26b06(IOE/J5OLVf/QbE>V1T&5-HML^@K_W,3gB&6/Z.PT5WY4cY0O8)
VBYP_fd+]YU.AG@[P4&:L@4cIT5IU/b^E-VI6:&[bAB:+WN1ZUU4C6]9XU(=?BD[
Mf^H[8FO5-F5SQ@9db6]RY(8+OU_98#g_/JPV6GCJ#^JVa&):^G:(dAadO5>JP??
e65NM;(bd#>G=PM30)DQIUGe#TUD-N?BM#DL/N,P=[V:S)fV:@,5bOM,&5B]A[eP
CWVNN[39F3>SM@JAYC_WN?E#B:\IFDMLcWDH@-JNH-+YA,_[:1+<REB[X/\aNU9O
+K[5ZX1?1AX@We9Qeg&d);=]OG?#8:=V4X.gI=eSNZE-8<M@BPef[/[(P(2W39O>
/9^=>/QEY6+K2V^WbdbYSfAR3JFaF73=9&)&a0C8_)c[E=?;C=@916S7L8^IC4A1
fb^E:.;c2O)H]VQBGc)1/fKXCN,0K<SY#VJS:3[cCJO-6DGTKVP>>aET82ZL,_Z7
d&L=8WV=&TSe_Q1_aRS>9/-:Sa>cWc&7(:;-b[[#XO(OYV5)E-;g49E5RE359TTH
(]6YL5MR0M6fT^P6PP=J[b<V/#@L/XgD6d0L#\X#TY.W,:&F37DW8=a:)SX@O)94
NU.S+g3&KgcPc3:)>LXfZdbf,6LS2HF?QDEG[#2T66<(/]=GNRVL>1,P9E2;)F<<
0UM9Q.-I-][#-9WNVV.A/4d_RUJ[YEM:4&65C&a27OXNF_Jc-F198GD&Q[7DB2TU
Ge_TcAA6FN..5\+3VAGD\O\:Zb_IaD,OK1;1ZW/+Ca\_TDX43GM^]@SVGL].<N7g
(MOV(dB)7=<]D38MO6D8.Wc-0-M1;#+O0@Dc)]<R)YZ#Je/&OUO_:1>F]759T??V
JLR^,_)50:#Y17TJ28[04L4?TBMLC5>\g:-:Q0T,S_Y7[71)8I,=#]g5WAKU;<8W
g#TF#1<R5&>,4XHeB4Kf1L>\>+fHMb-B#PL3^S)IN1C,6W8WZW>2:/J)1TKA-#T[
(J8\HZTEY[Z,(306K3R\2D:[62JH(,-/fWXKcGC<g>e0geC>)F\8Y<e543ZbAFdD
aZdNWJPb#JgFf:-eDg/,N;6-RRROM=S2R+gfE+c(E(>U?[V]C6E.Df?:S4_dSR_8
3^.Q8Jg\<Z:BWJE^4^,_NM6-3$
`endprotected


// =============================================================================
// DECLARATIONS & IMPLEMENTATIONS: svt_log_format class
/**
 * This class extension is used by the verification environment to modify the
 * VMM log message format and to add expected error and warning capability to
 * the Pass or Fail calculation.
 * 
 * The message format difference relative to the default vmm_log format is that
 * the first element of each message is the timestamp, which is prefixed by the
 * '@' character. In addition, this modified format supports the ability for the
 * user to choose between the (default) two-line message format, and a
 * single-line message format (which of course results in longer lines. If
 * +single_line_msgs=1 is used on the command line, the custom single-line
 * message format will be used.
 * 
 * There are four accessor methods added to this class to set and get the number
 * of expected errors and warnings. These values, expected_err_cnt and
 * expected_warn_cnt, are used by expected_pass_or_fail() and pass_or_fail()
 * in calculating the Pass or Fail results.
 *
 * The class provides the ability to initialize the expected_err_cnt
 * and expected_warn_cnt values from the command line, via plusargs.
 *
 * If +expected_err_cnt=n is specified on the command line for some integer
 * n, then the expected_err_cnt value is initialized to n. If +expected_warn_cnt=n
 * is specified on the command line for some integer n, then the expected_warn_cnt
 * value is initialized to n.
 *
 * The class also provides an automated mechanism for watching the vmm_log error
 * count and initiating simulator exit if a client specified unexpected_err_cnt_max
 * is exceeded. Note that if used this feature supercedes the vmm
 * stop_after_n_errors feature.
 *
 * The class provides the ability to initialize the unexpected_err_cnt_max
 * value from the command line via plusargs. If +unexpected_err_cnt_max=n is
 * specified on the command line for some integer n, then the
 * +unexpected_err_cnt_max=n value is initialized to n.
 */
class svt_log_format extends vmm_log_format;

  /** Maximum number of 'allowed' fatals for test to still report "Passed". */
  protected int expected_fatal_cnt = 0;

  /** Maximum number of 'allowed' errors for test to still report "Passed". */
  protected int expected_err_cnt = 0;

  /** Maximum number of 'allowed' warnings for test to still report "Passed". */
  protected int expected_warn_cnt = 0;

  /** Maximum number of 'unexpected' errors to be allowed before exit. */
  protected int unexpected_err_cnt_max = 10;

  /** vmm_log that is used by the check_err_cnt_exceeded() method to recognize an error failure. */
  protected vmm_log log = null;

  /**
   * Event to indicate that the expected_err_count has been exceeded and
   * that the simulation should exit. Only supported if watch_expected_err_cnt
   * enabled in the constructor.
   */
  event expected_err_cnt_exceeded;

  // --------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_log_format class.
   *
   */
  extern function new();

  // --------------------------------------------------------------------------
  /**
   * Enables watch of error counts by the svt_log_format instance. Once enabled,
   * class will produce expected_err_cnt_exceeded event if number of errors
   * exceeds (expected_err_cnt + unexpected_err_cnt_max).
   *
   * When this feature is enabled it also bumps up the VMM stop_after_n_errs
   * value to avoid conflicts between the VMM automated exit and this automated
   * exit.
   *
   * @param log vmm_log used by the svt_log_format class to watch the error
   * counts.
   * @param unexpected_err_cnt_max Number of "unexpected" errors that should result
   * in the triggering of the expected_err_cnt_exceeded event. If set to -1 this
   * defers to the current unexpected_err_cnt_max setting, 
   */
  extern virtual function void enable_err_cnt_watch(vmm_log log, int unexpected_err_cnt_max = -1);

  // --------------------------------------------------------------------------
  /**
   * This virtual method is overloaded in this class extension to apply
   * a different format (versus the default format used by vmm_log)
   * to the first line of an output message.
   */
  extern virtual function string format_msg(string name,
                                            string inst,
                                            string msg_typ,
                                            string severity,
`ifdef VMM_LOG_FORMAT_FILE_LINE
                                            string fname,
                                            int    line,
`endif
                                            ref string lines[$]);

  // --------------------------------------------------------------------------
  /**
   * This virtual method is overloaded in this class extension to apply
   * a different format (versus the default format used by vmm_log)
   * to continuation lines of an output message.
   */
  extern virtual function string continue_msg(string name,
                                              string inst,
                                              string msg_typ,
                                              string severity,
`ifdef VMM_LOG_FORMAT_FILE_LINE
                                              string fname,
                                              int    line,
`endif
                                              ref string lines[$]) ;

  // ---------------------------------------------------------------------------
  /**
   * Method used to check whether this message will cause the number of errors
   * to exceed (expected_err_cnt + unexpected_err_cnt_max) has been exceeded.
   * If log != null and this sum has been exceeded the expected_err_cnt_exceeded
   * event is triggered. A client env, subenv, etc., can catch the event to
   * implement an orderly simulation exit.
   */
  extern virtual function void check_err_cnt_exceeded(string severity);

  // ---------------------------------------------------------------------------
  /**
   * This utility method is provided to make it easy to find out out the
   * current pass/fail situation relative to the 'expected' errors and
   * warnings.
   * @return Indicates pass (1) or fail (0) status of the call.
   */
  extern virtual function bit expected_pass_or_fail(int fatals, int errors, int warnings);

  // ---------------------------------------------------------------------------
  /**
   * This virtual method is extended to add the 'expected' error and warning
   * counts into account in Pass or Fail calculations.
   */
  extern virtual function string pass_or_fail(bit    pass,
                                      string name,
                                      string inst,
                                      int    fatals,
                                      int    errors,
                                      int    warnings,
                                      int    dem_errs,
                                      int    dem_warns);

  // ---------------------------------------------------------------------------
  /** Increments the expected error count by the number passed in. */
  extern function void incr_expected_fatal_cnt(int num = 1);

  // ---------------------------------------------------------------------------
  /** Increments the expected error count by the number passed in. */
  extern function void incr_expected_err_cnt(int num = 1);

  // ---------------------------------------------------------------------------
  /** Increments the expected warning count by the number passed in. */
  extern function void incr_expected_warn_cnt(int num = 1);

  // ---------------------------------------------------------------------------
  /** Sets the unexpected error count maximum to new_max. */
  extern function void set_unexpected_err_cnt_max(int new_max);

  // ---------------------------------------------------------------------------
  /** Returns the current expected fatal count (can only be 0 or 1). */
  extern function int get_expected_fatal_cnt();

  // ---------------------------------------------------------------------------
  /** Returns the current expected error count. */
  extern function int get_expected_err_cnt();

  // ---------------------------------------------------------------------------
  /** Returns the current expected warning count. */
  extern function int get_expected_warn_cnt();

  // ---------------------------------------------------------------------------
  /** Returns the current unexpected error count maximum. */
  extern function int get_unexpected_err_cnt_max();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
NF\;Z5GFY1-6(+2.2\^G[2M<Ub4R[-IQHA:+9;YT9CT[?N].3).Y3(dA<gW7HEb\
R/DII<S7_Ue+7N#MC21Y/6-H_]IR&H3PI_e\XMJ#.A#_[)e8#R3)K.UY9HV>bV,e
96:[@5(W8QT>d+c:;9)LRCLGae>MORgJN7&B3g5=a)GAdV=KKIXH4;@dAAMS46D;
-^[6Kg8:4PJ=JRIL2O)4W\KQF\QM4Mf\N743]0\RCa(a^W)H1D:D?FRP>DCd?+E>
@G[1ZU5;29-.VP^DOH=VHX:cR)BgMZ6M5)UWVK-2[V4/3&a6KDeFeKJ0Xb,^YUC?
d1eZ5?&55EH:,HIO8AC<e;J@TQ;DO]Q;[]TR/0)X,a8TfJBe#.#eIBd+U^MCK75I
6UgDW=#44B:I(.PeEOGD2WE>9XZ^e#bBNJ.&T^07YI#]JYJ@V&5(bQ#?E>R:_U64
7P>d=H@PAB.UTe.8X[b-QL,:X[TZ(8V]e^L>9NWC),_fe8fO2>2,ZGU&DA1SK.,.
#PE;cF,<,]&V_HIT-&8c[P_X,;/VFVQ0#Y&g,LV9dgc:NHVN1\-DLQ1Ucg?(fBcC
KC\eV;8Z=c&BIQ;Y=aO3W4Ge#X@Y9g31E_^faLa1><GHSH94TgCA=L6+@9]5J]TJ
A-+X>dMSM\7KTPg?E436ZHL#CLQ;ad-0JaSc-:L(dFXYa<IXPK(E:7]N_c1M<d<N
?g/0PH/[G#E&=38f9PZBM,cK3QDUBf58fFa;Z8FWa)a14,JIN0Ib=+6a:),(J&e9
+[f,OeJ_b3_TN[2P+HM.eZH^/1&QgB#07P=bgg]6NG[-f50g#C[6VNN/,E0g3X-F
247(CgG[2gW836R-W4_eA2>S]8gI=0]f/MPWR:NKX_/Mc.2Z?f/?3V.TS.@N=HE4
&FUBZ9+1SWWEV0&H4VaYE.G??Q?Sb2@VWUUQ4HFYCc7RO.)\Kc+?H.IATTPO8HbX
CIa01LDA1MPg+5Ff/TW76A(;g>LO)UQRbR2A)aCN=Z#,aQ)dS3])#.H[U_=aP[H[
#?+IB1FNg_.KV2FcLefcFMF,@\/La3URI+GKO-dT>GNHD40J<7gdZTaa&4VW,Q.J
_XA>(KF_>XQ[-Dg(PYD=NRW7A;NYL3gXH)A2)./F>P&VTQN8O-SX1-Sd;FPH3<3c
=[\6&W+O3)YY-?(fJ09QPAf@bcGe\b?HcIgX<I-Pg\QWcXd<D2S+8E4?f#)gL>TK
JVB0^3J-/Z[[C@bQ(?[(EaIL[8AX]0VDZ3P6YV93\#.@K]SOCAc]>.+eW[fY?8AM
g[d?Ef2ONZAISCRKY_O\X7)6b,S+W=N[(&4R#-@(f\RAe8fTT)WbFNIfJ]+>,6<c
_(7\b^f?;NPa.LZ36>+=f.#FLVBf_>f8Z4f(DWSaa0U/Z#=AQUaDX2--+FP;O(.3
c=^FRD#:(D72]\>@)WRPFDJ5IGIH5[&N;2YZ5.)(C1WL,Y&>Q=c_gZR]DJAUDMbc
S8UE5g]8Odbe<;g]7[^BbBFTaPDJc\TDP,aF;;R-I0&\?UY,eAcR#HUae1KS-;;R
1T:X>A-1+VYMW=?D&<3>,gYIf-=:-UQJTE98e0E2edU>@AH5Q5[BEO1E:CYCGV8Q
3fV_)D7\7#CDS24OXI.A.H,K[D:b4=DgI1PeET^.V>SKOYJ>@M?T2fAE#_L2[^\B
MUECSP5Pa[TbF#?dTHf?W5#eZ,U_>+K?BUXJ&a+^4L66V+[ZSJ1)FX,c=dMR3M^<
PF6(7:5J:NY3cQ[bYQ0J(?db#g(4gD[XGY2=5]GTOX:H@26=>I36?/C)D5M7F[(S
:A)YN&<gP@@03A4P?IZV4)D1^\_Q#X2aOPNO]DYa21aW7?9=gBRAG:aD4Cb0<.AY
M140a(N^c2OO>RD:2&<X.I6DIB=A,TY)Z#+E;)Rf&g23egQ6BKGfH]IOKOQ)@e=V
Ve?GH4NDU@I]U)gLQZWLAZN9\Q^N+(32Ya=M_A?G7QPcH+c_R_TL&L^LA8H](:8>
bMB\fAF1Z3U.g-fI4KBL):b21b&(.7]6RWSK3\:?8F&6#U<aI:&FP)1PI/[9MB#f
B1HGNKR13:J2-G&Y5DgZ0R2#]GQSE5K0NJ=)T()41JY>PH.<a65;^LTL&ceGf_1O
-34e1AWd8g)fW,32bBL)C_QU855Z?E89_CO]F_Ia:95E\E@V=R(F4df1dD.Kfb>Q
)OdN:&)Y1?=-:]4AY9If0>/&&)UgV)3K(3+3[1O)_aaHY^eUaQ.?A:cY@E2\@H/V
?_N702@E[,QCIXFUW5GNS=c.N<6NM>>PR(A^&JZ/F9)[dI:V+UAaNd^+\=>X6+4^
VdO/=[Q2@;F6G-2&FeL/P;^e31=\@?UbcZCIB=gZNQ\JK=]3)(;F#WWF_aF)M33I
,-2?bMd+#]R(Y;-B#fCYWBSf5200R/K2TJZ4+=aeY<&WEU[VH,C/VeYC6YI2WZ>&
.HKG;0;NX?>Tb[5fcV(CH^Y<T0?;cIDMF1g#dVPFc9VY7_1PXE1ZEB:NS0(#69G=
QFECS+J7E.C9]366U>]9+c\fNaR7YFE.,_+.Z1#]^?Z#T_\)W4<.(&@\R2DFP:Q:
Cg4&dXG9<dK[-E;RF4O#)O7>2V4MVK51_KU\W(6?3>,gFJ@,1dQBTg.Xf[[#6Q)a
e.TU;dQ\I[\1Re<ODOccUYW:_55G+9B/Wb6f.aRU5491\OX8.0(#ffBdE&K2A\#+
4H&L6bI.e:KE;O0UU-N84aWdX=RZ4FMLK.d=P=HWR(5fbO9F>QKALQ4X(WTf16XS
Ba1c((^AVB:3f.BZE=(\NN8ZZNND7(NCUgQC/)2J(?/TZ?Z:2+RDO-?#/[aHGD&+
W0]>4OF-L?TXAL,VP#,a0C(?MK&Y_YXO6fLO<Mg=GQN&K#W354U,HSRW=4GC>)23
L>:O2M3dJ4Y><MIT6U/-ZWL\5/@^0/4<YPP<<\)L.4,f@_[\c&eQg]5HaJgW4O,8
Ud.g5G+29IH#_JG@F&d6GGE];]<Z<\Nb?C4)=/dD/4&d[TH(=[6@^\\<ID;EK.6P
QaG^2RJg^bFa=Jf=g_ZLCUE#/-+HXX0F^,faG5L^CTc@,d@T&-7[[f@_/WH,GNP(
3JPS:2G7cK.0_BG^0D<eSOg#&1_/+XZaJ.(C8OIMX:ReHQB6[PcYC?(2;9K8EdZ_
];K;].4JAM(Q_OLGLbM&ee?;IRCfd=3dKI/1CT(4)O,>\d#JF328^#GaC_g##D/3
:+1S]CFA11<;:g^1M7^CY]Q;F)E/#+/5:.U)>@^2)(@Y?\K@#\2W(YO@&38b2H#-
Ke^NRANeGG+5J#IQR5V5.D=(D4^bb3X1IPZ[-RAUAONC)_3KY>B\;O02-OM;STLU
JO#OA2WU,-?T&c;<8E(Vf[PK7.+E+1(0NUIYW.-(JX7>ZTgQ\&/7AR?/ggXY@L,L
ceNB7Q_?LdJ8(S7D&8bJIV:gKA:4-CD6H@FeY.V1a^=8K?B(.8)0FV32:_\<:+:(
AGOg2L_[#F4<GPNUPb]OAPHZ4bLR19-:O)00H6;)(;1]254JO.BDM6CCBM_9Z+@Q
Y2QMJYUTA91g=G3,X@BA(\M+c7V558,Yf[\JA#>AbKLQg\<ReJNKTYYce@P3RZ8g
]^gD5CCgOC^7934;Y(0&SYBAa3W;A2+Y:M_/V0V9^.PJF0Hd::)9fFCZ>5(9R\Y2
KV3OLFeA/e_7(M-DJ?ga.D])3NPVMLE<c8e[MQag6H39aGP@W5.K=c)\NOB#)F)1
I^.bHH(X7P8];<-d7<e>8<e(<X+U.KXH5J^OXa50,S]<?MW(2fd-.NY6c,N4F6F0
LEM-]_b7ee4QS0M1Z4+@?73VYBf^6-a7)>[7Ya,-ERT40@9R.dUR>ME:]\RUSWJ?
TS:AZ6Jg,,ZaS,M5fMJTD5bI^ES\K<L9Ze@>0eegGC.eQUc.Y;9.&YQbSWORf(4X
<=(4SI8^Q4KACR@P1(FW/X+#FBB2H;6H-7[JJ<[#[1<de-&6,DU.:CZ@d)Ff7KBX
#2J#^7fLL##<4Xbgf&ZPWeg3MSXA86a9Q?KUTN[]+>K8AFRTG[eeU&3#.b,&CK_+
4K<CQ/EUZ_CKEVAf04/bV-RE_C/UUf1VZ,]J&J/C(1)^=^IaIHHYbS1gS&NQ[/)\
9@5(TWB3aY1BOJUeFg.T5gC?/,I0/9W^NggQDcd\)=>2WT1aP/I?.]]WB>.bPR=(
=<I_(5UJTY;)MLCW#^(-d6=aOD\X._3,(VHY^1&YWS]H<d-&5?.H>f\Fb&/IZgN,
e-\\ccMJ,_>POMe)5c>(UdC.?g5&We#,fW8I=GS5=ZYF@.M;,_:KbLAa6]4TaQ@^
Ac_5dBD3,6R=gJEZ7]abd-1]T]V/M2dH5PT,TV]Z?_cM]-ef1F]Og60-MbQA@f1:
Q;^^8?WCU[#O((e/C#.>Yg)QR-J?#1TdU:H1C62TGIF(2U/fPQ\B@[;[VN#XHU<>
PLa=U<>3GPA>XXDP\[)H(=TP:-A;S)/\#3:9Ve>EDf#=@H:c=;1GeHX>Y#.f:(8=
AJ--(6D8>g&9)0UE6WPg]E3=J,MQU>_H\)JXW+NMDN(SDSWX@.W7;#TIYaC^0(XT
N23+3LT9]57d9+5Sc]J7<RV#Q3eH&Of1N-KGC2dYL\]b.VP@,]#1K3FB3]OeRb_4
MRQBRWF132RQ0B]<Da;Y??[=gVXOM;<c8K,e7^R1d_c/g8T^UfRM/,/:L6[AGa.H
ETEDX^UFaFK.Z9H-&dH5?A\V/e1e(_52L3#7g20\6B3a9H:DfN@=2f,@-^LPV2QM
;bLQf2:NOJ2-cNQL)eM_<U#WaS?_QB:QF)+6ePPLVCYT3[[QU,0G.Z0IS:W;fHW.
#@4X)3EZ+)4__e6+<0>BZ-&L/1..BY6K3>GK+LX&.eB53\\+>,/VQSC<&6]C#24[
>CMYcCC6;TEW3[<8Wa:_<a:+)815W74+-C)9Me-Oe?=a_#XYPZN)SU2O;;[P6XL.
6=8^-9L32Pe?a[+CT<:_PM4:@?:BIJUVILJEC>?)2)MI>.PMM>X<FSBX)4d?C5ag
.P+gV(1OE4VJ/LG8g]7OCL(QHVREBFSFZ,-K;3gbb:]Y\)YGEL64L9dd2?D930-@
R=g(fP(,\E<1eYaaFAb9^N?Sfe3KDH6<#&EH,dBW35(ORHaK<KOTGAUd2PIG5/O[
]H90(c6.WK>5,D^8JQ1fU5D594TXNMDf:d^UZT(W2-\=<++2cJ,@?73F;LT6[WLJ
]]1HK\TdF0X622dP/+#aY>6&66F8IT-U?bGFQ.a95CCCE-P5Q^cF(LMbM_e,;3LB
.M/8F7@&?aPAIfacf;N.HYY./H82>XcPCR+0.7L_a#-\>?UaU29@+LIG=NgE9ce8
#LdAO76ODDQV.5[^XdDI0T<g=T1bJ#Qg0@Y.Vd?=TH\+=MQMQ#A8?(FYBNWS:J^g
\e2,LeE)8C9E28[]+?g-@69F_)7WX._f(3WT>O.?H]AXNL4bIPDH]2,,dG+/D:-b
Ef3Z&7aCBaE3];T0d-+3EETNOS/:;=ENJVfD.)[NgQ^F.7L_>:1477UcV5R\1VBO
_B/XYaQ+5.VC\=:.UD+6#ZP3a72a?;7([?73H_P,Qf3:C=P1Z[QSZ)bJ&[)XX);^
G;(=MFJ\HK2X,,gF3+R19),PMSN._,@IO^9fScP.>3#N<acYcY92Q-BS9Xg0T9NB
-F+\DGSV2[ZGIDFDAZZPSg()9TM=+[Y<[,c7Q-:G;VP(](7e7-\JM2R1eC=(HFU,
:cdgb/d1U4BP/QDOZ6G58JYDdQW6Z5^I^@Q4VV&U;cSTSbZ?d]J_PC,48::UYG(8
[A(X_A.0<,d+G&.c]T^NXG4WZ6eH/1Z]2:CC]9.QI0[-YWP-GV>Xc7c_WYf[X8\;
Ne]&eG?F+46Y7J#-/>eBE47A<7^=J)V:Q<3WY5+SFOVJXHQ?T2;>CgXN@<W39)DC
f2KG45/c[>(=TI22/;Y.+Z2^.05L]c2I)OHR20@B/WX2L\&7-/=UNd/_LG(LSaF@
0f[0KMCDD)GO(H0](d.N<E(^HJ<gdBGK0\O&beSIS0R5D.\.>NU5=7.,Idc\UU\4
191Jc-)45=d,1ZOBa+0Lc3KcAJadbAM;.^&SP:e_;,XE)?2F4P4:#-fC[(@A;e,7
[>E^?c-,UR#T7H2aBW0gT(AHA\VM<]V.@QAfQ9(-HG;\b++d&<[/:@-D:X6GJRL)
V48IA8:MFbbLE]Ec4cdBY/(H>J/[:;^NF0I5/J9b#)Z@:DI7].(F(bMTD]\5#]4>
0c)3g@0M,X^/A3)03F:#aDU:D-VI9,W225_^P>XAeI\N_73M3\?JI^1WNX1N_^U(
,e4.NgAQK\Sg/@2QI,GIFS\@+)fH;H\]a&DIQKXP,0CY?WGfD=,WZd:]7Y7KJQ#]
=6>4aO&=bZBU0.PBPI^MUKF/^W4]9<0Z>R)U&O2DK6aHK;?bXe1,a,BCW;8&;XBN
3cLC(4OT:)O:J@3[bG?dJ6,@ZL3dQ#)B&BFK;39I680Hf5GF;,5d25>]F:.PN<OC
QJX69FNU\7d5#?>e29e/M\L@SEO\:K;&0BTAS0.<^\OV1YMU1];6HL:#2RNI48E1
9dg1;]VJ\VeEd6^>.H9M\W?#,UGcGg=)I\=XBI#B;]N]P^.LRb=[DbP)=).M6+MI
QN^E\<L9C:U?_LaJM^[IJ,6cFIVU?b>9R2<?]7B;bTE8Z#21La_N]C?U:C#V/E/a
dUJ:@53)-C5DR3W21TCT&W?/,=b[Q>\Lc>Ca0>+C5.\F)>2OD/^L;^(1aXH6<8)E
<2?MRJ_=E0=?/cg)T4_K3[FR<:9P_(.\\fSWZb2ESeW+P>XNZHf44-cYJ>1V4L^J
0^9VW\1VV;-e2AUR7K\0N+P[LB4TUK0#:KbNZQE><C?b[:QK_f8;AF+J;8cO5MZd
KT@Ndc]ZgFf6VS:B#>eb:Y^0C5)>I,E:IS&LVe9WG:+9V<L[Q?Q^80Z_Q24BZXH2
;;PQf-I-LcF5<U9EGZG^e)0N_.6d,Q1B7V)WP&(A#&::Y68#@TX@2=;fS+]7E9OC
bJ(#KL^N\5OgSNHBM^UK/d5/b4IQ3Ie[c3:)#d\A,M@Kd-&4cRR;S]81f]KdA-#B
AJ]F6[TY@23a)M9PF6ETN\:QYWHY0+4AA8A2ecJ^[IJ<dgO<5C&W.32c6?&&O,[c
(UeCRO/NWgG1_>;FE]gQX+D6\.eU>OA/<3MDH4U>L8F<ZCJIDc+MYP\3\49J?T.\
K>VZT^<(Pg@4M\YE5U]eC3)-2GWU&)5+eA[aX^a6(A-+U1RU,]RGI?_C?B@5WD(/
]V:6\/RS5PZ5gX_E+?;O6_<J5Yg?F2BWZKB)6.WHK,D4d2a(B+S);[(=HMC:T^-Q
LA/32O]97B9C[MOWQ6Tc:0>,74&,0;)B7:>Q2YWVQ&P0XB5fc_5^KHP\2(MN=\,g
)+\b5Ad6;0K2J:?LfG<\>dfM(;S[EX+cg?AWL#([)AKF>T>)#G.BA&10Y.g\b_d&
H^364Y-N^OPbPR42.3=QPBfe;JB(H&_?[:6R>9Z#CgD16J5gH&CA_A6)2?)3Y,M\
^O)U+?,YYO@-SaA6_K1_:SAK[];1cF\,e=/8cB?d=/RU\I9OT\;VB9\D[gX/T5C4
&W(W@UYW=_)FKM5;aRHPCMcM-X)X7L\^KI-L0HI8d:?Q6.I^&M:Od-O=+^(=61d+
f_a1U\/cdY.)>,@L<_[#b?#]8a;X#?KR@M@_GHB<#-HgNgGLNOANLZ,^g5c)JS;e
\)&])SeM)BYSWTJ6)-K(R1D(,3ceB1P2_.XVE;R=G.fS/>^>C&ZOH<Se6PWd0P=@
N:9&C98cS^H=@SC[FG&,AQV_E,O1]MR@d]@b5afHeQQWH)7FJQGY>_GX3&UR8#]>
VO2@5^GME:edHAD72&2^3)aN:d.CSKHK1#&?g,:+e/FIK\-EeO5)JMKFE>gQU8>\
WgPH.ZV[bHG_65J>>U>Y(C^V(RGTgdH8IE_a\BNg.U>_bP6O,@=bLM\Mf[EP]0MD
c3eRT:gALWM]B(+P:@H5#7PW4&W7CU_TW9X#Ia)Z((ZVZXLIK-LO;3Y]=/2K7U^F
0\LA#.WQ#g?G2&55-HG)H>WEM;C\[Y<01KJFBc>ELCY_Rge7JXUQ?_D-Fc9->f(#
T/-3V/@.5]>FM#A[<:,b)H1dAX,)V_E<]BA8>0A9eQ>]RO2ANH[@6LT3684?=dSC
T9J9XEEf3e:4Q;U_3C,7LC[](:a3YeRX/\J]@#1#(&QJ+3&/LB8;.c5]X#OI]UX]
/#\-:-Fb@PF#W.a-4\GPfc+aEdN,VUYMI^N(ANND@TX;B_Y8=1HC;g4cXfEY9C_a
RM=>?4VGaVI/\^\V47I&CN^(gOe/+@L,>+(Y@_a<0aZ4Y>WU.GO:2WW7[QA-\6,B
cFG03e,3@#e.RVXTIM\I)0;b,]Aa/RZ4,+0J02HAe&/B;]9D#W.L@#5G>7>]fCb,
^aKPY-gBO-<5N[a]BD@6L3c9cHA2K3]N)RPH56gT&X9D5Pc:W5>^(N4/Y&2KM>/V
W>.?^KZ,RQZ,OXcZV@#E_?0TL)_C/7Y&3/]GH\0d(XHFJRg8^YVOBG];)VBbcb>=
AX6XO?f_MB7<)B2C>AE:HHI=E)6Z^+c/;1?L0/P6&:<U\D0D.a2<YIQ^;_9VN@@K
7+I461+aW7\&Md([<ONSde@U\]1\\7HO29&OeJUT::23=IQ.HeGMXO4:[e=+ZWN8
P@=;C0DNF/F;KfPdgI]2KQe=GcS:G(EE50Q>4?A:dY>d?R>_]Z2EfKXQ2b8FH[RK
^:-(ZH8G_G79N^eNNZdWED<09-2[Wf?M&Da?dfCX[/&Ia)/<ZR&Q/@LYD-e0(Le^
3>X/-T&MW7&U3><B7?e>\T,Z5U0.WdC:NP)>Gc-6=5D_eBJEfP\2O02CYYW-+bR.
<A1H9W1[[f=#=R8dVP:8N4J6J:>:/<;g58F49.WMb2P;.AL1J0dD51-g-dZZJ<.S
6^63-H^a\Jg.K[\,09+VT[99(M/4H3g.(e,X?ZgPO=GDc@Z7BfX&fUTN;_H)ZL#R
\BO;,Og@#S==d]+K]>EV,:[EFKOa(24+S6CTO.TJ.J/cHO<U__4_Xaeb/L;f#7a#
[:Xe]JObc1KNX7TK-L)CC9PIM#-QU)2Ug1AG4SGFZ7<N(UfNZHK9UT/.O?W0f5TQ
^X\H5K#7E(]6^eFE5[0I#:,;[MHDO\UA7f@HFO9Gb&TN/TETOgZPf(7)9TQ#7/]G
;_0J-P/]S1&=71MBb.#6^a\ML>8-D();F[OG:T3:)@NA-;<JO>5OJ:W+fR+GA>64
EB89V84L>T,>M@K\3YOTc_1F=bRAO:KMg)Pg7]e:E21NQ0?05=e1GTO?J0=(2f&K
O.-;;S8FRIE7\,_a6)<:,^bHdLT=NNJS#bEWX=9PB4X[bCI>d;Q/W)a\3G_TM:10
;K.X?DcQTcM@3B<?ecfKJ1bf^KSaH-0BfdQ-0:N3KcRD<fTW=Yfg]=LV>]JY)C7Y
X0&c=ae1+16=g?0B@Y+._V<5E50U+K75FdLV&&)Hd4:APNa#f8)T>GN_VE>CR(6B
SdB_GXZ03CMDN./aY-(/C5PY<:#SG\ZEO3dW\DAO>Bf.)GTW8;UNM;VgBW/af0-;
+R>;=bf^),A]><]F&#NVL#(J+^gJ<:/^[^86YSI?\@;WZYYbM7)c6SYM&MdJ-#1>
0U6SIVb(S:Q++9LY=D]bK]16AfBD[7S5gKP@/^8Q?)VEH/S<]d90CNadC)<W5K7R
g@RH#4>HLaMRAOLUX8XR8/Z8V;;CF)Q<Ed:a:7&CPA:^Oa:;:G9GP7g&1Lf:<J?;
:2cWED,A0;N#M.fU0aYYf9>8S\3\^Ee]R,AC7,K6I+1\FFf@((?K.d^=2ZIE>OUV
#^<:2W+4<9\@e,FN+:=T)JaC5KX)E5P:Q9aPJ)?@[N[32PZAQaJ_UP0JKIa:9ZMQ
_L=DYN<017&8)gJeC:[RNZ44K2_4f>-)K)LDDHBDd#UB2WCK[8K\+]_cT;6D,]>R
A3&/bb;FV1M21CU&S:O:1)-ACW@_Q#OL+RBK3<[D@BMDOV6F;<\KDV81J-C2+II(
]fDG96<EG2F<T9&KZ-4-#LK?a^0Pb@+bf,]HPe==5#LfIbBTCPI+@.F8/0C8[F;&
FPbS7^RN?>;KL+:WZ46e8@,I<MTE_QY/c]K\_<6UKR(1e<,Z6X]5AgCU1DG1NVQ,
[UODOg=+M(JN5M[)D7P3F(7P2^91U-8b(CUKTNAc7Mc0,4C=AV^VKa5-?:J\>dXf
a79\90PQ46.FZL^g&18VUFg]EG=_1_8b(B9eP[aQ4e-LfLWeE\8+U>_Y]IPX@Z9(
b\d0K1@FF^CI:.-YIJM_D);YF60\XbBI^F\75EWGI8Pg@:1c&=(f_ggJ<f6.LGKZ
]OXc;7K[WRK#54Z)7:0LaNBOC0Y2P7\E-DJ&+4KPaL5J5XZ0DTT1_C9E^SQ4@P;3
4#g7;Cc_TYG][c??<P2E;R6/3.-fW-BNVc5F2,QaO>M\WP@RTT,I&I5)T-Fg8\)4
L?cWKG/3P7ETZ3U7C@80(H7d[)Jc0C3-.#<E47b;g.D]/\#F6Y-BGU6+a&d+Xa50
4;S7WgMdN.\U6PIa@=LA8FL>_(#)6AcI&T0<Y\HNYe(SLG(V9.[/VXUMWSF((gU^
39>PG&WeZ^c&2@&g9JB=+gf9E8=ZNZ4^;87]OJTEPZ9+d_(\S9TeFO3&b?;:ETc:
\EX/:K.3B1bYFDU0/_LTd&.acFaJ=+SUMX[K.YI-gFO3:7gEfV2>aaT>CG6E-(-Z
Te;SbK\aCdL3+RCLT<L\QV:JT9\,\aIE60#6NCRCceG\W#G?HW(g#AX.O?;ZS-6]
6[<Sa^:VE4d7T4J&SF?&>D>C[O1JRVTT2<8>(0eQA3eTb];YN/]C;OOE&]TbNc3-
#dTP>)g/S4OEf>M?V?42[a&N.F0T0WW#UFfTf><W1>N5UXGc#>#cU[;WNM1IR7=+
2UNI@<,>:->Q@U\,;R;^I@\QHZ@S9B[ZPO0=[5E>-,3dd3:UU?7/4fdUX(-#)dKV
?AUeZRO:5\)4?[0;BDaJ=OOdH-cUWG3L^0]GSD>;&DF53PQZWK75.L8VB[D5+LK[
Z3^YNZ@aK::D>/f85<WCL/g4#C9W[:6+dbT:e#S[X8F8@\W(7BTOL\bMFOQ++L6b
=Q1aPg-)K#EX=E5\eO:4MLC(f,4fd0aSB,S&(4B6D=5()^HGEe:#<S6S0YZg79F/
d:#K+]@_Y6@ac,&SZSAeWBT0:STdB&>X7K)8R@M#PXE##7,3G-)JBOCD]#^D,bLS
b5OSG+/egF_;,PZC4NZP(S:O:E2(G9?9e8_E8g):ggWJaN:I=2EJ?D@Oe#=6UKB+
9:^#4.-^Fe^[BW4[b8M6PUM]f[+U:0/9(=06WcK^=K=J87?gGP;@-f;M]3(da&C<
R,GgNWTGQ_RX+J(c&Qa&a2ZJOFXV^AIG02b;=g@8If@CI&+e^0^(+]86,D+U.@FK
LSH8_0@?,N\b1-^fdQP^^Y[aDKY3Rd=B/bFGZ?8c1#NK0J(2L0?D#)5/6?4[&=JC
7SH#b=:=d=LX;F<85]&47IL/d7CSd9Z-IYO_AR\X[50:eS9&Zc=GEfcS9EDRKVc]
O>&bg?-8>g>N):X;^^D9G?L/2$
`endprotected


`endif // GUARD_SVT_LOG_FORMAT_SV
