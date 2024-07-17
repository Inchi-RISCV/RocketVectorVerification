//=======================================================================
// COPYRIGHT (C) 2010-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_TRIGGERED_TIMER_SV
`define GUARD_SVT_TRIGGERED_TIMER_SV

// =============================================================================
/**
 * This class implements a timer which can be shared between processes, and
 * which does not need to be started or stopped from within permanent processes.
 * This timer is extended from svt_timer and otherwise implements the same
 * basic feature set as the svt_timer.
 */
class svt_triggered_timer extends svt_timer;

  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

  /**
   * Specifies fuse duration, as provided by most recent start_timer call.
   */
  local real trigger_positive_fuse_value = -1;

  /**
   * Indicates whether a fuse_length of zero should be interpreted as an immediate (0)
   * or infinite (1) timeout request, as provided by most recent start_timer call.
   */
  local bit trigger_zero_is_infinite = 1;

  /**
   * String that describes the reason for the start as provided by the most recent
   * start_timer call. Used to indicate the start reason in the start messages.
   */
  local string trigger_reason = "";

  /**
   * When set to 1, allow a restart if the timer is already active. Provided by
   * the most recent start_timer call.
   */
  local bit trigger_allow_restart = 0;

  /**
   * Notification event used to indicate that a start has been requested.
   */
  local event start_requested;

  /**
   * Notification event used to kill this instance.
   */
  local event kill_requested;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Creates a new instance of this class.
   *
   * @param inst The name of the timer instance, for its logger.
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param log An vmm_log object reference used to replace the default internal
   * logger.
   */
  extern function new(string suite_name, string inst, svt_err_check check = null, vmm_log log = null);
`else
  /**
   * Creates a new instance of this class.
   *
   * @param inst The name of the timer instance, for its logger.
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param reporter An component through which messages are routed
   */
  extern function new(string suite_name, string inst, svt_err_check check = null, `SVT_XVM(report_object) reporter = null);
`endif
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
  //----------------------------------------------------------------------------
  /**
   * Function to kill the timer. Insures that all of the internal processes are stopped.
   */
  extern virtual function void kill_timer();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
AWB[T&.gPfVU;cZ/FTd,E+0G;J526eXQN_V1RN,g,#IJRVLH\ZLD6(G-6^2&)b52
VdSPJFe^CE+2#1I53Y^7FEZBJ;K6-QH22M)>0T8@eBg+aBBWf.9b1G\a;ASf:c7T
EB0gFR_BKaXdL^AaZ4U.J>eWF2=@O0-3XE5B88JgPAcJ1JMM?#-XdE]U:<V#[1L&
5MJ2KVf@I7^e^6C8,HTbSe2:B#O&L<8bOMV1NeJK-L;DW:VJ,(=CI[fVX^RYMcGT
=D@2TFH(eA]V+WMP#-e0Lc#c9MJ4b_89/<;ZQa=[a@IZ17GKXOV&V=O[g9DZ/+L9
c(^cV#NZ?;QI.@Ug;+)Y.E-I(+fD<7Q&b,2T6QD^62g<EVR-#19^,\G72Rc&>;8e
6)_gK]L\-e1E/U,#K_0eLKT&eb+,FGRBQ9A9<4f8SZUB>ZV,_9Q7C\.T:f5IId5>
U=-(;,6,UP/2eKU5MC[Gb2\#UOb=(;I3IbgQ_C8X6V]VKa0RDO2L?]6b_:,N2)WB
2EM)3ONF<_;^_J2f0QT\Z<f[&MLEa7-A_aV?6bVd]g^]g5BSP\cVc/J8KbQUK;??
++?G^_#g\\#a=\66b1RfY7\8P9@NQCMA(Q_))=f#SE#LVe03F=&K7)N,VX\WC#:O
dP\,d)U<EJH/?A_OL.gJ91Q,2e98[#C-Af>ZKIM.&5.0T.G[1U=d-L#ONIKc<XeU
:A,=+MB_.+Y]ALc,CAg]Fcc^T@(6J+O,PRSJ>1d[JW?(R&<8BKDKd-KODOOEOf7[
ERf?2<9d/&3FSd14NON#]S6(R?MV8&JDg5aJ#&<=B,b4/4S=0LJV=/M1@WA.RPZ8
F15X)>De.?a2gCH-\>I6b.7faGAdNM604-PEg=BR/VcTI&g#8_-+_I(Y6g&^#L0H
_+J5&^?Z]&&T.J@NQ&-T0Q=V2M5a06XWZP(4TV@=gLBRY[IFNdT6TZDYI91@0g#X
.bMSZD5A7bfdA2NgVF<5G?ULTO(05@(Y&K>a@@]/BK#HJ64J&I&g^7_CL7N\/FAO
0L<b&=1f;J9I9DX(82#)<G,-g6Z<L[cZC@NQd1XP#4]1fF)[L2#)>UHV5P/>Q80.
-X4c(Y_-<g,BI.UF6BHB>]eU1NBNR;K-R39T4#HH]01,>]/0H0bO-(--d_+:=OdN
1a@4=Oe;QM8_9;6./[D>DI,.CWafZ1>E^PgWDMI(4\X5+FYB0Ff3QSP=\\2dF+2W
A6?I>/X?.;0GNd:FJ=d1ATU395GO#)I;caUb<4X.TU,XC=Xb@08#]PXD,S7L9]7_
@X\7IY,02d^>5fJf:OA-Q463:6K7G:DMa8d65:,Ce20.L<JRK(1XT<WJA4:T;H,+
4dYgM]D(ScfCP?9^43C#/TX/JfJUCVf=N2+GU^fKW<H<N)dLfS-PN2VBP8KFDc=f
d(ObJ.#ZG9;G@<]Qc0[Df>2(:NF7H4+#O]GAE=f4-P+1Z-N1[<(FV]7N(TD1b-]:
2GbWGRNX24Y6F;QdE)DN_6^c?\LC81bJ+8?MVP+/eHVKD)1;&DK7DFD(]c^-aKW:
:O,^U:Y9a^O@Y7,G6f>OI3[GH<b[E4\KUG#UFUXRCUSE[8RF3&M\@D9VdR.+FNKS
UCa,/cEI#332@R>T_)fCE5]@YNd)FUF(]=8d/)Wd#7U)e6@#)_.LF2bgTPT0cKNQ
e?Y;cDPP)UG>010VQ:_E@2PHB:&WG72IVDNS3N0eZCDE\?@AL4\;\.YG2Ia.d&8(
U5YT+5E]EYX>B?,J.0D[RcJZHNb+D=LKS1ZE=Bb]/V^7g/W+L:9dJ[:dUH&a,H2_
:MP:;ILJ2H(KF7N&T-;5+91,+L9\>BF]PAGYXe[09_XSTcY;F#0/L-1+6cGB:OcM
[3ed7:NBWBSD@9&LD:N=6HOdE3B1(-EbE4[,W?[f>g4NY#e+W?S0Q(S)?5AP\0QT
dIS]R-O9UXe-4BW,2/)H[=?[dYe^3eBdV?A4+eZ]U@bF97J0,&)[9?+22Y,]BX6Q
-WI5GY#WKCO@UZ1FSL\Y]73H++5YbeT7H)6JScI<LagW1F>Z67B.W(@_TJMC54<U
_W)UKGa6_Ve-gLSX\GCL+?aKB.CD.e7.D#NQ)IXV,;N\aMXP^L,C9XYT8R_TBUQK
AWA2DcgPPebMU.1NW92@+R2g?#RALPL55]:4L-O076-GN>YeaV.),W.Y1TRWQ9f#
SV)D;4AC9_-1T_PcQ2]7:]FY:X,@T8E5_>Z[2)bQW:F#(-8/d&:GCPE2Cc<gP)]-
-9/&?+<:LL\a#JHPQ+:MQF(f<Je0KKcFJ<<-6d263-]#E$
`endprotected


`endif // GUARD_SVT_TRIGGERED_TIMER_SV

















