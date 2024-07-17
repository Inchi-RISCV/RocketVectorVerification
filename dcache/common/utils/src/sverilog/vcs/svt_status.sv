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

`ifndef GUARD_SVT_STATUS_SV
`define GUARD_SVT_STATUS_SV

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_data_util)

/**
 * This base macro can be used to configure a basic notify, as supported by
 * the underlying technology, avoiding redundant configuration of the notify. This macro
 * must be supplied with all pertinent info, including an indication of the
 * notify type.
 */
`define SVT_STATUS_NOTIFY_CONFIGURE_BASE(methodname,stateclass,notifyname,notifykind) \
`ifdef SVT_VMM_TECHNOLOGY \
  if (stateclass.notifyname == 0) begin \
    stateclass.notifyname = stateclass.notify.configure(, notifykind); \
`else \
  if (stateclass.notifyname == null) begin \
    `SVT_XVM(event_pool) event_pool = stateclass.get_event_pool(); \
    stateclass.notifyname = event_pool.get(`SVT_DATA_UTIL_ARG_TO_STRING(notifyname)); \
`endif \
  end else begin \
    `svt_fatal(`SVT_DATA_UTIL_ARG_TO_STRING(methodname), $sformatf("Attempted to configure notify '%0s' twice. Unable to continue.", `SVT_DATA_UTIL_ARG_TO_STRING(notifyname))); \
  end

/**
 * This macro can be used to configure a basic notify, as supported by
 * vmm_notify, avoiding redundant configuration of the notify. This
 * macro assumes the client desires an ON/OFF notify.
 */
`define SVT_STATUS_NOTIFY_CONFIGURE(methodname,stateclass,notifyname) \
  `SVT_STATUS_NOTIFY_CONFIGURE_BASE(methodname,stateclass,notifyname,svt_notify::ON_OFF)

`ifdef SVT_VMM_TECHNOLOGY
/**
 * This macro can be used to configure a named notify, as supported by
 * svt_notify, avoiding redundant configuration of the notify.
 */
`else
/**
 * This macro can be used to configure a named notify, as supported by
 * `SVT_XVM(event_pool), avoiding redundant configuration of the notify.
 */
`endif
`define SVT_STATUS_NOTIFY_CONFIGURE_NAMED_NOTIFY_BASE(methodname,stateclass,notifyname,notifykind) \
`ifdef SVT_VMM_TECHNOLOGY \
  if (stateclass.notifyname == 0) begin \
`ifdef SVT_MULTI_SIM_LOCAL_STATIC_VARIABLE_WITH_INITIALIZER_REQUIRES_STATIC_KEYWORD \
    svt_notify typed_notify ; \
    typed_notify = stateclass.get_notify(); \
`else  \
    svt_notify typed_notify = stateclass.get_notify(); \
`endif \
    stateclass.notifyname = typed_notify.configure_named_notify(`SVT_DATA_UTIL_ARG_TO_STRING(notifyname), , notifykind); \
`else \
  if (stateclass.notifyname == null) begin \
    `SVT_XVM(event_pool) event_pool = stateclass.get_event_pool(); \
    stateclass.notifyname = event_pool.get(`SVT_DATA_UTIL_ARG_TO_STRING(notifyname)); \
`endif \
  end else begin \
    `svt_fatal(`SVT_DATA_UTIL_ARG_TO_STRING(methodname), $sformatf("Attempted to configure notify '%0s' twice. Unable to continue.", `SVT_DATA_UTIL_ARG_TO_STRING(notifyname))); \
  end

`ifdef SVT_VMM_TECHNOLOGY
/**
 * This macro can be used to configure a named notify, as supported by
 * svt_notify, avoiding redundant configuration of the notify. This
 * macro assumes the client desires an ON/OFF notify.
 */
`else
/**
 * This macro can be used to configure a named notify, as supported by
 * `SVT_XVM(event_pool), avoiding redundant configuration of the notify. This
 * macro assumes the client desires an ON/OFF notify.
 */
`endif
`define SVT_STATUS_NOTIFY_CONFIGURE_NAMED_NOTIFY(methodname,stateclass,notifyname) \
  `SVT_STATUS_NOTIFY_CONFIGURE_NAMED_NOTIFY_BASE(methodname,stateclass,notifyname,svt_notify::ON_OFF)


/**
 * This macro can be used to check whether a notification event has been configured.
 */
`define SVT_STATUS_EVENT_CHECK(funcname,evowner,evname) \
  if (`SVT_STATUS_EVENT_IS_EMPTY(evowner,evname)) begin \
    `svt_error(`SVT_DATA_UTIL_ARG_TO_STRING(funcname), $sformatf("Notify '%0s' has not been configured. Unable to continue.", `SVT_DATA_UTIL_ARG_TO_STRING(evname))); \
    funcname = 0; \
  end

/**
 * This macro can be used to check whether a notification event has been configured.
 * NOTE: This is kept around for backwards compatibility -- classes should be moving to SVT_STATUS_EVENT_CHECK.
 */
`define SVT_STATUS_NOTIFY_CHECK(funcname,evname) \
  `SVT_STATUS_EVENT_CHECK(funcname,this,evname)

/** Macro used to signal a notification event for the current methodology */
`define SVT_STATUS_TRIGGER_EVENT(evowner,evname) \
  `svt_trigger_event(evowner,evname)

/** Macro used to signal a notification event and corresponding data for the current methodology */
`define SVT_STATUS_TRIGGER_DATA_EVENT(evowner,evname,evdata) \
  `svt_trigger_data_event(evowner,evname,evdata)

/** Macro used to signal a notification event and corresponding data for the current methodology, but with a 'copy' of the original data */
`define SVT_STATUS_TRIGGER_COPY_DATA_EVENT(evowner,evname,evdata) \
  `svt_trigger_copy_data_event(evowner,evname,evdata)

/**
 * Macro used to check the is_on state for a notification event in the current methodology.
 */
`define SVT_STATUS_EVENT_IS_ON(evowner,evname) \
  `svt_event_is_on(evowner,evname)

/** Macro used to wait for a notification event in the current methodology */
`define SVT_STATUS_WAIT_FOR_TRIGGER(evowner,evname) \
  `svt_wait_event_trigger(evowner,evname)

/** Macro used to wait for an 'on' notification event in the current methodology */
`define SVT_STATUS_WAIT_FOR_ON(evowner,evname) \
  `svt_wait_event_on(evowner,evname)

/** Macro used to wait for an 'off' a notification event in the current methodology */
`define SVT_STATUS_WAIT_FOR_OFF(evowner,evname) \
  `svt_wait_event_off(evowner,evname)

/** Macro used to use the event status accessor function for the current methodology to retrieve the status for a notification event */
`define SVT_STATUS_EVENT_STATUS(evowner,evname) \
  `svt_event_status(evowner,evname)

/** Macro used to get the notification event status */
`define SVT_STATUS_GET_EVENT_STATUS(evowner,evname,evstatus) \
  `svt_get_event_status(evowner,evname,evstatus)

/** Macro used to reset a notification event in the current methodology */
`define SVT_STATUS_RESET_EVENT(evowner,evname) \
  `svt_reset_event(evowner,evname)

//svt_vcs_lic_vip_protect
`protected
H&1@43=ZAeV22a0+fPgA@;ZgHVP-M5GV1;3=U=;D,307>F?(^Y=a5(Q/Oa:.A;La
.LRKZ]>A&b@D6D?1O5GCbSD/V,0/Q1?_&MAG&HcEU=9P@WJD/>bHKXTLbgS=0_Z>
P8DVW1+e=/QVN;B/9KOV6JVW:\dX3-Y5LTP;4J=X^NO<>4UX?6,Gd?[ZAEQQE(SF
c;;U8N[UE_I;^daKSUNN_SBL,VO9O=OV35dK.JW;E@:f[M.Y7A1Q]]gKV#I5dN;f
6Cf9@#]gG@R5+g@5=_G&&=_,>aRJ048TQbc_;MC>2f,E/&W68Z60,fW#4&+2TSCT
PTc=gaa0X,XZ[CdN\+[)=V0Z#TgEb02+9+E\e?@9MYfC\&EI:/;8B+,I,O#P2X;0
_OL6L7H7K9.<EbW;e6NP6_UBQ+-+F+f3UELbH-1Z[\N]8g]a-H\&bD/D;J^0cL6N
H_>>?fH13L^0:)5NHGC/]JQJU;g)g8R2.GQA<KM-eGN.SY,ZD^;0+[<;>098ZK,d
&71\WT+X)b(J9=XR[Xb27J[<6C(YA>D.61M9VH?7[R(C2IdEKY+N9T>?:g^+R2G;
e69eM<(@-&(L.LDPg&Ib/VH/066f&)@HK\]HCafN3Xg\@bIRBO6\<O1/B?BG1:#=
,H:6,E]1c9W&>ZTZaLCMN>XQ]S7_D&@ZB,2AX>R[L3SG./23T18.RbQOg/AM8A+S
V],.aKYR^4Wd<V3>I]Kd]+@2eLYcVU4-IICI+OeV^-gH8Xg#gW4>[-3C\[=S20A-
+81Jc^8He[MPNVUH>A-R_5@16IQN-9G.H0W/[LcFV&8?/\eB<A8Z+(I)S+[b)ad+
BUMU6]c1M6YI:>8Y:/a<:UZKWCE#>RDV2)cICG,bL\c,R<C3O/a&X,Z?d\D)2&LF
/[W(cPN1Q4+R)JUF36<TLA\b2Z6AU=IdY;2XO6Z97>Ob\R_7CdT/(/U?ZQJF<>Be
ebVdb^UJVV+IFDL0[E9WYe(B_>cd4B0F7<8I;Xb[@4YMYS.WQE5F.d-J.)C]??M^U$
`endprotected


// =============================================================================
/**
 * Base class for all SVT model status data descriptor objects. As functionality
 * commonly needed for status of SVT models is defined, it will be implemented
 * (or at least prototyped) in this class.
 */
class svt_status extends `SVT_DATA_TYPE;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Used to report the Instance Name of a transactor to this
   * status object is for. The value is set by the transactor to match the 
   * Instance Name given the transactor by the transactor configuration object.
   * 
   */
  string inst = `SVT_UNSET_INST_NAME;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_status)
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_status class, in addition
   * to replacing the built-in vmm_notify with an extended svt_notify which
   * includes the same base features.
   *
   * @param log An vmm_log object reference used to replace the default internal
   * logger. The class extension that calls super.new() should pass a reference
   * to its own <i>static</i> log instance.
   * @param suite_name A String that identifies the product suite to which the
   * status object belongs.
   */
  extern function new(vmm_log log = null, string suite_name = "");
