//=======================================================================
// COPYRIGHT (C) 2007-2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_XACTOR_BFM_SV
`define GUARD_SVT_XACTOR_BFM_SV

`include "VmtDefines.inc"

// Kind used for byte_size, byte_pack, byte_unpack, and compare
`define DW_VIP_VMT_LOGICAL  9        

// is_valid return value which indicates "ok" or "valid"
`define DW_VIP_XACT_OK 0

// Backwards compatibility macros used to bridge a couple of VMT versions
`ifndef VMT_MSG_EVENT_ARG_TEXT_SIZE
`define VMT_MSG_EVENT_ARG_TEXT_SIZE `VMT_MSG_EVENT_TEXT_SIZE
`define SVT_XACTOR_BFM_MSG_ID_DISABLED
`endif
`ifndef VMT_MSG_EVENT_ARG_TEXT
`define VMT_MSG_EVENT_ARG_TEXT `VMT_MSG_EVENT_TEXT
`endif

// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT BFM transactors.
 */
virtual class svt_xactor_bfm extends svt_xactor;

  /**
   * Transactor id used to associate this transactor with a VMT Verilog VIP
   * instance.
   */
  int xactor_id;

  /**
   * ON_OFF notification that is set to ON when the reconfigure() method is
   * completed.
   */
  int NOTIFY_RECONFIGURE_DONE;

  /**
   * ON_OFF notification that is set to ON when the get_xactor_cfg() method is
   * completed.
   */
  int NOTIFY_GET_XACTOR_CFG_DONE;

  /**
   * ON_OFF notification that is set to ON when the reset_xactor() method is
   * completed.
   */
  int NOTIFY_RESET_XACTOR_DONE;

  /**
   * ON_OFF noticiation that is set ot ON when the VMT model has been started.
   * It is reset during the stop_xactor() and reset_xactor() methods.
   */
  int NOTIFY_VMT_MODEL_STARTED;

  /** Controls whether VMT notify messages result in display messages. */
  bit enable_vmt_notify_display = 0;

  /** Controls whether VMT messages include the MSG_ID information. */
  bit enable_vmt_msg_id_display = 0;

// From dw_vip_transactor_rvm
// ----------------------------------------------------------------------------
/** @cond PRIVATE */
  int msg_to_notify_id_map[]; 
  int msg_to_notify_type_map[]; 

  // Vmt Suite Level messages
  //DEFINE_NOTIFY_MSG_TYPES_DW_VIP
  //DEFINE_NOTIFY_MSG_IDS_VMTBASE
  //DEFINE_NOTIFY_MSG_IDS_VMTCOMMON
  //DEFINE_NOTIFY_MSG_IDS_VMTCOMMANDMANAGER
  //DEFINE_NOTIFY_MSG_IDS_VMTCOVERAGE
  //DEFINE_NOTIFY_MSG_IDS_VMTMEM
  //DEFINE_NOTIFY_MSG_IDS_VMTMESSAGESERVICE
  //DEFINE_NOTIFY_MSG_IDS_VMTCOMMONCOMMANDS
  //DEFINE_NOTIFY_MSG_IDS_VMTTRANSACTION


// From dw_vip_gasket_rvm
// ----------------------------------------------------------------------------
  protected svt_data xacts [*];
  protected int cmd_handles [*];
  protected int xact_cnt = 0;

  protected int out_in_xact_map [*];

  protected int max_active_chan_mgr [];


// New for the BFM xactor
// ----------------------------------------------------------------------------
  /**
   * Handshake from the derived transactor that indicates that
   * change_static_cfg() is done.
   */
  protected event change_static_cfg_done;
  /**
   * Handshake from the derived transactor that indicates that
   * get_static_cfg() is done.
   */
  protected event get_static_cfg_done;

  /**
   * Counter needed because the methods used to set the configuration are all
   * void functions, but the VMT method set_config_param() is a task.  Since
   * tasks can not be called from functions, then all of the calls to
   * set_config_param() must be placed within a fork/join_none structure.
   * 
   * Since the set_config_param() methods are in a seperate thread, then there
   * is the possibility that the reconfigure() method could return before the
   * VMT model is fully configured.  Therefore, this counter is initialized
   * with a value of 2 when the reconfigure() method is called, and a thread
   * is started that monitors the value of the counter, and the
   * NOTIFY_RECONFIGURE_DONE notification is reset (set to OFF).  When all of
   * the calls to set_config_param() are completed in change_static_cfg() and
   * change_dynamic_cfg() in the derived transactor, then this counter is
   * decremented.  Once this counter reaches zero, then the
   * NOTIFY_RECONFIGURE_DONE notification is triggered (set to ON).
   */
  protected int config_set_threads;

  /**
   * Counter needed because the methods used to get the configuration are all
   * void functions, but the VMT method get_config_param() is a task.  Since
   * tasks can not be called from functions, then all of the calls to
   * get_config_param() must be placed within a fork/join_none structure.
   * 
   * Since the get_config_param() methods are in a seperate thread, then there
   * is the possibility that the get_xactor_config() method could return before
   * the configuration object is fully populated.  Therefore, this counter is
   * initialized with a value of 2 when the get_xactor_config() method is
   * called, and a thread is started that monitors the value of the counter,
   * and the NOTIFY_GET_XACTOR_CFG_DONE notification is reset (set to OFF).
   * When all of the calls to get_config_param() are completed in
   * get_static_cfg() and get_dynamic_cfg() in the derived transactor, then
   * this counter is decremented.  Once this counter reaches zero, then the
   * NOTIFY_GET_XACTOR_CFG_DONE notification is triggered (set to ON).
   */
  protected int config_get_threads;

/** @endcond */


  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transactor instance, passing the appropriate argument
   * values to the svt_xactor parent class.
   *
   * @param suite_name Identifies the product suite to which the xactor object belongs.
   * 
   * @param class_name Sets the class name, which will be returned by the
   * <i>get_name()</i> function (provided by vmm_xactor).
   * 
   * @param cfg A configuration data object that specifies the initial configuration
   * in use by a derived transactor. At a minimum the <b>inst</b> and <b>stream_id</b>
   * properties of this argument are used in the call to <i>super.new()</i> (i.e. in
   * the call that this class makes to vmm_xactor::new()).
   */
  extern function new(string suite_name,
                      string class_name,
                      svt_configuration cfg,
                      int xactor_id = -1);

  /**
   * Sets the value of the transactor ID.  This is only needed when using IUS.
   */
  extern function void set_xactor_id(int id);

  /**
   * Gets the value of the transactor ID.  This is only needed when using IUS.
   */
  extern function int get_xactor_id();

// From dw_vip_transactor_rvm
// ----------------------------------------------------------------------------
  extern protected function bit[15:0] map_vmm_to_vmt_reset_types( int rst_type );

  extern virtual protected function int map_msg_type_to_vmm_type( int msg_type );
  extern virtual protected function int map_msg_type_to_vmm_severity( int msg_type );

  extern function void process_internal_messages();


// From dw_vip_gasket_rvm
// ----------------------------------------------------------------------------
  // Functions provided by the different model transactors to create model xacts of
  // proper type
  extern virtual task new_typed_xact_handle ( int chan_id, ref int handle );
  extern virtual task new_xact_specific_handle ( int chan_id, svt_data svt_xact, ref int handle );
  extern virtual protected function svt_data new_typed_out_xact ( int chan_id );

  // rvm methods
  extern virtual function void start_xactor();
  extern virtual function void stop_xactor();
`ifdef SVT_MULTI_SIM_ENUM_SCOPE_IN_EXTERN_METHOD_ARG
  extern virtual function void reset_xactor(vmm_xactor::reset_e rst_typ = SOFT_RST);
`else
  extern virtual function void reset_xactor(reset_e rst_typ = SOFT_RST);
`endif
  // common vip methods
  extern virtual protected task manage_chan ( int chan_id, int n_threads = 1, vmm_channel chan = null );
  extern virtual protected task catch_buffer_event ( int msg_id, int buf_arg_id, int chan_id );
  extern virtual protected task catch_output_transaction ( int msg_id, int arg_id, int chan_id );
  extern virtual protected task catch_out_in_transaction ( int msg_id, int out_arg_id, int in_arg_id, int chan_id );
  extern virtual protected task catch_initiation ( int msg_id, int arg_id );
  extern virtual protected task catch_completion ( int msg_id, int arg_id );

  extern virtual task catch_msg_id(int msg_id);
  extern virtual protected task catch_msg_trigger (int wp_handle, int arg_id, int arg_type, int arg_size, event watch_trigger, ref int obj_handle, ref int int_arg_data, ref string str_arg_data, ref bit [15:0] bv_arg_data, ref int status );

  // Note: getXact_t is changed from a function to a task.  Also renamed so as to not
  //       collide with getXact below.
  extern virtual task get_chan_xact ( int chan_id, ref svt_data xact );
  extern virtual task finish_xact ( int chan_id, svt_data svt_xact );
  extern virtual task garbage_collect_wp_xact ( int xact_as_handle );
  extern virtual task sneak_xact ( int chan_id, svt_data svt_xact );
  extern virtual task sync_cmd_stream ( ref int status );

  extern virtual protected task do_post_chan_get ( int chan_id, svt_data svt_xact, ref bit drop );
  extern virtual protected task do_pre_chan_put ( int chan_id, svt_data svt_xact, ref bit drop );
  extern virtual protected task do_buffer_cb ( int chan_id, int msg_id, int xact_as_handle, svt_data svt_xact, int obj_handle );
  extern virtual protected task map_transaction ( int chan_id, int xact_as_handle, svt_data svt_xact, ref int status );
  extern virtual protected task map_to_transaction ( int chan_id, int xact_as_handle, svt_data svt_xact );

  extern protected task start_command ( int cmd_handle );
  extern protected task end_command ( int cmd_handle );

  //extern protected task clear_xacts ( );
  extern protected function void clear_xacts ( );
  extern protected task set_xact ( int cmd_handle, svt_data svt_xact );
  extern protected function svt_data get_xact ( int cmd_handle );
  extern protected function int get_cmd_handle ( svt_data svt_xact );

  extern virtual protected task set_max_active_chan_mgr ( int chan_id );

