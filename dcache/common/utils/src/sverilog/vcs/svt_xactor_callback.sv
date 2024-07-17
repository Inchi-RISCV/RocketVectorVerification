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

`ifndef GUARD_SVT_XACTOR_CALLBACK_SV
`define GUARD_SVT_XACTOR_CALLBACK_SV

typedef class svt_xactor;

// =============================================================================
/**
 * Provides a layer of insulation between the vmm_xactor_callbacks
 * class and the callback facade classes used by SVT models. All callbacks in SVT
 * model components should be extended from this class.
 * 
 * At this time, this class does not add any additional functionality to
 * vmm_xactor_callbacks, but it is anticipated that in the future new
 * functionality (e.g. support for record/playback) <i>will</i> be added.
 */
//svt_vipdk_exclude
`ifdef SVT_VMM_TECHNOLOGY
//svt_vipdk_end_exclude
virtual class svt_xactor_callback extends vmm_xactor_callbacks;
//svt_vipdk_exclude
`elsif SVT_OVM_TECHNOLOGY
class svt_xactor_callback extends svt_callback; // OVM cannot handle this being virtual
`else
virtual class svt_xactor_callback extends svt_callback;
`endif
//svt_vipdk_end_exclude

  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  /** 
   * A pointer to the transactor with which this class is associated, only valid
   * once 'start' has been called. 
   */
  protected svt_xactor xactor = null;

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

//svt_vipdk_exclude
`ifdef SVT_VMM_TECHNOLOGY
//svt_vipdk_end_exclude
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transactor callback instance, passing the appropriate
   * argument values to the vmm_xactor_callbacks parent class.
   *
   * @param suite_name Identifies the product suite to which the xactor callback
   * object belongs.
   * 
   * @param name Identifies the callback instance.
   */
  extern function new(string suite_name="", string name = "svt_callback");
//svt_vipdk_exclude
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transactor callback instance, passing the appropriate
   * argument values to the ovm/uvm_callback parent class.
   *
   * @param suite_name Identifies the product suite to which the xactor callback
   * object belongs.
   * 
   * @param name Identifies the callback instance.
   */
  extern function new(string suite_name = "", string name = "svt_xactor_callback_inst"); 
`endif
//svt_vipdk_end_exclude

