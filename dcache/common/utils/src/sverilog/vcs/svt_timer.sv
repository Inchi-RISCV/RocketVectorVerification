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

`ifndef GUARD_SVT_TIMER_SV
`define GUARD_SVT_TIMER_SV

`ifndef SVT_VMM_TECHNOLOGY
typedef class svt_non_abstract_report_object;
`endif

/**
 * Macro used to check the is_on state for a notification event in the current methodology.
 */
`define SVT_TIMER_EVENT_IS_ON(timername,eventname) \
`ifdef SVT_VMM_TECHNOLOGY \
  (timername.notify.is_on(timername.eventname)) \
`else \
  (timername.eventname.is_on()) \
`endif

/** Macro used to wait for a notification event in the current methodology */
`define SVT_TIMER_WAIT_FOR(timername,evname) \
`ifdef SVT_VMM_TECHNOLOGY \
  timername.notify.wait_for(timername.evname); \
`else \
  timername.evname.wait_trigger(); \
`endif

/** Macro used to wait for an 'on' notification event in the current methodology */
`define SVT_TIMER_WAIT_FOR_ON(timername,evname) \
`ifdef SVT_VMM_TECHNOLOGY \
  timername.notify.wait_for(timername.evname); \
`else \
  timername.evname.wait_on(); \
`endif

/** Macro used to wait for an 'off' a notification event in the current methodology */
`define SVT_TIMER_WAIT_FOR_OFF(timername,evname) \
`ifdef SVT_VMM_TECHNOLOGY \
  timername.notify.wait_for_off(timername.evname); \
`else \
  timername.evname.wait_off(); \
`endif

// =============================================================================
/**
 * This class provides basic timer capabilities. The client uses this
 * timer to watch for a timeout, after which a notification is generated.
 * If the specified activities occur before the timeout expiry,
 * the client can avoid the timeout by stopping the timer.
 *
 * The timer also accepts an optional svt_err_check object at construction. If
 * provided, this check instance is used to register a timeout check and to
 * flag successes and failures relative to the timeout check. 
 *
 * The timer is started by calling start_timer with timeout value. The timer is
 * started immediately, and allowed to run until the timer expires or the timer
 * is stopped.
 *
 * Once the timer has been stopped or has expired, the timer stops execution.
 * In the total absence of activity, the timer will not indicate a timeout condition.
 * The timer must be restarted by a new call to start_timer(), or by a call to
 * restart_timer().
 */
class svt_timer;

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /**
   * Pre-defined notification event used to indicate whether the timer is
   * active. The event is an ON_OFF event.
   */
  int STARTED;
  /**
   * Pre-defined notification event used to indicate that the timer has
   * been stopped. The event is an ON_OFF event and is reset whenever
   * the timer is restarted.
   */
  int STOPPED;
  /**
   * Pre-defined notification event used to indicate that the timer has
   * expired. The event is an ON_OFF event and is reset whenever the
   * timer is restarted.
   */
  int EXPIRED;
  /**
   * Pre-defined notification event used to indicating a timeout event.
   * The event is a ONE_SHOT event. A message is also issued, with the
   * severity of the message controlled by the timeout_sev data field.
   */
  int TIMEOUT;

  /** Public data member which can be modified to change the severity of the timeout message */
  vmm_log::severities_e timeout_sev = vmm_log::WARNING_SEV;

  /** Log instance may be passed in via constructor. */
  vmm_log log;

  /** Notify used by the timer. */
  vmm_notify notify;
`else
  /**
   * Event used to indicate whether the timer is active. The event is an
   * ON_OFF event.
   */
  `SVT_XVM(event) STARTED;
  /**
   * Event used to indicate that the timer has been stopped. The event is an
   * ON_OFF event and is reset whenever the timer is restarted.
   */
  `SVT_XVM(event) STOPPED;
  /**
   * Event used to indicate that the timer has expired. The event is an ON_OFF
   * event and is reset whenever the timer is restarted.
   */
  `SVT_XVM(event) EXPIRED;
  /**
   * Event used to indicating a timeout event.  The event is a ONE_SHOT event.
   * A message is also issued, with the severity of the message controlled by the
   * timeout_sev data field.
   */
  `SVT_XVM(event) TIMEOUT;

  /**
   * Public data member which can be modified to change the verbosity of the timeout
   * message. Defaults to the verbosity corresponding to a 'warning' or 'note' message.
   */
  `SVT_XVM(verbosity) timeout_verb = `SVT_XVM_UC(MEDIUM);

  /**
   * Public data member which can be modified to change the severity of the timeout
   * message when timeout_verb is MEDIUM (i.e., when the timeout message is a
   * 'warning' or 'note' message. Defaults to the severity corresponding to a 'warning'
   * message.
   */
  `SVT_XVM(severity) timeout_sev = `SVT_XVM_UC(WARNING);

  /**
   * Component through which messages are routed.
   */
  `SVT_XVM(report_object) reporter;
`endif

  /**
   * Identifies the product suite with which a derivative class is associated. Can be accessed
   * through 'get_suite_name()', but cannot be altered after object creation.
   */
  protected string  suite_name = "";
  
  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
[g8DGJF?U,0G3-M4X2[f(SNHQ;O6I0+JE@96?J3#\CQBfD#GRL#.&(f&(71]c4[A
>P50\BXd9T,B,:+.H[fYcM].2E\BEOVHH4T>=\+d3[G?KWbJ[DRX-<2&N,VP^39W
ecWdSHbeR]YLN0dU7-XS55Q\2V#KCRDS)>E<cc728fDZ1IJ_XJYC=&\2H2g?6):#
(,TEB.d8=a@J:<8PLIdA&.Da@W:-]M8C7,N?W^MgJ^BWK:N))HQBfBQS2fQMZBbQ
\1SK1a1N>-OWI@C.)T@^/D#G-&c,<D8DX-NDZ?aUMTL4>1=PD0.&YU_d6907a:OB
.f=4CTZ&&-6VSfQK5ID?R3.-P\G>)JD-9<-(bgd_#[LAD41(K<QX_G+UF@_I&=9K
/Y8Kc]@2DG=+U]aSV&L>+BY(_He#IL>IO@a0;(:[/9A&/SL///2K=R-?>R9:ILM1
e5dT:>7@3ER[=.^(B;>BMOALCdD9[WgH86U[P)b(7IJ1KU2-+5>LV]P9JT#)XLP+
OTJ=VS5/CO3DV>?:H:(OIR0O3#aK/]](YX=cDS.(M:3/UX33Z&?6OW=?FT;(MZTF
Bb8X9__N+NP:5<N;91@#V4^?:gDe>&T3S)RPf<]geHPTTQ=SSYM92C#XM,U=6EB?
&9U=#H89E@#^KeYGCIMeed1H+J&+M.WYJV.EaQM)/4Y(&(>dQ_@SP\IQEE0V3;45
+,MP/5gd4/XW]JN_1NIH1VB6N@G^_eE9=]&T43L+b.02GeBX?X7E;UDRSRc/bOXY
OXJLD-X_;_edFRfL+b5][-.6\/;[PE2.VcU0\VATgGFK<;gf_FP:8WBgc2KEMgPS
Z8fW(a9PWX1L],3AfOL=gSM8,:Q:/U=.N=920UFTfb_+bJ.Y+&KDaF/g#Y:K^V/_
3\?EC9GK)d:Y>e+NNXdJ/D>,TKW]c.1=7,dT]1>8Q8K@5-_P5Hd+(Zg:_S;U;J\9
6TJMcJ_/UZENb;7)dE:2,:519UB2#P/\EZ:IG?I3P&Q?ST)A4@/Kee)A=X0/1[>]
>,aAUY/K.MfdST?5M#]VR^4_.M:Ab&;J>BcMW@WK))3]PX-[PPb0^-1W^E^(\,d;
eM-].T9++UaO@EQ?>0^L..D=K0)IRU_XKNKGY,ZKC/ZB=eZ3d2392C;PD.#c/;Sc
#G-Z/IZ^(PcWA\.bZ49^+FJ#EE8XBR8,=;\K(S5;?76PdV.:W^VeE4([];g<dEP(
g:49E149]0CU+(35@2_[#4K\(a<T,-4EYUS)Kce#.0MP=La0.b>ZVQ=1S4Z6VPeM
OG?]L2KQ>4?87:.D^[O>gMdO6))O^0EP][]I(DUgg:0ODC_O8aX:-XZe1=7aL7.&
&/U:@\/)4X=H>b@N.E;6bdb]dNXDJ1NGd;g-S<P?64#7K_\JEEDV3^HYZOU=f?:@
+Z@>APf#13e>ePO3&Z59_?P]FI/P=C(RP]LQfFW?3+gK6WXG3&^Z[5J::c>bN@dO
9F?7YY\5W5ZR3::^@#BfW\c8c2,HI.Rfg0DX57N]D8?_,WUMV59U;_6g<\)VZ+>g
/f/a8,_#A9]cP;e=&OcH;+4&g-#3C\,E&OP.0B2IPX[eW?XCUPB4FN[cdZ@724[0
g)<BD\:dd[I/NFC>1+Vf.fD&K)Q\JWX6.RN=0N<OBf4X-_^Le8.cYO864.f\R5D<
,)DbbC,^dE2UeC-9DU:d0eMcf2L>f7]9VB0RMQCeWD1bULGN@L.W^2-OVKTH:cM8
=Y#gOMRL6Rdb5:I9/9P&PYZ^D3K+>/D+-QE9,)[Z)5\KMOGIe9)b=-SVU]ba/3VI
5.4QYfQ[S+LJC+XP#899:AGQ_O-.6HW\RdU5S5VB]&)G\#\4f\&/)?LML#FE7dd2
GYcO(PTV.&ef+B=dZR5e:K\W7Z0F,CU]MKL=N&.=g7G32T_C6/g0978_/f-&EJ6=
B7=6@^Y@.._MBP>A0/<^Vc6\+U=U?56a8L4][=e.T-DbPbG:_KR_42a_\;bc5\4C
]FQHUXDQ&UB;H\0>4,HD<PRZQ:@/NagHOI^?0&#623J:\]-Z=GW>I/Mc\1A-g3e\
08[\0Z/T9dBL;d?)aYM]-UN1&GgI(B&a<(=0I1^TbN\Be9a\e?ASVEQ7?F;SOcBL
e3(P+R:Z;c(+THf?Gc1#3&7J2U[R3#g1I?5]M:8McM-00:2:=T/^:T-NDLF10U^@
dI.;01c/<J@V#;4V+U/))4W11X]2#FVWa[+@S6[E)IcWO,N#d:\SZ9QUMBMJ=(^E
B]QFfa?-RR0P#PQ4LPV8,Q@S^I/FMTJ;NN7N2@Qf5fHE5\4&\+-BQA(Y@e8\8?:-
6-V3=:a>?Pa_:2;])7bb^@,3&Xd4b+ZNVO<b9WT5MWEPgS_7,b_a3#1D\K.^@;/F
Q.5cNWB?6e+@edc@O4[,0\?4a[,@d?9;_T3e[C6[#<0,aa=.^1+)@=^+LMRB<8X,
W;[ZKUN3/#TWP?)11SOJ<VPf8\@H<#Sd7DPD1-7-dbKK9.S4C4LcRTeH_V9\33RI
8OHL[?V&b>+Xbdb8fO?1AYM1GeA3=7<74Ae?O(7RCMfO-S(_)Wb&bU]5Y;(>@C9Q
Q0f9XW3J?X,dRTX1.\U1&98F963[\[T&#VF>:YC4g[Uf1QI9@UER^I.+-AX]f_0\
,=ISP-^T+,99H#f,cMd=cZG-93ZE]8(@XL;#?TE8WeLc6@Df4N=Aa06348#6O=,V
H=aK6c>;SENKK;/I/3QS]:WB4cC&ZS+6G@c.#2A1M/ZGW9E6b-I+/:P8fUfL;X,Y
fVR(d(H1cS@aC8?Nf_?\LK(>PYLF@=^c4P7SdQNIYG[D-:g&CfFDKFL=KNU,#;aH
BF=(=HR)IUL?NB&c;<G_7NJZgBLYY,N]Q8;P>/WdEW[&O@\4ebef16:bL.8cd:U#
@X&C]a&05D>V/GI9bD;)XXH)ScY/&Xf8L?J<GdVWI83\4DQ\9H.[@4348U=[a9IW
I)5V^5:EXM@?e5C861C\SMK4Qg\;9W2.CU^9IAO.(Q]&:EW/U\T&E,L(\QZ>]PF8
/XWC;?Z^-TDQd#C2PDI.PfW1dA;:@#<C+(H^HQB:Zb>NBPP@42Z(U@aUYf:Q?g-X
KK_BJE&UHY9)I1cPB17W?<SDI<UC\\[:O,^8fHeIU[-GYUV:MOT=Y8P^2,U#//^F
&\UY6d63EJ8FX=?)=.)D[FM03f)<&?.)+1,R27MP9\4bI6^J1;2L12FW5&LMT8cM
HAJQ(UF,O&JP.VZ\,2HU^,,EXOD,ZP55d_[\+2XgYd?97Sc_S(-aXb/[cc:?@L6P
_JIOAXYd-FI+fa0M;6XZ](;<(2[TcK[U2U92\6PTc1:>_9GaM=dLc\&Nb9WH8?J2
<4[_39Y^/\(J-23Z6G\#g0;D]C<fN6N3D#e@&+0cWUf>A$
`endprotected


  // ****************************************************************************
  // Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