// From svt_xactor
// ----------------------------------------------------------------------------
  /** Extended to update the NOTIFY_RECONFIGURE_DONE notification. */
  extern virtual function void reconfigure(svt_configuration cfg);
  extern virtual function void get_xactor_cfg(ref svt_configuration cfg);
  extern task get_xactor_bfm_cfg(ref svt_configuration cfg);

  // Declare all of the virtual methods which allow access to the base VMT commands
  `SVT_XACTOR_BFM_VMT_CMD_METHODS_DECL
endclass

`protected
]a@GSZedW?gf:N]Mgc]^#4a?fbMH^Z&AH9cF.f->OGF.fR,1\CCO))e8CA#-a7,f
I5--P;UdfB]B:IL),)+_f91&)Vg@V75ZeXAL>g0;:SCc+N<V(L;F;RRd3ZK>)4[d
UE#LgZ/S7TDRB07#1^PV(DU644\>.D8g)K?<85W^d(YAb(U-.=J=g?2]&03:@EX#
#QRJ#:@BW/CUa=2ZVLC;L2;+Z0PGOLFLSBOBPMM>,WM&<Q#L&Y\?8IJL^9e>X/Y2
fE<:Z;6Q:Z4UP,I1=A7HWfWPg^9X[5NO_TG9L&N+6Q489\GAAc5/eROID8/+@N]9
Q(7^ge)=c?ZJNEG]W@9#:>IGBHbT4/HIG9^D^9-O,67c2#f72RF@>=5e?(>?H5RY
IE.<3]e-1RSS]&YE:\X5DBBGL7557<3B?.3W?WaU:(#294(GF<fPfDCC;SH(H#WL
J0&\40O&HRcT\EcHg995<M6_EQ:&@-6MVNVN(bY;gIfbHgeIB&3>552[[Ea.TB-e
5eEZXf=QYXFCT,7Wf+Wa[Q26JY+aL[dY7fRcNaPgf;5:_],g)]ZKK07^JNKA7S\[
@fa_<E]J\X7/]E8LPJQIfWePM5Hg4,e=>OPH8dG23K6Y0/O1BK@R.UX1g=bGJSdS
4JVXMZ_e)(4(LG]>S88#U-OR6)<X2:a^T_4Ecb1&fI>HSW?PK4C#BV2T70Pce5B]
U)V4)Ef+)c@UX(1gg#DZ#F]5aGU3eJ5M_?ZGYX>(#;+,Z+\g7;EZ#07,DGZ2\4g_
[Ya@4=[FD2cS,T351J7_+H2TZ7f5V5>Rc<KY(4G3:+AOA<c)VC7@TS@,5D>@fPDU
?bPOHTG#.&Je)-)47IUS?U,9X\(IY3;O\VBbBd\PR\>/c_XVJY;&9fV]TPA8THQ_
\H8Xg/?MG7f.AHNF4@SZ19_H73>BgUUaXTXAX1@I9bc7]66#=?]OIJ+O0P).2W:\
6;TMA9M\\IJB)06bcRUPI)+I_JF<C@5_,Geg7[48R1aT4T4492)7O2SYg,(G9GRS
\5:#Y]C,[-2YALf<gDXBEBd@/:I>J3FeX/>9fb:X1^R)<AOH-A68g+3:W3/eJ801
QO=.FKOEc)Y0.Vd-F(b=c@>6,XCD/:M.41@AY^(+SJZ)fMD=_A@gK7dGfFgC\7?K
\,GP0#.#87HSBLd8\=WV7\YF]>D2Cda1>--aWJ,3/,ZK#B[fJ0.)Ab[#THA^3,DI
PG.N,>GZ-VfcNdT9W-)=)>8+?;J\aee=5<?8c&OK7AUg16&#G6g>^,Pg\)5<AUI5
?58C3S9cbV=,L2^g4SWNcCFM#KL;AQdbRVA,b&8+;DHKP8LU3a]W?A;Y/Q+Dc2\b
@#K[@JeR<Z+1;\HAG0:NA_^,J:fd:L8ZY7D@F??\?4XCa/XcRc;<:1,YJ8NFgOF/
8[<5BO8b-B#FYFLd09?fO-@FU^V?bTV@NRe(#^d[Y+0P9H9-C2_gJ]Tf;[&J9bAN
#5_[dB(d:@aMF?1XK[XOWB2#D>dcfO[6bb2.CI6>8^596J4BK]#[-HQcY-B\??dZ
)XZfR&6ccd]b6ZZY0-UG0,5+1a>143X3K#?@Q.0>H:3@<AHgQd/O^PUVU)dM-#71
J]WcA95dMb#B(&6@b^KS(/#;0/6YF;FL>SSTP7/NIA.+TX5+bdH5cYca_CG1=K@+
46dRG)RJBXeVOH6<Ca^R;L.XC9:FT8/+B.d[_=D<_CZUW=@K/0bJUX)M&TU8P-RI
/N=,)_XNI1:,:K=N?/[-Af73ET-6BBSdF&JJa?#VGWW;V/SEWF+S3>c8:-)X3CCH
X2Dg+YQS2cd;2[c;b\WfJE1e:G2RZS<+-_ED([@&:WL_1?Xc89G71[E2WD4OGO0F
gK2.ZAb#[N(9G-OfL#9EXg;]4MAC)1JDP(8O_TR^-8aWdY39Tc/,.QLMb[d]7<Pb
#E]MCJ9-.\SScYDP\H,Y&)(MDI\c>X@8<=,PF<<68>D6?ZVI,&bN,.>&Q?&WeC<@
:L1ReaD#A#gD;[\SWVQ5cEZ7Ka2:\6Z:BVdOS(4OAJaTNIT2)19B[KbBRFDWC56+
[J>U1@)\RRSG_^d&4ddG2=b2E>84[KRF&BV^e#\](>:[4/)ZNeLg6L@(.K.EG#-R
9[0^]?CEM\GR5a3#f-[R=(Aa@aNCUYL-gUY,A0E5_a_,\B+IPP\fK4#ec-Y)@b:f
8QgQ>A8--0/R0GgWUgE_+;5=dE/e/U)Q/FY[<R(04AA1Xbg\ACZ&W[#O5R4EP\@O
MPLCLXf&:4=WN(90ODO-J^/^\ELWR)I,O;]L)M2C02B<OJ=Peg9acW,M]&R40R12
RR-I)/(fR@T/5C68V?fP77ASCR7SB[&MJJDR:TP6Dgad@gFK+3FCOT>O,,AKR87\
W9aC54N,WAeH8E9N7\,VQ7^N(4I/<;<:MR_(UP4FO,Z\HM7:C?K6\aQ-:-E.4K=d
61+(JbSR.R7F#d4eH]C(L,ReM67YWg0e8b:/Z@8O:8LdgXIDgBDE,-KAUNSA(AQN
[OXWY5b-\F_\fM+,Ra2BY.]d3<F>B9Gb9].GI=YD6Y-#caN59[PFb/Jee/RK6(eG
/d8&^fS2S6PJ_^\YF.4A//cYZP3+B@)?@?<+;2V_8@Ua[1@<LF8f=FZGFU5b2#GK
&/cFIF=/?CE95(-J&1IRZP7E\TG6WJAfD7(3)aE++PG-L>f_6><D7_Pf/-,WYVXT
/.X&NVYP,RPb#SB9.S-UCDb3F@CCba_JV3QdQge(OSET@4KKV[N;:,>eXJLJB964
X0,5XO3&2:H#/e\(K<R1[dOK(K+FRRN=L^LKJe9,P(fZX@aaX1,H-+g;.VF#]O/Z
+L-XRccc7a2<ABCQ7dK3=_P1.AaEe->),OG/(L6GF\&^d7U_=>5HfdOQgP[@)f[1
f8W][@&7&T&JM_I^(/K(MR#/UfY6gLgP)1XJ+J84OR:Y_44<KRZ/geKcXE^G?M3a
J,:&8f].I4&WEX]>eY8dGE9SY?2#a;R5L22[]S+c2(fd>6Q,9JSAe.M,a/X24)DC
-Oc2V##SBD^4J19C1#G1B,I0Ke49PQaT3e5OL5_N[^8T87/ZgFE/gOZIb>RB#D0=
Xe\XG4))60W2@T+(OFE(0O:AeFcd]:_<gW97R5^f&V_WW(QD4B:^A?ZS0NC#N78,
MS+d?QF@;[7S:@KXe[VP=:3^Q)XSBZTI>._J=fA/O)Qa2TG/IN1Yf.38fOgXfMX]
DCA5IAQTg:OO<.^W>.a]S>Z4d4E4GZS(f;WgG;DHYYg+f=M]1Y8@)9FeDRY/;L2T
/83<:C&0CdG0&&aL>[D&,;Tc&N;SB=SYIIM<^SUD+TF0YU[EXDQ9P6P&c^L9a@0Y
3Q76IGNSHG5O/dBcB<457J/172bQf>7HC?FEIZD]M2B>4fKBbI]\>0e4C.(IH?\e
HFbF_=#).+NQ@[V;f5]\\g>[UCL-JB7JB-9Tc@9?:YVO<dO0_FA8G0-]G=WTcNE)
LYO)PCBG[Pd(dH#_/8<A^AB;H3dA;a1VDe;6J?J8W-3<:\E--(Fg&VF58R&,eCA<
\A&<(KAVcDGa&<M8fRQY=;:a^#_bXDC>2Z7CGO:-WC\>W3fD_=017OOOeZPOLTU#
66P@@JaAI];1/MI20WL/ER8gf8_9eRV)^MF[:4NJ^7@??@\a\>/#OdXZ<Q-^NL,[
.NNGSL[85I:I5Ie9S9+:DfJg<RBVH&[WYYBdMFN1H/@gX7PJ+78+cIb@(QGf/5C2
Fg1:MN7RVfPC9=]30).A49Gb+QB:/I(F[Lb,C]1W@,7]SWXHLN1ab3If40Ua-EXa
G@07a?W5aWe0ZQU\@Q(JT7Vc9<3R)829HYX8d/\7P>LA^8UKA@N0L]#?;,?;8/d+
#:)_CIC/?TDOW_/G1X372\K[c-U;]VXOb7H]#B(JSNKZW1\ccQQ4(S;=9C#=H#QP
V[B5LIXCSe3&cN(::2K=X08?0;>GOHc6,D#K9V)RfAWX]1A5EQMWW^Z6_51f>HXg
F&c__Ld6J2#<C18>6D9O+Yd;:V#44M4CaVJfB82?FT9@b]d[^F3a?;CcT0;SaU#+
?6X>F5VeLC&_P?G&MF_G,@]NaFG0S;J]D?S>,7>&1O^TXL]g,&aZ38]#]>94.PDX
3gfg30KCG4#UJ>XJX(ER)JTTCY\_L^U@I:EV\?B\4U^\;f-GO(WB6LOIY/,6>GMd
RUgWNKMdLE\O&Ccg4WIILd5=:NT8_I9X/&(/RI[R?V683CPX-7FP\gWO\S>f4DL2
@cdK&[=J;HA08Cf#&X84OHAS;c\SYO-bVdIO2,0d(=(_V7/CW1B75&=@FaVWYNLR
>W72aPA:P[252?DQNN+gf;0c_C&VMA>P5=;>H>L44)=/2fWg&GWaD<8-H?^&KOgW
ST_UceZOdg5IgENJ]Y[NU&8DIbLA^8Q+M53KQaYA4Tgf?#+Dg.NAa,6g+X_bF;a<
R?HHL&_ZOX.9JY)fL>/&a,(<)WSNBL.;&?C=_gW^:_,Xe8IC6KE7PTBZ^bW==6PN
c6>;a1JV#K,:52GLX4Ug3^X56?Y0OVZd3WPcXa)L[S4SV>0RXY@c:>;^<<9C<D,P
@@[4&fP6ZWB/359>375I\Q]eSbc[,U.GI[>:?eJE>S9<E>T<?gOAE4HT>1a\dZX\
#@1K>fIc80OgE?(R7bZg#9ZV=4BX]=9Ub8S=9.::9/?6ZZDc+d:@JABg-\X\/.#=
TeW>P39.2]7I+G5J6Pa#7,-MWB9YD4gO7\X&8a.EfPRWZ8][_eeVP(7#TddC-LYL
\>7(.6XB7G_ERH??IAIHUQ3SH7/\EWZJDD?d98O1SADB@O-g/\44)1\VPYc>Oa^[
LP@/TL_K-)E@FE9->f#08K<6\HS4;bEW688:<P/EPN(#J6d1Y//;baXZZCWK84N0
K98B)N6fR_@YNRV<)3fAI:3A9X6O3@@VR()R&?eLc4Re^]C=#(g[MOH=)8DY073(
V)]ZF,+8R#.Nd54CWR\RgZ=SK&e?D29B8(F0gB#&F1K+\c8L-CM=1#:97O>TFdT7
_agE-M<9E9\4a-&1WGS+ARZTGTSKc/QB53_ad^d6S@aT:[N;[I<UO_3W8@I@YZF:
N6J\3#d4]/e;0XOWG2C?O>a6<>d8MMc^]D&L=Za(^PO0IEJ:Q_+K1=?>(LYf29W@
,-V4dHD=8B.7_&NIRQgP9efccW^8VUI4:cJ2b,We5PDRfQQ4+aGS4G5^g2YK)Ie,
5Hb]UGeU9A6VR-+cMd;O7/8R(N<8Ta:S=F34N.+)<MfFE)Vb)g\9TJb/_e\c;Z2O
Rc-E5<=(Gf(0-\0@B#D\XJ9,);#7Z&c>0f[_Z)A<?J2G2:fP=Y7/03(>]<c1&0[>
UdT;^1bgQLNX1J;bB86/AUZ3H1GQ6J_=6d&FYP;22QC5JK1BfI8VIMBPP7PfD9#G
&#e)&c1?)cT@PN1B]D+>PCd=^KAC1@a=aQ?\4eEI)R3O+,?:H[M7fV_V@:d;<WQY
-N)ffUUPL]VA&(28aJ(bK7N3R#U@2:/NY:EP,V(MF.\C[Q#Ef>=_39^^49>J0^Qg
9gf[g1=7eP1ETN9V=SB_-PR.bDRV4+W6_]DEN,PNW]:^3OV=<aHWTe5+dS=<f\CT
.^&K49=-d83F>7-D=(d6>=R,XB^#;eHDY>?2)RdYbfeQcFJ\OQ,G(3.6J.eKB1X<
gAB&YU_\#0=@QG9MN^N5VYgHF>9@>I:\\gc;d#Kdd^?GY.7;-QY#RP8W(V97O8YR
;7E0PZ8+846TC&Cfc7V@+fF=?BaCI2g@6&J[034<W^(dZGI3)b.0@;1\9BUT6_GE
U,[-PDQY\WAQQX(<DR/^9Y)d:Q5f)6;UB/RDCQBR^>bE1B@8McW[/2PaWb-T(MZ7
W@4NVU&\05^E-<HQ)/L2FG<B(8;NeR(=FP\D?V;UT_9LMDZGJI8+NRgbe_R22>?5
F#^UZA2>6?RXHXL(+K=aT[BI@:1.]dS;>S5OAW)857^ZE36A<W)Ta;0A4@3C(2VU
(P]NLa78fPd<BWJJg.e;WJOfX/HTA#aQc1QFD<VbT?U@SY-_6//SC3M1KAd_5T][
9D,@#OZ5NKJE]XZZM&\dgQ5bUICf\Ma&KS\?Y0TT4T],?5.BO+/V4UGX.BP?1HB(
N/d@>I^#C3B49f+MVe5JFKDA620I/.4+0;RHaO?_CXPS&CP<EHf1f=Fb[eQN9^C.
)LCMV;gEe2HT8IY#ZFNc.]CH7S9eKbFMUW#WNT5SSQM\<;\G_XI,7W7H?P0E&?(U
Z.\JN:&WBeZ]f#(]&[?-bR2_W\[\S:H)0.U3>?,P=Cg7BB]X._5gR[1RUNg=(E]F
[3M<1_CbKZSDD&eO)7f_#6MR\P-aU>?9ca?28EN[eCD3&]AYQ0L?Q&b<\Q+OX4#0
5f51fYXI9Wc[b2;LO17]B=>3;E:WN6bQ;@VCaI0OWH(C&NO:NB[S57+Q;Zf&]9HA
;VX;51#(<<^;;D_FHgS1T_a;VZ0STfZ,\#,:I#_B?Ge;bY[EJBA/0(<GJ[;\Q-[X
=Dc=?S[UYS;Q]DaNa8Pc?[3GA2C2KLLTCI&d>Pa#9HeLWN>8T[3+A70>8\/IMLf8
>aNa8D47JFT7=7E0U[AP14)D\20TYKXH1cHP3b]A)O1=O0.BK6,0F[e&IU,KYFE>
V,::+L+LdLED?L0g=@I1Z[b2]f&2FQKE<>eQ-5D#G=P46T&3ec&=-bE7e+XUPD.R
8QeK49G\ZWSW^\E]SXSQX8<e?_eF[\NPWM8IG-VNe0N)O2&C@YCf&bd4XdX_\Ag.
FLG&aOA[bN)8[#GJ-2MJbWP#D>XD-4E?b0B(Z[d\gLTT<8@-2/JP#GE1F]+fN]&d
,XPbU,C9A2?,HU@G)LL+XB8DR4_d+WSHB(NOH//>.)&TV@:VG[LLZ<U=[I@4DF-&
dJA1f)IUM4XaMOff[6HXJG1-Y0>8;ZY:ZL5>G,gO3M5H84UXM3/^VL]0:Q)J47:+
DR63I,#Qd>Ngd3Q;&C7\-;Y3CHIRD9U:DQ)?=,TZ1E.?3]YD.e[YJeU_)fHFR2I>
[EfA)UYHE==[_[GD89V05\]&81L[/=XK@J\3g<Z6K01(C2K:dJ\GOa>U#5=9H^d<
:Ua(1^eXY6C.f7Z6MH67e&<-SU1\D3B@ggH5USJPJVgLOf_<[b69]_0.(TU;=CDE
Td^WPbKV=9Z[ScX6=I=6Z>=)Ua]T[U4C9I^#DENJTBYF)F=/>H#O5&PFTD:d[,T)
B,9Q6N__^-PZX;aN9Q__187_gE4\@c4TbW.7Q2JG,7<6@0#G_@,,-e&e,5NPJ5LM
XUH+_Cg)_dg1S1&#7V15UZI7]?47Y-7:H#P:#6_L9/0;?S>.;=:e>8#LgO]^@M>T
50[4DK=4-b/].(?a6Pb:bO4_(0TC2a(OW[A\GbVE;8P\KK/M:&I]+.G]a]X^ca+]
e?W&&eCdH<:>f>#)6\0a@L[Q1LW#a8^8,B7EDaI;6UE#H0#<C9#@E_\E[=AW8>OW
VT3+VJ5O7W@@<<_DgJ-@-bPf]F>;V>+1&b4S4WfQR5<f&WF/ZL7,A+eeU6W&HK)Y
Cf7D)K@&PH\+3-7PNX-g=?Z-A,=743:#+8WL3;CNZa[_P:9V[_8ONcAf#S28.HPT
[gE>fQe_=?0=<-@fP6RN-Ac&&WBQ&_95]4J[8_T0B,ZaMB,?/T&J0+)#R#@&>8-6
+0HHaHU;SRX?Q4_#)#]8B53EGU##&&FWYc.MF7Rd.;RM52N-9HY13I8VD1@AB]B0
39DHY#g&4dG7[\6C5N<^.e^N>V>96R(QP)9<.OaL(@@30.9WR([RdG;7B)&+VA_I
>K@eO.+H]:eGcIRZbA4ZVBQQJ.[YR;-II5+N&6JIfN=&CA)UE<UA2ae<_9N)Le91
LdNAJcDZVBR^=.#.F.ERf^D@?a=+SEa4EWJ<Y;C9e72O(4^dg&BT/X(/0L+g(7<:
0_5TEO)(1#B4:c9;K@aQ8Q;X9<],9FO-\E(\D2N4[J7.5G0MLELUU]K<92)>gQJG
)LL/V)Xb9dTXX#EeG7\U2IegYQLfdR>VZ2T_KG^YbANc\KFd73]\YV+>[O4XSBHY
-Yag[g0cPW:cH]U_S/^D:2#PcBC\HbUD&G^Z&.KD:3#UYC^&T&].5SS^Y(B,YbY)
7O\9<c3cf<Y[19,1R@A^aRHE:V7_NcAg\;2RWUd5CZ4fFAeVdX,SDUg=gf-7,:S4
FTU;gde^<<?[e\/R:GO?9eHBb/S;VEYbVb#6CP)ADLaX_3LS)I>:WK0OK)C<D]PV
W5\6b,4O/LKDLAMPHR10B]URB>.I:8;&dH=D]]f8dK^(aW+R:[_H66S.Nd/a]-GF
A],+R+06UO&Q<8OC+DWR\Vg@#EQd#CbF4[a_Q9ZA^Y<[CFfReE41H7(V:L&M_T:3
N[&C6c[ZE,e[&8Z2Q38TFc5.)XgLA]MT]^PK\8gfERS-bE#?b?Q6(;)S)BdIC_-T
C-g;FNb1H9=a;XBGVN@UYaS>B:;70;1Q49LH_0AJd>FY0;cLU&;7UNH:]6/-1dUW
Q[,a\O@<JPZQPX9/SMd9:JA+Pb470e(].]\YA[bS7EDZJ-)>U(b=1/6D4Sa8f)=(
5DY6:SEd.gQbE\U^__\aBYYO@d#d8NCOR>672=\23g<.[5e&W?O.bKPOZ9-^_6a:
<>RZ>:<K1Q531Z;bIgDJ0(>3]f3IC;M8TcE-8#:B5?^<BI/((-</]H3MK,JU0VMX
?7_dbX-0#RAKFDcb_1MDa8]NgSd<U]?U=@&9Ia]B>Y:BD/1G/,[+&9GYLVP^D86+
\\G3AB4F\,9Cbg;a&8+6IZ6=MF^<J.CacFgT^PH6?U6fF_[KQ4C=M+)L\X,H/I-S
eIMe<5[IX;=eLQg4>PL@JbN2CR\1,#1+FMSE2.=#a9^7C<GS[eR9dT[ZM,&DFIK^
PH;3K;9Ig2dK4(CW.+W_4E@IPN@?K0MVX6WMZ(>W0fLCZ.@b=&.#72E4_14ZI6-Q
c@UF#LPP@fA/[#KDT29#_H<2.<66\_@;B:VgL^bOVRMA(2Q2/PEHc^Gg@VG0BMWT
:T51WZM]8>(.,cSQcUV7O4W\VI.)MY744\?JM1f3X-Gf#bA>0,,?ac,G^,Wf8#G3
-R<cLddF]&M9F9P^@LCKDYH]]V^G/#747X_S62=>=+,bH[=S)3(4P#gNH;Z5[c:L
,2,)/_a]H^<;N&GeDY0WKNQ<YD(CGY(++80Zed9d1UUcg93Ce4DMYDQONg\RG_VT
YUAM.NM\HE,g]\,1-=>REG<;_BJY=B_K30GZa9aIA))eMZd(P.JR<U5W#e[T4,5H
Mb-K_A;fdC:ga]AbRWc?=0+aJ6=c:]74=fPN;ELg3Ea(&U3/cX9@+]GUFO<<9((G
PE._5]70QZ\?-O^HBg(W/e)XE0AOD_c_VH+4>?5.MV1BNX^4L/^RPK&4:G;WPO=5
gCCX1OHa2SJBE:gGEWH2-K+ISQ6b57gR\+W<<_WP@Pg#-<^7R=Y.6&#D^7WCU;2J
f-bQ6_&W.\QeS?I8Za,CC\L/)+^f9QTPZQf)C^,#M8b66]J&dcE=W4@;)[:9M:S#
FE]Ad4b:+/g=?Z3L01dO#6;>GGKRCD,JKN&c:@WA,DIUKd5gQ5+_J+I&2b+?4?P6
_;U-K@UD>4ISIB-]<J><,gIVP..HHJ;Z0T891B;0b)W>IcBYC:2P&\C]_;BK8KRR
;99485N#O1QUK4.R6N5a&(@YERUD#F(N8::Y-BP9&.\Z]:+ZKK_ZE/]:1,3.;>L]
3gV#_0/D-a^)#47W7YDQ2-MaQd=dLPH+;T.[/\g@-W.;.SYB<Tb:;95;A1[F<:gW
W7(E@.^QM81>L8T+#C1;]EY&4A;^&7(CK]_[)+7@Ga(.+04;5.M.C-ba6I0\g@L4
AQ18CH0(,7^G+2X915#B-Ef<J;F74?JLGNaNO7cZf5QG(;I/dbLcK21Y\:#[QZ:,
&0@\aTeTd<#KUG4a/>G47NgZ8:+c\J\GdB<N]Ae-A^U^,::KBS/X762cA@HK7625
.0[S+D0b7KM,1(fP2]REMb=J2UQFI\&EHfP]EC3ecL#fQ-\7-I(Z83aFcKU;?4^b
#3P>28X\TCfUa^:5]VWgGJIJK-2?+2V#P#JY.7VBRc+?AS/>B>Q:T)VNa9BE@=,E
A,].cbVK&5K.0724?1>Ra,CGfC4_ZI(NN_537=E0.e/K8@3?C.:8C^D5db]M:F]e
Sa2SH5I\b+NL77^\?4:^8:.SF2L/)=PHQ5U8P/2e^S.,Y;XTPO7[RFOCCe13,VQ^
R8>3,I-[>51>1PAB=Tg+TE\DN)3g\X?Na.g(Y&JfQ^\,4Ne#\Le]b56gH/DD6ea;
be7f5F.EfYP:cF^G@95I/5gFXDg=I-)H)F?.^]YBV>6K;,Z4bZ?GX@+&Kg,(QJ8R
,+)]_MZ]1JPDE/T2SY;Mb<5)d@&RScg?W[<^=M<@2BDGQXX;B,1eV5f,F3Z.-UDW
9bZ9L6T3(X?^0U5cBQ_K<Q^26S58?Wf/d?TBG?I0=+<DL8b-LWWe(1?3YIcCdMZ5
PZ2:^;Q;QQI>([@4PgOR2A+M+@89f8Me]6B36?(fPRdGf&)5Q/-O:>#EO#_=I<?8
;F0316JT]S,A):+fT97<XR^6+Uc(9>AVaU>M2aZMXf@RJ.eXG>G+6WJ8fA#=6?_1
@7^O3)<8]JS+bSEK=I/XHOf^R7ZeP+C/1cC(;eg^Kf>T]d1e0S2gVVI8UcF4\+V(
IM4?8&7V1/D3=>a^W02JU=KR=3=6Z&8DEYfQ1^)MP<e&D7EK2&[TY=0=U)5gWFC(
CK\)#SC(H20&JKbMV)f^g_<I6Mcb5#=QVIZ_1TCLDG1VdGRRH@IMZ.0?5feRU/2V
\MB>.H#/+80,4I,8:8KM2e])@a<(.e()+g(f=5PDJPHJT^;dd9>=91YbN0d@Y4=-
O3geBOPQ&N^UgTS/^,OU8-1X#fd9L3??HHgCD@P>>G/(ceaCLXe.V80Q=^&E]\9d
O^#,SVUYc<9a7B:6Lfg><T5R:7;/5PcZD0Q0>D4;OPD_f9NI[U4;+MP6.EP\X4(D
BB;e34^/&8X<^<.(\(/g2U=55LP<E,YD-9c3MYMZRU=&B)#:?Q54RS?gAP\R>58[
1_H][6/([KY/TD>a;5;VA(IIafCCJe[AQOQ3I]Hg;-OFAZ:NI[.S>5OcMb)9B8ZE
(\/5(7JDD>27NQ?>B0FFP1_8@Y_ab9d=C@Z3TS4fN^B/MAKQB:ed&<dP<g,\(P<.
7.S(V>4+ZB7?O4[&+03a2?P5fKg(.,aeHFJ#9W9G__b6d&,dC3e5eL<V-.,=YS5P
@dD<BGI:K.b33D?]cX]@5\U35@&,TR0&;4MM^17b-](]SPdYc^fW/b.-.XP63Xb:
eH0DG7]>3d5a0F3bM#FX1TD_=_-C03I_VL\+e.DO;X?=dNdY5SGBZ5[5H#d\[)7-
3RU7\13R=f[8^c\PS4P@W=Pa2MT:0R^;S>M4^^JXVNQV(G=eL_1QT#J@Ye,UL17g
N^\9K_L?7)]@)ADRbVHY<SK;AHVZXK7V1AY=J]fR7/d(2B70OU^;EJ1#:6E/\B[0
@We(O@U:76H]OOE#,(ZXJNT)cV54#.K3G.3=<^aeN?E63:+@[-4>#CagSRUcW@WD
MZXZ4&I3f3+HdN>>([XVVg(X:cQ4Y6UM;60-E><IE6SF9_@-RV\?P(/M)d3B]4PN
]<:OG8VJ+]7Z((^3SN>:>)(.NIM>PI9]VI.1)MfGPIdO8=.Z^V47A=O(X,-Dc?]5
bbG&R65fd3VK@V;);=E:<LT#>4/&8B4S_HYW90GYS<Ca/9Qb65gXUG\@0A>a)@VX
?4.@E)K-T)P1/&8JaWZ+gKSE5QG;[L/,gKeN9:/Z2;R-L7cDB#[H\VgU[DQ,ID:0
B9CMK)b2,4bARZJ\E.6=:A]UH#]AH8&6_D:P-\DW)]A#b3?HO9BA]GQFA@X=Dg8[
9\9(Ce&PaJOe]g6C01)\V#)7b8Xd(PVCLNBD#7c^a^55?&bfBgTJR/KI.L>P\ZNX
>>W;C,ffMTECDZPBdFdY0a#FKXUL8<J(S9#D<]f:A9e(1BDW4)D8[@:YHb6Ldbd7
QYM+GB6]K]@H9ET\\fg8LCY3;CX\QL[U32:9KEfQaU9HM;E(M<b9])(bN7ACS:G^
a^QZ6.f?G^RI3C8TIBXFBJT>Y_:RE[d.SQZd<3P[O71RaF89.B3MQ+RJUI.9g]g0
#NNP/Y&QU3HXTMKfJIKZ:XPW;X_TPV#&]@./7ObX>.dJ0GBeV>(U=.fL9cK^5[<a
09;=8]A\VVZNCSH8S):UX5[:(#CN3Z^>bW^;6=0<W4eW9YX3Cc=F\f,2</46X:40
4WCM3&[_><BC294VQP?Q):c-B^cN7d9cE<[6NQV4\9X:b&YVQ-&3X)>g0FYdW_-5
SQ/;E5=6DWN5&b>U@Q<YS-Q)4WaI>6c/6SIINQI67R:O6))N?/Q?_9\T9G/E76ZJ
;NL8:C[A#5L8]UC]WU^4,IC0:LP[3:F&8\WbPH7OFA,c(V_HK_cMQa<83RA7IAD.
+_<1ICZ>\gRR5@e6CQM[f2IZ6Ac1;,bN0NJHBSN#?X-UeYRS#A[8_LdACS)J@,f?
=O]c0JG[VI.d^V]I:aZ0]Q=f_;NJ+E?>+OQ\(C?>?F20>^W]8BN8@)3\F:E^X-IR
e#Sg=:I64AFH-@f9=)BfLYRTg@L76E=N?GG-eeRf,NQdRM5dT?+K.BfL?6DcBF=#
>SIGQ<+MT6L2aO8a(,6D8PU4I8#M/1THH)1L#XdZd#WfbEL(.N?K+->e)L[(4f^M
],_X.WMJ6?)#3_#[@[c7)cV3?#\?M>R3f..7,SW=AU=]Mfe(<R,FLf7J1bBa.OCb
G?THJ9>:N9N[8gITd__82Z/=1cDC/7?b(#G9U5,6cT(@_8Z--8VZ=cOQ5WSCA>-d
Ic7aN)Q9U.5^T:eQ.BWGEFM[H=#9/3PYQ4Mc]gXSM_MZQbdO_(X-d.b^6?MgL[,Q
1Y\48/+.C3B6CC8+,#HLT?f9G=W8/3L9?IaV7#A-86[Re4ON+MFAe3_aHTF1@X<(
B5R^(PYJ679R#LIO^J1;f)5XTOfPT6H2FGMNN+)gB\c8;U>Rf93JD#5-7WC2aZ23
ZKM@-?[:Yf?5F:EdY[YT\K<]77[IN5PFCZETK84(\;f&4(N:EV9/R^LR4<Y4\=ZK
9:I\,-6^KKK8H&0/V_@?Lc@/E7dO(JAO_:R#EMD4>_IXcM51C\1+<N,YdB(K>USY
+J;-?EeXDQSe^e)Saggd8K_0TffFL)1Z<ZaX1EFHWHB&FKT5eJCJ8^#^/@--P1#H
^U31?a[]-@Q+:g)g/=9PY3a0&B#)UJcD7e[2b6GA>@/N9>GB2LTD@4.^d0/?)D.E
3;D,VGE1QFPgb@:K=7a8I<2^^+Ka))KVE+a7NM0-6AABTH><F4(S>?fcO+XGJTRc
^/,B3^F;RL[N3[<[X]L,T.AO6=@Bf9M1\dDNLd1PN+Y:;[,BGO54CTWQKLa6S^9Z
D\[ZfdKcY@&<92/W1?-XE-BKHP,NdU8?A_;9a)W(BJ#NOfcZd4RC>PJITd6Be>UB
OII=@5UA_5gLB1W0.aY9X]OC3X>JcTK3AK?[[7F,-1XT1\?3/.</3H3(_-YJ)?L@
?[.QFRN2=[Fb+^a3VJ(-VWe,L_XN+)1--VB2fd[EMbO#._7e;^OId-^NT2#<f45c
cGQ?JZ&P>)TAC;]B3E@eNMFTe_-ZeE]\M.Rb6A+7\FIM7_8aFQAYMX\<\f?B#C24
0e=<20S]<2P#]#H_bb0=GE.A>Ue9.13OcSWDW\]/d8\e#..3,EbZPTOSTf?/GC(]
QV#VPU/=>8Hee\-L-[U4<H02U&/O<a@2Qb6JMY(0M7]\>fO08e_])AIEcM&B>5I8
84;-LVL1FXE?-@aIT47?=)>O\>S^?/Z+LW],A<PTf2TZ^E:DM/f1^eDVc#eXXX7I
WDefQ_@-?Q#SOQ.3@,Rg8WPQ_0F2>QJ3<V(dNf5-P^.0;e1a0EF+91/BfF5fK=cC
UgUIN&cTF5(G8D_89C<Ga99gMVbfIZ.[<eM8MA,(,6^]R^gd\_]K-.900eDB.UK9
BT+;a_IINM<E0&aAJ+F7,aA><NRR(9@LJ<&G>,>bYaH_GULYWY-UVO#;MG4P5U@H
a5JVJbgfO[&&CX#_5XcX1?ag,&(J#/eBSWbQH.429.IXZ.DQIgT)b9R5I,D[B)P@
G:./TBACfIJY/RQ4-A?GaF(WEDD2JT[M<D()@]c(N]egBOUMdc\RRY91F&g[2faR
X\UF\TB5NC+<(CSS0XC^d.__d.)O,+EZ/5e5:;L[N:]0V^70Ce-<HPM+c?;/+fK8
PU:;+7O5+Z[.#JNJX>TH4B3M6EL\QS8PR2TcORa@D85P5aN@HcH+.&FPBL\8g:N9
f44QN-.:]0C);)(<TBd)41&B<4JYB\=WPf1IKc7HQJ@P_XMT\c)?1IZdFVXRH002
9Z-K=@TTKW]^A4@VI955D&1\Z+KDWT3HV3bL<-ZCSfG(NP6:cV&^8FSVU^F#M)c_
-_J,L3eE@<d2JbCE=])]M]b<[feS;5,TF9R,W[ERG7IeKHI5.^1&)&.D&3VHf=.O
6\S+8JDMV^GPVeKW]4S1SKFJPHXV\F4OY>(MF.G0I]PM:fS,)O=b+\?IO4;Y+6fd
D/A/MZ?2IC)54<fEQZc6_.9.IO^Sa&3K0?6:_-[RL88GARCLTC/gb0DKWP(O&/(e
JbO4.2UYWRY9Y8RDKV=fN-G<S\0S5#GbVd^918DSY234DWJeWeM@BY\]&56/LP5/
#b<,GfDB;AE:AH&;9U1Gef7(Q<RT:17?YQH3^^1bPK><HfRL)G6_b\3gW&K_KgP&
RY2ac@306V35CL6NG1Nf:&Hff@/.XdG;3V/U4g)HWS>[d7b3CD[[0](+5JS>#a;S
A+_&cXTQQMC.]c0[<1@LeQ]=KTD^]YANR0Q)SL=c\;@Z-+?cP=d:<Bd?&)_0MDGM
N93fL+=-OV\>gga@@g9YDY.VTaG\#V0ZLUZ<I?ffO/0N[XXW@T:>J^L(5f#]G>,c
He@WQWe:_#:IH=:SM:,,TCHK)KfZCU7(LMg3&Ve7#\8KK2Za+XdDH]BcR,=&gf(X
a:f_dLDWePb-8IDS.-CS4;V(5NT0-4V&bMS9&HPN+<XJ-#^)NR=e1,6_(;_&K2NB
QRE<cM_]#^>5N(+C#EN]AD8&F#(U-OCTDgXE@\4=KZ^df-[5F3T1RI]gd=#4;SSZ
T[>BUW@PD-.+2PTEW\9,5BW=H-]M0:=>P32ANIWfcDTJZ@WTP^&>6@3e/aS;ZW[G
BPFI3Q9<b\_X6):H3C:SV6R[#^ZAS=NHV/)[Zf;L7L\#(@EH;KZ09A,OA0,JR3&#
GJ1D)1\-c/JZ<ZJ;:V751E<,J^X8a20]2^[Q6KcM)9>WBed(C4-Cf+f6\9,0..N]
)Nf-5P_-.:N;[<Q.]GW;J/P/P,&Rb8\QfVN1Of_^T_BJ3=>Wa9cDYQcJKKG,B0).
,Mf\/3-ME+Q9;:_4dVI9&.L@Q)I)d2B<D<WEP5-FRP\b<gH2TZXE3F^;&?dF3ZF]
O:7S)eae^;J]8J&K8T5:Ef1=\GM<@Tg+CJ=\8,H_.?a6ae<)R_>].,JD3g5Mf0]8
S50<:?.)f=1()9XYbP\EEU=QY;M7<VL7/>WXW-FNL/RbP4R51C=gDR,#KHE7RI3F
+5).-7[gBQ[J,^.X70(?<QK/XVQ8=X4,+0f]RA49HKfd=6E[/Tf&D;<:DE_UbHVM
/#L7E/)aF4HR]g_,fY7AA:E(I,Wg/dV6W9E)10gSOfP#C/41e-T@D@;?b;f/U.O0
1H+H>@=H6(bM_<+6>IfPLeadNRP=ISIIO<9@MV#CdaNHV2[&_;]5FFBT2U?+,)4X
P15(6O9Y<K9F3]4&E:OVU)KcQ]W+=I0c3_+?/;;6&+PP+A-.>9I)(GD(aXBE00K4
b9a5P@02QA28W[JLSc^?R2R.0g_dV\M?ff[NFU29CQP;7C>^?1BTg;6aa]=K89B<
5bX0/<U:>P-:<^4GOM3GN83BKJ<cBST+<bO153HT@PS7fZ8?C/Qf(/WcN=Z+^Hd(
@-D^CB?a^^[J+XYJ.(?>PJG@_&Fd0>PJ/]R&bKX(W[UTcG,af_3_YA7UUU;ILdbI
B.\&#T6J>0SC#E4UYe10c&KDV1&b&LaK);Bb=@DI,^H+66#6-TaET4J[#ff,2H_Q
>R4RWdNO?\NUKNI-]cCM^2?5_+VD5+HRf;d^+(LJ5Sf]agREMU-Y+Y^&R]I/6QL<
a0R&PgFV9::WN,OJXR[A@8.VA,NFe6A^cWM74;cX\8+TF0KBMfZ,b9B0,JA/+I[;
TCN_1Ca91IQR.MLW?eJNZ>f)&,eHA7887SaX8++F#GZ5HX,b(EW?W[_2Q<EAgd2-
Ff^7\#d,PLZ8FLZ9>K766eNXU@6bF:eZ5gB<B-.<M#;+VScH(L9a91>LZgJc#.&1
_66_]K0Od>_(bJ(5g\0N_CCf3aJ/GCcb&K(>@KVI4)=3f2+/TER0HBJ8CYb@Ddcb
39P[0OZ(Sc?A/3gSMcV&-4&#;9A1-+4G4/>bb/5bIZA9#d@_TD1ROI-.]#U,/fC4
2(YeL4@c-,7a@Rc_4@VMb,?I95>LV)/8c4QOb\26O.V@2)UIc]F1C4PN23Z[WKFG
6^W7<G..A51FdE]CBg_,G;AT6Zc=WZ0E&K2&QT?e5E@\_5aV,LgL>,R#S8ZOAM5G
.-W,]YH;:O((Yf<Q9d>CSa+bK^CU[U>fB[b4A#.:=9X&9R@MXaL,O4N/RE8U1)\K
JJV,VE]>TG^g>#,>\H^72/^_#29,NSaEZ;:FEWQLg7+OReJ6@(g7-[6QU&NH8-B[
H,KXL,A34c]a+5.IYQIY@e9=@bX)X2JV_VaNJ8BI)5V_W@ab]1=;V(BHCCT#<Le7
2T\]+1S)\5L4@PQH5W5(+<=\AgLZ6^#;Y^^8/)LeMG6f>A9SYfeG:.3+1OB\)fI2
aZW\(61g79E)f@LQ>FcD)]e#A[I+5UGfeeNfO/>dV@M]\(Z#gR0Q@F\2;#Fg=aHX
c=<g-8F+2NVEd_R63_ES>9OeHZ=2]P(cF&/5_U)^68SS<^\]V?O^R^VOIgXJK4d0
6EUGS.af;<7KKa__IN0f^.CU;d]93.6W.[TfJCCQTBVXUYV<;#NDKB[+R3eL/G@c
-+b;N0X]\5BUc^_M;f@W>N.[?K(fJ898366:N.aGZ724S3IGL1\M+:Y<S1P>=CeE
47\\Z67#S5MSO<I0fLbQ2?6F&#TW;S#R3;LNgKDccQ;8)Y[df(IM_1>T?,T[?EY>
W>+G47bHB;8X@>>70Ke@#?U3KH09QS;&Oa9[A&XV?ZV+UOH6:<MO:0,Ea4,B;Cf,
N&?Q&/A\W=LZ<>WT<C/T;AI<9#QYT\D228J8A.IgScHVXJ<+)S>ZC.^;^>=_MRV-
.WO^H:L;;C?YFFFT2TSF&/ZcgJ>&e;6\3[[K?_Y/_3YMV&-Y@&G_T(5\&_Z:3_\C
,95e2;BGEN;f=R2F71DDB5-df)ETO1QN6M)=Y;Q=5=PD)bTg5FKU<U-A3NR9@a2&
4W[fSdBD\4;NPbeXFGK^81;@_;US^5AWE]/XP1]f@QG&5T#LZLV>48M6b>,Z2]0I
):eU)CJ@-2U\ERAC]80dWE[7cD-/U/[VV&Z@0#R+)<8GB02RNT>]]\&W##X<X]\[
^?[1U>-9YAHZJ.VW9b3/3-;Y&V=[@g<T2Z4U?^F\Rc6.7.Yf;Od@?T#=9UgX/3IF
+5\;6\UC_2B1d74TeV,P>J;fcIPK_TVg6;H5.7EcDX<+41@JO+3=;J+RaDH_\ACJ
U\_]6ZH4<_ENV;Z,2b#Q.,N.T;XE1#Tg0O_:C+]ceT;@g2YHQe7Y42C6LQMc.SP>
I&a9e5[8-?<9cb?=G@>Cga=PDAA8Md1fUe<)NVd9U&L[(gR95T7@N,\J4Z_K\>Wf
JE9+Gc@\fe8b#&=Z<d]6@>GdNSc-]M5AeR\Z[/6Z/-(R=LCgLJ]b8P<2R<>7^MCL
5SA,_)-^Z40=QL)gF4K^;7#SaWgDZ:<4\YWfI-b,8Lb>bT;EdAPSg57U>O8\_RIX
fK[?A2C4Q253/f;KZ(G8aUU:_g.E_JDO,+[(YE4^6)0D]@TRc_c?F91EQ><B_ZC1
T&GW4:L_W\/3N)cTV/S7[G__]PCYI=NT@(@([FJI(#H+Y^\C0/@5>G2/AH/=>1=0
A+1=RZ]FH/V+cC_OT3^LA^gC6WL_U2G:_JTYQA40Q/YE9A3X]EA2Zc@V7&Bf;Y9?
:=S.B3H+d^N)3NUJ&=Z2U]D,R7TUJ+Bc<M<f/>(O5C+#WT)?NeP)+8&CES:PG.4M
W^_aPd)Ea)+\0(^>B@VUdYF0/>_<,B4JaM^F-]eQUA2(ZeM[ZIfPe<YBFCU:&J\[
EHGC(a+\J/fCQ47E@C9DUe]^B&&1JM\LFBQ_C&TGA3_[5/AF>baSTG.(Na-MRe0e
YG:TR:McK<KUZ4_E\<gZI90aQ3L_M(cI)K?>()cQG<QdLcC4YDPcQ#d^.T^M^-BP
fc?I4E:Yd,NbcV7EP^]X18#>d6[C+GQb6./&AINUH<[6BVLOeUM=@5#\@CG0bZ1?
Q)GE@f9W8+L>;CL32;\33J,GW?9e6YV6)f+Ce5:4>gC3G/C4?G\@MG_P.ZZJS<R9
=^RDZfO1fDIN_4E=gF=JO2a/(RNBS2>,.,_QHXPSZO+,V=,Y360FK6=c54&4]KcH
b^fU\P)7@2S4S4&PfE:B=[5fZD24PVYNK>.JQ1-g9LA<)/V2CD;)cPDXgI:I=T6/
C5^.@G^>Zd\gFI>+FWZX^OcS,:-_8;[NT_=QQaPfQR9;G)ZMQ6(c)JIU5(0HLW7:
WVXNYPW7CGa;H>=IeJ)/e#42LQ1B^D3<RZBPUY#T8\8&T1D0-<5QK(RL?f4>C/Ad
9A\-YC307\IBf(9J^ZG^-?J2Mg5O1B#\+KJ71,KJI=[H\fY[@99J?D21daQPJ;d5
GZ,E]QPRL+R8N^]WD[DU#I42)HaWP_./_@Q=eU#G0]AD+[8/).DR^N?&g:M3U/Q6
PGaT&>LWZK\\I-_9V:c2T0gLcF><IdY0W/ZK1.A&Qg(T)XTBL]=:M;F[73C3R#D\
.f4ANO2T)(BaI\:48VfPA8=OU,c03>cS:/Sc5#?0(W1CWQ\gLJ\B+;)c_P4T0<B?
2Yc-MTJ^gCA]V+3VLUGW6_;:/XcC5D#8KZ-K;L.g=J(@];eYg7B2NJK\J(?K7(,H
CG8<_=0F8@+1g_b>adE9MVReM@1c&YBbP/D@XfSON[T4#ZDIE/3c-:A7YIB1)Ma[
5[B[OR;b)I)10X^>XeTF:Zf^/BD+Lc?/D\DDFFU-\/B]:[<PJUd]A,WTQH^+Y;L>
K=^I?Y8c]JDPa)H2-CCZ/>(YV14:d:/KJ^PYCE3?4d#+(JfP.:24]c(T,<^6E\NR
(8=T:3bA>&8P)JT#A4=_RbVU;>XL>.9O.0K?F3a[I]dG)a/A>g3>/OU#&NRc]@8@
&9;MJS2CeLA._9M?ZGLM.G02K+7Q4d.LBJ:=ZT\H2MBgRGQX0)\A-QGT=(=:;J9O
.BM27TCLB3cCSD7(\N[-P.QA<3^-b#L:e92WEIJbF6AP?669?(7.]2c^.g]f?bgg
DF8.Y\>)W),.]];DPBTc15?6<R+Q@?>OXcW8:C0?:g\eF37]4;>Ic1)F9&-M\?TW
-^J\+C84E1Na=#]9BOH=_ESSIO\2e57\cMFKdU4.UC>_P@V@8b<I]Af1L^=IRL7B
Q[X^d3KL-\f.Z@(Q^bWWO1bS737_O)8X-)WFESS0/(GKN?;0fO\927b?&M=9><UZ
JeH2[B^g?&7-//N]e-gZHE8_(8IZB6(ff=N9830-\PE#a?2H+<\]Md(Na3Z-^9R:
:N5K\SAG6\O4e4IXJg9#O)TO8]KOLX#<[Ibd;JB&8_G4#ge_)4>:,GNY&?Yg-a69
=?6+MOaSgS\6)NL,>GKRN)@GHc=?X67dD6>QP<:)4b79A/^98BKD[MbAJgF)FFY4
E\ZP582W@Ve5cDS\[E_)8)MJKJ6FT?NIM:W6FB#@gP1XZ-8Y4#@60M_2N,a_=6ZH
2\8HcI,RL&V=D]#+Ib2KLXSc5>.Q5E\Z;bE;Z4OBQUS9E@BBeg561e4W<Nb?;LcV
/Zb.[;X<T[.E@;Q]FgJ&(X1@^8IF,^,=5<BK-#c9&E>Y,],U7Of:f:\dK@_8+N=4
;HgL=cJV?8NFCD,B/RO5S8dDYNO5IZE/I^K1;).NKFC)?<Gc:3^DU?g(^=T\dC/Q
f9X4a.>[4^;gSf#KHQI(?SE]OBb<B4^,3CB216F1L26ZRWCcCS1JLZcG\YY7O4-B
[b?7(HAB:<+HegQP?1T>T(P^g(\KH#M4=7NROOOa[GDFM?M2V7<SWF0+Ja/P[_]#
P?KY9E,W5;.MQD#J6ebEb)XM7M)]ZA6#U+K07+,JHK;c=O#H?\W/\DaODK(D7H,J
G>?9>W,\H+0PfVL4)UV-ZM:>0QAZe&4@G#1]2X^YIFF\K#<,?2(W0T&6?-DN(9G_
BC>1YZ8=&Y)XT172I3E>6VXAb8W-YJd66TTE7fd5G#\aaRHKD,QUGAXED+FD,-Ib
\TDWIA-+=PRH9?8cZ+9N8MI-L0/OBbU2X_Z2+#+fCJ\g[O-[\bJ1TC)JAg\RVZ0Z
;ZL.UD;S[Jg2V)(8D.N[8B]Sb?b:3>fX^X;YMbWN_E1YXcU47URHU2\0H/DI+Vbc
S+?IST;4,ME[H9D2Z]GKOWMLWe20eLb)YG>&_O0GPI^Af+_?^2baAOWCVUcQDX+L
,]F_c41?FYH[21,_^1=0O(,X1##PgY+9?8Af;D8/A&=@,5,E>TKc2EW,Q:fePX)P
b.ETM];HXF&.-N,6?+ZPMUUb>7A=6,GYLJ:#NDZ=25EQ-8?8HA]aN(S+4(VC:;&A
2?H,GLHSUMfB&fV>,T#?P#^cF4??21>?@^V(M,,9g<KeGK::f>.bRc0^-dUGSe9D
1^C>>3]GeTR]H^8(O3[LD7f).-[O?D&dD96CFJN?B,[d?#&&)9^-8cf?NLZg:ZTf
^T+))[87_SaeKT9A:VAOgdMD>/.G?=/+VE[2f/A2YW//RaMa?K2f6f,.TagE>&^&
A2Q@Q>_V9gQ]UX5\J)&f+b\^T(]&HHZEBXb_K)RQX+^)e.,NJfVg.>>H#5-Q8d7a
O2NaRSOcU>T+PNF^NZfcE[Vd]Ade:U4.TWU;Q&^>+V_>974g.(Db@F0,M[BR)W@>
W7AE-]c=NEd8d(R7&R9QFY281D&QIL(J[_<:\5;PHBf94N=@].[R<:T3Y4N[DWZN
N+)RQLKJ?B(X_S1=VHPQ?]4\H:Q>.:V8M[OUSZ.-2-<94QXRRHeS2b3RAZ2.],30
BFZ;@JA2@e:Z2-=/H2P6]-7N@b-._/4##d[fePX1MN-Ofb4CT_DP,MI\D+0fMAE&
1\cOTAM]L[<:K^,IJ\[c,<Z3VG6.:eQEP,ggeL-88e@U6Z?@MK?W2>GJ(^Q@gR9S
#&NDfbF6g1dgZ&YYT+_>O<S>;e<JG1&UM:a^NJR]4?R@&P)F#[<?Xf6cd1[1ZN8,
2I6I(4_9M7&(MbI/OG#^_-DCX_P=#@a7O6\/3RPJ/=LMFNUJ/+QL/^NE9f,:-+Fc
IbTa(A^PAT8NPVf.^C(?^M]/EU[L(SRd&HD_0+QLPO[/;_6?SeSN+RYWE\S3),Z=
A;[6G0UVI=(](Ve72AUgF3HX=25G(3:7V_;GJL\J^GO(AG/9A5@]4#c[S+)L+WJ[
F5GRXC[&D_0,@XL\^fH^=TFW4&NM:=&OCMdM:IP?OS3X4bG6cFe/b?VLBGTRgHG>
QX\(HLFGTV#f&WgX@9N;2,EZ/ANe/aLT/\5_[>7Dea8>PRZOMKJHE).e^MAaSNdX
@CL)6GG96IK:fOU_];@KDJI1T;PcW:,&JaB@Wf).QJ(=(^.XDgB^;A&[P^(5Y+UO
W1IXI6N[P\Ogf]8X(d&BG6JQ(&-EfPW,A-5/3gfK&UdSE/[fb+=D\P;b6Md6#78]
ULgYS/7\?F]J=S,[DP6)J=2_H-74B4ZCVITeZgVVFTcfgXA(T@\2NgG+&<5Q.VI5
<ea8Gd)Me,Z.=b[_EX:G3:0W04IXOZZ8D1MBZ)c9>PEB3W+,#77VS?]U(+g?AD9Y
&ga2KY;F+@JBB69YgAc@<?fc+Fa=[-.-#g.D0dAfWSYGBAS2KAO0]d&G9HSAKI-L
-;eE(_fg&3=]W#)+^\g#--g)B;C9H-Z(H=[O-gS+4#=7Z4,:4D4(ET9F6IE/G/Ff
TLG;W]g2cED,#fa4I([351S??OJ>3P0)J\2U0?K3)P^M:Ag1W:W.Z.UQ5,QH=+_4
>/[=e5VDJ4^bfS^&P6C93XWA05c7,6]M>(\?c<#fRE2(&Y9JGDVa>B>FG=-T9>3)
Y-J^LGWD,\U@+E&fVBK?\+<:;??IUg_O@65f6\]J\&INHN63.X3g_ZX-LW#C<YRN
SM,_T-VKKPg(/(7)1M-2FJJ+5K;3HSJHI<-&f:V78&78ac=PL+ICaFBd.P__/E/;
\+gf+9,3ae=3d<X-5c8b]7H1].0AMIf/]OID+#4,HEKD,T,7Md/JVI]7A:?]<@69
I:Oa]_E/.S(7aXWF7:0Yb(Z^.)d=PcEQ=[Oc_F4;2#eH-bJCEYHP1O1G,J?5P,DL
)f&b8-LdK/RKTa(,W8cTH)d;>)5IQdSeD;-F/67L\6HH\eFJaD4LS0QgXE,0A)RM
HM=c/d7a:B--29R/<Z1UQe2SV+/M8UM_TC-8A08&4a^B@fCMeU(U<V>0@#]KAIS)
<Q5M[KA[,\,g<,QX5(Eg1G+_\=X,1c7a[X^7RfS0>>@R=,e=4;KDAW)c1W)1F+[_
M>H?XB0<OST=MZ.1Wc5Y1=\dP?VUPeg,^Y^RP@G\(=cAcAXP95\/f4LB]db(1Y[N
+bg0-MZ?BY.<T?6g?Gg9Od)>V=g&LgVMe?b@,7M^8GA/9?9L#UZV)DAcQ<S9>30P
3+Qd@;_MID,K>dba17/KS,ESO=A3J(QgPS;FZ;TEaV-)4E6XK/@.a/?[,>-gODHD
-8=AfdgG-?@/Q=999AM.ZGI5R#GD;QVX=92AFX]bCC8>HS_VWP-;B3YPQeVK<B&B
fIcGT#242PD?40;1,Q&^\,7Qc_MLNC,3==I7@XX[K@^3XL88\aDRB[^VJ=VREdWd
C0C)P26EG=\)=>I[(gS(bG_#-eZZ-NKaWaL(9ZQJc\Q3,)\0YgY=59=VZIE;G+2H
\ZWYH)f7AA^SM>@4G)#_2P)IQ1Ld-DNW3NL2PZ_&>_2;6]\<3.:FELaW#>;QS?#V
e^0+-a^be3e#Z9a3[4VVb,QBL8B9AD:6^Bd9=;;SbQc0W\A;ALb^2-2f[;f?2^R.
51If?e,aD1_869/HDBa.[_bH]<Sb_OTa(BLW/=cY7OC5Z+Y\AFbRQUVF_S)C(,=(
-_&\7L(DQKE6B&[VQU>G_OPMU@BdfJ=Tb#aEPFJU?-,)e:cWGDBEP=8??M+bR8IQ
#dB&H[]7_/bV,>ZT@WbYPD3\5?2[0?VC7a=XcP)VU]WgFY+d_EU,\cZeT2.Ia_\)
S#W:9YGIBc[3;17F+eOM6e[cUJ7/8:EEE435Qd_X[BDI5f_.Z=bcJY:^--<SM1U:
[VZA5PJ\B[H+[=[?I&I\KT0<_),V1>:DJW3cH>Q=7_MWT/\SF4US[_e\e@184U-/
3R(Wf^O+OS3?(g&GO-9=5?M\8Zc9eQLX&?5TOK]R8#Q]_BPCEQ=B?]#RCLL6T8I1
MOdbc=GNN.:Z1Ge87Q/.g/C;-HCV#8+280cfH-M9S/KERGGNfZ.=#Z_(;5S_Q28.
S&ZZH2bg1^[&-c8ALV3\)T=5RD_]KV;DTOX:eE4#fON+TO8F\]OTY5YRbg,UAWPQ
6K4Y1bS;L#5)CM3:J5fOFB+4dFf#^ZeIV95F^XY5:;8.NG\aAJ-_bFCS#^U^24Ab
dQA+++bQYgC9Q;.>3HT^=)UYSfL3S1-68;\D\ATegEUH##QEKN7WVA(CcL)J;#2^
UHXe_@4)M+TV+DeB,6/g),5:XIeGO<^;<fP6]2-4B^CZYHA]&B3S)D?ZBS[Hf;2W
W>WS7_JB[8Q/F2a-(RF,&S)(f4J)Q\VH.UTA&:d7\F,<cH^;\36AC5/5f5#4;4(e
QVAN4P@g+V..7/,;PdNg5-a.-<U5#c._]28PCQO>Ja_Bde:aME:ZY#e@>OT?Vd@L
KJ=\/_O;-b=5=M)>.>]6\DVZa+W7c5;A0g(_MGD]XN04(LE8bf(2Y4&gO1^\?=(?
IQ-3U0]ZC1DEFVbQA;&)XA()Q?(MIQ^9N4UI0BEWR:BPL:)(#[F_FS--@^_fV9:D
\CZS7WYL2IU<4-H88,]1.X:^58I)4_Z(K8M_ZH1Y:#R5Z#3,JMY,=E8DZG764a)b
#=5W58bU4T_F55b3SYJW_T,0g<;IMS:4[9g@/RJb7<N()9C/]2,,)M9THdW]b@-(
&+#D^J6g-ZPa\^d4g^VDePPF417CPVT]4GD,?+)WZ4:\(70@2TKIb@=Qac78J><W
JQ)(cM>\P^?R&GK0Q&gNHGPACL#cX?<f-<=OW+O^IDIPc,@HI[)IOH-J=&8E6,,M
).A;PPM995R:_f:;LLdCSD_>X>1Y/;@?-7f5MRAV?eEQN]6P@62JBAEb5AccB^FM
fH3KbFc?G[A^a[bX:2c_KJV@6/WMZ;0^\9eVfP=A1X5?<R]&cMWf42SeL\7K/UaC
<AV?>U27Y2),PgFWHg0SVJX?,9X-]Gb4@Gaa(ZL2aN>\1L;>>gVN++UW/LRFIBHc
2,?>GF97.2(U-V7+4Z<M?a(+W>O71IN[Y0KKN259O[6Z?S[VJ?OU4X1.R:Db;g&N
92,<B&a_,;+c=J]&Z/;<H[L-e+1R=_&PFb3XM[cRMO);EOIAed-5@KeQC(TS_#G4
1XQE:IL@D_)gga7XA_M&]\+O^B5N\?e\+<Y5e>+U55N;#L5VcJL-F;e;^J/Z;S@+
GK^/R5WAgX)26:2)#@[IFHaUCK(Ea6c@aH9N8e^]_=D5EYY6FSb?7IUT3GL8\\5F
P=5BXWX)I7-8G_1>]Ag=JK=?#Zb&4J;)@U>X(fe]#]C;+J?(cMZ4aJM7cX<)]2dE
.J^=baSMHK?0)6bKc@XL,C?Ae7,PD+b(<:-4EB\1GH^A735&UMWVSPZ^;dIH+SL-
S/47@JSFT(^Y@;1g4].030K97+9eN?-GM;Y\-gT-3/SMP6PN1Y5).\e0MS+/0DXN
NAC63MZMB+-P&+D<GTBdV]=V9[08#HA1[Ud5A1#H1DC.Y8P])O_/6dOBXe/ABb;+
g#795b03E35_)@YS@PJ28;ETJ1]NQae+UQW-VB\+Cf>Wbc6R5FH[V(Q2&,_e)D6X
Ub3-5AG8LP/1.ZcW^b8R+3&1VEB5?>A_>WC,RbR1]Sb+BK.XAU&RX=F0(DW2PSU5
[J.2GA#]P,^dL4>+581N5_RC?=KPVgO>+[^UL/&3:?4BR9<Zb2fKJRU@D@^e:;PL
:4(P^88L#C4GAM/gbRSHAR\OBZ6M0++?EcLa)2:8;OO;c05/E9LQM@6LaYG;Z8RV
(Y[-3Z^>A2Bb9/IE6ND1GYJ#;,_d2Q&FQ]5;R<IC5ZI)BLJ;H8GDO\&QN(+,79c1
fMRfYYMD7a?>6a::N&TSW><C_I2(#?RB#W?\FQ192W:(U2d-)P_e]=V6F7^L)_=K
)4d8@dYR_4R<Ee9YgG&W.ZL\)Q>)SN;gOd6J;5e88KdDEIY(T_:K?YA.WE>.=7)-
W4F[e:fZ[1W-Ic9bC<PRDS;\SS48FI=\9+K):4)_^F(#FeY\P^GZ#QCVYUQ6J6e&
d6=+HC.V1G6bRXgIZ3CJ4VE[ZW6]B9F[e1#+FYF2]\,CRD>eb&/F/COK9fSQ_aP9
gJ[IWATdK)KbUX<G0(GWa-(O?4:)cfc_f;PgfJ^,I5Q9K_N4V&0<5T]0991?VY&6
:7+G1TZfc9;&FM_&96Fd/X5,JX]RA-+THaUREFG1@f/52V.3VXR#/fV4QR@d=@AL
[FHEd9@[3HUM_c)^Df&0_aX0eHDQ.>]&>(XCL<C_&UB/@dI.g8,/;00(/bb)M/=(
aGS#:.&FN6cDYg(+GC^YfWD/O^[N9f#M<#[X)JQZ8T.U;[3ZGXW[,/QCU-;Lg=T[
Xb>.T;1cH0,fC5Q9.I&.)MF9S(UI9</+^1=7<ZBH-8@6_SP3cK(U0MLQB3:@2bLT
:.O&4->CCI/AZ#/JIPY]YS3T(C12.^EaNX\c>ec9O4P)8<W?fJS[?8GPfJ+@L6E&
fM-:P(@J7\C>@]O-5e_]ZRBEL8(+e^ETKCDDB,&f?CKK5+1^5:d6FGH5-)9Z=:=-
RIYSf_OC73B#61_L&5F_.,5(,E(/QQBYI01Ib/[:/g4@E3;CVg+0G,9]A8eGQB?V
((KbYcNOfOS9<WVLA)^eIeET^_E1Q6Z22U_2:8C(-C><6>,D0YU4L+NJ7+?\QO?&
?g[#7Q3G6XOC2J5A;J-7-YL/.<VXQ3)<GH-?<+L?9HTX2T><82:5E##J)94.>d/P
)c)f>O\J(-@Xgcc][),0+]?>V9AQ65bf;c[?e:,P7O-0g(LQ:<OL<]=g5HP#_YT2
\XLY5U?+3W<FMXHIUS8E]+IAZ<GM\LS7\_b8?6:bIJ[=79[?2>\.B+2YV;,@b0@>
8X@-W1](C-?f#9UOP(S,^4^-7JZNHA,<_fb=ASP>&I#UA+.A6GbX8)Q/YZTIY\F+
_SP7,I)>-_ZZH>7O7)OMUYG[0B+:\6(>B^a[Y19)<V8DMSKf-]<1[L.4&CW2XN#/
W#Ec\D)eMFa784&VKR\-)24]5VU8F.KB70I_25?.-^;&U/@&UgABI@b1)CS1d&<1
=>g>KIQ&XQTD]<bc>K=TH),.WJC7\>1=.QZ5d#?XYaKf&O4+IWM59K&TRB]DWB_P
U2&&L9BXQNgWBGMU+-K4P;K)?6Y(9W]fbVMWA0a.#Vafe?&/[9-&?cQbX]6aXg_D
I.RS:E?UcLc\aN-ZM026B[X2+WcAK&0HRg?F6X0+b95d.P.,)_M+d2[<1/1:3&78
CO[.eXI^UIR#a:WSa#P\3^5V<#\&+ReeXcH&.)0EI_R[;E,#]MAdR@5]FGRfUf<B
K3]a,4eW2NU7]C0M&D9+_(WJ^5KZ6;IB>6@N#-S:U//,RgH]&G>@^R52LeAJ=7CD
K138WHY;=\Bc9Q[./;]@A+O;TU=LS/QV,&&H29R>a))^W:3?,I5gN-V:#BVB]5e_
2^dXTIf]fLAV((If4&LVQeMW(aP/H)dUfFQW?>6G;WS_7)#O:2P_B9-OL8;/C,Cc
>7?BB#QI77^W24&,@E3L?+0PM4O-B0/@5;-0F/M8NbM4J=WGWV.9aHCA/HS67XEM
?PPW4@;0e;Df>])D7Q60]>b<V6,M]9QY73a?GQ:-DO__JVZ2N25?V1^TYMeO\dGY
2aS[3PJUP>D\Og]ZQ;1<P_]NG4T9H-2Y0/&[bWY#RQY0D.+;>9#31UW&-f?M=,33
FcGf&9=-1S?<=F&8b2VY,Y=96^8.3<H9B>A\-Ae^[;W(Rd-)6P5fLMaZ,(;[_(2_
B1&Qe.:I5[MX.QPYE&A0SbF+^B,213C8N(b634X#)LRNFCU5_2O;E;IYd@/Ab-_6
7Z)SCUa9?(FT6Mf^A+YG9Tb:_B-fP5-K)Q_V#LK7FQ,([JS4O/6LM-GSWR.A)^W>
V0c64HP?P]GM(M>A41\KS^L/6>I^Y3@_S+VPBAY;X6F^@2@CBI2IBLaKNYd4a]eO
a1g-RVeJ[5c]@O[]>+KO(BN)(P@#/IBW.-B6QRH<,#\e2I51c>U-FO(;WSH3d1GY
0(L1gT]ZF]S-8AZ=&2V5FEF6\VeZG&BP]EBJ:f+BM]GWJ<1?/XJT&J+Bbd7+g)L3
[gPJ8?NeCIYE&N[QdI=C3E#=.5>]YK_g)13K8D-_FTc]-7OV82,)/B_[]V\B^;5Q
].gGCQ::_)f^12=)?:QW&QNc?HUa3(@<;G9TC^79=_ZIaWa.VNdJ>JI8Q)c[Fc\f
H<\8a:^E)IIg^\UXPSEISeOEA[YJZW(T,I-6_HLVUa131V<+FR:&#D3Zd#XU=C&-
:\,L^R:WT&T-6/ALI[BB3B52HF[_2745W1JNV@A1O9<PH6S<5EZSVF)E4C;2.W>O
>\9)(@(TIaY2:XcfKP&4/PZ&\>V.=gN:X4TIP]SZU)=a+),c0F_NW9#,7Agf.KI0
+3PWIRA_6UD]RP^CCWQ,:2^VQYDO/8(,3Ya4bUg<7VeX9)#>Wg:FAPT:4QQ[T[a,
KTRP75E55=#W^b[(TZgB?QCB4Xg]Q7,3X1LD6=04LJ3IE;aGIURF\Ad_)#)1\]7I
RZ(4L3GDB2U8IEIK1?HLa,G(YeRWeDGF__/N+Ha9)/cULK0,@6Yb/Ebc[@_1W3H3
S@GSP&2[.?]M]EfL+Q/&[.gA/ebfXDY^VU.4P]43;W;BM>SJcgP(22=9,3.-.R#C
Te3aJ+VAAUW/DYFP(HJU7JJ<gf5LX[bZ>=B1Bd8P_@f82\0Mg1=W0A>ZZ&E[FX:d
UH>O@BX5][U[H=35WB9_&a104?_X\G9aPY07cIN_O9N:0C,/30-P0O?G;-Y,T53_
@#a]\7K(a=ZT[b8.I9.?LFJ[)+&-/4_X=^>a7X]X-b<9+MQ.dB)[48IbG^G<A;9N
?9)YYP<V-F@3+,?g\]@HZ<DM#,ARNg(^cWM<60]7[B<.3T29BO4A1F,]1-D5dEOL
^,>&(7d#QZEQc?)ObA7,[&b22X(-:d6[aKJIQVeOMLP;;5_K(:IcA/7bFVI5@/5O
,e:<&OI5fg^W9A_).OYHV,=Z<@NX68J4((NVcaN\7ZSQJ]2#@bS)?PYVMCT/H4;6
_=PPgd6WD=],K:]9F]e0VG]7?)\_d_&&1>K&gRd0\c\XT45<>)S@cDI;XOcD&7DS
/GEXV-a4,OG4/E=Z8@QIEIN^3g1TO]E5KP3MVAT\B;;&SB3BIfWR_^N7Z6?IfdA[
:AUSe09^>&1]TUQW5:RU7QE.f_MAaN->W?[HDC0=L.>Z((&PR81aT2\P3G6gOJ2a
D)JSC^b\e3K6N0#JR0CKSSdK4[0gWRfJgXb&B>aeba=M1e/U9ce->M\L#7[PTVU,
X5.T6M>/?M1QF#BKOGK8e?Pdg&MK0\2^4COKLIbe=He[Q?EV1Q,\1Lc/aA5VC(PH
8_6R;\1#Ab5W2+G=QI-=TQCSATfRTIUK&9F/>^c.9[1BgK/5.W8>Ob-[V0c_=,Cb
0\R,dWMaZ8]2/&5(/JC=-;Z;5O5^2ccU;.L3)ScVDIIbRdUF]UH(V,_,U2SCfL:g
c&FLJYHd>daR-L+Q7-g\E)\d/W)FeKg=Ng:gGJ&L/df+8A&XJ(e=-W)M(bMBGH52
TY#9A5Sc76b@G-7\R&8E<TUcFGa;D<<5?bg)X-HIZ+bRgBHP1^(0<<ec8P^25Y<V
.f=47]HYEI2HQbH]>eEYXW>8?3>Z[R[J2JZF(9gL5?K4[KKUd6N68)-]TI;OPECE
8HQB#4X;,H#.:RP+^<_ceND#@W.F7dM#0>&a3bOA)PK#YcY/ZU)X0<5:>294<R=-
#V]F\B_/PQ;)aR08-ea[d[JMYb2QROE.#+-;D_Oa:JfL+F:2YK7_4^HgI\E_F]Vb
-;\)E^R/+.CSRY[[E\A\SBN>gYfbHY=d&>bOGTe40)>0F)]/f;XV\:aJW2/J;;f(
8eJKC5VdXF^,.fLH@I\c7PYbRJ5XRUNR=,:_Y^_XA)X5fAODU-CWT<K\MgYb,T9H
4U3bI2<P4dE5-)PT#d2ZV8DC,WdDaJ?):61.)2HIR-KA8#X5F:/5(d4PL+PXWW:B
>VZde(TcfCDe[G=c+aMZ,18aC=Nb2A<BeK;BT8>TUeS6++]SG6f]A8g6]4O4(&O#
A-12QV3I)EI\bY>=&e.1OC)<?-B9<+bI>;_.:AdV&VUWRCMIaNZUMPA2,eM4HJMf
<b<26_-Z:07?P]b\9Y<+J<7M0-_/\[G8TRD#c.3L3/O93VMCSOgFAbYL]0(gD+6Y
V3Q)LHBW@)O,+7S-D)HP1a;5)NEMCK:SdM3GG6@KPbgO>P1J-S#/^4PfTfN0+&.0
OQP9W_Mb70_<R]RGPWO_BgD.QB+&5P3#^H[WQ?NJF^IHb-5LEB1J=+4&aa7@WN9T
>Hd@DM-L\Rb_33X)9ZVb>J-PKQ4=3([00+]e)f@e#_&8V9PP2O34(W#LNP984+5=
SB&6DcMW8U^0#\0dX,P@#UgE+0K458WE7de-85<J6g6R->Z&)KMdD0C>[UAC/Cg&
,QKYG+];;(QS-S+0]X_=9T#KRB]=KcHOCG8V6N><MHO&BP=dE-KS4CBUd9eA4bL#
CT&JAbe9.K:;aD.A/@VWGAddfREX7/CF?LR3ZX#U[[7(ZbE#[78#9FDb+BFRC1Y.
OPL0VU=E1)cNOQKVIBFI,@PP&=+(65a7T4P:3=VN#gbf:)Z5Y\]OIA<0517d6&Q6
<,N2ABKW,7\C1g6P?A8PJcKZ;G^7_?N,\6A-VgH&4_PO8.a(,9?C3+T3)EB_\Z/(
fHe+G,;GKS.EG9CM+9JPPdQSGIIA_]e24,0O12O?^Qc/SC62]bH=+LZW67Y.B9<=
D8V?.fE<BSFLJ7b+W0+)JWI[,/;G6>@L6WH[=Td8S_ggY)^f+d16G>\3(BCN]UDV
.dV8HJUWRSc;91?g4=2QDWDP03(CN(&ZW6[?fE_J.PX\YEJ6.E<:-T.,N;WZXPRD
cA>.M[)OR>7X-8IKB:770S7U>#/>9Z8A9_@ae/[54/I-L\0^ILP&6@&W)O]+LCfU
dXaY9>g=@DCSG-&@6#60?bB<1Y0W]AfXZWOQJ>fWWUZPB:?Z6K7MeQ=)5@0^XU>+
HR6(1(dK6GOQW:[(W]I_?;NDc@J\VIU2=A+27=:L_(DVaK/T\LL^N71;9E\eGC\?
eACE1g&c@XIXHOR\C?7P<)\G&AG&MFg0JY[;@8V:=N/(5c>S49:bK5=^fADPJdVO
cFfR1,gXY^-K6Oee7>GL<?Z8\J,JF&_,R5b[<WBbeODN1S=G=NgQcHG62A5)_dcI
W:H#^0>^2/K4E-cM<VPLT@D4A+?.#J/YYRg5LPgg66<Xc;gUeL#_TNIVKSMDdEg4
B3CQP/@9=.CV7JWB[-:e)L8M_@YSccQf/:-4gaW)@C,-A3=E(NZ^^ZW^Pd5TeR@]
NTUd(\6b)H=(,T-M3JgA^J2(d+-:E&=SV@Y9.9>RJ<8.,LcI[IA(Y8G-^7TY=.bO
E]K(\Ede1Q#3^I(SL<S#99AB5WCa_QVVKf76><&0Ea73A/_(R_N#<eHF9cD[bQVW
bb<2,S4#McTQCGNZBBgcOd.+17O@5V<[511dB2LIZ&Yc=@><a+GG&Z@,=)F8dD;N
)JR9]8\,NXV3)VJ4IPc1^#+\b2W+#ZP3U8.8?efeeXGG,]W_L?bR1g^d^ID.707O
8YKa5I>A[Y.YGZ.9,)APMX/7B5@E5]CA]1<f8Y]CIAQL21BMSMc<d:>c#Y<J4P,N
Q+W^)F0V8#+TVN2@WCaA4Q3H/EB77/^ISF:d_L/N+U&LM.7W_J?&&[c>,9UOLC8\
X<@S2@\.If,F8HVQM8UK^Kb.0@+,GgD6FB>;4\IUE(f.fXN9+X)??JfgU)X#G<)^
O_N^Z[J8PYDQ<PO<[>LU5LfQZ>PgPA_55=SCFZ+E5+dK>=W3U<b63D0SC=44gA@/
0=_#IYP;Sd#D2Ob]_E2FS?J792<2^,OXgFgUZe:?/2[1RY\eBZZBP-T5#=]a--&O
GX9T^3M3Le;#WBH0CW(a+10]&Gc5KOdG7Dg<G^5W_O1a.gIIO-bR/?5QG90C1V+?
T-N31\MKaWH-,S0D(4fB@dT[FU4G7e&WHE@-b7MP(W]JDJ<=>6-0AZBG@\FF+D/-
ARA<,>W-ABS;DH[33F2;MIePFX_cL@Qf#I183N9G(D^K\[NZMYSdL8dMAfT#30WZ
5A[:a5Gb/V]G5NV\,,4:ZT2@cJ.)aL&20b[WD_(]#E^KbHGX3&O94RV\T;1+O]QC
YLJ)gB<a6@0#TQCZTeHS>8N-TYV.UP>+#CC:V?S:^CY5FJKC83HP/B8I\T0CgCeZ
U/?0KZ-GCQ,=cD2<;T7,OaJ9H/L_JZM[A8@D\F)69Z)W=+?CJ4gJ,DLHV#0ERFL3
<:BHf].RUYBFF&f:Y@UG9HD5E?851fcAa7J907<CUT.YOa0^&UK>W\J9Y-D(JE46
?gT#c98L1TF&<aRa/NC#Q^S^\Z<HZ=CM\c_UX?EL\R.;SB6(Z&0/eCRP+/^YTDS(
I?f-H=1#aNC)Y@4AS8J9NX&J(8b[;/TbVA+\U]^PB#6fMW[<W4Q91=L&OTQEQ/6I
>cLOJV@fbQWA41Q@-KX]7U8X1>Z?W@:a:E_U5678fP8RG]fD.534LW0a@C=cX&;L
J-F?,8eMGFU+PMPW1g>7=(4/->FMSZb;g)EM-7?1g\EUAA0,EK?1>00D>HOY\f[0
Z99&FDJ=8&\4ff3E#ARPH<<3W>KeJ+]f9bFK_Lf1E@#YD>7[)A(cAQBQ^VEC1>MK
@GIe@cI-e8(^b-MAcO1a8aLRASC##T)G,H-/5A#b<e:/PeWY=dM^(d]]=+N&=UTB
F-:@\cAa&a;?0&/EI0;Z(I#T#5g3[5J<6P\Jb;^K,UL]ULe31(2J7DE9eVNV4b\C
NB7Z2G5]XAgWGFJ:1QFMbR1)d3S9:gHcVTQb(edZL1]aLL79:WF,(45c1>fS6=93
_:FBc,9FETPUFN9&7>0#Q^Q\S4@,FS.;;1JDUYR#KF89?cSI#>0[eFg9aHObc9c-
9T3@-=;U^aOYCG[T8^)W\1-/0++1(4&P?@JXLcSa+eWfKOB^Z.MS:(S+A&1;>0+(
aWSCcK-0C_HQ96)CC8(c;FgN\>WP0<HAdKGA1D76#L8&Z^2N+9WSGE7,7feD,]4C
8:Y&OHIYL@9\^V_Je9I6V&-a+QeWW^ebX;&1ZH//Y\8M=5KMg#f\Vb\_#1V1Mbc4
]]\3XTEZ5E76dU^CPSXa7O^+NeLW/+bb=\^9_Hf<\YNA/(\?/,ddCVLTS1;^WZ=6
N[0^P3f);?5SJYHSAdM[W2<F^2U@.\g1ePc.)MVTdWa-cUO=05)T^5P87=F,a6B3
>b8RYI]_[[3X2a)5[#MVWDL/L.TZGGdG9C1MbJ+_bQe#bAdU-:SEfb)?FUDJd@]6
YK[V.cDMH6^(J++RY1O6MZQ(Q5A+,<@K83<+\F(dGK+U9RBDP9SU?>b+@WO)Q^0]
P.g0\\)XOY>&C;J1).?FTN?[cObL/_5=BacAfZ0C_[PJ4bD(2f[WO/J3]W\-=ga(
UeTIVU=\JO(94e+-8gQU<EG2NS094ZJ4bK:RT9.H3eR(W[44Wc853YI2861]NMX7
066Ld51DP8IBGH5Y7?Bfb]7=IVK\QT6WQKL#4-OI@OJ\K^f;9[eJWBea1a656.XP
.;([9fMP5b?DM05<F@X]\5JB?+K3SY-(Y@=#1,gfC1I<)I46bYI65b0=Y<aT??gK
#+2>83bOV.VCUbWeTG(SAM9W)gNE8_>Z9dN#-EJY)?2?X?_[1(6FD[;&4[[9.\&?
Eg;g>a?;K8bTe9)>4;Z3cBfB]6d9<.X>fV&,L1ARX?^X;X6:;X/1S^>&XH,7U.#d
^G\AEY<<7d&6+>>>JJ9H?-6&Ub?g&F217_D9E.(VC/Yf,G,H?6b4(;@,5)T?U>TE
FeQAXGI(S029N?=825/R<)#[<=R)=eLBF3OF6M&]eb3/CbX\9/7;;R>&JNSP,BeN
0/FMW508dC20Y67P=9J,8)LK/4A(QaS]E9FRVTPS4bWBaA1;694_GV&Z=U]K/P51
2=,_aY0OEA(,.;2PKJ(S,RR7.XO)N-O.:4MJ&VcQg7La:?^\XUa7T<cQF.-gMg[;
S>/1L#(V:2=I1E(>Oaa?=#-f06F7[Pfb;0]fX:4Q7c5X6C)9?M0RK-_GgfD0Ga7?
\A;J,2N:N)@>dJG8d__F?4(OXO:=Ha20e+G9JUYdW>YU(BYU&8<Z];6<QV))0P/&
..;WQ&DPa/WHB[69,c4&)/>F[VgJeN5DB#(6;W3I<+E9Va8]E_8O>R.P#<YTb4^#
c8QIB+B+P@,G(S7LO(5-&(UdA^Vb/\c)W>84].f1>:2Ug:Y05Y1_QB@4WFO6;4<0
EG@f8.NBU<F[ML1/0:=aT<,04.aC3IRYN9.H\aQFQBe?FU+b;/C+=AT@\Ne9-.cd
3VWW+7becY(L0@MCf<[8_QU(aJXc9CRO-(N2,Mc#/Vf^[X=FIM##BWHV=AW_DX@+
R90Y^B.5?N7Pc(#_&^\74cG\/cQ(-,GfI0?C6c31(d6N8>11,.GH[/J/5e:d,TQc
De6d>,Xb07=_]1>#Tc_C;(G,QBHZ>CZa_+JMO?(+R9Y_.?b0)V@5)9+4Y+-UCE7I
>GNFM&\12>^eFFX#TY[#a693Z8(LR&-KW&5\.L@_ALfQ+<<7Zfc8XEY+)3\F,D,E
=WB,EH;ZTdQ/__MfFg;5V4[37IYNK>b&.F4N?)@5QZ&DMVBVf[2GAFM6LK=>g@]e
^agZ6B5M/<(Q0+XZ)_#UcSMcb6Z[U6DN4JWN=;EJe)R=/EQQK#eO.9##Zg_gU_TM
-D[N\C1MFE9W.-O:Q&XEJ-9ZBU,PK+JX&OQG90ZZ<0H(faRQeGB/c=:8ZG4I-N/F
\_:-dC#,,+2TIf-^C]dC.bL<OfE_T[RZWPcbU7@9bTN<_RI;M7/,.gBa1#3aC]=C
=VP-O:1=5a3S\Nf#7;d?a8gd4C]3PL0EcD.10e]C\K0[]Ad6Na^<+3[c/-Z]OeK6
EW75H@U)9e[614V?:FUIX9D2U/<X8:b_YGTHHc;\SN=fD;?;(ZOb=UHg+9J0_N5e
S4L-&G27TBg^9]O=:-KSEF]deKAG6/c5Y_0A7JD11XWd?K\^UW6D->7eI[_>^1(Y
:Of)Bg;\PF]UO2/U1^Q[U6:<LYK;)^_F(d]0d0[))fNW@L-9fC,4d8f)TC-ZC<c=
dU2\-RSAVH^)eHNC?VY)R095cc_YgNNgYIF:7-cgR223HFf^>]LG0;VMD+3JBPdM
R^MVDFdg^bI5f<&WAQ+00F588T>A8QQ>T^b2^4I@#L2Y9501RE9.YRW(BXFML/2C
bJAIAMUGa[X[]+S\U4gZDB=,XXPL6]0G59Pe6f@J5gc\<MJB(@dRFIHL;1NT/:=G
a?TbVK[U0.85>;K;Q#9PV8Ef8PWGV^/I0MbG2gK@=OJ658[))DTO0B8<U1?AXTc?
+Q\N#a;A8UOf,ATE)JE&<V6(e/-7=LI2]MgA8Q+9>bN3^N;Na?NDV3RO^LU;c/OI
8MWRMZ#W.R,5##+EPWfX@6O&-)[;0\4@3N0OULdYbe4>N(FKYLPFXf1NH&2+B.1B
Z6?gGAP+;6Z7<;c734D939b1/Ne;^Ld:[PHe9LeLW<0)0?\eEP#:NFGIBgRFMHF^
=+#8?agLgCQJP)N[S=I>GGc;G4F^(.)UJ\8G?O[</=:,^_TM(_3SJDBQF\Y08aVK
cUZBRIINU+[ACaHZAF^aAaN727^Y^[(\K<fb7e,?c^+E#(T\DI@P;3@dMbC#Be=P
_I<c)d<B?da:S8:;#>8/fPA?J9F[@gO@)Oaa[cO,7d,cR>6fb>//7[/Q7LR>Wa/d
VGMAKO3XQ)]ga+1.ECINVHKfg)>5@B-&GR(2+B,c]M2#X:dVKQG?Hf(fc.IE-PO1
NDW,WUV,]PIMbMRXKd+f4Y=-eC<a_\I?fN0\S=5JY^;5\]J@E8?W+g8,3T\DE.VV
2Y4ga&4@g7T>_IXcdJGVb]M.4E2L.f&--9g3DM?M=b-)0F@7QbL9-C6LCb_c>dDg
P^H:-OW+?J2eR\SZXdUE/_E+^IgVN#C\FX>9O=?TE_8MP3HKT#.]UXDK:(;QTUEN
a@:GE12RY#W:L0-9R4/9[9Y@QJQ;BEJA4:U?cD+>g3+_][FGMOOL._(Y2@cA?M)-
RBJKD_+I=Y1.HRg?bSMLN,8IEcV)cI;IOCX=JZ?#BaY,Oe.2QbaNBV(]6N>/Q/b-
ZI?fQgC+ea7.-$
`endprotected


`endif // GUARD_SVT_XACTOR_BFM_SV