`else
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_status class, passing the
   * appropriate argument values to the <b>svt_sequence_item_base</b> parent class.
   *
   * @param name Intance name for this object
   * 
   * @param suite_name A String that identifies the product suite to which the
   * transaction object belongs.
   */
  extern function new(string name = "svt_status_inst", string suite_name = "");
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_status)
  `svt_data_member_end(svt_status)

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Helper method to get a handle to the notify data member, cast to an object
   * of type svt_notify.
   */
  extern virtual function svt_notify get_notify();
`endif

  // ****************************************************************************
  // UVM/OVM/VMM Methods
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
][RNQJ;]\e83;@-EI[82_?eS.6QDB5G.7<@?cARb::_C_SHAcE93((SJ^?FX(I^U
8AUOCEA5=_EaIQX]43F_1VRPAY\T,;7Z?I[EefggQcT^7B3/(DeCST7Hf77]NY9.
B2C6U>CI\\UebL9^fUB](eOYP:0:]LW8DXT@.?PR80_CX[=4?T&6LDC4c,E.SA(-
&AP_R25:QX_<QU:>#YAfa20bX4@F0:.fLZLa-?#;@;?(QSgXYS-]PEcaVDUK&,O>
5IK9d@@ZQH.SBZ@LFI1@Q<#f:YD/.@EKOgff?FRX7]>KSd[],MN380O1e;SU:QD:
USR,NOe)YP.TO2[N8A-+N2YB,:6fVA_Q[)#IF)OAACg6g,8DDL#f-f&>>Hf_#<6X
#C_.TgE/ZH(M-\2?J..O\R5cccB<WNQ_V=Y;396+T>a8T<a]ea9]A3#S[5RPPSQ<
IX&SUU6RW08/2BQ,cbFF[XT:)4,.U>GGL58V/BfHcgM@[KR/0I4e(eb,dKgD)52B
[AgS34UHZD)K-:-HbJL0\2VDT)@<B(Db;Z3;R>68Se2<T6@,(b[&563BTFJ&+##[
FdJ&E&F72#1F-I>0ICKC(5AU(P1Q4O2LF]_G7=/@2WQPD<:5DEgd(5)?H#]E8+VE
\WD/BB):#+P\.bg0DPO1YXd=712VIe\CB=?O+cTO5[Y3aK(\:)6Z[<gWEUO2?Igg
/CU>;1^NUX@6LfX]+#>:\1H7.NIb)H^[I/,H#UAd-)TKR+c8c:A7TVHYGV)6a4KA
CR5@<cX3IT,S&Lb>8OE,/JGV#G5+?LH4D=L,2+I9AB-+@Qb4aAAE?,[d>)]EU(N;
LR>R=91JO?1MXIf_.fB(aAaXBUY;W+g#;94^:dCWI#UI\>@P>5<[f<XYN6McRc83
,@G[WVKW1(.-\d78:U(6O-XU?WHH0fCHd>^VS:-1\S_J=\fc#211SR]AIF>I8@;[
fELcT<J?<;)>G10M/RP[U:Fc=V&C/N@@_;Q/3=,SdD\B#C)\5H<5eNg.A4-/fSMI
Q\J#GbM-gKFG=DTO,ZH?=-e=c\>U04WHb?=+W=RJcDaeF^C2HDRY0B8Y9aLJ9+GG
Q3+T0>_6V;&g@L>a5GMOQ[/e7O-/2:RSb]@26,L.Qa/+NWf,+J,2VbV@[?6)A7V\
fC9.(+0-Z8XLTeE3FQ-CW#@D&b,ZV[/]U\?&0Z&/].]K#>[8;8KV3gFFPNRg2R/W
N([9JD0W;)U6OU/M3KVaG=6633[6],TMAK3?VBDTEE8;6A9E^)#a0W.;X)-a?[+V
?,V4cagXHeP62O[TG6,FPFJL<?NP(4a4c1S1GLYSTD0YYJ70;13f,ZUW&/.W2&\-
LSGHb,&SP6YVH]?QfcLX)+AV6@A.R.gKZ1YbQHZO\b0GO@&<]EHV<@SSL69L,(MX
DTGB2<=ID9D52C?B9#B[=2f9LC4F=O-U1b]8:Tb6AZ@KM-DA-M]TZ?\MeQW#,0XA
Y=>9+9=S5XCYVJ_:JNSE&b@)d<\IO@N(3BK8DgRF#&]36#?0bT/2?B\WaG<FaV1g
75]@<cI#d_LP=0,F-M<Ca?J,1[Q&54>X_g&UAeC@\3\=CEY3U&><_44;Z@6J&N;A
R=J^H<6BUPJCS1TDP/ee&7FWT.PPG(99^bO_bA#S15BPd1,BgKFSV1c<4R2L+A(@
<)d>I&FaVGe[R/9XB#^5aI?38fg7#4OPV#P@3>U#aa^J@T@9QX1)C?.Fd0\WPe<P
21)Z5e?/5OLIOe<GB2NfS\IDRB>BO2M)V526Q(0F_=DKL6bDMUNY:5><<;CBM,Y4
ZICS+TTA&-+IN3FM+QU4#FY3-:O:SF[)3S\fIO;7<-Rf:CE\A]ZWWdJXW/3Zb+LE
0ZDCJc53_\cG_J<FA/5-E_0^9L]L9@J4eJLC+&R&MYY(<\3+?DY2+a\af<Bf>#7^
9PZb]OE<#>f-Q8M-abOf5:54)d1]+5;6;Y2X;/3NV^SF^5)<V;2QL#Y)bbSU[aC]
15E2&L5:^Qg#>:;\dS?]4QLG)VJ]]+G#d5R5ab6G4JX2=UffL\OJPQT-g>R)G3HQ
Z_FH@_OZL3KX&-;_Q@>GB8W<0\H6XF.PGg+;a:[Xd<SFY(?0;L;8gNPA&_(Ud2DM
U::](AX0GZG.I-C^XZbG:5c3=39R2<M]M[M3EHGJg):P:g2NZFXbfA;<ESGJgQ8]
JH>G4D\9g]XUATVMUUScE>e9JD@P\&ETE:RQKe1PPd3a46JR\Y1fPYN_<\Z)4YR:
@<bZAab+)3XS94Qd[d82V<3H+)W&c?V2G0c2We+[-FAfUXP)0Z=]1;H==MEW9F83
LEH&3?UU&#6c<AA:g1R8B&KH55e^E5FAQT=Y;^^TFH6O<9EU^dC.CNcX=<O&5W]C
_VN1:/N,d8eUR9PQA=56VHRIUCUG2dZHS7];V@YTZe_,:3XOcW-RVPbc-#]0Vg99
_]Og68OG=01Fa?.DIF?Mb@1,X(-O#^>O5TMSNfd_fSCTQUU)g=?-bR#&A[,b;64.
2OB-edTDN;LLJ3#CgL)3E^J^cGf[#VGUe-dc[_d+4LL[b15d[A:d#8B7Ze[,<^M&
4?AK&24#UK/MYb&H2A81<+ION7:cN7Cg)3.4@B1>E#]2RPUNE_=V+:?:&+SSI&8H
7fEYKOK/WNc(^D]R2@N@QfDUC_@D4-@;KMYeGY]NSaeOWVWaS0>-25fBQ&f]M8YZ
2H99H_#V&/<;NV&GV5c_:\1LL;XB@:c/c9U/\]dNRVMH).@_Ff(DJ\O7O@0QZ8a]
=f8M/a<Z7#&OLaab4Z,CHF7dTb?7B.J+GO\6=f2CF:#3Z=K0+eXTMFS5C)0<P>fW
O^WNNNgEU+afGGI1990)HD3&[V5C.2H+[aR.>YP0<NRXS&;6(Z?U&S^fYQ1H^6<H
Wf2LR<-(KU,<T5SG]cWb0U6=6R,\f2D=265=\&DP>FB6+2B+9VO2T.3X3fDEOcTA
MM0OC4U5BLCDZ2)f5c&PDF=-MH4QFP9-CDI01GUQPE/HFCc3>6@)/4Vf;3D<_#Z9
U8ZW@VM59?X=S4;#SR&WaOc=S[=9@d_6N#ScYCUW:bg5(^X5=-&N^R0fa;>YZRM4
<W\6bZ)+\1MG_8FZ6B<//2fc&[a#:c(bc)g,G?2[Af179KJ6WC6+5XPaA,(gc?YV
VE#//2L1L8YdS]S/\3=K2=RY<W0:JUJ_R2,1eP5ZYaL#&GN]>\\b/VYB@;@^bRf6
LSUP;S.0N#&)H_VRGbBV,(Y4c\KfC#:0M)gca]J6GLg@NGSL2CdKX:>I+W[fF[=H
<M,7HKbca95?S<V4B8-TeGc):^>R0?RfI,2_)1@(;H?V4.3;4A-LgKV\KT1_I8FT
4W.SGbe[-aMNec_LPQ#[F1E^#.M#/(;>b6&TeI(NaVXH5HYSS9]eY]2[2Y+AQ:>_
>Z<E,S1675VBP031FR&9+f@ega\[[9dMaG[=QN\2@f6e<R@[DDZ-OagT7Yb7GTa7
+Q)^;#AW0,eb:DKeRP=JNLPI;W3PDNIG_+PRLQ)S6E+20&.:@;MdP.3NXC=9\+,.
(fHN/:.c#8DR_;U5DNId)f[IA69=@C@/TL1FPE:@RQ\Ya3U:P&a;YN1XE@\-<II8
DRO[+DW.MA\S:<e@;UaD1S6Q+#M9PaK;-SZ&JK;3,0\D?UN6HSH2#_)W3Ie23)-:
B0+XRV,&X9U?O;]#J:O4M2+A2?::.E32.&J:J.C_GHTTW,)<8BcfUH[-WS1B?ab_
@+)/^I(.VN02\P/E[J4]7#M,#I8ELV=d8-a^UI0d#16Z<(,AD3+GKAg<[U0/FH[S
2#(=cO3IW9#MEXGCKL.YU&<4,7,@Ze[_1_f^,2GF)69ZCId0N7[P8&Oc03eMFGf/
AS:+L7HdP,<G8WEaQA6+eX.2/1HSXMS-.VNPQAf8OCZY,T0K9<O\PD_3IQU9;UG8
J,Z.dDCWg-J,&51c(gAJDX/NVZcEBg8_H-(YO/1LC?#E71XcHANG8<^aXQ]U+R.>
^-/I2R_-&b7D&VNT18,2?>)Va_f/1@1)L.Y<aPK/=1&[6/]8DF(Z\6B4:VKNW[))
>>@KgT#P=+=A@B^SPQ>BMVg3R+VTe@B^PJI@)F+@U?<#+W\3&O=8_>aX.IbG@?CA
\QI1G0Ye573<7aT;.<WZ(_<bY2Hc.<-D&^&dK_(ZfC@BX)d>5^bg_ed5XKf49AO[
V+N^DF:U2S,1X6KH\Ib&B=NZR.?8OQ7KD,9,d0YT[>6._M6(9YA01@9JY\(L-73U
8X98E)_-\^cD9H?7]7U1V:.B<8-W,U@G#Dg3=)g,2(P2@V5LcMS&9N[2P?>^_,77
1O(ddV<E46J>1b]50?&^#]d1Y<^#fG;2[AX90=3#SI4P5+TfQ?5M9PWX23?F8;:O
,>Q5=dUPB7+Kf_\H&;R^3QGX7A;61eO7?B>(f=1#R<+TUOY4e)F&bFadT<.;KQ7e
I1YAfYB@HH4]-0174S[0;4:?NcRB]Z-00A)d&+KSV5HcCB(?A0fGMN:W1S/2K6#;
c18&.QRaPZ6Y]=+@33HF+]OZgU?&7YBGO]+]:/M7E+=0BG@WRV2df8Z=.#6H+5HQ
^9:-LJ)I#,O_0T/6LIIL@M=\V7WDe>WQJ1e(=HTPE=YaH7EQIP>-T?\fXU[5W1A>
=,H2Y#Ccg+]VFSVD]C4IDPL+eKA,af\3@ZP>U,gUC2.WJ@#VH+PDI)(Lb)9)3OP@
^gHQ;<YD]:(dT;C:\#8#47C]F;E0?gWP9Y,T+CTV#\I,/Z+D)f:+5M&J9U6Z,c2b
f0L(&B\:&[S1cG3=]K#MJ0Z<b],b9V=0S02<;G<g9)C2[\\9a,Ne&U=Zf;geKf]d
:_(:.baN/F&:QYM71JHb<0b/^IEYXE?55EF^X>=+D:2bC92^\@2)ZRC2ba:T9,40
H#MH,2W)ID#]F0D3ML(#CC=dS8b<-e^,AD\V/5C4bOO8&U3;gABX(3>8Ug:0]Q[6
;2aU]9[\2feMLQ2_b_a<=f;T/<T?S>G^)0;7+IO1H>Re^/V6M;&H(W6,eB@V(Q,O
SJ&UI<[YZ5B99A>[/B>.3H3GW5/9JK:TDV5[R2<G>g1FHUL+?(M(DU&DeJ29cTR8
.X4I<&>X>>]G7<eU<HVRT\XQ)P&>Z4&Ff43FGJSZ82?;6aMP:aE0RL+00IL[KYT^
SW7?OVe;/)T]1LJ,F;2<OK#da<3SB1Pd_cLWS;K;YPc[[KFYZ;L,LL]R+_1A.V1&
Ee#(g07R(6ece20da:6LM47;]g76<.<J&088eS7I5;8T:<)^]#)f:,#;CT5PE+5c
)5MF9F2(Z#:>HOFdG17OA/1V)e&W/#:D??]a3YfSRW.6V1+VN]6),TNS+PMJL9f^
@QV52;#fdO4<-OG7H&V[AC0d,/UUE>\fJg0?LET<?DCdWHA3f25TG:>Y;[eKg_e@
@1f#JH<X0bDLH-2DSQV@:J50bW?)C6J-Hf&T57G5?LP;E?cGG7Y=e=\7^]8:L84V
Tdg:N9HDW0-UbWd4b,#W&<:R=a8ZOI\=9:EOA0fJ6-?A;(9L)>DeMG?4Y2[J^,4O
<d8),f]&F+UY>7:)=8e,NCLZR:\JHa^#5JR?d^]:fRfCe4>57aUa>D.E_DF2AMMf
\Z:2\]QHLdZYDD3#:&1]YZRX:>e.].XA6<;OBY[YF>Y5dd_O0(CHIWZUP^IW]A:/
C1Y2@V#IQ=)G@4;+7VL#(f)\\OB_]NJc43LcISM+V_WI:#<+AD.&.OB97[AcHHWU
@/6#M1R8ZPFYGdd:WNS1g/?S:42[(.D&&SB&,e[/]KJ]S>Y1Y63#@a+6ONC#B-WC
gVX(_RWNCQTMYC80Ld3,9C_@7g48_3=c-e6Y&AOe;IK/gHTCWf-@11JQS1NTS>CB
T/?2FOKA5RA<JEIZK5U4R61[<;WHf]3_8CaGEC:>A8d;b9&O9LD?9=F[73d0IW3=
3@UPcH@OLOZJY7GT<KX5JH.VO&J1JC[G)bZY,8cKQ?G#-?\^=BN[MAGf83E(884]
P-7J/]d&NCA/]:?IH\37CW&dKI@SAOR=85#X]4G_XUR<3MAO@KK:&Y^KO#\3&Q\M
Xe6+WF+<Pe(QH3;1FQ32LbQ+J=<fD9BZM4+B2,)d<#IXOB>VTLMTaR_>J-_)D(ML
ZL<3#>L[]+a(I;_caKc&Q#&H>6@eZ1\=0FKAMfb;1I.&DSO^dfA2)2?@+-MFI6+[
-UH.F3Ca9&?J2YeQPb]gFX:.e.MCK5<18McHEJbdR#OD:24e)[7gQ)YE0+R_C9Y[
.IRGET^80]Y@ZfRWg5ED,fSZV2_bHA1&QOG,fc0/:-,^>OZ,3EMLf5^/68R,R)<B
b8>G2D,,(Ec]8f(+:6^&2S.g?B4,fRcfJF_Aec109\:Y6]<;XU)gbg\2bd0=H[d^
bU7?<f&Z+IZYPA.GaS3RR]9DZ.>2=(@DI-RMbXH2&JS&L^BU80&U-a-Aabd9/)]F
CB6BeX&.)>Uf\/@F1FUH8\P9MV?99&B:@6F/7QY)SEXeL#d5MD@O\=aCRV/F\,fc
)H,Gf#G_K4],PR]A:#BHQ;^=C\DagE5Z5e@c)&E[DQ@DUHVFD:7U5N:T+^(_V2aK
Y):/?1b\G6>a^cgA7LK77@8#&D>8?==2+8-9-f9V(W;+c8g47?^=PFDGBa+N>DU[
=f](-6?C#H3S68E<5=bTgW4K5Va#&9#(OV4b927SWU1aQ+d)3Y6^0YNDCLFKM7RY
8D&f/]_7(]#@89/@7_-#]&;+#SP,#e-TTcc+/TI6GVB=QF-9&_8F_I3))8,@1QfP
A67[27X>P6)6]>T&D@G]2f8a.c?PGaF\BYGF>?E(-FR1OB,4^C:[N>P]DDc\N(GV
\La[BWLJL&LZWefP3-(Gb/L4?NI3,Ha7AZd>6dO0;<;L<+FTg,^>8A/I3@]7M4^0
T)TKXHSfb2G[[La8BP0AZaaLKbIe[+;H85Xc^bZ1Uc),89TM)SQ14)[01S2^?c//
JZJ8#X[L>4MB4+<K6@g#;Lc?e(OOD/?#.3BdMW9GPXKD<5E;L1&a9@?F8+^\cgaD
>HXM=CR>HE:Df@Q-@6J.9K5_.:X]>)8e?g#+3Y<b1U^.Z0VaH8BGX(#/6e<DU?\7
@:8O^aZZ,]bWV(5>,PV&,FVUPW9RD@@[:BO010\P^4Tg+=M]\W)C)aYXc3];T0d7
__4e9IGeca#fcR1N:eP@F]c0eEM4XX\J<M^=)-c=)2>HJ&[\(bI0\H(>3;G6>P25
^^\@>/,TIBH(E.edbbM<bN9]KIPc;9LHVad/SU.M#+?RZV7D;4Y/J1?B@B7ZU+)f
:6?^_M(-.26e?I5,BH,5^4N#4>[K=S[a&>4cEH\N[6RBAWNGKX1CB<F+VZGHCDLG
A@GHV#dI3SWP6/Re;UH^>ZN#6$
`endprotected


  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
