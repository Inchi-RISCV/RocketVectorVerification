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

`ifndef GUARD_SVT_EXIT_TIMER_SV
`define GUARD_SVT_EXIT_TIMER_SV

//svt_vipdk_exclude
`ifndef SVT_VMM_TECHNOLOGY
  typedef class svt_voter;
`endif

//svt_vipdk_end_exclude
// =============================================================================
/**
 * This class is provides a timer which also acts as a consensus voter which
 * can force simulation exit when the timer value is reached.
 */
class svt_exit_timer extends svt_timer;

  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

  /**
   * Voter class registered with the consensus class that is passed into the
   * constructor.
   */
//svt_vipdk_exclude
`ifdef SVT_VMM_TECHNOLOGY
//svt_vipdk_end_exclude
  local vmm_voter voter;
//svt_vipdk_exclude
`else
  local svt_voter voter;
`endif
//svt_vipdk_end_exclude

  /**
   * Name associated with the timeout value. Used in message display.
   */
  local string timeout_name = "";

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Methods
  // ****************************************************************************

//svt_vipdk_exclude
`ifdef SVT_VMM_TECHNOLOGY
//svt_vipdk_end_exclude
  //----------------------------------------------------------------------------
  /**
   * Creates a new instance of this class.
   *
   * @param inst The name of the timer instance, for its logger.
   * @param timeout_name The name associated with the timeout value used with this timer.
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param voter Voter which the 'exit' is indicated to.
   * @param log An vmm_log object reference used to replace the default internal
   * logger.
   */
  extern function new(string suite_name, string inst, string timeout_name, svt_err_check check = null, vmm_voter voter, vmm_log log = null);
//svt_vipdk_exclude
`else
  /**
   * Creates a new instance of this class.
   *
   * @param inst The name of the timer instance, for its logger.
   * @param timeout_name The name associated with the timeout value used with this timer.
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param voter Voter which the 'exit' is indicated to.
   * @param reporter An component through which messages are routed
   */
  extern function new(string suite_name, string inst, string timeout_name, svt_err_check check = null, svt_voter voter, `SVT_XVM(report_object) reporter = null);