`ifdef SVT_VMM_TECHNOLOGY
  /**
   * Creates a new instance of this class.
   *
   * @param suite_name A String that identifies the product suite to which the
   * transaction object belongs.
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
   * @param suite_name A String that identifies the product suite to which the
   * transaction object belongs.
   * @param inst The name of the timer instance, for its logger.
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param reporter A component through which messages are routed
   */
  extern function new(string suite_name, string inst, svt_err_check check = null, `SVT_XVM(report_object) reporter = null);
`endif

  // ---------------------------------------------------------------------------
  /** Resets the contents of the object. */
  extern function void reset();

  // ---------------------------------------------------------------------------
`ifdef SVT_VMM_TECHNOLOGY
  /**
   * Initialize the contents with the provided objects.
   *
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param log An vmm_log object reference used to replace the default internal
   * logger.
   */
  extern function void init(svt_err_check check = null, vmm_log log = null);
`else
  /**
   * Initialize the contents with the provided objects.
   *
   * @param check Provides access to a checker package to track the success/failure
   * of the timer.
   * @param reporter A component through which messages are routed
   */
  extern function void init(svt_err_check check = null, `SVT_XVM(report_object) reporter = null);
`endif

  // ---------------------------------------------------------------------------
  /** Returns the suite name associated with the timer. */
  extern virtual function string get_suite_name();
  
  // ---------------------------------------------------------------------------
  /** Sets the instance name of this object. */
  extern virtual function void set_instance(string inst);

  // ---------------------------------------------------------------------------
  /** Returns the instance name of this object. */
  extern virtual function string get_instance();

  // ---------------------------------------------------------------------------
  /** Returns the current fuse_length. */
  extern virtual function real get_fuse_length();

  // ---------------------------------------------------------------------------
  /** If the timer is active, returns the current start time. Otherwise returns 0. */
  extern virtual function real get_start_time();

  // ---------------------------------------------------------------------------
  /** If the timer is active, returns the current stop time. Otherwise returns 0. */
  extern virtual function real get_stop_time();

  // ---------------------------------------------------------------------------
  /**
   * If the timer is active, returns the time delta between the current time and
   * the start time. Otherwise returns 0.
   */
  extern virtual function real get_expired_time();

  // ---------------------------------------------------------------------------
  /**
   * If the timer is active, returns the time delta between the current time and
   * the expected stop time. Otherwise returns 0.
   */
  extern virtual function real get_remaining_time();

  // ---------------------------------------------------------------------------
  /**
   * As the SVT library may be accessed by multiple VIP and testbench clients,
   * possibly with timescale settings which differ from each other and/or
   * which differ from the SVT timescale, the svt_timer includes a scaling
   * factor to convert from the client timescale to the SVT timescale.
   *
   * This method sets the scaling factor for time literal logic. All clients that
   * use svt_timer instances must call this method with a value of '1ns' before
   * using these timers. This calibrates the timers so that they can convert client
   * provided time literal values (i.e., interpreted using the client timescale)
   * into values consistent with the timescale being used by the SVT package.
   */
  extern function void calibrate(longint client_ns);

  //----------------------------------------------------------------------------
  /**
   * Watch out for the EXPIRED or STOPPED indication.
   *
   * @param timed_out Indicates whether the method is returning due to a timeout (1)
   * or due to the timer being stopped (0).
   */
  extern virtual task wait_for_timeout(output bit timed_out);

  //----------------------------------------------------------------------------
  /** Method to track a timeout forever, flagging timeouts if and when they occur. */
  extern virtual task track_timeout_forever();

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
   * Start the timer, setting up a timeout based on positive_fuse_value. For this
   * timer, a positive_fuse_value of 0 results in an infinite timeout.
   * @param positive_fuse_value The timeout time, interpreted by the do_delay()
   * method.
   * @param reason String that describes the reason for the start, and which is used to
   * indicate the start reason in the start messages.
   */
  extern virtual function void start_infinite_timer(real positive_fuse_value, string reason = "");

  //----------------------------------------------------------------------------
  /**
   * Start the timer, setting up a timeout based on positive_fuse_value. For this
   * timer, a positive_fuse_value of 0 results in an immediate timeout.
   * @param positive_fuse_value The timeout time, interpreted by the do_delay()
   * method.
   * @param reason String that describes the reason for the start, and which is used to
   * indicate the start reason in the start messages.
   */
  extern virtual function void start_finite_timer(real positive_fuse_value, string reason = "");

  //----------------------------------------------------------------------------
  /**
   * Retart the timer, using the current fuse_length, as specified by the most recent call
   * to any of the start_timer methods.
   * @param reason String that describes the reason for the restart, and which is used to
   * indicate the restart reason in the restart messages.
   */
  extern virtual function void restart_timer(string reason = "");

  //----------------------------------------------------------------------------
  /**
   * Stop the timer.
   * @param reason String that describes the reason for the stop, and which is used to
   * indicate the stop reason in the stop messages.
   */
  extern virtual function void stop_timer(string reason = "");

  //----------------------------------------------------------------------------
  /**
   * Method which actually implements the delay. By default implemented to just do a time unit based celay.
   * Extended classes could override this method to implement cycle or other types of delays.
   */
  extern virtual task do_delay(real delay_value);

  //----------------------------------------------------------------------------
  /** Block for fuse_length time delay */
  extern virtual protected task main(bit zero_is_infinite);

  // ---------------------------------------------------------------------------
  /** Returns 1 if timer is running, 0 otherwise */
  extern function bit is_active();

  // ---------------------------------------------------------------------------
  /**
   * Set the message verbosity associated with timer timeout. This method takes
   * care of the methodology specific severity settings.
   *
   * @param sev The severity level to be established.
   */
  extern function void set_timeout_sev(svt_types::severity_enum sev);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
C[2=HTfP_-6<#P/GDHIYaU;IN+_CAHaAGI/H2=;;YV5N8P]BL)52+(c;@LB]K=00
QW.3/ATWW9I^;0AD4.UI3LK.R,R=c?(:/:PXgI]aF:]#JJS;[3[H0;]8He]#^bW5
Y4J9+C.:32U\Nd90KbW_)/ZWQ;?PRfDDQ5TT12Q:CO)E7#Q)>2T[YGc?82YQW[.H
7H:.G5.WO:&)N+8N.PCK,MB0YA>SfNLPEN:>\ROD7KaPg:cCg6.bRV@]Y\+142bD
DgSgJC(X<;d>A-DJ]UbIY4b)T)4Ef4^b\R>Q>87^aW3@]aM\&U&H:\=:\b\bMdd[
dY(L9a,;&M)0OP&U+9NW=S-D/ZCe[d6JZ2I&B1VMQ:9If#@Tc#+:?O78f9=(9ZEI
KJ4[^CY)V&-5bOIMG0geIV<T@;NDGIN8gIRcb?UU6f9AgTN]TAZa?BAfB;.,H#M]
-4/@@ML+_;.#Md/ccN3d.PIgd(RNf:P\fVV(W?C#aX:d2LGLO=1:Q;?=Yg\-EQR6
;#>]C+<&U.XTRB@Ede@K)84FM&5CWd5DCCZZb7@35aG.#b^]&La;c)@9ZfL<?;e(
L4^O[Z)75e\8>XAUI:&f;3+9Ic.a6MYKD->[\PXPfffHY)>(N@PQZ.R+2:eFWb;(
ZJL6fEV3gL(A):;)?0.R^#&,D5ZC3P8d_gC^W9)<1)dP.K@0@UbQD^S/BJ=5R]dD
9+d(B9C+S7SbVLQ2Ne1/:@/^NC;]]^)a7W7d(V8ffAbgKPW@g#<gW2gI))b#7gWP
>aUCG3T7&4/Y:O=B>:7TTc-KNT_CNN#+D@LJHg+2bH>MHd6#(cZ__S8NR8.+#6@9
JfFac&6e&LKZ=Ca6S]Kc<HPc0FK4LUQF7UW6JBNZ[SgDOcY7^WDJeTd-4E2^gfG+
.aATd0L_7C&]Cb>bF6_GAB+FOdaP0)TE60HH]>YB[V&5N(eW3J+(I^8NVGC6&fDN
f,L/U7CfV_QYNLg.S4VAUEd][GS4CI<]3DY,9dc5,#)98cdE]gbBEUZ?(2&H8bFa
3HR>,ZQNS4^W(aEP7&,KMbg)GJ&@)3^KKF>CEad/B1[T(KA:bUIg:cK85#8Wb7a#
N4,dQKYC[+\]C^77WdZ(#W.3ND,W5YS2G?99Q,NE2,GM?=Vc?J8YNR;_U-B+:3@:
Wd>0e(N.#WXW0[:X3?]D:cc)T5S]H)aGg>L1N]ARYLO(U-P_Y@)NZ1)<fM,+F[EE
<4N5;SED5b]=84N(OU(Qfc=5#,ZX_GeL/IS7fca7=Y3a\aR7J70&\L5C/5>_Ld]?
\T=N@,/gP=ddG?;=)&.aaK:F[[E;0(L>_T.aPbF_5PH0gJ,_WT(\//:Z,^=NH0?8
=9.2Y=f>T7Fc8C&bbJ3)_UCIQD[HZP0b>4+a_8(cGHRL)/4,,)8?c]7[5=?(6<2.
#R_#@BLJ=SNW7EfJVXY.Qb^TGGTLD1<1P],cV8f+Q.0cFH+&5aY?V;Y4dWPMf2NE
:LCb=W/b1f+U_,,L^6=e2_MB08V?PB1VSQK<>W04NVJ82IQa_HN-C70[I2+,C=H,
Kb[464I-XIYYR\S@-IVJV]P;]RBE1.Sd3.N._8IV)G+[#:I,2PP)+RSf:0W(f0-<
BA8EU2cCXRS=dL7;G]3f^bVKH=>=AP]=&2Fdd/Z3cVS+cf:>G\_3HaREEG[N@8CP
3M,1/)(W7)[UVD2=H0AOW^YGKAf#2Y(^-0AD@R+-ZF>6DTf^9S[O5XCQJF+J:\7,
8.;.)gH1Y4W?2>V=VY#G0+2TGS:ZF)JZ@GebV(PaL.Fc2E=:)]FP\PB8WOfO^>L7
Z?(^BKI+\&)5HQ(a.2/0Sg:40bbg.;c?A#+1>1C_ObYeEaF^SAXF9JX4Ze1EX7AC
,M1IZ]QSCaQ0aNJ7gOEU.-P4d;SQ8.cU76&H73:Z&Kg.L?gM,#gHea.H0<^A7J1H
^YEc5U72);WS9cX#,S),&ILH>Y91Q9X]JL5&5])Y0V?GF/BB@R?-RJ.:-Z7BU+=M
LW16]Md/#DG<+S1ZY<bZ]VUCe@Z/0L(e<P@\<Mf)<//,Yb<CJg_Uc;5f_QcL[\F&
..38>Z5\AVQ#TXeMM1B3W-)Kc3?ON1dEBW66GfFRf/@f(@aW)c8M,,U,WF_abG<I
+9D/_OM3@dVYL\#KI6;1/RaGeGQJ]FHCD@ZGc@2aL,N5:0?C,GXd1c/EI=]49;Z/
P[)@8B<_;eA^]gA_E4V;4U.)<3df^N7^T@BKc[DHM,^8)@<F_-S-<8CZA-/#MdWZ
f6E6K6C,A\Xgg6QRAGS?;[_(]JgTW1?]Y2XVZ^)0QfQ-SSBc@A[gT8.CXaADP1U-
YW]&A)>g-WT#aSCUO2OcZ2;[IJg6PA3cS;6,Te45C..SP@Y_QP.])]a\P^SXbCNY
>2W[]<<:X7fHaOfG._&.6UF_JK;DYg=CYd+@c,AZ&9^74QJ@N=:/#9b7O\XJ)e/3
0<0SSE4B5T6IRe++eKVHRRKMF\[fMCeGc#;Y5IBb^/2EKdQ:M.UJOdR<aU:1Pd6_
Z7QaLJ:[ED^8<TaCgeOJ9g=.(34:g2T#/E(NNRDg<+B?B=:E1@^TV;RI4>7^:YIC
HX5=5,=7Se=TDRH@F4K0UN)67AZ-5M.BH<J,(,TTQ]7E=N+RPI7B_68EfR\<N+(H
eWQ;F+.Ia,E=CO#R8ZZ&ZD[C=_a8<YGZd&Zd>Y]Z@FF0P=BeL+-8(@aBI(1C6+\K
XH1A/7Y/ELW-R/-<PVL3CJV=NUGMU2T&[Q4BbJ4YK1Hd.(J3dY_2H+.@WQ_@dEc)
(\Zecf0gTI-1YP.Xgd<0Q_0Jb^7>RAf3P)=;J->X<,CR(.0EZ+;[<^,0@g/M^)_<
NST]J)Rd[G.8RH4N25MRNg2c&-_?DUMZ(J@=WeZ0I&fZZe1<2JQ\0[H/97&R1R2K
6(]?6^U]_4?;d0D5E<6):Z;:gPOE_Ee7U/@LJS^X,gE;_#VDF=J:G\U0Q:K>4UEF
<4725RKU(&9W5HUe]5Z\K=/4e]A7dd/DY05?)dQV:gMOb?<\68RWB&EaG<@5c7FA
WeNAOM=KK1GLZ_L8#Y+OF7D??(eMFXA5>XW=3G<F[AU6\?^VfQea>M?a.XLBZfZ(
gH9eM,2bBT5VRRBb#EX#H/Y\JT((EOA_596EAN2WVfdf?+E_0\P:KSSJX+_Ef^+Y
aS3.1^&G,DQ<M3Z4)<T01S(CN)PW>;[4SKa0GAY__6#LG0X/4,7IeNNU#<[V8eHR
7^.UP,LY^TEDYE2gf95Kf@X@T^CN)/6<:M]B(K4@<cc/6L[EH>L<F?4:Z\@E]fJg
]MT;-d/VWL>(aYe/^2JQ5S;R<D.N3;e)bIJf<f]ZeZ2G2c#KD/8@VBKFWX_+B)ZY
N<GZ<#[30[3fNa^/D,LL7Db.+L]M4+]HKT93H#F8+M>HfYBb&?1=MWPJK/W/:5YZ
_f0+52P#8IR7^32ID10?-Q#;CbG^)<N-XA6QFX8EPHM+bW5\f#&V7-0PBW1PXZV^
6#9VX4MAa:_Kg3@)_8+0d&ZPM:#H28eIXE7fbRYJ&\B>6c\ad0JLWUU/Aa=]6L.^
f8D<;13ORB8L]K)g0,7O1LBB]MA3E-9,L\0SDe7HZJ=YFEK>RDR4BU8XNfG/7QR:
Bb<D>R0=6Q+(C=eb8ee&2W<JTeFPd7MGA8,(9:+UU>O8Q;^;ETHINPgR9;BQL[20
TW]W5bL]E7RYSAaUMZ-++I>d63_([ZY\9EH:3b^F;R.Q+U)(][Y2N;X-[L2bRZTb
@@Xa_)eVKCU>f;BAUc>D=@f4VQ(PC:LTC?_7.ZB>>.,F[,0>.,>_cQ]eMG@IUHF;
)+R@0Jc;&P<9XJ(DEM\.UgEU@QBQ:ZFH^5A5P:^)^@5E\MNC_EM&<Ta;c&^bDTP,
,BZEEW[fbAb^d.J+8Z0A^3V8J[U0,-O3G4N<^EVIGMV<./Oe^36W.\W;/]OYA.RT
YF</X(?Rg2deITgJ0a))1(:HT(Pe-\&LFagHJe<c;Xg?6&O@2,EWO:R7KP0d\^Jg
G2bQ^&,&M7PG?e(3)FA]G<18[3O)6/bOYeC^.dNc2JDC2J7]g0/?g?4P1XG2<[3L
RGJ#LK+ZK.,M40eJ2\f5C&R]d(Oe_EbRJE&TU+^c@3RHH-dUdOe)RE6A5(Aa<f,C
A<Oa]f[cM):Yc&;\J,H]8I8X.2N:9^aeS/-FUVbRGE,fZN+N_(f)=/Z#9dF0@G;L
HMYLHN[L5@gWE,_D&LEQfASfNGOQ+DKEg+&@(FQ6)[TeI@dQCHE0K?f3WY;#ddU>
B.\:J6d]L60[b)1+XfC&+GCHcc0.fB.M=c9JJ-8O\(a6PHBKC0M_>NWQ#201S6#W
2#Yg>NB71XYI(O)Y31R-cJ2MV]/^D_:@AZcW?#(D@F_cb5YPe1K^3Dc.(\FMGG:5
)CZ>MOAg];]SIAQEP_@MXU-7RNMAE5<P;2M,Z32.F:JI&MPW86UGJ0LG@]PIK:XR
F?,^2D98@KM8NHPL87^2LZ([SQ+3WSA7Vf49b0C08A&0^YNJ4Wa^+?>_BVK=UZ0U
6V8PL]Td7\;YeIIG>LH(>AI&PD16RC,=-9(\;\d/)^,/b.=9/Y<@A+6#V7/@/:>B
<^5a]-((KFSB(&+CK,WOAE?Qa^>97;BSVR8d&Y^P3.45a=FMgJG5[;E\#]-+FHRY
JT=BT->c7.Kb,#EQ;_60Z]QC4]f;EQT:]-RPa[fKC];<1_JUEffgQ\>-&K?<4Uc;
2^5N)1:S5E<d0?9D:VUHV8c&f#KcIT>BO^X7b&f(?H3&85:beKV2eV:N8B(5MQ;g
.fdJ<;0U.F;)Oa(g@M8=[>-GD:;PF9TD:P+)7-1>B@QZR8<F#_SZ1g5-H#+;d8Oc
I0&6Y,W#L_(.0B\aI4D\KaAA.PXH9G?&CYd:#-<-&Q.[@1VR<<3-@-fDW:2Mg_4A
(K^gG^&@@=M&4G4J=(<cLcO-R#FE5P-LYcJ@/Y&L1+,T^(5V[ZE8.Zb[GUBLA:Qf
Ff@WcQ_4JAN#UD6CE8JJS;Cb<#0I_80/R(eaF/YDa#Q72dN<+FZe/UWSO)]fD\H.
V(1ec@BN5#@dd5OL=9;cPD&3d^4SJ5/A\5&O8TJ08O76H2KM12:MF52@DITL&Xca
8+^AQ9S/34CeW&I,P?O0=a=6e;7ZK[dCaQ]0Dd;8#gKH\:KD9)R@:R),>:U?)VbU
Qb#KU_A:H^f?7[WaJM-QJ026#MKXZJ?@A6;?._5+E8&?7E+N.[4[WAO(4?6:4b+G
:J0X#4-K)N_19@=N0J0AS[,]>9\X<?R,g/e&F8-@>XgLRB7@7R;YKUc,W@VV#KIJ
I<ZU#7eSNVIL80eIGQJ#T(TaUDba;fP7b&^RIS@_,KW-BfMY8]P4=)P]/R^aEL5[
[bLJg=V;[W:1De-C&e[dRU11L4_@^e=?M8L[S@D8JLg60e\2KGKQUVB[E<BRFRJ_
7<&MaNKPC2RUW(5W=;DZTY,Z1c56>:EN.19R33Sa=3Z2&aJ4HA)/Y+11IRWZR?3-
S^..UU3[A;/XUILYD^f?[GK.&>bN6fKU9A(UGP.<UMRPRgDOGIG(CU>1d:51g\9H
5BO]2\a?CWOZ(4^c]c=VJZ]ZJXM@BGWFaf+K\2&;c@DW^^&._A8P;X_eH4\2Wa#M
e>fLf.8+[0PA<J^[N4\eU_Z,NE[)#?@Q,4J;3?:P-IIZae4cPA>2@>O0g^=3.4Ub
0A8\R8@U[7;\,SG\0PW.b[:FfZ#W(IA.Y-.U&6E9REED;D=0CB,L,DW,6H+>>3I<
N4<N2KA8IKAFHPIQ4KXF5.M1]\bY+A;D>L&;BVTWBEW&<<b>b1gYa,&192QT@a#Y
#)5Y8)fMDUYdX#TEd=1EZN>F6e.<fg9.]aIQXI0cT_\FQ[-Sa;^g\#6B7&L(@<ME
2A&4@JE6YW7AdeFLBaa6G@IHRfTa.89=UI(e2c>5_03^cEU;6++=7#NZ&8Q0GO/8
<+6cJA=1GWCRPf^G:,ORS^@.)W==1[b6[Pe>W4+SIW,(WI>;\<--:gZ&(fQ:KW,(
&6?GJb,NZXOO<B,JK0SMZd=Z/N<0fBJXM5ZO-;E,IZg[P&bX3[(eTO53N#2MXE7;
E0VP:?Q@E[ZE=\eHT>#[KMe6gMY/M^SA@=0Q.8>W5[V?&2:,^Q-1_Ma5PCVdW>M@
UV9dO)+8?Z)_GM+4fGSf4f8E.-g7>AJS88c<3;=J8d0;=Da?\5(3F48_C--GBF\P
M;c&19KeMWIdQ?7N0^bFcG):K_YVe]U2/X-=Q[EWAS9(DZ[Y^2cGFZC8_]0OTJ_Y
YeW?5]S<CZ#=CA_Uc+N+c@U8\F7DVBI+21^e5Z/(,AD(&W\JJ9)T6J?\]-N6)(BF
R>0[I^^gAG#L[KU&0<2)@J>9#+V?44>A@cU>4dV2]DZMF<;MN;0\L<IE1fXDR#R@
CY3YX@10>0-NUSKLJ>EJH31@RA(G>FLAJ&Y_?<_8W+MC#END[]C5:ZI;>&JK@KIS
:/36O.2[YJFe\K4Y_E?W-](M5TZ4MddY]H+&MPNYI#McEQWG_Y>QHg56c8A14b]c
,T_W;-OA8F]/,a7RHW0W<3c&H,+5-^HTF#(bDTWZ737&b7V=G5aCKJH[8TMQTX<8
J7S)07LCK,)KV7<[?3W7E#]3e^DR<dRH&aB_+3U@,BQ_Egf&]))=(T+,Ae:YU6aR
KeR)O1(EKU:)SWB<RP0XBe.[5)g.-D8/:EMWf+6#f^]c(=7(37MOBE)PS/[;;=f2
_8Db77MM0.Qb@eTD4\>V8,#X0f+9)-e3cMG[(KH>bf:M9E9&#>8N4g]b8;YX;<70
Uc(5?2Q]R&^d[#-)b()/N&DO#Vb002B=54CfS2bTY^D=A0C:N4eUS[M,;Pb1SK8G
K9OA4/-N<;UJF=d:gTbZ4GK=&C\SEC3.7++D@PXdHR0a8WI8VQcU;[OG/Z8>G_M+
>62:UF7+dD[UId1IX#f+T8\1:6R?JcE+X_a0@/2gK9c.QW.S&8K,,P,V4TE;<3bD
\-Hg7&W#I?Z.[4AYM@MMRZK)RMRT:@>QN/Y.,RBF(W)_509R-A\Q=02;I[Wfd5FA
D70>,FNYfD[HRW4,,13d2E[V35C8[;e^FN,:E=M2EEeQBJeECF=,RFIgX+#eM8#d
,IIC5_59WD><(TQW@S7AAY8egfFAPT\P9IBEIN,_U3FM@g^2,0I2M500:/d8H[YN
GLV?(6&86)WLUfgFcSOBdca]9DKVfeeR^&R1U:+AKXC<F[@Qc(X1<ILC-;Y<5FX#
ZbdXM3c1e?R:<#&<U=deVFD[U;NCf-f_2(<._3MDF9:W\B;4OdcDaG)ALAJ<EW\&
;7CVNX#bO?B5V1ff;]H;YLPMd^C+=@_fY[JQ^6C)&<g0\H>gNEU/2J&J)Q)=g1WS
F<d-A&-JKZT#N1&UIU/)eGeO.(XK)K#(1REVH^b:H]P@5,5WRedQg=#g/;/e/K3K
B+;>_5=]O&4#P3A,>)aJT]#LXY[bDVUBbQSQ=1LPVOVRFB;ab4A96[ORS;.SQ==\
a>8_#;aH_>Q=[A>>SB;gg85b=TEG7W?L.+0WY9bZeQU/&CA<2:FIdebAKSf<.9+S
X+&+;9JPYWfE7G?/+#Uf^J,]K:5[&B0BKA2V:V8b]SXcfIM,VNg)87[,=<;a[A9H
;;5NT6=c;&U=D)ca0D,8/cAXO<5?5bU\E_Je=a/S-9MP5C^K^=W(VY#NJ]2.ILTY
)@<#0TCVgBeQ+aC-3&I&FIf@;Q[AK41-BNR_[63cWC6dbKC&:K#=>Xb@AYYGFUXN
(d>6K<^HY9e:-#,fW##;9J+&c@VL)]C^Z#TSB)MM(^G<EBMN/c6c8.]RWgSAf>T1
^5CWa:C?=Q&&)<Z7_]Z]0^[Mgcc(R=G3Gd<bTV/&6.fEcO^+>2Mg-11^FMbYX6T3
B0C.aT^#LQFWCe7@2MHT>,G.C04e?]eKGC0Y@8PQAE^]-&_d,3>D7BN(dHE?H)NC
QY8D#bTYVO&>S1JR(]Y0eA(^MYOXKd6d2F\6^W9TM#EK&0#_FVMP9=\g.dKf:E6S
8,><9@J:L]J_/3G]V(1N4aZ3)_W5)1&6;Ne2Xbd-WYF4c3e4&^FV?FBYCf[dEa)-
7U=(DZ&YLN(N#b^^gJ?7/-e1Q>T^WL,J1DA_P>]F4XJ[e6IESO5#&Q,54#J_J#3C
:BCA(=^C?A>VQZYDDU#-,-/07AX>dc@+GAa^LOK.JdFBVb>@XcHX2]&UggIY=5MX
2DZYYN<X1T>Y?4e\&7[1XG_f^SG_b,\>4F6&/gHNcL;C+b-F)9TaP3L.f1+2)LYC
>88B()cSR^/P18<Z4I(c9GA0/57&K&P@&1N68^(817.0QQ\.#R#a]IJD?NM=F^Mc
NTDNO@JQSQWDb-:XFKP4Ng)(HT.fgO[[@P3QY/7XB<;La#A?A>.PH5&?31._g&-Z
ge/fD\(,aR)<I9-EKRG)?#C;GHU;BR0<bKK?_d>5SJG1ENVVb?>1?VO0TLM_:4@G
b;_?_#\+RQ[@-RR[@.6\/W)gd7\a2T>MU]LfQ\cC)0??4gK/f_&Y[(TX]7/Pc>WO
e3GIVEdJ_HF.++>>0@KL5?B&70ff\)VQ;E1CeAY5NMc:]#4a9a;1;aXKfE>LK(,,
JdA-3+=4=+K:0d3dH0:>9Vg5@\\]YB(@.^M,<C/Ug):B,C<HYWS;L9Jf_BY]XHG(
A41KZ,TSBaU[\gX0R98UJ>T8+91XV4UC-b(HcC72/I1<3REI>>\/;>KW(]_J(/4Q
g&50;fX[O>NNE+5fgM,I@e#:^7F.?#B6ZUg3_1APM;JSf^1]V-@;:N50M31;JAGS
fE(b[-&P-2NT-J^Pa4bdKbZVLPaT^2_;44C)+AZ&Qg2U,^91.RdSdF]-+Q(cVe^2
19Z03R(M)BB^>^_E^OLNH=<D0HYNLP5?X_9TV.,;,dMbYIWCg8aCZA<JZ?10^,11
TW=[_b<U&SN894XXa1.BD)1F+F+H:V,:8B;:O,MOFV<BQcTQEa^S9[.6=3BQQT]+
NV\D:\>^U6ZMO<-.aS&4:adC=OOb46YW+#B/OVc8Q;1B]>]).Y[a39LLDY0L?(;-
RVBV5G6]d<6>HT=8RWFe)+D#-@,PI0&UU1#A&R3OM.JaB9E\T,YfXB7[-=W1T,1J
<ZR94?[:PRKMH)_3g[]9CO4-KJW9Z+EE#Je4HU:65BFTC;dZ;_P>43gBCZK+8V,b
?^@/E<67RHa;,)eRNdB?<..WL,\<C?d\<EGb#MDd>1QZ?FG]P;)aBA=KQSI_I8.W
R/9J8))QGQ+eV;:AP<@9RX_R(,L9Saf4=T<?W58M(Yc(/[1>>8ZDQD=@&T^YSFYS
VeZRQQ+\<T9G(][dgZ@#<B7PLd=P8YOAY9YfUL3@>f2\@e6#C4d5=SGF9):=CH@f
@I4efWK9EF+NWI&XPIc8dUDHdQf4\\EH4?&-8#);@,6,9U7ONC,50IR7c<+SL^\5
6XV,HE\AESL;==3AB0\E0#GJ/A3,M\2@baH-g85(]8N/c[B80A-/-X<>-29I7TL(
U<PbK<M8IaH(PKHa?9#_2bVNM_5L,dP9(->]bFYKLN7R(UbVN=^4Mb)-cU&a3>@^
=d\Z&d(I=_XMbF6998[Va6]509K4M+P]&;gYZQ^ZV>T_HH[78\83,U7fT4;_e9Aa
0IKAW0e-ebZ_\\HffEX8(F[f8MH^Z#L1P>>MK^Eg3E,Eb_#SB&cN7ZX7(M0<3R@#
)UJ?dCceSgOV]P?=>[Fd=>W>NE=^0E<J.-M;AL/(,XAN8&L_df:.a+L/78?#<SI(
>(NRg8bbQ36U5]a8+>d9JHPAI2A5Eg\UAK#-51?H<GFGSNUBg;XN7ZC1G<3RY.YQ
b)]8O-A5MS0B/UP2=,+:cb6C@\\Cg_7X]fQC)R(Y(N_I7f261US2d_fHc[DXbP&9
+&.5FQ4W[RRQ=+(>P<GP5_7G>(C0/36a0RgNN=1=S)N&:bWcB;+)]f.IDddG)ad@
Va;-De,==KW@IXI:9@B]^UdMMc)C2QC\_X+=R0[cde]g)L][M9g]>G+,H5:fL<4,
+3#c\C#[#(Y3EB<M[dJ+9f^FXf+VJ0^78d\[4Z)YL=JT-L0KG4/NPK;UX(afGS99
+-)/YX867_8S_?33Z.B2g@5T&VZ>-3<J7\KdOGW:dWaA[ZX+g\TOHIU:fE,2RP&R
<2D@8(^1DHD+6:/\?W^ababc):-T\+DM?=[LVcIP.&0LgZIg>YC>XA<f0KZdQH5Z
CP>X[bdCU@R.G(SP8B.L=F^PR+]Cgbcd0O/dcBZ&?g.KDKP=X?++(BTK75([ad9Q
-Z:PfQ:4:;#a3^U,baU?gfH2OT+H8P0:OA^\/<ET)T_DI.ggHcdWOd2L\c\K=QPQ
J)B1(7ZBEF8EWeb/\BYYSge<>GD^X]YCRJO^+6/#g1I?Xe>]S1?3;N29UV.@WQ^<
:,8eeA^/S1=ZF^6[(OL3LH(1OXFP@<YEC)1Oe_dPDZ+_>-=Sb+NBOM-TfX=UDbdE
<UFL<];7A855F+&E\a3L;9gfIc)4L=YE,P,,YO+U>>XM->8b8\L9BRA649TS79Q&
P2F57G4V88;[=;PY^#35KZ(baf@A\B:).3/bM][\EZ#=TFd+KW>]0Ka,GL).,D.[
D[09f:-:;#1b^eJK>@&(OM.2#@B4b=eMBNgT3agQ76.?V@gD;;PN?6_RZBAY,bWg
U)X6RC76<26-F@O4W4Qe0RQ_H4XDU,.N32B;=R--HPBeBOEg#O7B^-Q&S?N=cdGE
>8P:MS5b^3:aODd^>/EIQD7e#)HAUOX6(H1IXRN2f^8+a5P.06V5VC2fB(_83M+E
;751S6gY(PLFCcd_)F_)Sc1##&W+fJf,9TO8&,LJ-I<,D?]e?79&1g?.2ZW]<-S6
XA[GQ@,KYF7e?##<M7WK&TS#/-OAG28E^SNgM:)H_6f8)Q]<b17eMf:5fF)@gYA(
b58]AZUO[TYKJ5X#V)W2)FU-RKU-c3K_DPbV4Ob05^W(b6,ASVQZ7=4+).c[B-/K
^N9b>IDJI4P]B>LU-2PX5&Z\T,;a_H->f.V&4N;aPf^T_7eCa&LbVYaN0^LH).5E
gE)YG>1^g,\99d^31XO_\Be\Y>P:c_Xf?@Yb\0GM@V+MU9KOB=g54WLW(@961eNS
He>XQ.79AQf<=/PU=^[O7gQ4)[9665V;CC@YZ7F0aeYWT]J-6Z_M.aD>J)P#_5W<
2OaO^\,QRBTU+DdT)]&/gQB?D:dVO&5<1;;IYKCE4A/[27O6:O>g)D46;gT5G6eA
(6[?=MQX77V^PU,?<J0OeEGd54>[+V9Fe_O>KE)8]^DZ#IAJ_\5F1<>d+:67W0^V
NZ3TLU6[a.P5LM@#U2J;L-Q](XZUT;?P\OEa]V8?=MT0bTQ(YAR;/:CUI;8QdS.g
88.+O#/?ZH_?T;eTD&a05<7XcUZLV#OCe0SZC0GSb8,Z7^(1K-VX+8U\)[FK5#&R
0c)J/L2FVK2^(OccJ<=Pf/2?-8bF3LP5Z^Yf3ATfTX&R:gV+8497RZWb9.[>3R+J
F#X<6D3GS#b,c5^5?4DSJ7/]V:-3+PH<H(6A/,[MPe6XS7BEBWWK2c3TX<I[U:V5
Gb_GG\1[2ZHG;WKc5K36TQVIPceJ[DGZ].,P/^b3I^b+SY/X\&2V(a23feT4OIGM
9CL#4;4_=,+g(@O]DE?a^O9bH+#\e0S(MMN2J3QB]X#V&<D0K1e,+2Z?ETbd4;U1
)0=,Q4E1+L>UC+R6H?I,1->/bM<\ZK1cW4BJE2S>eg#O)X?cV/R1X71NX@/X+?9G
b</W4C#,dO[O(^R;M(E6cTK3+)O<XXOc@(FW+R(PM\cD9DR<M:XY>f[dTNWD@LO-
L_NW@Q_LIQC7=f\K01c:N1E7&THd@c<R73YP&Q:,BRRHE9gRW[_;Q[NTRDS+AU>S
F=S\2BVF6RB0+=?HKgOG)b853DSL?9,3YbX]Da.,7[@RL2D>b?:=P^N(Q53XJ&X)
ZQ.QWCB-&D7M&)FIR4[OETCa^-C:B.Q^6P+4:US+ce3+OP[)aIY-M2gP8T/X7V<_
W=?;dS;5Y3f,LBT\>6XBW\eRg^D+.EY&Q.E;@Qg)UM6#e^57_+?(F,2K[^K?c<?S
4/\QZ)?cX^HMfQIgDK7U//E])XB(@dV^G0[]T1Ed&e;[g@GNIUC^<BY+@V-TNVK4
?cW@4HdVS6:J&AY-)fdBbJcdS-F=&NZA7V[U^Me7caK,^OF]a0)QM8[GJ-?CDPK0
59/7O?7,S<;Z7=830aF<\T#,J^)TC))AY6f3G;-HZ:Z(1)WWCcL]W(MBdN&6PM17
b>,S<QLLU,.8NZ2SVIM<d)QWWNZ<N&dYMWfA^XAeKd>G/-c_Q1?B4/;>c./X;Q6;
Ga^DQWC-]@e/A+/909L,-,>e)5:3b5F0)1cI:fNXX&]#\D?6\Ac1O0HLccB4,N?Y
J=QH0ZSQ)D-6968R-KCS?KeK)4gd>X@LR+#O5eO]]7@,,ZHa,THQY2R)KUFf5CGM
7/-g#UCLE\HIUZG.T>H-.UaSb05Sa4L#f//YLV\/5O]PI_I[>6]a2+:KFA)MaW>=
/9A^]ZGX>)W9CZX2eP^f;^7^BVa>)SQC)7T&e-Md2-_9F]8Ke?(.?8BN):6a@E;5
QGFCQ^P=&KIJ:V\-JUA</+eG7>8SFHP#\O8HJTD8TQUb4c)XU]JG7\@3/(\^UJU(
Tb&KJJTHWOTS>g87)4S1e5g31F8_3E0<8X3+A\9-/G^J?G,(1Vd1A6I#5HCe/39.
V#,YUUOJ^QO,QaZE1aDYRa761L1.,c@]N3(RNQ3H]1-BB1/RfR#,7]3[W11BEHg6
;HWg+FOEI,WI]D>D,BF6R/d\[K?O]S<QI#Q;\=e+9^bQW.B1g>C>N=,4GM[0L9N4
_)M)V[f>I@Z5DH?fdTeN#7)8-ZKHBK;CW.>f.+I<AUZE9K@SC/9d:e4QYQ[gGUMa
@.7Xd8e-HMG&@OJ[Y(.]ORD:=4=K1:?)I^UWY)L#5S(Q8RP1FZG^@0S#?@E+9ZH8
0-f:^JWc3^&SY0#Z1fEV>Agc/<[R05YRTeRB2^N(B4gGZ_8+XN2a/gE-W];HcVJI
#OLFK_-CdaZ2:-D&?Uf3>ELCSYS;^&ER-Y92.G<\2CD)04-B]3)&35E>K)gQJ]f)
eVN;5,VI=_W:Hd?2VYQ[-)c(GDM=5(#TELd0/Tg0ATP1^3QaD1N,aH?\G8U4_c5V
Z_\Ce:ffCH^(OIbNP7+8=YP[@PVba]V_S+0D,&<PA##?Z=XB(HY6c7[6_<5b9J9;
28>(.5?=_2^6<V]N?B6-RBO05<(XgZK&/;^M,-/H7=MG=A+,QHP(,V2H;VI(3Z)7
OH1-7b^[6)Xf)SeFS?V&DV8C0;;\@)V#bbeAOK_+Y.E:Og_9O.5WF2dAQIA.N1aI
:MAgJN-FL\D8QCRQ&:P-](R[S91]-:FH#69^\Q:H6);:KA\7=J0TJGYVVf1&cIf^
77JG.;]c(&CQ4TR81DI\0BTdA\DK<?RWEM0G0F7eY9-93[TF8H\e<U2IDTB+O(AE
X1VI4Oa3a+/c]dV-3/\QCa(4JDbT6/X(W=]<N\P1a]^YdaD+4_g\<g;#/d>/\cT(
22HUXPDEA)3I_Y:GR.]E/4;>,HWS0PGE[c>8FM3#S)f[MGe[.M+6MHg-HTB,ID,9
YA,D7P1514V#^.8.6X71L6U7_85A@&Z01YYaNQgA7c=[T#ZJTCXHGcQ@g1H3EV.]
aZf_1I?X()IE)^0@CbEP8X.ON4/S;?FXGD[Ha>H-KE-_GK;b(79fa@W6R^M6YecQ
\\Mc]Vb+N3+9e5J(RJA1db@_65(#G/>F3ZBAZJ8-+Tf7?/Ja<5&@a/<a5X&g]8,X
E-Z)OC]GaNXS1+B2AeT(1M,D/160/M>#_@;e<]^HZ@g8EBG\D:Gb\)1_[@cc4>I>
/Sb#BT9.)5e3?57CM\KcM<0YD@&g5U5)VON^2Ieca(b&-d?e5+5KC<=1NM/(N)c7
:B1H_HgJJXgReHc:[@134/O&bFY:EE//<[DN.e]E[..D(A/7[:6T-aG<TRCP6:T^
XLgU,e&XNe\Z1RdXC)\dXCF7BF06;1IP457+/SRF)<+\4Q423+M[befPgJINbaLF
[EQ8aI4,d>V-a9E=NIU<Z39VE)]Xc]Z@4dXc@e<&F.RDF@[X7eN#K]/JGWMeXcZa
F@M/C+Z-1[W0G?/Y4a4OY@=:#1Za^VZ6OWBF2K)GV,#LI9\/_]Sf_M\e(N@J5XSS
D.#X?#YS4Q[)O)MA(47KI]bTaZ93b9EUedQe(UE]6V6]d79U4UX;Z5cN<(DK-O:9
gE,.I7]28#gg\2;28A-,PYTcT4Zb:+Wca_B3E;,a#J_A1S8,#_DHcY^Z2OT_66e2
()d9;c03X6/,dY>6,_d99KF,gEI2U87E1R,)A]c2eU^a:7]c@./XUcUg\>6/ZS:I
Z:&0aHb:g@J921+7T(\:DM_aQ2<B]1YS_15O)4(cKGEP]4\[c@T7K&6#4IYVUNM=
&e^I8MN+M0S/=,=@_g==&AdF#-([c13dGd4APV#Og-(,8X]bO_db9D9&^DFX,DE)
EFJ-5IV2F^aP72(2C5R\Yb97JW(LRR7Z6,RTe?/Re;^AUL4H#5d0MDMQVb)cP5@M
Y)]RBFQdd?51F2;XS2E2fO/MLLEKCU,_DZO41[Ic,622VRTb;DVAabBA,L3V^&cN
cO&T]\?KgN(f2>YULK#K3aeIe/O]/Dc8;)B]3KHQFK>T:-c>4B_D_8RfDR?7<:Y-
PF[7@a/e+[#-2G\MQTPc_QcgF?;Me(S1[^Q4ZPI-(X7A],RLc^(c&RS18aXQ0Q4K
;L(Z5@4GMG#X:c;7FCHKIgYPaE..<T,-(Y-?Jf3(PE^U3CY>2/E>FBDJ&4UHDdQ&
aL@3(F-/GU5b+.1\_dYX4/5=&(H^>T:-2I(K=1>fOS7&XM2(1Y^]&)XgdWR9S_Eg
[@B@R?F]MO6Y,JN/EEgPTKMSGJKDEEb,(e..M^>YJYWR+J??MYEDab-22-_ZAe;K
f)S+Mc^2&J)?S##V=E5^/\cKLB9BBdL74YK=M33D-SM^<Pb.&,]C9]M^W@d_0C1;
4TC;GabFY0F@:23V;]1BC1N/a56:UgDGZH39VI.I]]RIG6VJ&F:c@P:P&-ZG0LaT
b[2Ic^aHTcf3@LVBJ8K>GY37P5aG1LLYbL.&#;6NG-J;#g.VVFX&]P:WH.6Ga-XB
(BbN?bKP;#-N\&+J8?5gaRgR?)C=^8@7911T/fC9^R&E/]dNc)1GaPX&ca+0VYZL
2bMIB,^XW&R@-cMKW)GWVDB0e;_,)(B@ReR)g\BfT[F&]P>LP>g9GT](eB0B&N]c
EHB\ZTPG<:[/bf>8,M)O([TYRN8X=X63;=,K(5=1OOfYYC#Af1.D0UKCM&,@XOSL
VF&K.c5&-_fdWV07.SAJI_OMN1R;2+cKN((73MU6F>cG&aF6&8P3c^5aa)?4=:5^
(8ZMUVT1dLDCQ1]cX=PWQ@\)CeN&(=9KN[=gb1:GJ(1eA41Y,XACQM4_]I@a5<#<
#KNe^Lb1B3H/Q?,S-V>5.IOCQ.SLcUg+bd7^T(SCLK#)K_?b(,XMJ;g:5C7^:TE8
>Z,36e+^_N;O)[\9?/QV)4=+Y9E4PE:HK\cCRXeb,KW1:Jc2FTdV6W/c:.C:-F+9
M5Xa>XD9P=:)F]]W\=(SFYDXA:IC7X<CI9:>WFQZ+g&(VC1NQ:GPA6Rcd#=P&K/^
#9Hb5S+8QeVIW6U,+VaYg<a_M;DVR#^]IBOG3?)SXc:&5Z8gM\HPc+YHa.C_]@CL
]K&UG>+9Y9=8<0&A+5fP;VSPOJG&?8IEGaUR1;b2KgO0CVX@7B\A^5b5/g1;c2Rc
3,2-R8VL+c+UIe_B9I]6>fFU+e\28WW7f4UAYX_[89OTb.N[(ZP<.C=bI83gV[+4
W@4O=VMFcPaY=[cEgCT]CMW^SL7c#Q]1]QVD_^BIL>&c#\?SaFV4VTGPWNJGbfY=
9>B1RYKF&X@A5ed:IY&GV3G2N4aM[]XQ4LMg)RfFKc85.QG/-2C?GRSLI&PEg=21
@7CF6EgGK\223-9f[V4PBW=39,LXXF&A(R313T.<__a@d<+EYU:5b<-,-U8TPX7/
g8+&GWSUF8=#XW5;:7CD]AB?a)(3[5Za(&aRBZcTE^+T,X.[e@bU.dEMMKO;I&AT
7DN2R#<A#J9b#E1/TeRVV2<(SZZ?T>A@==-IR:(2bALe>..FTO3/DZX<BC(9K>&N
g4HY;@Q8/A?>aHTLGWE=LA<2FF<KAEZA#H9KSB8bSXA8.,.FZI4<a6AB^Y78P(6[
<D+b9KMEfU)d(9WB6^XG,VeW1YOgYR2V@^+-e^I]98PKW94760B7aY,Y+^ZFC2N0
+RcW:\IK41)U-3_Y5YOMcHQTG.aJbNb+KQ)3&L,Tc@PQ7-PJ+1<P^CeOcAGYd_7P
(SQEFN_.TOXN,7\PR+gU8X>)FJV2Y[3gL1DJ,F5#Q5KD/U7cZD,5F[c_eCHP[0@d
&G?K(&a),<;(+;:,,>Ge1+ZaPZ\e,BU.Q5LQfCaPHg>9=)XS20B6=RT()-L\\]a^
E?_a48([GY4M1d^V6dFY#]9b/G,AWDHg,b)P48=/Ce<3>1+eHO9E/,0P@V?/8:,N
<#e/G+Q12BgXIg5-Z\^;<S.\4T>=dKRfgS^;0TT:NdSE9G&=.MbPJ=C+2EQ6AIb4
F@4/<0e)1#B[,[1J7&,5/4Ob_B(-O]5OZXX<#>S7S<26g?ZEeg9AP&]/9GB\G?Z[
_Jd5eZW6[6)bQbA6dC]2_=-OF);BZ\REM<+Nd[7_H\\@fJQdD7AJ3(_3KP_9847Z
7\S50aD=P>:?B9.VL/bcDX)B&9T]BHA1]>4^ESPVH2Y40XKHRQG6871(17?4?N2;
;[89gONaVX#c>cN>TeVTCFf_NR6N?Pgc:TF=RZOJBD^<7.K:21aZ\X[-[5YeI<G1
)V/8WE5_e7SQDK&fdIQK]Z&3.#[4R3G2WI-(.09gGT7JN_S:a3]8fFN4Q_(BfPFM
]0UP=\WDCd/9Q=7@G&]64>\H-BHG-:Vab4fO/9C=V#-H(U-\@23Q;@1:FZ.QAJ_O
1W&^@C28Y>9?]?LM4dIJAa2F5.^E].#H,e,_+NX&eDaHTIY=a-(7O;/8?<.59.dG
#F/GE,/N[1CQfH7&=#U&9,W-O0HbLS]_9==:;Xa@Q2Ud5[.WLaKcAI1UPN:;^LA0
0X&-OcVR/+SB7(WNW3E@FR.WMZ64_A214<HB=10?&Y)IZ(.M80PI(M<gDJ4OMIeM
MJ.^0fVQL\R=\U3:.B&9_;>1C[_>78]RacP-9CW+)/]Jaf>)e#QD=;[>d(BU7+6L
c@)0E@bSSHLL9fMaC=I9</JcT3HEX,EPL.;^@YaU#XC4/@e5H>V>19[cX^g?OK+A
:+bBX@a5OeZM@QSKY+cU;OCd2JSFENIDd0@GBMO<JH8K,W]1+8<5O2^\]K]BPWD.
G\S.N[K^:<UZQXX3;EYKgcaW7e_/PL>/ZV4F[=bBeYG19M#^GZ(4=30?D4&U&FQP
5Y\V;&K-HRYNJd_SBQ\Y>O4dL/09RO/LC&X@](P@#&&J,CQ@;8+LMUcg-D@J@2F@
Lc+KLF_3)@TF#9ZO\_@[VCL#E(;<3YK3?>&T?R/gS1VZU?0\fR2X=L:a]7c9@d[3
f-@><8PD7dKYNJ/\PfDOH8PV^@Q)ZV?-D821\@LGGdfc#+cEaC8BU<Ib/1R:8^CH
/&cO[75E5Re[O=2Pf.CAL<8E?ON&76bP:(HI+]@YGR\U]I>cVN#RGEP37c:FcU\^
6,59+OKJ)B^@UBIAU^\;C[D,TW(-a\fL.:Vf(Wc@)N^KBL&fOC9BUeB[eKB18MBT
@0__)d;<8&G1MaC/,-AUYFeLSN59OTdLY7;06V&E6\;R\M)U;?EVSXd\a@_UE4d0
858(YMX2Zd(BU?M8cR?_f5?/>4:JcUZ[dZ?FEbe/CP=,aN)U6VfEd8-Q09cV;8_/
Mc[JY;)2^8IHgSG8\#d7,H1Y(KS(=T]9=Q\Zg[HeOa)8G@1(5N66^LcQTA)DZ:2L
[,#[TF^;IR/EG(.N3SN7R7+1dZPg)I\E#:#LOAa4JYL>VX2IIDU18Md4,.><aIKe
FH&Z4@C(UVQ7V35)HeLa.;8G-G1K@^[0)FQKa2/Pa)Ja>c(\gdH)2QRCSAPA4UPB
=LKDgLHMUEM2673TeFQLS<>)La8S\R<A]1+R@:S]20\:20Nb9B)IO+-R()b,MM&^
a\S0W]7?Ae7a[4K#c/O]?FBM>V5RP\A/^f/&K7[JY?bRH/&d2\E^7?V]#ZCN>:8X
)D^>-7f:O4<2DTL&dJ,B&.FDMIJW6NP\(ga(SGS:<P--BWbf:T:^XB\4WaO7&KQ?
\^/@8DW__55B_1SB@Z63Qe;]42))/]&:QAZ<1K#0QeG0f##LVO&[cNH9c;d@]ZV@
d>#TUSLO[RRO6M;DV<\Q4A;;-EaDbIUb2SRM8/P4B/_?L[O,?2K#b?SD]U^&eHKD
X3G>XfYUF63P24NBHS&R7YJA&R6]3Q]NA/(@@H\70&baGV,S/^=F#;DX&)[SLbWX
<#M-Cg\M8f[bS3O].-L.Y(-19b?5L))MI;g.FZ0]:dB+Y1b3/d0N0Qb^0eFA1KPW
Ke=9)S&U6[>_TCFC+49U.<KA4@[Y&Z64JH:#-JIEI9/9=Q\D[Xg4O?E8=UX)^[bD
6KF)2#?df(#a;f9K-,(c5M8.=]\I<5NZa\2@4&D8YAU#_V,FOCDF>A3TfP4QW[,O
,9aC,8/?[)VKdcggJ;8EA0?5fJ^EHIc+GCGV<#/CbgY5+c4+->@>^+5.H1OJ\2^5
3\;afU+O,ZD(>7O[KN?Zf([d[;V21FeNSVbR1YfUOFC8N_/H&Q(.?]U=63f3I8]A
LQWdb2_2K/(gQ.Udc4@;\K_PP@F&JWTV(dd&;J=TYYA2+@DZd#,e0]ZV-^QTR2ZF
5Yg#VdKXNVT]H5<M5NE;D(0G+J#[W^00:&-BP+1Uec1OR5S4H(F1[F/Lf,aaRVJe
d4ZQ59Qb,CQfa.@?.BR(</(dfb^^]BcLB_OPE=[<B7D46g9HL4N7N#=8=&^&#5IQ
5<KdD,.4cfa.&W9^7,R4eJF].[gNB&N-.[a:TZ.N>61C^:&-50XG4L6Ef?8e:@7Z
27fQ346@_OW8J=.WQ0(a/F8@[R9?MR3d1Tg_W&ISNJM4&9FRE@F9B+U1^Q;AX/UU
a4cU+FGLUdPAf\T.DSSX1]TCLYEKgb-\U^N-5AUV&M)]>&7@LZFL,1,]UH0KA:MH
8eeI<e(@2g@12bOG>KX/0XOa<YA+\>)?f;#4a?.9\:Z@<7NPW_G=@HGQ>,-YXP#8
WT;fZUDAYLX8<2I_B2;ZM(C/Y^N/e[QfE[9f2DcXO>E#LPQ>Jd>A;7WNc7C@:,8+
8X6[X<d)2aH<E6fS,6LZHSOQ.J5\22GL+b4ZX(eE?>[1+AfO-eY,[TRe&8(QC+gU
J->YbX-7P/SXb1Z;BPI,^#NSNeRRgGMC7b=SWdI@JR9&Q_(=D)]HYHW&KgON_\1/
;;>5><]6f?_+c&e/]I<a(5H,,I?B95ISBVXf?6\VE]I.&1(4/^b]2RB+N4QZT7E6
#9a(=&RNTE4UG7[1W>,U1HKOWJXMKSD_Qf:Beg)LV2E4U^cD(c=1>#H28>.WZK@]
P5-]13^6?e03>5RH(;7.7+Pg=ZL0DR,\Z/PRXH^]Z=7?L//#)0(SV^SRJS?ADZ(V
SXUd907]RD.)6Kb=V1TV(^R.U;-E)[Z@^7@,(H[HQZGHV6O(5dF7>_KUY5GGcOa:
FNR)+W;X4;:#03/^;N1)VMOJC83OA8K\7P,S674G<g/WI\];,S_92V<eGM1gg[SJ
f;P_U^B?\D+/a?D1)/a)3b;\_.Q-TX(dTII^Y<Jb[NR&@>/3f1E(>?@+[WVEf[XU
(P=ANE+7^;L/Sc<O5\\H\B8+H#\-#LZZ>]dVZc=WIFKN&+c37PIF/K;XP3Q&eNOO
ZE_)AH5T0P@XP?N_fCS>U\b(\;4N#c3F\UJ/8R:=)9:@&E@b^QEd&c/YGW:a8=]M
EKU->e5f+TPB1Y;9KFHY)Sb0a<dS&^#/OY?GVBT>)>ceU^TA;N^J.RIAW@OD[1^H
D5HXK7//a_R9DIL&BJ:4?D<I6.M\JF(T^I0RA>_D^HUg8V&DaHcLd\(5^D1;&V#;
[&B?WAd9H?N>((BDGV34I=F_IEeTY[Z0Z[B1>AMa5^6?)5R\[fS_Yb5#UO9aBOGC
]dR+G<R#+e+#\^+3V[L(>bMN:Q-;dL(;>cZ&=?O;JXUQaPGg:<_X5]7\X_c)33PS
#7e#c=GCJY91bdUWNWH\Q=&+]cB/5cTT9YP12#5bF)9IYc_.NKZWDb121W]V;AI+
2K1G8bb==\<S5XJGKRU.L-&868LMT,;&(SRMEV2GM7.(/4f]UWN2E3VI0,?Q0(NS
M,KNK_IM0<0XEAY20)VW7@@V3Y^AcJWA.I?5X#-63XS75Z#LKRJa:-OcQYDAS0+.
)<<:P/c&5?GA=)cBUL+)ZOWb15ZAC(fJ)d.eE160NY(V&b9F@H;V>G/^+e<cE,M(
32<<INP.2b\SKY=FS>1,dfGZ^;JGH.A2a:M[L/G-<37RG]2)F1DY7X9<(cJ/F&;/
b5T,fN?00Z\^S7XJ1eG])AC/46R];c,#d.Z/R:G.QE^8UM;.De#3OG8SF[.R5^)f
Q@C&]JJZ1R0KU/3gc@bd51#TcH_L;M[E9348D-&D;U&#Y?Ng:/Gfd&T;N-CAd:gI
PP:&:559[fB4Qg65cF?0RP<QA=PR8(gZgZX@DDN_6D+US]03HM,],4Q>KXC1U)7>
HK&WE_3R74?-FY<-_<EM&&X4OAb1J-PCE)I-\bBO,G5MB7,Fc#e2MDg8Q=2FRS8&
DU.H<9&F1)1@VXX45gK8SLRN)BK-d)D\S6aZ^d-8/_6Z8:99CI?GT+V>K:Zb&>7^
&[,McVA7TWU#=V6UR)Jg.#D:S_XNJZP]f)&DB262cW:<\0WS]M/P^84e312@MKY+
WNJ5M_0/?Ob2Q,-N883IJ#RECUH<F#;+)IIIH)3Y\KGHUA@T,IBKLI;cJ/G)//C:
LZ-gB]W__5e4a8(\Hg]H[Ed7c9,8ZH.2ZR1W[BNFOJPU8U]/>7f?A6J5W8W<+I^G
^IOJ2D5W9<)&SdU<W@:d8UF8e6dXLC-F0P4Q&?-&<IB05YF1Z/&-_FOEHT?FaL1e
@ag3ODef^[;[CP>28FNZUS>;/6c^AMI-3^U=VH2V7E30KV:HWYFY(=;1H+_7.R)N
&8C5>)UN?\?+gca.PLCV7P_3d#:?TQLZ/RT/[5QDFG:3KEg]I0GHZ6J05H(;U@ee
J>F]a5X9\F^7\YG1GCc8,e06EI]I.9&[M3/cIQ/DG@)GP7OF+NE^7@>XPAA)J/<?
R98D,Y,aV50B^0EI+JHO2X+\bR@KL^d=]1;c;PZ>4H>R0PPd-WT4)6@J..7c[He_
FFZK@GP[IWRP?fgDLf_UdHU-Hg_,ZWZ,2_?Z\(5ZN[Z<3LU#f3>,3eK79Fac9cFC
<+>__,gcgR+5FXX>OHL.:bZPdD)^;:-DA648FDSYH#U>EIX;;1HfV7(D2VU-M_^(
I>D6T0;KJ?=X5d,,,+#cDb#e)fS\3M>:e6Vg9T3Y2GL)5U[/F<4)&Y86A4?UA>7U
18PP&3G7M4f<)8M3R=L01E9G[6;W2F-S9ab4,Ab)(TH2RI+8_?O>N#Nc#G0HN];L
H26Ad,>FJ>gBWC3^78GgNR4\RH>.RU>8^8=<#bJMc,KT2-KQ9Q8C4]#-\<,__,a5
1UaEIU5YgM@6H>OIF5Me:3(8WJ2QaV-R[gP^T&]dX\dfR-X(T^J1=SF77>KFP&R]
CZ#13]J++X/Z&D7[_R,&ZGP7?bAUaAbDbSg07^f:26VKV>C\WVX@a/)aIRF0R>c;
/_-A/6[K=]Wef[Q6W#;STT/>d94VT0E3YR+&+;G(U2>c&TI=UO:4/dBH7ERb;43f
)4Z+/RD8R8()0H@fCE9,DE@F6@M)a;XEa&0\b9\:ET):KT.ZS1T[9DMQZJb,[=TK
MI@D93V]H?T+(J@I;F0b03^C4R]Ea:.E66Za6A@M&1X0VI3=2bI<D;QSCGC.b++c
D1aTRA.d>3]c.]K4MP8Qe#gNKFgX#KL/SOJQY9\fB43P5_<^JZU]SS<(2O<(PdGH
N29XBD^+eG0#<C<[5K3.e3VD<Z37R(#=Kf3K&[fJ2(0AGN(L>HS84B>KO=F5,@A7
#RMX^g>ODRC5cOT&49cf:F11P;=B8I=\&C:T61VK?LRA[T6M25=g3R=T==KWG#:=
1.U/ZY1[DMPgg528EIS.31=.<73d3G/?X^JTZG43ccYUB:WE\0:[I)M&PHU99M+#
50VF@E]gFP@A/2A01b&:A#]G^BWM(<:cC]3Z\.#\TNO(JeZaII4YD\<fT=Z+XgP_
NP#FA;;9((F3?A<QP4NN/9Qf(bJ?D6^,Y(8,-K[Tcc;0OBLFTC4f/[@fAD1?TOR=
\a@bNHEG8GSCN;d)A-.G-SQ&:J2KDB&b:_e#S@2HGSD7WZRKQH7>.G9SMD>Q9J#5
ObP5&a7^],?<T0[N^f&T5,DKTQ67_P[>R,=@D,[X]\a4595_FA/L7QE7?J3@AG(b
.7f=(gfQU#Y35Q&1[Fa)Y:=Q0ON^D2/@=8P@P+^/,G3M>GdCEa1P&a)/T>g2-LT:
[SNP/&S0>e0@X?IWXJGV8C<>L4@@6Hg<RDDWfOK=8gG5HJG[-c?.f7NH#/<Y6M7N
^fF1\^V45A:?cI8GAWE&GFDE0?&-3-;RH=.SQ^9H=SdS0bKWY,EHW+[A^ELH;U@B
\e]BaW-NLW2D:9#[XANV=50g<a<Kbf;2W^DGWRSNS5E3J@31ASHb1#XH2Lb@<8Ea
.HP</UdE-/H>BKe@P/=7H-9PaQ+9eS_W\[DgJ2f9J4E\Ug+X4_]HD36WN;TUEEZF
V:RO5gU7,DeU?_9^\>.K;<I+<SfK\f/(P88Rf@\gECK7g7U9DB_5d00.G-I_8SG9
4F(G6I&HN&H<LPdB72d:[c\Ab<FJ2BSfXS)?B9NCMeZR1WUI3A+U6fGJ&WEa:<PS
^D1b_LHg5Z5C6O.0f2;R,>)aXG.D?FWY,9C@dZP2#&8F)<HV9]8Hbc:7>8bCAAT1
(;\?dI@0_=RIE>A1_O\J);3<c^NCL<;^.0QHY]<ED^E0N8K/X;9NZ/Of.bU6CL^@
,]DV3Eg6RFOY0cQ&R?,>(=(9I^FH+0UdGH3:-@?@\+?+b?<4J[Z@FgKg=9F_5,02
.0Y(L5)Q@)WJ^_gO]T<12.e<5VB(0N,(7BYJOYNgOC5d6b:]MYMB-.^T7f,I&0E:
@4e/U9H73RCB3-2O.>J1X[Kf>V18&#H36;4PT.:^#R3>Z/\];7bg/bTXCa1-L:c#
[ff(E.9:FcS36@.Qe<)a9S6+Y:>&/5:?1>4#G5AWFOV/EM<T\IN2A6e-<NMQC(Ac
0@6cR2;U)/g3H\fMQF8EaJ]bB,YG7:4V::;^gW]V,a4Y+?@W9RODd<QbcH7P5IDP
UK:D\-,ZR>];+<6?9a/M/2:AE(LZ>(+;\^@M#Ge\?fP9+#+F@Y<g/S?96e)K+2G7
+cV=g4\X;e5L&1?Ld9:>RG]2D6DJXE[__F=+C-Rg@e@4E2<RR<0.bg8#aRKQQE83
bX(cNH390/.L>W/(+&B#4F]=1=V_<D6a,bHNYfF1JNZHZZ9c>>2<gT79d2c^;86K
Lc(HHUV_<9Z<;R/MDEFa(U3VWf?H48?,E5aZBF9M0/2EB=FM:QMQ5B>#C)[cRYSZ
3I8&O4@;GEW3OAE->,QA7DJP+J.U>GbNa];HJ1=:Re0:f4MIL+aaI<V1/WM\(V:e
BNc>YI<X7R/1O=4>:<9GTe1G6P;Z9+^/FcK1Y/D++J<[=ab>=WDXZ_MHD?aGJ[_5
Tb/c>]@1[d(E#,f(2#C=g#W:+._b]]AI^F;>FEV4,+-PTQLgT43+Y[)7c.)@b,QI
Cf^gb[=?Be&f3aN@M/1BN+EdSB;)]dfH88_MQ</\>T,B>cg\Ba,&].c7LWB[NMe@
80?T81E-_54+>bR086QVW790.238FcdI-NP=g1B?8J=SPV[PA\5>78d@D^Y6(5-N
Kc3V=bN-8M3PNe\[Ce/HB4DG&;<=+VQ>CJKP=#=AHKXP+Xg:b\eg-FS7HcO(/[+#
3WI>Yf2QRc#A<c9\a5B@UJV+/?-TegF=&,)PLR;+>M-3ZZV9I=MO](WQ[F5+#Z6M
NL_:LX=@7S2f25)D]WGACVY/L:ef<UN..G:Ka?(:#N-0HZ8N,AUB\KCQV5AGBa,e
QLe?C&YQV\<T2P[/TI3.DgWF@0Ib&7[[Y^^Kd@fAe599&NU1IB</eDPL1M)9.H9V
Ye:KP@g(7-WBe6.N#1N,R-Q0KT,.(\D=GRM6H94;.CS3OVM<;f7DD0P(/?(A,<)Q
EMCf,ERfN.?Tf;6E=\6XYMB7>1LHUS:]d-[(@WS3SgHL7b(^M(M@Obd?-6Q_N#5b
f?V9,&c2S=?.ZQNI.A#CW?LB7CBKdb:R:QdX\Y2=&aQK7QQ34\Gc(+,.:]F2:?GE
Z@Z>R@H[F1D:6D#YJE(8PDdaAN2CS6WXA,.b0@#V9^=FJG&X37\(X.PM))91AK9H
_166dG4b4JN-1g&NHGM8/6d=I)?Xb:+D0Zg,8@PABf)[)VJKH0>N#:UaI:P\A..R
JeV4PF.#>GT;?#^BM.UQ#g81,[=JP>[LTN-&X,5IPR0f(,C#4B::ZYa2=BV&X/&E
e3ARZ4ed.9UFAPfX,,]A:<g:^g^HWJ1AV<\\8eR2B?g)J5V:dQ\X?bUG7^AA_)=f
)V#LD@<Y2ZG1cM&^OF3QW5S/\T+1:)OcOED7,M4_7U8HXCGE-Q&2RZf5a\)BMBNg
TQ(KN5]B-@\K<Z-]E=/46)HX2g[QU)W[eJE.)+2Q6GG7UXV@#(/,G8e2HGT=KTEf
L>5VH:AH4_GAc<PZ_[/UI^6^PabFFX7f-1\S88]5-B?M5\]gR@U\]#)/U7=.DWGL
1.#;NgA3FbJCP.-X)<Z0f_F/5AAS):fgCKPUPNZQReA)aYJb/c<Z840SYB(BUX#b
LTV77QMST+04ZXg\QQIbbZ<,+7@@LgLXCXN#7Ha/&C6@g7GJ@;V]JVFX?:e:Z0&g
fG^N/cdFME4V#OXPPPSD;_?d.FaIPZ41Z=Hf7]G0gJ)]X<=]W705\?:\8,6@eGCE
c06KY3(L,[Wb4G0>QNG666b5@18eUd\^59J+@_0YbBXgD1Ea6bII1Z2#R&@^HSec
@2N6/JHZ]FJAM\fEASW^CWE?V(OVOKD?X;gA5[_K1SA\_dBb>MFHQ7gZZLc;B/52
XJ5@GC:X_66VbULJ^cJaI^&.0J3RK<TH-B\95;TQL89C.+R@gUb4AP@&@WRgXTL&
2.\?O>@D1AF658HDb=0/,/NaI;N2D;b:C=T:AcH_Hc&=.LJM)>_,\\;Q.V&,0ea]
4=#H1]dLd0ebCINYeLIgGQb_(-7a..-c(09TaO@@ea/G&#?9:geSZMgEd73eQDG6
gE/T[C.3^&7Hc#WQ4+9;@TAT.ee6=b_0<Gc/P\H;cHWCU.YG=Ja0]2=FW-=A6DK4
DAS_CEe@-NKNIWLfaOM4@:e0>8eY[[\G4<eMcISPO^5FY@[&)c&)7MVdS5F+d7Uc
5V9BJDWd2DeL8;g^/HS3GX6)W28ff91G//AS82)Y>NQTVR[b\=Y=UO[g=g;VT[>B
I:C]:[\T2)VI[3/FKS\X3>7/SdKC>@(Ee/dA-gD9HA_O45,08/Vad,5AJRO4X)[N
@9e16b6,GIGVZ1ZCO+WA_ZM<K-DU&afQ#bXSY7+[N>HHC,3I\DNX>3R_:A=cb)#^
JW74a?CB+[]7cXgJK_3]ATe0+Lf5QQ2(eI[d:PJOGI2G:YLT3JT0-B;0[&#:?MP<
d<W#0^_HBWQYU?dN6K508\bN1[A=OYbL]K.WGZ?J:[PQL-TObYfC3>0::P&BPY&#
R\>A.K/DC7RC>A]BP_(LY\W?c^K3>GR>QM8GU\3I9FG8W[2N8bN4@1_H_Z&XdXS.
f-6FUK<2P(<V+cGV\B3eGU5#CgA)c9^\Q1I&WD<@<0_If/YG2HA@]Q[bRf<W-04+
8&a?H.fUcY6SU/cd.3Fd1ZTEG.dT>X=e@ZZ#gIKcPI?Sf3A8&J160\7Zc4cZe?KP
3HE0c?I<Ga++.+dBQ,8;?/O-ITNaC7CRHQ?+ZZf##VC\b,b]N@D-/#K<UL/)]6R:
3bG/f2C(TJO1_#&a@<g6@BP@/4BJ[.VSUGG8?>S:eLG5&[(a]YPb1(6^bWI5bOYf
@[:5Y?0V70;SY[(-a5[=42;GVSE16MT#g[W;L4M29G8[T]?+7TMVOS8O]^;@_Zd8
Jgb>g<>FVNJ3\1A7<(Pg3eEK))CHCIc,-JY&^5?8:LR&&&R6\)(Q3DGA/FX,7VIR
4?,[6B=M7<P]T.TYYS5..=M/SSSXVFL.MVY+H(@2TGTCN\PPbb&@KQ2LM/:M:5L,
X)=4bc6&^@T5-ZO=f=IFD+,YRN0d\82@DU@4B0.;b[1N,F0J#TMdXA)UA2I0M:#;
FV3[:.eQ.ULMb4EK5S+RR;(;LMOg+GTAN-,FeP<MNc5EQ00_A=b[MP,#9AAT13#[
eQ7Y8f4,&#;<,)..PLdK4>N>TI,d=N\,9e8HK1(:G@B4[-0;XC6&0\G#M)_-UX,T
EOM7JH<4-Dg9c>N6S9^:-H?:8T?_eb^^\35J>:\<\]9:)a?A&6?_5e7L5WKV2L-;
1VKH=_&\&B_#f):@11-a2JPO_U2^<)aES&3bUZGe;JdOA=1;?TF5RagBW3S=5Z[e
+Z21W<N7Vc)&?c;CcF>[_PfbSP;@.A-UaPM:<GM6HbgTec]V]gb6-+IZ?K0>\](_
0+T\#G^#8S29FPWUH:Ad;g+@S=>Bc>_IbQ=g_7?5<]19b/1W>fT,I,EH(Vc6BJAb
N?F1<48>[GN8faJGUIX^5#S_E1bMB=8eDR@^V71L&4:EHX,5+]/7eD7(PL(8<5Bd
F7WC+KGK(H<M23G=B5d>E:MDf=.QK<e>INC=\)Df1RYf+K7PF/gcYB&N[2QCY4=+
/L>UEdA-<g]H007NO:6A=g0\1X/^G9g[gGHa^HLU-.FNa_FTGKgU1,X6=CI\MdIU
Z?]\ZZXSGd#gNA(VE-c]K-A<fg5(==ZT=g0H\7]VLPgYV(:ETf,_ea/X^@K[OX5R
R6g:W)BF_CO?C1H@ZgKE=ZX)H];<[6XX/;AEZ>N+T1R?U-+EU1>DHeMS-5d1,HGg
_PI__YK6JUC556PWa;D[b5W5W:IH0_cQNb2R:2b]>RU+42V9dZ\/\c/J8.10:aIb
+MJa36UR>V#gA5JR#4dO/TQ-5D[0,=R9#GN_fT9[]fBYF#?2_)82e&I^CC)<b(7)
/-Mc?:MMa9>@MHO0LRB<[P,PMO-&aeFHI]aLA9WP.a(/>3EFXXQ[<.[HV54XSSTS
,B-;X0VMJ<+I?3\9/cUT7Td5]e;-5ZOQ\#;Ca(Rb4Z[=:L912Z[G+2NOA@ZDfRdg
11+O@T1<0g+EF=\C6;6,.1@bMA6:1-&8ZH,[<Td#b^#_0?0MP&U_1-KB,Y2A:_X9
+>CY/dKQ8O.P@a-RFVGXJ5d0aJ:&PXXWb4?A?f/>.S?YIG2QP<c#A+(;DF1C4N9N
QQbO=8b[I4\0R0HAKS+a+<D<(RLacE9#cQYE1->Kca+aKK/(#:c8AQM.EYce#Ug#
Q(c.VMPE;)AQRS@P2#8<7TbU6;TKFc3[Y:=TDQRWTZKN50(a?-a6(4ZEV23g;Z)@
:.>aT57G>&Kb2HH<DOT1K[&D/#YRWVL(6:)6Y0\GR\:)-X8=HaZd55V_S[Q<GBY@
0&)g6U)gD3(ML54SC_SI#A\_K9;;C,0#AXR);b-T@7L_AUB.)fBe.a9_1=3,)Zf4
/(3YD]:c\?FM-$
`endprotected


`endif // GUARD_SVT_TIMER_SV