NI:#7.#]@@854-c_gg5ZY4g&b#V<P<Og.]gEcMG:T:N6Q>4MM@J61(.&RG-6-9:5
e?M]3K&,WfISIYIbA.LeUTX[eACdB2,c3>^]@XYd&][=dYN26>EN@(FQ3IHH03,(
O^f3WS+8d=7Wg^4;1\,Y<Aa(T#GLB\YGDDAgFBABc/CBG=^TQ4R:PG,MVR,&P;2<
BY3GR3=.B+R=;=f)cNbDdbD^&Z3&OVA,ffA#:E\9S)C==a-<ec7G39^,e3P]AE^=
-O=8#>Z-#.@SNd3A2b,,78V4CNCK5L1G12<XEP51#V1UPBJfaa:((&CBbVM@_IL6
Y1KdgQD.HB2JR4&67(1[CIW+4J==6aaHY))dJY7?ZY[+;NVgaTV6XATaCKM78JU9
.X5-d2O5Q/+fgB=-C[2V+N5CZ?X8<=)?2D:U>KaaM4HI#/.AIO9E>Nf\:c.1>]-R
?0.PS>OP;\IM,O:(EQM;\6#M-K:DZB,Q6XTACb)PMBL,.ZAU9-@L<FN)B/EPPCQM
</3,Q>NW+<3(7QBZG//LSRV:D+S->Bd8RbFL=&6&__.AfO.I7ac#.G30#BP2XW_L
9JW])\S1H1][2FaNX\F[X^gEK2LV:O96_0ILZ(S-[fbXM6CfBEHN=N):O?_8)MK@
Hg3528>)-0#OZ/&(6]+fBPPF/Fa?V2DVJ[I_V-\ZNY1Za#EY4LcV6?=Vc53D@TN3
/g)Bg;H.JP4]><B[=/Gd>>:&HX8VO^(C[0.c<^C;\B\dfH6ZGR(JL5CgcPH0VS9N
G+c,D==7fHA,-JH@;^T+3JbD\S(?J]/]_0WTFRL##-)6>MJUJcH6d60F:K63<\CH
KVSIMWH642g;+Q=)bOe&Pg@\9gQ61^f^G7?>Z1^#ZYeNGB/?=RI0X5ZDH15(HGD5
&NP8Jb9<==5QS#_G7PbH[\O#V5:9bC^<ZSeO&0=CJ&F?H@&6CJFT,H);I^]GNAQA
I_+7\V/d\,I9AN2LKU4M)P>f03KJQUfEH/A#^gCA_]C=@^VZ\BX88(_E78(G(<Je
^9Lc/_O70&ca4U.BdT,5RaBQHP12ad=1=GUc?Xb4WT/,_7+((cJ;5H3O^UQc?;f\
P3Sc4A5:)]Ze[>eJ>\c-<DX7CTOQ0:dW=IRJ<OLa@aa<M,E1(MEf7;e&^8Y^VL1>
&O5AXUIa>Y^&2cKZB0CcLX4/,IW]cH9Z6MIA@Af4UEe]:R2/9cM4g8bY<CU6_c+A
/G=&F.-4N]NgVD_#OW&1)aU\>L,GJZO4dPY9?VM)7JM=<8N\,C2;?bF=,X#B-..B
RU/,<=U](PN][F981C(IS<\XLUgcRO@1EVA0(_3+1A70L,IJd@D68>:I=70\KNP)
(]Vc^8O\HIIJR-\fgPY?>g]f&^2D:[7d#(H-REL@H.<F@eGf,?T&=3R2;9dgZ9QF
&)DSS/OQ\U7ORd^/Jc&LP:g71RJe2=R;M_HC52/32^b)+\c24;4R4F=?8_SHa4=S
N6V?^V6&84CC:.T(TZ=T;VEgec=T)23XWT(GU/)A>71V6)W7^CNIfIbG;gfKO0^M
QEA@bX,0KW72.,dV0.@a<JA+>a:LJ88-#G5._Lc0,KAA=_):O<\WMNJN,IVe2+IS
d?)=bY/9:-EOgUWeHHAQA]C^N0=fDaA7YGc>RZD?Y=7WSJ&QE#fW&[:4VZ_Q0Y&U
;\\/gU;UNY;Va[OG2>,@9UI_3(d_aI/5;/SFK-8R08S<7_K]L#Lf,c/P+1_eL0=]
<YFa703b33<JG(T;VdeW/9,Le@HKNU\O]^X1Hb#C=[P)7Be)/gZ]<)ZZ4/RQ222d
3.=YSa8EfCdR?1bQ-V>bQa/7<8<]6T6ZTd6Edd@DY@cFAT-BRW>-0T2\F2&SDZA/
58@Ob1^>BEH-]?Jc.N8=0g<<3_BQd:(]):?fIA2Z3#E6/S@>gZDZA_L3<2Ie#_)^
B/5:(P1gB(H29/UL_:QD9b8gNF_QI7WBF9^7/ZLP.].BDX+V6&VXWDZYT_Z:T/X&
^DUMdI.K)W?\;ea9?@/9f8XQ=cfAZZ7JYSb;F4S20W7&]?,/<S(TJ6W0A,@)6U?c
X@;d-YE>W7MCA[&SGACC9<X?EZ55(^RU(=-XJ=&[@;0#B4O0?&?I8PBG=8Tb0YbL
g_=XR:?.TPZ3=I<OF7S+A?89=L2KT[^H637Y?<\QTWXBJZQbZ]CGJSMY.2f.;ERG
;=\WV6fBT2bE9<>@R;ZS9S5Qa3FYeLD5g@B]_RFP^gGFIbX[1XL+g-J;X1I5J@FP
=(.OD^]K.W:,ANJb+^7WN\ae=cS-[a721EG(^4g1;F.S(a@?[P)GLSaB=[(;Yg0=
TX7f:YHHA?[CQ4(:GTJ:7#.-NQ>c\@SNE==FG#?gMLQ.6@HM/T=:;)E/D^gA^??^
CTe)J]cg[+1gU4BB1BMaX9E#?_Z,eIYDX)#4,T<K,]eDN2\4_ZE1,dX+MBVEgK35
E#.=A,>AL;_ee7D,I\d]0AP/5=8e[VfQ0<3T;>MR.9fMGTR_aa0N;#\Z(LK^2.2Q
=.WF_#RKPY65F.A<-NNG+W01+D(,.;;]GcD7f[B.;/e]<4XYB;YCQP2(SAe.@,P2
S7Y<409Z4X;>>-LeBEH9\aZN=E@5ZVT0f>4@88_6X:SJ=+N>L,(YeR>5[/71J^0e
2@XgB^1X-U:b\3S\d]XM<N[Q#IV5.X,#B0([b/YA(B]#O6KJ.F#0-BB]M++@#\?>
;\TP66A_C5,DQTQ3J&9CLaMRWAec(N[(D/9CVN>-J3df>7S/+Z3Hf23I&HDG-J(5
/SNDI\HObA(^(eCZ<D4]UGbDF@M_OT[VAAZ7a\[ZPUgeL_9X]M2.>GP+B81K@<c#
cJ/FV_IPaCR[AI?(GZ:VY?SO5(X=a^4DSdTVW/6[6/4#4Dd_O5Hb?<N9)V#Z)ZOZ
+\(V]01,[F9a6[QfFQZ/=3V+[4M\)D8GO5>gM1&,MV.f.Pa)[FST+\95P()BeUS[
@)K:M)-B8B>OHGVQM+eM>1XfG?a4+gfOOH5X=DSD9\UTO#0a0dB]S&W,dZAG.>V>
WQd?R_;9@PJ5&:6?LcQ9@N@8FFBf=M?O&.:N0RQf_dC@D2cV]EL::#]I5.0?S?@5
B)6E;0TD0<&)e()Z?dP3\A[E=3-fXK<1A#MCU2P6K)U&B^EgWLfg+_=#AfC8f<-0
3[LTCFUf.g6BUYLA.I#J>MLX,[HF=fRLbAT65C=TPU+1gL_O3DT<Ed=?#WD^W+RC
)BcAcV#6&<4H.RgYVXCfA/371[=IP@+dX6dM:5<1T2G;2B-FfA.&-<11RH_Y,GFK
:SO?K;-&d0PLAL]-SX;cRU]Kb_VYL[RCKUK9c8B4_9U0#2#aP^)9]PY7+Tged\)7
T96-d?4B:]4Y]CCIIX^5/K?0J<H:aCUAcT,=19[_>T:7MC/LP^/SP+]V/I8,-E72
<WZ3-[<28g7aW1=:1Z)>.D40V;b0[LH&&1P&Q?,gOAd.Z+AYP/])a]gd(D,4HR/\
Y#CL&)2\Pcb<X7X6X\H>IUZ+R:><)2O6^V0_NRO_P:^C\G.0,b=HFE^,,A+M88?g
LREcUbLHATDf@3?@QWTd3&HL)P3&9a@4Mb90<)-XQc4gIUM[.HH#-M<#&(KW&>-d
?6&,@.(#K_Q54;&LI2\c@aC5-TTdQBTBW,EPLU7gK40[RLWFc(YbC,[,64C1LbI4
:d)+=BS5e]-5H)f293^K<JM=d\T>EeHQR55/+Z+E8+(R1E<D#UPCP1E:KGa&,(&J
\@^@YH_[4KD;AO<#f/DZgZd5U-YBTSA1,U3aX0(MEc5KT#9<0^>.&E5bP1PA(==&
E[AMJ?)_aAULX\2#>eBML0SUcO90S&gPAA2bO=\_SV^<@V[VV9Z_ILaR8DMLX]/4
f/9H,EOJ2P^=#dQ2SaNdSDS+<e_\LOYQ/0XdddSW27c0I&eNA-6VRfKJ=K5g6^#,
\G/Z+BW1d(EgcPA]]DIO<.c1=Z8#QcBbMRg-dL]=@Jg(S(?Wg<17>E=GXQ:-]Nag
Q:9@SYe>Ne7\]77g3OD.60eg:7=C\?(=b^b&G6M)JQeNMefE7fA;TEAL&H4M/\P+
.M]_58:TX2FO.)[A:&N#T\MKKIV<B^EUDF1X9_<7R,B=H-a45GTaOUeT_E<=eP)H
c1.^.bcX_YFLB)HVMDec2COFU5WQfd]DYN8[L)T6>#A&O4PAB,EEOEK3Z3=9:e22
D:641R.QKSaC..(3&U\=/e=ZfaA0f+Gcb35>YFeVJZecFQ9O1=VBS2;/PFfSc1G^
Q;]&#I?NbLg(F&ZTFV/GI)Y5cB4=5UF-EC]NW.Q.@&fd+SV.^23Zg:S1?_O)..dZ
fMYZXAHMeJ,NS<,8YNa:T3Ca6c)=)LA]76Y7d+/bFg4+fS3?W#+ZgX?=;e(Db@=?
=6MOVYZ5c0<11F4TK..36-5Ce7\EK,B@=1\1,X:BR+P@T7FcY-[7&4M^GSE<K,b+
C&(W3\g2&;ec)/VE5H8AIYQ@XX_7TA^ACX5QLa++[>TLS0XRA/&0R<WfRDQ#8?=/
Pe<:[K2f-(g0.PJEU+,J1:)5Gb&/FgJ@-1\S]+8V3Cf53cO=]1NL,[IaK\0B3JB.
cQa7A4J_5B0>b9_K=_BI7/W<\Q:XF3]>51XW02[Y8g&4Q;-FbPZT474)>93FMS7E
b>\K<e\&7B5ZN(ePCMQN;]a;@3U4A\E>+W2a^@gRGOBF\JfgfVK@X357]BO5U995
G6HAE94VgG.[U[48.Ie:8e@P4BEH<bO6X)57,KQ&L,SHg,dVbS\:IA.;d5-Sc@X&
4K^NR_:^Bb_#_HSJ^A&(1P8TTFg1?:;:Id[[aCK=>/RN?<9Z,[W&XHL2c)E\MGf6
=[)J+[5KX,F&c6Z8Pa,F3U@;3d8G\dW528>cKJ/+JDAYQ<eC58:UA^RCJcV[MERf
TZ:X.KOK0PaJ^E9X+C9(=?1?MA(aA&?Q)??DR3,VB#D+eD;YDWJ/Ya#>^RIX=.8A
V)[][3JP[<I(3_a)H-)dTedb/5)DG.;&\_>L3)0>Y8+I92/Y7<Y5=S6,F+gD;=SC
FR7&-8eQJ8(Oa2F74?Z#+L/EaPO8d7XDSAG]+J8GC_GWN?.T2N:g\XeA_YTEJ7(@
6ebX]O1e]KaXIDgZK/,\cJg1ILcg9D(bMC]V<>8+BK(+5J>)0fb7/cD5X(MQAcT,
Te>-R&A(VQV(;#&/DN)HI6a0G[^;Q2X.?97]YWe&#\.@e]VCd>[d\X,E5P;dLXC]
:I6b:KBJ,cf9S-DUUF70@G27\N<<YWaYE:PY;7SdH;NKVO=1++NH9SUX.HJQLXR8
F6SIdU7&<QH54MGFc2BIHGN05]aW#SR6^[ZY?+JCZbL9W.RUK-S>3ffYK5(4&(b3
c-FRgL#2:cg+b0RADbN>a3TR-[GfEQPbI5e-C\DR0:bU9(,5VE[W]7K&)&B./TQU
6:eG)(X0dI.=XY0FdAY.3,;J&@TMHB6FQe(Q]:4gD#&A_HZ@\C,&eg0dLVYdXcc3
]4cbg@1QI+BefB;e5K_Qa,636G^f1&MQ_I^4>-.H#9bBL7#cgQ>P8_&)+H1-7G8Z
?..4[=<H3^LIO>2/RX1M:g)\Q[A.WH^PG<:gVg&]a</O+9S<P.BQ?YJ0,+?Y_Tae
6Y-g?=89<_#;N:HXeUH:AMGEZc6;XNS^]-[P8VL^ec>[cZd,3bY;^8Z5V?f_=Jga
WOQ_G;AF<b7fRQDK\8JL9KBeD_P^D2;&^S6gYe9PQBA>)JEXeFPeAPdS&QH(YDER
GRb1&Qa:8BMQVTY#LaW3_Pe.S^H9KB[FB=6&^WXPCDYU83bRgR=E53CDD=T7YH/G
,@&:R=I2Z[YQ>:H.F;UJ[6f:GdNZR=d7LZg@WLaQDcPPHM>Cd/e4]UC]^g&5.Ke:
\]=V5O;HcX0IRPSZI-c:6Q23XZg_CRJX+]>0>FH=A&3O5WUL2ggR^.T.:A3b1#W.
C4UX39-^KD_T_>FW&@/57G4RT9f<\CDU>8S?520#)NW>+NAcON8T]N^E=/0?TB0=
>]89&=0H>AU@e>O4-4dX\@Z6J(HJOC;6.Q0C\;Z@c#+Oe=\RYHV;N-=VI5Ae+,=K
9gJd#8Uf225@221404^GO6/_-H79FR8OE\.Wad/ZVSGR+]>X0>)#U&&Ja?c^TWSS
e?dK@2eB=4RS)f]7==bc=KC)9]RWa(1gCC)R7&&>4M@Mf)[A]V-3NCBGc#R=4Z[5
@+1BWLDN:GbeD>OaAeYZB#OQ6d?@BJaH8(+2)Wd1=c)1-Z81#SgGZH:dL\)#-+S#
YYJe^[)+-b)5^\;F\^:^_Oa.LN-cK<BG7cb5Z#QSZBH,@#F+:5E__+QP5b;B&K4F
1\0f9&=6<9)S:-=LF8:BY+>762b7KQ-^OD4c)+a-+^<&Z0RcOX,R8P0?<8+L8SU@
gD(NV6])Da4fVeH26eJ=62,e0&Y8VXJFM5+D5.B3<V_@_?If_RaZ;-Nf[HSY3I9U
?+D)D2)(YNQ;95d\PH.F#P[??YQc\J&^PIg4FJ8&/D1g],&PBe[/_fVB7_&,O<:\
]I_9@eFWR8e9ONN495HHA&<D>3&b&YC;V]/^,LI6R/Z1(\GXIP5=JZVBA,6TPQH>
JLX)][<2C)+^T,)7TJ([-()e+T+&(cN5HO@?FG^=&Gc4bJM=Jb0IE:G^9eB+[Pb>
bVIK(fBYZ#Q4:ZR@5U,+\M-;GR4KSY+/dM9S,aN+T2)2EE[1[d[gHJH72\)b.+8Q
Y;cf]fYD3L@O_:2M^C25WK1<ZUP38fe^;]0:@.cFA.#=Y5J@_P;.[;dX3g(KVN(4
M8IT2JJ@(JY[HWQOZfQ#[:C5c]KC>LF@F98NPe=Y:?fM.;gJLV@TS5Y-b2\FTgGE
]NXY1bF#[0;KI+XR>15QZ[]4(a#CQH/^SU;;PD_SM,FME@R=\KOLCV-O1:0Z)b(K
V_TI+YLV.\,?.D=fT]Ta^TV_GR:.gQ066Z;C6ORc?.9d)8=dC]VW.0<U^g&bA5VW
LKF0EZB]K;V;Z_>S\\Ma0V:+TbOW\&B5Y(1/#,bHaSCU[MeN:E,LFN^dg_GK(G_<
-d^@VB\6fEZ\#9XXGc5f5N73#Y[IbMZ),FT/@+\7_GOCgL]4fVddUb?M)LCeS?(?
37:Y:_-V)c&2OZ3K+d=eGeE6.158B<a.9b5#g4a]e+7YA4(F)9=#+C#3U6E#(4/a
R-(95C3)38d>_;>H6?K+0Iff#DgX1]]Y[ObT9_>E50_DBb0H9JR3R:R2(M2F2YF[
&OF-8,@Ya>LXgP=#X3.dAMV>SD_X6=\;#7BeO,),Kd(9Lbbg-eN1V1Ce/M)d;H?^
Z6CQ:S/K4[8FeP(d;;=;e77B@5V5][EHG]JO1<V(?QO9IGJB0;Zfc8)^gD#QF#Ha
2/b-5C6L>O6]WW/#=/6M.]a\B?8]9?Fd+[4XeV@+3\I--)fGI2]@A7FY]4d^DYc1
@93F4DJRWV0\))DLg\83G(S&-?E@7TNQ/+LafB\Pd)]A]A:@P)7D::Lf)/QO0SY#
1RVYGF>_KZ&3ZVcZUP)YgRFP[HR]\P8-\QAY&#2d?P\c9[IbQ4J3LJS7J19DI:F\
U(T9^+TRBR+IJ@eBX:+B+044L@Zc6G6e.a&IPJfA;CT9a&Q^;E,b1M&=[[LIg0bJ
KKH/=IcLKM^S1FSX1=0FGT_Q9S:.GR/MC4ARe:3fXa&L_@S&NOX)40f#G9@WBUB[
Bg>A&ES_7<;#^_2Fc8-7#-EYG2/9?)N^eF]BF77c^.Gc>:c:RKT&EIO/B6=c;eV0
@DW)3?@GeN?b::[+5V(]a\&6/PU?](c2d=ZY&/bM)#EJ_(HZ<1)7,#W:9A5F1?d2
+e-FQ&0Aa/T[0W_WfMA)0;U)C3^8@\(]3].66JS[SE:3:QE_\7Xc8JP@#V(BTD[4
QY+VVFA4^#>Sc-F1;HKg+>^N@=EC>;@FPX9EKbEJ6,9Q1RRf&J5-#eB(439L[[#=
1fJTYP?A@GP7MJS<#&8McA?+AMTSV/a,9.]3Y#SW-0I;WF5g:d:ZXAL@LE;S0LCX
:GG=/?CX2,eSg(O,=(@TE>CO(EbDS;0Va6B?O0\1aaFS6LC]4SOC,T1<Y)OCVd.<
9[;9DU1L\@XE[/UHTa68/@IM)c+_5=I3E?0,?:>DI0^/BTCJ1c1>4).Se5(fC(K?
BB\[OMRgdV)\]?#M^a+<Fa2GBa/-)B8U?(Qd;U]>J90F@<#]OD9<2RdNJ>CW4Xb3
@M)S3\^^0)W6>ga;J6E3Ig:R?DP0KgB4eF1,B3;I:W_g\@KE[9<,)U6BfVO9E4U&
KANN(#(4O);U8:)2\HUXf[fF.Y,B/#AGEZOa.^<H)Me9e@2cOL+ES(@dD0=_0dE;
;1MER,>8UKE;6ZO\;),3H6+VGTW1eV\NA-HKSX+\KGS5c[3FQPJ?PR<R9XV&DNcf
f#VW#fXfWC-#X;C.9WRH_1@T^Z,OI#FZ[SA9](Ye5I<DX:4dBg0O^AE@Z0NC[;,B
56PQc0;,Q2S[GD(GJ4533eS]HK0dCYc>:HP?(Rf0Z5V#QP1S[&1A[_PRSGa7@^;B
9\7?C\CE8BP@(&W>17b#266HQYfMW(/LKB19;51YS5;J6J>[aa0=L@F(C#J0T^KQ
A.dSOPC@TP:+>@T87fUOfcZFa7aO4-c@PbP8S1b5JH8d8&gg=eGT,6gVN5<d=cPG
Nb#AEdYJI3]E5P^E_[7W[//,1<[c3Z1;f@4+X_)>/JWI>0S2S1ZTR[6d_bSX(5=K
<8DZ_]IXV[<_P.G>eVH=L;(>:5TaT1gf7N1+L[U)7XZ:G??<d5W/X:#S\9&>.BE1
LOE-&>Scd)(^4WPZ9,9KR#L?Q9YOI\gB<4NQ]J\G).N-(8NcOJ,Y5(CZ9&dXH5C1
26[SM&6Jf9=E>UF6S\6DCT)6\OA^_F@-#&?WX:2)\-FF[K;fN^.WQ;@/D0^]^FUP
0_g4Fc#@0?J&/c]QdNe+?>ZKK:&gePTH^::H=]J^(EYL1e7Ba1Sd<(LWcX@g(A/>
UP9g9FD1JV7f;;OHa_:.,_:7<EW^OK4Z?f>f;fQ]4Y0_]Zb1EBcd<#R8WVYT:74&
9I7UYfPTd;Q2)VdK56NAU6#8S8B4+,;^06Y_F7R(F,[#CFGS3&@440^eA=_7EfN,
PK<GHUb7O)f360BdfO2VAD&Z@b&S(&1ZCPWYL=6eZ)R0dT=9M::?C-0b,^_07.]+
@^;/b\:3aB=H+GOSE9f4U0(09EWMSHJ#U5TG/8e:aHceXUfA[5;1TS)1e-2:TO1D
e-d]2OFZ8\2./3g>LX<OEfR&XbdZ.NG,.K8Ieeg(1I+bVCc/.R[Y[>@7B#MUDUgK
9&O3_^;CJ\^[fDX?(=CL[I]\.-=c:X6,B=b:@:)fa&_IG^#g5K5Rb([Ye\^Y@OcM
41FJbN3A^VgP<D+bZ5XL=8-c@6R30,>ZW.eL33A82/dcMFM>:eI4VfC2dcN.-M@N
6/..&\O&0?9(@4I(:6[+;L_GD-G.@Reb2BfFVJRH4=Gbaf5AQb)4#6,[-10dYQT:
0RZ?[0fYTW6^V(gDCFF387N+9_K^HbQD_GC;fP.9+S0O;\\V+?Z9E-f[KE>U)=#;
XV@=[RXL5,2fd]@_=2(:ac(CHZF@RG[-.2]FO=,9<3E-B:<L8ASf<+,\R8E\<2]d
Q=[\Y#=0VVBe+)7aRed,@^B/c39T[;:(WdL.><NHCF1W^a\_bEVP5GaE.TIUUBcD
@aYH6&fM1bT,3<R68L7.H0/>Ge>UIO^([/4AIYK]24@<CJ;Y3c/F0+V64O[_(\&-
K9_#0[MO/34?\dQ;#5@=#SQP1A>G-^@g0:c3d_-:f#=NS^7@<.8B[Z6=<2_6H]F+
b-L.]P-e&gB;?A&\(J6?BJZ<Y1/Z_@W&QX[Q=IVgPe=-EB7A]WgeZ\1BeP8/D(,:
78RVb]5Z,a^87gaELBA3FX:gWPWW8^MEW4(6N,dcAT33ZHa=][HWUX-J6@F,.;dA
0J0JG?We9.7Y=2gDM_f8YG?Rb7AJ2>^3R(c[+V][=ML-XC3?BV[NE3C_^O\DC^DR
>b9CM=[C-_7P7+W?GO)[VOG#7(CEZ7]UX/JG+]+9cLGX:+f?O=+08XS/[@S:VFNG
I01>ZA(DOC,aFAReI8E,J5bN.@_2K<-M6?^f+:(4Q#T,[PEIg@FV:bgIQDdTYYQA
+_@_3<C(]2f08V:40[V9d,MJ5U5\=X.\bJI;E&&LJ9f/K;J&g?.4XJ[G]QR_Fd3]
?/=J=U\b[1UaG0<H;\\562g-F/GD]VS11<TfBA^Xc=FR[N_4PY.--c/>Q)]>c0G2
]ASA9/:1V9G-B4M61RfR-I,MOcGcd/6]?e&eK775J<^Y#fYI&P3S<^)Q;YPZOA)U
FU7+7IX>eW,#3=:/G5.G2PM0eS9Mag[P[W>]_0M4?WW#IR0VNGCfE)^.86aIFR?e
0LT4<9c,@eJNZM\@ST>eI+HW93R#:7EEF\^]@UUY)D<-]eSWW^,R(cPRe-e5]U:c
0T(ScZ6:U7J7\-=9Xc0[.J)68Z-13EbU)_;]:8;L?/X8C>a0=,>e4D#T#[AXe=@,
9=/[d)(^KNQS.ZZ4=09C8BW6Q\A)5QU2U20@b\T.JETH6D\7D8@ZL-9J-0]1.5-e
>VEPUW6EFH@=V6LB43W0)5#UI@a/JeI\4^Sg6A@cV:)1AR]G_g07Tgd6g\:)R-+S
b&?(7T=,&IM=+$
`endprotected


`endif // GUARD_SVT_STATUS_SV