`endif
//svt_vipdk_end_exclude

  //----------------------------------------------------------------------------
  /**
   * Start the timer, setting up a timeout based on positive_fuse_value. If timer is
   * already active and allow_restart is 1 then the positive_fuse_value and
   * zero_is_infinite fields are used to update the state of the timer and then a
   * restart is initiated. If timer is already active and allow_restart is 0 then a
   * warning is generated and the timer is not restarted.
   * @param positive_fuse_value The timeout time, interpreted by the do_delay()
   * method.
   * @param reason String that describes the reason for the start, and which is used to
   * indicate the start reason in the start messages.
   * @param zero_is_infinite Indicates whether a positive_fuse_value of zero should
   * be interpreted as an immediate (0) or infinite (1) timeout request.
   * @param allow_restart When set to 1, allow a restart if the timer is already active.
   */
  extern virtual function void start_timer(real positive_fuse_value, string reason = "", bit zero_is_infinite = 1, bit allow_restart = 0);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
aDB[9DAJLBa&b0W/N:8PfG7@>3^2BL]94>AJO&QVL,T1:V#&@bI#2(<.[;N=bc-M
Tb?5\J_/^&U+<\HERe65<CM&@)N^]GY;gWHa,W7U+BBT\:(E?fR&P2]J#-C+Z3.,
(&;>OM,a[<WL@)J(IX]),X<GR>K3e3UbVNOC.L[)9>/:G_YGQS3OW@@(,ZED:ZO#
<BH3G5KG:8</MX/R?F.N)ZYVWFO;6EfNF^KS:ccN2aEH[NB2T-M;,Q_4Nb^c,_A\
S.]QPF95+^?e/a#<VIeV5SPROPY.TI9fR-J]O0LZAN,Yc1e&(HCg_>E7V;_6W+Ka
SG]Z5_;:J>RHf.,G2WA)M=Sb:Yg6@OU6T.eMB]4@<)cI_3_f3A+D+AF\A0.=Yg)Q
UN;HDX#^X4<\QB#-V?SR&)O>,_]AHa9D&f2fcS>HSVJJ6gH-R_f;HIFNU-1UTe[F
>,#DP8gP-_JeC4-OLMG2YY405R+4ZUNRCFHH<NP.aT_3PNH3fa<#Q,8L-K^BUPc#
P]JEY+^A5c\b821&fcWH)5LHH(g4R)H_ga,V+5?)DcN<Z:O:RF18LNA7-V-J?#FN
d/]Wa+g@&[MOS18XP/T>ba#b8^[Z4cI6A@31E^;bc5:C9Y.E@d.G+3W9+/5_A5<D
<ZK?/I^aA[_OF?^#[;^YW=fI.Q-TAeS+R3F6fXd22;ZQ.VSbWOc1_]R><TY8AF+8
aJVR@5\Z/0c6QeFe9F?PRY5M><D-EfCa0/E1[G@BN7B>->S[?:f(;V^PER?=XF+,
?(#8c#<a,N3^CSOJ>6:KC5J<W)aTaONI>e/G86fY@4+:W_W7[YG2X@NFffg0I]/K
QX/CY@B#,C2COEQ19;T>-TPe_]]=Xc1,;5[;DFa#ZJD=J_\KR/DW584<1J4g4P\M
<cY&NAXG@27T:07B-DF1NbC<IL1=gRPH=@Q7&9X+]39c2H((fU6a.a8?XMSQ_7Ve
P?3:ODR2,(8PNO<4WB:\[CIW;/f17KDIZTQ99b.7->dIL0L7S1EJUPPb]^TZ127+
STH^CFaD_YU05_dWS8/,;8IY\=1cd5ZLB#66D@)\OG4T7V4KL<.;aJPVVeJ@QUQ3
bZg;g@)MKD+X+2#3A&VV8>&fKP=YI9#e,46R&:;)Z1AJ,F)?C=e<R4W\?SKTF+>.
B<,//))R9]H##BL>7EP;KYT&-,^#2[CS&<#;2+1PUU@DF1=@I/\L#5#)HgTe++XC
_N/EDI#D4N=HE-OUgNB-DJ9M1L&JUZ2X/&9>EfZ]ObWMZB^[8VXX1?L-K=(+&(B)
G-\P(LPf:&GW5ca-g7fdO=S?>PK>)X:W6J[Y#Q@9?da_a=RL)_1OG;5b(C<,VgD^
0@Z39&cMX]2GeRg5<>HJ3957DJY?P1P_g,+V@747gS=?/f/Gb(a2c)9H1<4TVWH^
J&>O_C-R@K(G=4^GN/6g^2SN2+2,TQeN8UK,Y@Ze(RYRLe&I;[<U.TAacDV6dMBE
T7/25f6aC)50NaOD.:9)bE5A#5GYf(T:DN]a[Kb[<(#a]>McI_[e<\//Z);[X,Ne
B=1@f8R1?ae?,;JJbD(]0&)6b34(8F<S>\L1AH7&c#c.ULZdM[4bR^0,5[-/b.5=
R/88g16b932LKLdTL;>1(2aRH0,WNe_-gD?1[3J\Qa,H.3@/f0+F=V=e@K<B/H+>
O5[:MK>MK+T1?;aB6)[]C7Ib3S0?G&;91968K3fDd-I2IW4gaAV:82@H+dZEH33&
gR(aL_g2:I=TA43^-O<4888./MaD#:@d[3HQFb:U6X&3ObC?I_G2FC0?JKe23:I.
P7(MMRV.^1>Ge/X:,CCJd]++-R/<Ff[4,/=Obe^e+@LT+P5:Qd(?C9R&WT&fR8Q]
OT0dS8M=#.E\aP[3VQZR1T2WYGNUfcU10^Q1W0FP0LJQaYfF#:G4=O=-G-a5e8_U
0aSKG03E^([R>-e/AVY]_.cR2I/g(/3</:M4:V>5;&M2>bE@5^0PL&+,?]aKV^@e
GV(DIS6Z_2+.cV:BH^QKJ(,\7+^:>&F]W>OQfV;JRITYbA]FCNC)&NS9LUdDC^E?
5@F.?c9?9,6dOUT]^,_0W,R=::NJ;(TQ&bLc0UggaF,dXD9[X0<_TPY:c]XZYC^K
,LL>OF:#OLPO2<+DZ[-P/Ze9];[=bJ[,#H[e2[L>N=4]24eLE2fXUg,).R((@-,H
Hgfc5^&LaZf6/<-dVQ?I#QU=?]E??fT1EK<^.>NWPY;f-VEBdC<6)@8YT6c8\f4F
RP51WE_4,];=97eP@?TRZHHN_0aXc2K8@-5N\_)Q,(fS3Aa&_BW][1HO_G<X]Tf@
.dI&L,g&M^5&_Q8]P[?/?J-RJNHAOECY_1d)T3[CA&g4-I?0D+b\b\EKJ(OFX09e
4(A2F+9:M=TAaG7SJ\&dT;5D,OW5E@.=D<M0gac+)20GVb/FJa,&LUB4]&G+;LJH
W\:b)9:J?a6Z<g:]eW63EFfU5P.#G@57[<O2f=F:_4V8.6S1;:+06280cDH:9[-R
T5UQFX#D+N9.Q=e7=Ud[;/]?C,:RUB@[5A-FGcgbLQc6\(>OUY2?-gbdTcK/aS.1
eO/4+]gV&ZH,^TCQ4LRf,-0,)EF>ZXc3=FJK0@facX_WZ3&76>_f.94T&>1S&QPE
dYA@V:^:P)=V/VG9c6#4&7PS;]9AT6>FT[T8?@NIBF[C><^?TNfc#^UC+WGH68_@
002Z;bQ9I2OXX+-fOH8Z9(\,^D,&4G51BbTH^U>PVZ>L/UW96c,_6TN4.V_C;-?,
5&EcdN>]C.M34EV_I/Y1@,];IJ/<WBL\Md1#aUC&21CZ:H_g5V_735PG^+UTIZ_Z
V\]-cO2NQ3FK_I6,IY2STR8QeI&BHVMWM[K94Kg5=7_g:VECL:98KQ[D4cD;_ISf
.[TAI_aL((SU#V;dAG-cfE#+]TP)2HY&T(Y2f?10<OF/_VSYM#YHONV/I-W\gL>=
/ZRI;B.GGU#BU[XY4ARg=58E/beAfE#101QOZQYRP7O7PVK?_E[571Ze0B;]NGg&
S7[a<#fa+=&SQ\2?QGD8IcLJHe9),_FR0<&LQF0fA(OG2bXCINE5\^T;.TSF32f(
LJVJe_5JII4D&OXZ+@D0JL)6??7Zc@LT_6[UdS#MO3BWe1_2F<?ZZ;=57+AVML)R
aIeaD^,#c/U?OMI9X1+ZU-_IDDQA)cOd7M7R7K<^DJFF/WRV6XC:SF.0RJHGK0-P
R]=[X;&_?20[/A]X,_c]VI1^+K:eUe1L5&STg9GRXLSQ(^Vf4V0N58=d6^AM-076
9AS7:TU9N+]0IcN)X1cN>9,(:<?/MYUHE(]+2:(QD]C+2GG&19KST?bMVb(6BD8C
[0B)L&I>>]15SbL^a8_@afYLb1;-9YO)K3HH7.D9C?-CQ^eZO1[5gGDWgBLMDY,X
ZgPN&NdBAM55GX/9ab;<SK2,dg1QdCG<5HAV\G<Bf8=9@27Yc:YY8W[bdH7YVL7.
c[^1=/35Y+^:&UbJYSS-:ZVK&[^7c88CRg=HA-LWD_+W6/R3M3B(JY.Z?.:F=I\^
#I02?+ALMT6,ZYIV7ad2bU?U,^R[-M-1)BP^a4T)+NQECU;=:4Sa(C?.E1\@5(-\
V6>K5M_@3@MRdUD\3]&;f[1=,)VHfPZ0OZN85J<E#PG?72/6P-U7GZdVPA9bK\&\
<1@)6ed.F#BTH=_?N-d^FD_f8;YN3@9+J>NHA+d.deXg3&@[;)08)F?B+O<4OLT7
Y^MV86Z;4DgEN8DIdM;TI+L>/795FDd;AE;3OQ=:M1Kb\)J+A^H>3S(gfLI;AK;<
&0=?B:=\,T.S0gON,SVN-G;Y?dKT<-,UL6:>D<;\)@KbE$
`endprotected


`endif // GUARD_SVT_EXIT_TIMER_SV