//svt_vipdk_exclude
  //----------------------------------------------------------------------------
  /**
   * Method implemented to provide access to the callback type name.
   *
   * @return The type name for the callback class.
   */
  extern virtual function string `SVT_DATA_GET_OBJECT_TYPENAME();

//svt_vipdk_end_exclude
  //----------------------------------------------------------------------------
  /**
   * Callback issued by transactor to allow callbacks to initiate activities.
   * This callback is issued during svt_xactor::main() so that any processes
   * initiated by this callback will be torn down if svt_xactor::reset_xactor()
   * is called. This method sets the svt_xactor_callback::xactor data member.
   *
   * @param xactor A reference to the transactor object issuing this callback.
   */
  extern virtual function void start(svt_xactor xactor);

  //----------------------------------------------------------------------------
  /**
   * Callback issued by transactor to allow callbacks to suspend activities.
   *
   * @param xactor A reference to the transactor object issuing this callback.
   */
  extern virtual function void stop(svt_xactor xactor);

  // ---------------------------------------------------------------------------
  /**
   * Provides access to an svt_notify instance, or in the case of the vmm_xactor
   * notify field, the handle to the transactor. In the latter case the transactor
   * can be used to access the associated vmm_notify instance stored in notify.
   * The extended class can use this method to setup a reliance on the notify
   * instance.
   *
   * @param xactor A reference to the transactor object issuing this callback.
   *
   * @param name Name identifying the svt_notify if provide, or identifying
   * the transactor if the inform_notify is being issued for the 'notify' field on
   * the transactor.
   *
   * @param notify The svt_notify instance that is being provided for use. This
   * field is set to null if the inform_notify is being issued for the 'notify'
   * field on the transactor.
   */
  extern virtual function void inform_notify(svt_xactor xactor, string name, svt_notify notify);

  //----------------------------------------------------------------------------
  /**
   * Callback issued by transactor to pull together current functional coverage information.
   *
   * @param xactor A reference to the transactor object issuing this callback.
   * @param prefix Prefix that should be included in each line of the returned 'report' string.
   * @param kind The kind of report being requested. -1 reserved for 'generic' report.
   * @param met_goals Indicates status relative to current coverage goals.
   * @param report Short textual report describing coverage status.
   */
  extern virtual function void report_cov(svt_xactor xactor, string prefix, int kind, ref bit met_goals, ref string report);

  // ---------------------------------------------------------------------------
endclass

/** The following is defined in all methodologies for backwards compatibility purposes. */
typedef svt_xactor_callback svt_xactor_callbacks;

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
IM..8/@IT6EeDeZX.)2ZLHc2\aAMf[M/dNB5]-0A6>G@9OO0BF?;1(86:=8?R.X9
2e^cN6\cQM_\4DRTK5f=Z5M)4B4_4=PLHB/]:J]L39BU(759T9E5<NUdT-GE7ET3
Ac,2^C.BdTdD\NH<?e]1a9]f@H\E-a=Vb/\G\WKF[1G(I14#HLF^#,]0+85KD:K<
8])07L2T8V8+8H<9I37.e#9U,^ITT)8F]:6.T&+^1A?CNY9H(KJa4Z)R1VD7@M[3
9.+PW_Mg:+XX77KS9MVV/Z\J?c/4G)+GQOEfUSYb025NFVL:DK\018R04O)8C]S.
,)(:fdJHDQ4Rf3BRX5P]LVKU)55cWaK;VLP[>(aZRMDV15B0;HM&N0@FEV<)Z(E<
@/KUc<NTTY1LIIBf8J>\P.VHZZYDCYFScL#GM#)69[:LWFdfg+_D&/,GO[XaKUN.
T5#C:#A3bdO8.?[=d1+UGH#N]5^de\\,QT4DRX21d&MCJ;:;8T]FTe03O[eF(5gH
)E1W6>U9QO[__C]f;-GUKUX][AcG_<EF:R^.+2gHUBQ7+)B,6AedB#@AY0B_3\V>
.^V>OL#0VHb:_VAGa:0</EZ_fb=Z;J7QPY4N/4]F_+Z0F4CV)5+g_QNNXfa1NE2=
(dG_Od4LN3eEagOa-LYd696[\PILN]Fg.WIQeUOZb5dPHIg]IDTB,J?H\DbG97KB
bF]=f3VbVQP=3ONeac/4DC)^4:dggM97c;O^AVfF]G/5BQ(&N67+d8ORV_2bECT[
.><9K<e/Q,_=-P];4AV>ga=?g>V]bH6c.V@2BCY\UP_B9fI/a0W-GCV1accMK88C
@^G+VP8Z[28?aC>N4_#b7GVF@dQVLb,69OWf.Y/8I.80#dQQe.]NK\\U:VVR^ZQP
^H:S6#;#NMRe)MP<S-FD#XT0LM);.f:/6bD#X0NPA3LCVAd(K4T87SS2f>6+;:ON
282?X^2)9(e(M<K\K[HIQX+&\6B?;b<Y)EIY_AY]]\OB4[R[-,-US@<IE]ZU_:1(
#&#MgW]e85NJ5+:7NS<IW&E_QW\2)(50W>c5_D?;MEcB,=G-ACQE(:+]J:,XT(4=
99TAF4R>EIW^REZa1YWTB[7a(>e;0-D;7^TO7]YA40)>)ZUN?K7=6I:TMDD.<8YN
N,[J9D]L9OgEaQ62YIOZYa#0R<#SA<dRPPbZ:eG&9]2)XEWgfM)[6=0MWM=VN)W?
7ffcGIQ:+EC>C1M,6-g+;Z6VI+RDW&(4Ie#VN=-]:fY,DWR^1g7I8HcaF@Eg<=9W
JA;bES_093GX0MO.UVMV<KEW3<3?a>4gQ03Y9.c_\@16DXAIR1SBQUfdUQP]:Y3>
Gb&L3I6)P]FOPE-<Q1g\9#:=7e,AJP4BeF9R(,(+OWfW063acb5HX[U2OFb[MTMV
)_fSR,@.fcaeA>XYMHZ87?E]WB1KSA&U<f]B?I?1)fIZS)-8CHJ4)eW;Y0[?T=\U
L+Zd=I#A/e,FOC2[&B4MC7DF7DRH[O<>e,?ZP04.L<P&@bcZT0KJV)ZW7)-RYd0Q
1+;#P?R:.JEfRPP:U99ddR4_PLC7[7T3X[OQ.[/4Z60_16,2<\?3E[,Q;Q.T)_;:
<]Kf[7F[TICNA/L<(SJ].O]0JeAA#e25ISA(NN7TY&;]D9A3LH@\6U2]ENaeJgNU
06QY).R;[J8XM4W[.eZfF]T3PJ0ZUHANfM2:>+cMVZEM]9/Q&LXIFZa<;@8DG0[&
E74+gb:B5N&(LJdff.2@6f.P.VbSZ@-2P4/,DB@QRT6E=J1gg2K2T)^[]HAQ-\CK
QGV\KPC)Cd,QKC1&PGeYI\0#MHYAbF7B.2U,V&0[fd55JSNZPKX]S8;D:YW-EVe:
;c@7fEMH[HP@9;BK\b:SLXg1Z#NU=bd5,9CfWYW_e\H5+XN6EKM>4DS@8=9O8^_E
G,0OX-D6Q3++IL2R?^2\^<@bR_8__3a7])..@dE,M3D^+F--aS74A[@\;)P#W#Bb
Zbe0,d2I<C=O:d?RZ:OX0(OB/2JF8VXB#GB5(c\aB2EKF74B3;I/\ACaWEK94.C<
STA)Q=L-LV>R^NW0Z(YLFZ.3=5J06RXX;c/2[@SW)V/Q6E9S_MF]ACb]=7-+Z]QJ
R8CAcPJ4eQ^B[)A7@[bC5YH7[Hb:?WXVL?O5T@AMW2\Q^,-fYG.[E+TPVN)[V<?2
CHZ0@=O,e#>[AYZBV)2^0X2H(W[KM)SE\R8PPaedCdCOABYO@8^I)H[[^R\B947O
\a+;+0Y<\JP\;8Kb1&9<-;8&\KXWe13/W0Yf[+QTM?8.(+)KK@]CQU,QRWdMd6?Y
QcaCf[@NM2M1;\AU9eAPX=DKL[/.?+NQWX\JVSCC_Y&[S8gRS_]HZ8IU3E,>2;/[
?gN\YVX7H/AHc#)=?3?M^)d(Uda:^R@B>+S__0DMaOZ\RSWYE4_1?RR1[?,Z?<GS
3/XPeM;\V<51bc_7N3bBA)NRU4Y(d@930HXcK<@C,1Y=KF[DPedXEEA>b3;A#W#G
&R^54R:7YRFVgCb,?UWC1#NR2$
`endprotected


`endif // GUARD_SVT_XACTOR_CALLBACK_SV









