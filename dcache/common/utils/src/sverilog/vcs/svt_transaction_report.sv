//=======================================================================
// COPYRIGHT (C) 2008-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_TRANSACTION_REPORT_SV
`define GUARD_SVT_TRANSACTION_REPORT_SV

`ifdef SVT_VMM_TECHNOLOGY
 `define SVT_TRANSACTION_REPORT_TYPE svt_transaction_report
`else
 `define SVT_TRANSACTION_REPORT_TYPE svt_sequence_item_report
`endif

// =============================================================================
/**
 * This class provides testbenches a transaction mechanism for reporting transactions.
 * It reports summary information for individual transactions that are in progress and 
 * accumulates information into a summary report.
 */
`ifndef SVT_OVM_TECHNOLOGY
class `SVT_TRANSACTION_REPORT_TYPE;
`else
// Must be an ovm_object so it can be passed via the set_config() API.
class `SVT_TRANSACTION_REPORT_TYPE extends ovm_object;
   `ovm_object_utils(`SVT_TRANSACTION_REPORT_TYPE)
`endif

//svt_vcs_lic_vip_protect
`protected
021cW,R0-[PS;Dc_V@MO,-2+Z(C>CS?b/<X8aNA\OV2E,Z:-f^7:1(Db[e\F0M#P
F2bF81\J)MJG,g7,U[(aA^<MP7^7CI_3>cF.a(f;<Ld1+&FR5@OFOXee0/CdXS8)
BMeXWDRE8e3/OSBNP@32>.Z&H>=L^?W^EBY>H,\_4b4SNQ-[(=R.ZT6PgaFY&K^/
]7-\R(cU98:Nd&&\V^B;NWGd9TL[Z=P,@@P,\:B\^<0TI_0U&::U.(4L>3ce?H3K
R&_e-F?g>Z/SZ@M,3&J7=-c9+S\Y?[]JU^->&3+b(bRD[KHCCNU-L;H;ASdAJ/[_
\UV5^&-P&Ef?)b6HdW2>&@V=\)[LUJ1B5M7[dFFUPC=T-J@?dO)Wd_6FM_dDaUBQ
JI,a2;Y)0TT;07>4C)U3,]TG+IJ:B3,]S?ebD=b2F:F55.Xg\:(1=bcA/0\17aV7
<c,8+Z4-[;:;OUcZ<e9#1@M/2G/;(-@FFM3L#Y]cS0[@<;:23)@bNB>LbN?U&;TM
H:[F==MG>)?0b?C(IMN6Td[HPXNRAL#/AV1@GKW)S[_]VT3Ma0c60,IYa32;HIWN
S23FT[430[)\S^=f\Fc\<\6<@P13/Y3]Y^YNV+e<0H^DRC093bB3>Ed9\9_&X:R+
+)Y39dSZ0.g2H3N&A?f^<36<1$
`endprotected


  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Shared log object that can be used for messaging, normally just used for warning/error/fatal messaging. */
  protected static vmm_log log = new("svt_transaction_report", "class");
`else
  /** Shared report object that can be used for messaging, normally just used for warning/error/fatal messaging. */
  protected static `SVT_XVM(report_object) reporter = `SVT_XVM(root)::get();
`endif
  
  /**
   * Used to store the tabular summary of null group (i.e., summary_group = "")
   * transactions as seen by all of the chosen transactors and monitors.  This
   * feature uses the `SVT_TRANSACTION_TYPE::psdisplay_short() method to create this
   * report. This is the one summary stored directly in this transaction report
   * instance. Grouped transactions are stored in their own `SVT_TRANSACTION_REPORT_TYPE
   * objects, inside the grouped_xact_summary array.
   */
  protected string                   null_group_xact_summary[$] ;

  /**
   * Used to build up additional labeled tabular summaries of transactions as seen
   * by all of the chosen transactors and monitors.  This feature uses the
   * `SVT_TRANSACTION_TYPE::psdisplay_short() method to create this report. These
   * contained transaction report objects are not provided with labels, and are
   * simply used to manage the strings that go with the labels.
   */
  protected `SVT_TRANSACTION_REPORT_TYPE   group_xact_summary[string] ;

  /**
   * File handles used to create a trace of transactions as seen by all
   * of the chosen transactors and monitors to an individual file. The
   * trace feature uses the `SVT_TRANSACTION_TYPE::psdisplay_short() method to
   * create the individual trace entries.
   */
  protected int                      trace_file[string] ;

  /**
   * File names for the trace files, indexed by the group value. If mapping
   * does not exist for a specific group, then the filename defaults to
   * the name of the group.
   */
  protected string                   trace_filename[string] ;

  /**
   * Indicates whether the header for the trace is present (1) or absent (0).
   */
  protected bit                      trace_header_present[string] ;

  /**
   * Controls the depth of the implementaion display for the the null
   * group. Defaults to 0, but can be set to include implementation
   * display to any non-negative depth. Updated via set_impl_display_depth().
   */
  protected int                      null_group_impl_display_depth ;

  /**
   * Controls the depth of the implementaion display for the the indicated
   * summary group. Defaults to 0, but can be set to include implementation
   * display to any non-negative depth. Updated via set_impl_display_depth().
   */
  protected int                      summary_impl_display_depth[string] ;

  /**
   * Controls the depth of the implementaion display for the the indicated
   * file group. Defaults to 0, but can be set to include implementation
   * display to any non-negative depth. Updated via set_impl_display_depth().
   */
  protected int                      file_impl_display_depth[string] ;

  /**
   * Controls the depth of the trace display for the the null group.
   * Defaults to 0, but can be set to include trace display
   * to any non-negative depth. Updated via set_trace_display_depth().
   */
  protected int                      null_group_trace_display_depth ;

  /**
   * Controls the depth of the trace display for the the indicated summary
   * group. Defaults to 0, but can be set to include trace display
   * to any non-negative depth. Updated via set_trace_display_depth().
   */
  protected int                      summary_trace_display_depth[string] ;

  /**
   * Controls the depth of the trace display for the the indicated file
   * group. Defaults to 0, but can be set to include trace display
   * to any non-negative depth. Updated via set_trace_display_depth().
   */
  protected int                      file_trace_display_depth[string] ;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * Creates a new instance of this class.
   *
   * @param suite_name The name of the VIP suite.
   */
  extern function new(string suite_name = "");

  // ---------------------------------------------------------------------------
  /**
   * Create an individual transaction summary, with a header if requested.
   *
   * @param xact Transaction to be displayed.
   * @param reporter Identifies the client reporting the transaction, for inclusion in the message.
   * @param with_header Indicates whether the transaction display should be preceded by a header.
   */
  extern static function string psdisplay_xact(`SVT_TRANSACTION_TYPE xact, string reporter, bit with_header);

  // ---------------------------------------------------------------------------
  /**
   * Create an transaction summary for a queue of transactions.
   *
   * @param xacts Transactions to be displayed.
   * @param reporter Identifies the client reporting the transactions, for inclusion in the message.
   * @param with_header Indicates whether the transaction display should be preceded by a header.
   */
  extern virtual function string psdisplay_xact_queue(`SVT_TRANSACTION_TYPE xacts[$], string reporter, bit with_header);

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Create an transaction summary for a transaction channel.
   *
   * @param chan Channel containing the transactions to be displayed.
   * @param reporter Identifies the client reporting the transactions, for inclusion in the message.
   * @param with_header Indicates whether the transaction display should be preceded by a header.
   */
  extern virtual function string psdisplay_xact_chan(vmm_channel chan, string reporter, bit with_header);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Generate the appropriate report data for the provided transaction, placing it
   * in a combined report for later access.
   *
   * @param xact Transaction that is to be added to the report.
   * @param reporter The object that is reporting this transaction.
   * @param summary_group Optional group that allows for the creation of multiple distinct summary reports.
   * @param file_group Optional group that allows for the creation of multiple distinct file reports.
   * @param runtime_trace_recording Optional allows runtime recording of data in trace file. By default data is dumped at the end of simulation.
   */
  extern virtual function void record_xact(`SVT_TRANSACTION_TYPE xact, string reporter, string summary_group = "", string file_group = "", bit runtime_trace_recording = 0);

  // ---------------------------------------------------------------------------
  /**
   * Method to record the implementation queue for a transaction
   *
   * @param xact Transaction whose implementation is to be added to the report.
   * @param prefix String placed at the beginning of each new entry.
   * @param reporter The object that is reporting this transaction.
   * @param file Indicates whether this is going to file, and if so to which file. 0 indicates no file.
   * @param depth Implementation hierarchy display depth.
   */
  extern protected function void record_xact_impl(`SVT_TRANSACTION_TYPE xact, string prefix, string reporter, int file, int depth);

  // ---------------------------------------------------------------------------
  /**
   * Method to record the trace queue for a transaction
   *
   * @param xact Transaction whose trace is to be added to the report.
   * @param prefix String placed at the beginning of each new entry.
   * @param reporter The object that is reporting this transaction.
   * @param file Indicates whether this is going to file, and if so to which file. 0 indicates no file.
   * @param depth Trace hierarchy display depth.
   */
  extern protected function void record_xact_trace(`SVT_TRANSACTION_TYPE xact, string prefix, string reporter, int file, int depth);

  // ---------------------------------------------------------------------------
  /**
   * Method to record a message in the file associated with file_group.
   *
   * @param msg The message to be reported.
   * @param file_group Group that identifies the destination file report for the message.
   */
  extern virtual function void record_message(string msg, string file_group);

  // ---------------------------------------------------------------------------
  /** Method to rollup the contents of null_group_xact_summary into a single string */
  extern virtual function string psdisplay_null_group_summary();

  // ---------------------------------------------------------------------------
  /** Return the current report in a string for use by the caller. */
  extern virtual function string psdisplay_summary();

  // ---------------------------------------------------------------------------
  /** Clear the currently stored summary report. */
  extern virtual function void clear_summary();

  // ---------------------------------------------------------------------------
  /**
   * Controls the implementation display depth for a transaction summary and/or
   * file group.
   *
   * @param impl_display_depth New implementation display depth. Can be set to any
   * any non-negative value. 
   * @param summary_group Summary group this setting is to apply to. If not set,
   * and file_group is not set, then applies to the null group.
   * @param file_group File group this setting is to apply to. If not set, and
   * summary_group is not set, then applies to the null group.
   */
  extern virtual function void set_impl_display_depth(
    int impl_display_depth, string summary_group = "", string file_group = "");

  // ---------------------------------------------------------------------------
  /**
   * Controls the trace display depth for a transaction summary and/or
   * file group.
   *
   * @param trace_display_depth New trace display depth. Can be set to any
   * non-negative value. 
   * @param summary_group Summary group this setting is to apply to. If not set,
   * and file_group is not set, then applies to the null group.
   * @param file_group File group this setting is to apply to. If not set, and
   * summary_group is not set, then applies to the null group.
   */
  extern virtual function void set_trace_display_depth(
    int trace_display_depth, string summary_group = "", string file_group = "");

  // ---------------------------------------------------------------------------
  /** Used to set the trace_header_present value for a file group. */
  extern virtual function void set_trace_header_present(string file_group, bit trace_header_present_val);

  // ---------------------------------------------------------------------------
  /**
   * Method to retrieve the filename for the indicated file group. If no
   * filename has been specified for the file group, then the original
   * file_group argument is returned. The filename returned by this method
   * is the filename that will be used to setup the output file when the first
   * call is made to record_xact() for the file group.
   *
   * @param file_group File group whose filename is being retrieved.
   * @return String that corresponds to the filename associated with file_group.
   */
  extern virtual function string get_filename(string file_group);

  // ---------------------------------------------------------------------------
  /**
   * Method to set the filename for the indicated file group. Note that if the file has
   * already been opened then the filename will not be associated with the file group.
   *
   * This basically means the filename must be setup prior to the first call to
   * record_xact() for the file group.
   *
   * @param file_group File group whose filename is being defined.
   * @param filename Filename that is to be used for the file group output.
   * @return Indicates the success (1) or failure (0) of the operation.
   */
  extern virtual function bit set_filename(string file_group, string filename);

  // ---------------------------------------------------------------------------
  /**
   * Method which can be used if there is only one file group being handled by
   * the reporter to set the filename associated with that file group. Note that
   * if the file has already been opened then the filename will not be associated
   * with the file group.
   *
   * This basically means the filename must be setup prior to the first call to
   * record_xact() for the file group.
   *
   * @param filename Filename that is to be used for the file group output.
   * @return Indicates the success (1) or failure (0) of the operation.
   */
  extern virtual function bit set_lone_filename(string filename);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
WOf25WZa5#217/DIZa2XBUcCOd>BebC^\[AR?:eI;b9K7b3Q<9Z<&(C3Jf<<AV(7
8M:R-d)aG@-HEU?CYc-FJ/,:_:^Pg/[HX<5L\aJYa/OX&g#:fXL3@P23aD(OXNcX
;=aVZ_.MZe.+Pe2,/1;RBJY=9+_R?-d,Gc_9ZFd^<9I64YdG@Z,b<2dL.g9^:PHa
>dNQ_QWZRA^76X54<c1<+26K4NQPM,YU1TeCA[?6<fZ)+dF7WFIaf0G_;3O=V^fD
bL.b)WQb(U##7-.NZS]#3GPW9GQ)UbU2LUXU53E]9HYJHI>LdM5QfF4.6cGA+&>&
Y4F2a)GLB:V[A<\WI&T.\OICc1cU]gcV4(X=HWT67aK23+8NIdaGBG70&7d0Yd/F
G1T=7RQ09IcR9MB?7]ODae<&[Z>0\31:F?6]X;V0=]I.0]?#b3EQ1X4__aF+,LNc
B\8f;0MGg5Y30AO@08B0[WMM=ER27H>.F),)SgN(2,DJeS]gI9N=CP\V6,C7<NFb
8?HG2\<SA<N(1)KF\YMgT/dAD2@_[#8dAE.+5Q7,R=C&BDP3@KI(D5.<P4HJ_#H<
TV7]#D_N?Q9I/\,.HYB6WL2Kea]J4BeaMbGU2ce(NL:+[6?M^T<)^6[4cM=[H>9a
+JVUV-VO5bPI19)dYR;_T+@>_:S<EW,0W(_;^QaM^^4X1ZcH6H68;+8?XNB8=L;/
\FE))5g\(Z^Q5MbGb6A=;RA4ZM<CAf?>J)YN]F[.0Q-1U-=EYFDb]fXINeCagcce
&WSf#1)_aCHOQ?BGM:/95@K2(H^b>WY1PbTV.NR,QPXW:5]:W8e<;XB>4/\L=E>+
EF(a]@3:JRQAeYU<O>WI,.TO@:VB?46<^<5=)f#2gFNFc\(E+6g5/#CL\:0Z2]-Z
(VUSBb,SHaY\1=,6J<>Z70?OOWTcL#[+,HVJ(edCPNPMW.X+ee9=\V:U00\>D+(\
^U?),fKR4U3#+828.5aIA0KM)G:0OWD:gK#>49L:9N=>c\4dU+#gGAS^P;DdS1I@
JT04b<VFN?2;N^SBQ-EC6J0H&=Sb]2#LWBNDXSP(C,P2>T;IVO+(9cgPd(<GO/IY
Z6,eCg3U>#6:OAT+AS>2_5.#9IL2DfA4V&(bHB@S/,3.SB.37M(CRR]]6c_(ODZZ
G,e9NRgNG\_A[JIPP1FXGWD)E]UG]G,5=g\RL2RVg5f1L0^V7J7,VLe86#I)Lg)#
_Z=.?CZ?gMB41]9P^Xe-K=c>IZ-&J0#,Y@g\_BJ>>ZY7C,](]a=;bU.B1B#DJ;D-
EPTAfA^d#A:X_NS0-1Ug[/0M\LAZH(8/N+=9[>H_+]CHAPB5HR\6H.2C_+KE2DX^
dEcF0VX@B;N&fQ.DB#W(GNG_Oa[63@OX>1+/8YS=g<SX#7YCg<N9.,<g+e[1e]:G
#9T&<M>f/2f;Xfg8P?R_Z)BNN^0YK^2&++E\IDA(D0V&K_PV\&I>(YQ#2A7C4B,d
<OJUXfZ8W5Z31_XeC&UU[<PN4@YW[>.aN_65_JN2)])QO6@Z,Qe60VcI#XIQZ3(T
67=BgZQWE2O9a.ZB(J18Q,adfbNA>HaU&9.X5[&Y6=ge=ae?5?&_?JSA(aT,2J_@
#[1Q2]^60<01=K[NAJ]1+&dKB:GcX40W)^U@Ba4B(3J?D5B-2VM3V[=LJ-R,,3cb
&=+/N/gF9]N]G)2;JP:FHe^A<G\2O?R4FSdFf0Y+(2S-;NR5R:T/Ia_+We=LR&S4
=-\T:@S;a4OXFR];[[KIeK(^U5=^#Q^H<b-g6=b=cJ5b=_L_I<VXH+44.F2N(JK[
Eee,+3(Q1,A<>/=:;N>UTLa6#NRSZYe1WbacKV_@3PO]_fJF;T8QEf+UX=-Ea^KI
Qb6MO@E0GZeR)HHDXOJC\,Z?G[:FI2OCA2UX4aIW#^aE)DFP7T@0Jafa>BG_M&1@
M+.]&96Z9;b;cC(GM;@6.1[UF_E_CdM/([>__>K_3TVV=MI9#+SVI&+_796APB:4
6XFB5<#K-7)PHdd&Y+MaNIYX@T>,_TDc6C>=[P)DW\FO_+/Ldff]PB3+D?J7OZ25
;a:ZX6GFMGY?H54&R4W^HC,#-Z(.\1c[0Gd6QIIEc4?aZUCb;;fa-#)2,3gP1=2A
P?gR3#@N?5R336G&7U/bQ5O4I3J@Y^d,9,=YCBLFH9]_VL(FGFPBKPaV?#a&Tb=)
ee2;b15BTP-b/?JbKJ?\IS_6YDIgg>X)f2a(R]FeAA6H95JIGH#UT=5JCS6NDT)C
WcHS0fL:OQ[.PN)H46C\fUKWAO7<c:RfNJU=Z/)E@U,)a<D;-F<?2bD.V+^+@f65
,H(+XUI;(KX,gH#B\U\fB@F:Qc7TX3/Sc7DG-1I9BU=L-WP9.BNN]Ac8Da-a\Y8C
\[J^(WF[_-)0Fc_J0>DGEMA>?S9,D2E_GFMUa3U2>Z(89M,.;,^ERN.5A^Q)PE-T
Ka.\=/.H1.A],QZ@Q6G9O5RHLWR#65UPdB6.[UKGFcQ&?K?[UE5UZ3_?8/DMgASf
T8d1S^dXTOE#KJY,FPJH+5,e>3J74=8;F^#/\(1S?B6\^R22@82e=CSYLg9+/.?,
TB/5ATXX<9W[gG&RC32fdJ/9d/g3F+J#8/CJHT3F]QK4A10WB8AJfT5B)?dJK7/<
2:TMO908X?_:7U4_DaLOUPY@5-10OPVcE5QS)+B\?6g&:L)Jg7)42BZEL.B.HKH9
NAU41)OS>SELIcI:1]<(,#>A[S_/@Fa0PR6>PU&5Y>?VP.K6(K)Q>2F)],Y0Rc7(
O<X3QV^5e@ODJ.E@76[b-912O?aU:GfSRV1YSK9E&K+KX]-_@b&3b80dA5UKdc--
B7NS9R7EAf9QS7^J(MKX>T,:(C4VVUb?&;Ied=ZK@H9(CMTHUBKf7Y>XUEJA/fQ3
BE)5Z)QK[,_Dd\>@C4WG<).K/OZ<E]&FO4+PR+YZd#;b:L1XPV3<I+MYe3WFY\UX
Y_F;>OA_V#01U+Q3C3FRcOX1O2JQ>:;0.AKg7U;L2V]713JI?]dHG<X^d\=eC2?D
9N3W>19ZXP9FZQZG\6I)_de=JW#(I&&JBfF?:F;6d]cC_5E/D_c6Ne.L.2_9>dO^
FS8.c?8_/)b7S9W\Q]X<__I\(S5A6ZK#:0AXS8aM?W&O)5[&M,SLEZ]8V8cK_fGU
)308FdRWQ=S>[JGW_/7fFb1&Qb3C(eIM0MBSX[=Q>?[QAU)1a>^SCe.?a3b9YBec
R>3T;+^)H^eL4+5eEGW>)MWa]B=+9DK3]0LU@>,Z(b-e)^(ZT3COX/_c/a#WcO46
#0Ke3ZJ,.c5?EJ<8Z4AQ)>I9;LQ1[/a0Y6#79RK3Z2E/ZI[1DU)T&g=(b.bW0DST
@TUNRA^VYTC);K8PDcVHX,<Q#GIMVPLC8]P#ZI&N[SW[BE@5R1@JIDLaEeg,L4#H
SD,GP3O7I[4PS;MP<cM-GN;)=#>\e:M?OSGK#@?.T,B8^P;&1IL-E(XTZcD+&Peg
9f_C-@^DAU+(2C)E,>8I9PE,[S_<<+^==QFYWM26Z-B)IT?Jb.]^NOD+MTWHL]S=
)K/KEV_5?\CD[_2M],cGM^=>]f=f[@LL@d4#M8=OVS5-@;6?ZeLg<94V<dUaUO.0
C(:D)gc).333M1D<]Y]_6SW_O,aBQ(#gX^4g<E\-RPCCcFNdM73((2V.XMV<Ld8]
;=dI:-X<.-),K6)ff#S/f<B;:10_^+))NX>:UTL7(]Td\(Xe_[V=>H6@Ie&\e-G=
3?4f67]4EW&1O)?T5?Z@B3C?^:5\5df2U^M36@bA\)Q#MC6QZb0:SE.MZAcQ9CSO
F1@FR;+@(:52+;XJA4d#[+MAa#MUND>d6RCLN=eYS6/\(Ce>7e3@&EKU)caH+Mf6
bA2/Y_2[2/N3Fa]@#\RgJPO(11QgL?MXO8fA/A3:9&_A>OEC<PfL.XfYQ\/UY)M9
aBWHa5[1+-8RIce;a0=6fBd]UH\S5RZS8Bd&F]5e(Ca)1U,7G<FUNFKXGFC\.>-g
PcTJaX8DP\YHa0R\fCfVQ_[dEH2XOL87E#@UVFP5g8b.4Jb^FeR1eIbCL8;6NX+F
Z7L>37&I/R_F67PX&Nf@-6eSK/7UD:C]?+R7SfX(,0d2K\U)@DQCLG>[b)a\]\f2
[A/A/(F>\Q>/GOMN0c>C?/II/K=]=MT_2^W8<N:a-M-?DL<a<\)A,KSTRU9-OCUc
NB6J=>S9e3)[:NGC-e;?Q4[Wa[H2T_+OZ#;)[)[_R,@5@a6eP[Pa2MFX]^>UG55a
=)PC]W>^1A[HA>0P2@Qd^LHJC\LF/S?VN.-5/D2]QaH=Z4>f)93c7N+4<K-A=U^(
cM&?HO3-+d_,GM\ZJN^OXV0Z.bCXSMPWF.(7KdA:ZQC>f;)37YZXGge)&PWb[,a(
IU+1GV4Y=[T.PN221\R4.ZJK]P6(a7^J=D?^]G457bZV[_TIX8a4cU)84NV6<7e\
-UPB65[G_]X_D<JB>_.6],OY>TN35>3#&NdVO.CYefXb)1Z?DTOW40?9Aeb;EX_S
]HJ@JQ#aU9_Q\?_6Cb1QA>SN?Y)GYc#4@58B75NYTXV>Ba#.PR1R=D3):Ze-B65_
+f,AP6A>(Q6_?R#f@AE^CC>Pf1A7(+@9B,(0<[53@XWR;P463)/?f64A5Z^8JI;a
-/-7GbPc^-U:,2?PQOKcYH0QMQ?F&Q+ZV<Q+1M4Z-TZ4U[&+F)9KE=QQ.81e,J2L
^B,P&L5M9D07A8UF#EF@0[>RZ9#_M]g@Lf1Ab;efI39YL1a[T@ZegT8](f1)[>9(
0[bMTc7=AI3gBc+.-f5JLV?Re,X/8U9=f]R9/G@[5PR6PIfHDS,)5Z1)5C8WIR[4
NA86c>TO/)61/)X.c<@Gf67IU/;.c[GGb>3>[YVB]PbPH)?;M6-_?\8[gWF>,\OL
)6F]a6g#QW4R(5(NF10Xb.8?^13P>;g:Zf1O;VJ_gH^[M8H>?(Z.^e/DCZ:_Ia7F
.-?<d67>_/__f\<BM+(73@&VO2&E5g2fdF7AV3G\>VSVKM(4Y&[32O=cQ:_XS6,]
9(^6L3,W5I>SN[0(KfCHC?2XQRaAK=PO44+\2^0PNDD4-NLI)JZCb/bV/R5\OU8H
E[<ZE^cg6,UADC-+P>W(a4SIH.H<VXPATM(_c<:E]?YG;MC?)2;<4^H9O^2c[_L,
c_RD92SMWCCId8U:MKFAXVIYG#\Zg]>Y^WEN^F@b=)Q;#OM=EZaO[FT9W>dVcY-d
]Q0RIb7G/RWDXd3AEO0C&TN\S4-K9G.:K)5QK6YM@E@UKcg6f]#;gV^G=+g+Qd0V
(H@G4gJ78YZa82[Yf=[[cXSg.cF[YdBX[7La^-NM=H(/Lb,^F083&^b#TAY/<@)Q
91N&Q[<MG>Z&^7X#34);PM:#HXHbLJVLd]0;gKR#>IBV#S?5DR<7_&4gM6K_CRdQ
0PM.>:\Uf()dSdR]a4gDCG,Q<e@9c\W&N#++9-f(W.M2S88Da#0+EYD@+U_\-418
_SCR,>bTPZ47I=X)c\JRRX6@,a3\N>,cgcXea[:TD:(K-\gJH?R_3,?c&^B--8\a
HMOV[XI:V:M?FWO<6W2&SMK41W-,I,7I&V];?-,5UI75YS&3U-.ADK/K[eCRU;aM
ME,<\,U9H(1BSKI@2REYeS]X0b<[WR?MQPD3+6=^2RHG83BA>PU=TXe1bOY<+R(7
,a@bI<_Ue0Z3Q.f_[;G3#0g^HA\BNH#7G05HL.R<,)Z@f]L#KJ;[2#13P-W4LQ-;
:C)dCP(_>RJOE3?b]&AGNGH\6^\9a@Z7=[8A7YMe.@#dX68P-[eN.O=AUNI1]NUX
,b0O:XF13&OG6AD[@K>X.)1c[e^d4XN9SZZ.)HGH(KZ8\X6G2.>9.1HIJaXY5gCQ
@JMB[1^\8Vd-bBFdff^RF>X>LKd^)^;Pf=G;+Sdg;X;ZKeAbBL/=.ddVPE@UHC7<
5PE.=aQA8eJ@?SU/A0IT:YBefWIS9S,7/5E\._6U(7G-1R35##:cUYOEDJG(DL@^
Rc-458C:I?H(d5V3e([9[5\=SdK>b>&#AFIgG/B#I.9O>,5B3T0&XG+GB>CMBJ1.
4e:EJOf/,>^4>3CAfC\<e[,dA/:-H&TL-?CZ26&W3C/G;@:P\5fR/^,G&K72[,bg
THT<_D6Oe6-.>>W9f53M]5OcabbD:XfK/[RD@YVW/DISDYXX4\;QaPH<=&-SAMKW
>,@Ke(;?</gQb;0C?f)P/YF9>FcCYBFSL04#1A9U=C4N2-c#&bCKAK^D[JI+C=8;
@/4QL3,cURS]-=9K7Eg-;+>]G7_.Z^=,F337N)FH?IGdFVM9dRF4[Af@#?Y0.T#^
P@1+)LgI(A:..Hc];)(Y^?O?[K1?-5C+(3M:RfE(g_^4aD.:N,3._Ta&8SMcFZf3
Z)X:^>1X#Dd^Y.^]XT:fEScC)S-IP6[&KVC]@-)Hg@FDKL.[Z1LV&G1f):<:/C->
566M.T?KG\L@XK[UE[>-R4:GO(UHC5<eAH/S5AeC5]5gI9X]P\(e9IP_b>C6IKIX
0_@,-P=5NR/\-AR/L1OAJ17A)9,^5R_cUIdcGH;FL?].5)R84K(]8&.5U\8W6+/J
P7.3O-(a;SQ[^#C==C1Jb(+\gU@gd_O0,[f3=B_A@V9g9f,b@N9R3f4R+8=gX70#
Dd<?2]2Nb[D0M<=S3CJW/UK\CD#RM]5WP\7L7WR.8;0bC\b=I9c2aI;R,eY9e3Z>
CH,>N.)Xbee_/a^(,3TKW?Y[+#,I?[1f9.;1M?/?037.fdGB@H)#RZW1=NA?P&&V
WaT,#).FHU5AZO(\6P)&N+g-G9/-HNHa?HaNL5)La7C_3ME2DVe.WT2e#@[7XT)M
PgXEEa\IT&=+a]&_VW8:9O4PZ=KGV[=WKL2)c]V;QSd/]J:P]aB+EE(0T<GW/T9)
,5S;UN(@:R.OT^N9dcB\JRPG2c84FK84=\ER8_IO;+WagN-GN8#1b<K^,HRg-N9.
g,.I8>RFB/>a)DDCE^X4(W/5g&.=ZZACFL3e(352AHJABXC8b2@Ug:&G?O=]=S_#
1f&7^B<VQgUVZ9+ad8J8Db)F@N3&Q,2@9TZNC&BGgGZ<#+\Wd12fb_Uc2XN1\?_=
#VYS#Zb((X^)../0f?PK0+fQ&\R=UR<6)OSQgM5J26^4YaY;L@1aC7>=81AZ\4e8
:9KE,]HbL/:JCIZFO.YOAaV+W]QE^YRC?#:42.6BJ;7Hg(Q\\(DKPb5LCK7(MF.C
+IQ&1c#;G83?KcE\X2LPFOT[f:;DdE.I/4&P2Pb<SceA)P[Z.>W).<MET?eOA/]2
?_L8_A;-ed>X7Ze7?1f#gS?7S>G-/[;:GMg4&8cDLIBE:=8F7eITU#+(X3A@EFB)
2g)[#^92<HH^&8@AW@IVHD07H3@ME^CcY/FgfG7@RLKX7VVUUOXeTe7-?g?.C^A@
e+COL9MY])/E1\<D6STZO.(V<F8+H^g1Of0V?GI0:_a[2cJZ#M/b[^EP8W/[Y2)?
_Q0A<F]=b:T9,_b;WE8S0-9,f2W2=&+H@<+X[PTW/;M4F6&>^:J(L/B-)8SeXGG3
cCAgU@3DC?QX(3E-V?PH>F8P(Z=IcR&b5GFI2Za9b:?S5R<cU0T1BSb]?(f3>&+K
MDHKEdRQ[++6Cd>c11.I4[X<UW#_\(Y>-2a0+@f;L(E8Z&Ndd=PQIXXN^Y>J7^c2
^=^J+EE8f;L54NEE?SbFNM+)ZN9OHYZ6R<]3)-H:.Z:Q4G;#Mb:)/DU-,X6+]gL5
1+\NHK6cX5\=_Ie9)Ta?@Y4N4(A5.(d,5+<&2TRKf96_4MHZUF0e9LceBRg\_F6a
:Y79^178bO^SZEZ48f0U9]V@SVgJ6SYgC439LggQAH3O/K>T^T](&O+AS+O00,A)
<TF:gZ@9/P<PCRbG^1>ARQETa;/C-W+6X:[OR97a2f>N2T2N]R)b2A939^FXTQ>B
<]1,N.JBN]g79c?&6((--:QW\ZU,f1HC@6#KRYY;bK8@,CD/Dd?Z6GLSN>?Da)bR
<MQT.Y#Qc8cfJ_(5C,?<BI(DXg_O>UQOA?FLOH9[A-IZO(X::f6fO:N_\]J))WNc
R(Y(^JbZFeY?@A<R0=-9OaB3FJ\FSgC]VHVQD+,CfAd)8GgC;KH5KBV0A\;d&cAK
9.@8Rb=.;AKXVQQKcH/MBUTc^U<^g5ERUagGbe8PG2MKYa\I<T.VAFGee,dP:3&Y
7#MJNVNKA5.JP^RU;7fDA#0>;/R@)Y;d75J1:?G^DN_P#]gad+N5O/1X<RJ28Z.@
_3fY#(5X8R=3H9)@b3=K^-1#@+A-:<g,[eX0<;+BK:NE8RO3<[J&N#J[4L^1PKe?
@D[2&_G8M3,gg=I=.36T-=02fJB1;F4._]):8\-2QCc;g<eKc)eR)1GRdBT@_1@N
e#<cJ&D)20\0T#0JFI,<ZAO>7bEZ8S@/BaK.XB3#0EX[E-SJY,<(7g,H7AM]OeD4
c(?/1R>:1Df?AI^9a\^XVA-EdTZ.&NP]8F35I<:X.8b;U4/@M=FUTE&_-e_=gC=g
3GW[e7<f;?QdXLN3TR3<gQ<#RN8Ra&_A,U:JZg7US-L((-.3TVS.@?[KYVUfXaf>
^21XD^9b?Oe=VDXAC+BX3^+5@OFIW[G5@^2eMDCADMZSO3K.;JA,&Z\62BHegXV.
9^GBZ0WW_E4R89DB6.?,^=2D:T2Y+Y5OE/Oe2C;eZG6HZfZE30#IRcb31YVP^a+3
R(CaZ@7V0]M2>NV1UeZC4Q?@7,[cBO^@L)g\V5B;\LJ]D(:FM+O2gCD#=KZ/ARa3
Wd.GN&2WYQK>Yd_FMbDU\CQA286[Fc+cQeeeU<[W.-9Tb@9N5V4GK]^.8KBGN,4I
T?c_(eFCLGRE1KO#_&cSJK6?2Yf5[M3@()a68&?&P\:N>IT5DKVc4Ke48JA+Zg]S
;KNfNTf2?f6K(Q=(UB]TT;08FKP1+KY;D<@2(cO1UGQ#@:&2FWY]eG+I9IYReC.K
Y-BY^WH:-VI7CcHUEZIH?,R=YEX.40P._S(,V_A7a+eNRf+MAY)EIIb+,QV^<\4K
G>cfC]UI1_ZR[LBW\O/;4\60YIc\YGS2b@-(V(L_/Z6HB=bBWg21NVRD48#=OQ2X
eYBN)\<KM:X:/OF.2J+U3S09Qb9]]VSY,IdO_1bO3aEUeVKSgeC+3f\<L/,S5cM[
)Z[6>O=)3[V]D&=.BW.OGR05_8PJ(=C2=>^^,de7G6+_?G&BaA:\-6N,_]bM4eDV
@1_=R/GU;+Eg/FG:=^KQ[_DN;H.Bf724:2Z3#d2aBKO:D0G4Q&_)HcVMV]8@-C>Q
:(Oe:/9b2-+VX85bc3/,<CW)J^I7J)\O_E4-8P+[9IY12\.X76UP&03R(X&+-[;a
P9S;b#)8HU2<aM(>&^OE=aPW([TZcQ;EY97-f97c92_<.KT:fHgQcW<^#&LS/d)&
c-)f2EHCCADGg)(G2afMe\WAEPgE2_/eTV&3X<9HR6d/C1,_&X-TP[gO/^O?^I2[
?UU>AIc\ECQLdfE4L1)6^.-(AB4bTRX9W@G,(4V,XV+#Q0WaNVRLc-=5:1O]OEd,
\XTX,@FM>7BR8>\?a][eeT^]^2eWSVDSP<4&=:\?L0S@IAF.bE=<R44LV<@@K[3D
KcO)4949FA<#PQ;[5A^g:g;c]Yg^#A6T7GT.RY^g#SP2e3)]7?]Z4B0(BVV-X&LJ
>dS8)g>7TR.,]6bY-7(+E,R1.BIGbfQaM<N]6b2<.a_Nf1T90_:UN6;)[<X5^PRA
403E-YT-K-#-)Ng)&QQ2U@HM-ST\H)=#>6\@+3KDg;?4(B;WaUbgG,4eX+@Z^PK]
4,PKc&^NaYc5\:SXJ:6_W-/&WfbIc=#ecN.Cb2:^eDf&HM:(5=53S)8\OHQ&dG++
fXLX2=.-^IWd14]CHO_\JRT7KSV8MZeHGFTF)7@-7a?GD8Q-&83^R,fS\EI?HdIL
/[,(DHa>dMb2SH+8I@B9B:[J+X[>D.X7D3dLR6e#(N<1-bGK8OG@FZ)^L6^I@0Sf
-^ZE1WSPX^S>a8Sg2bO9N1BWgb4CFAg>=9CR[\/]N/KTJ<995+P9CHA/2_#,F(Y>
6e^9Sb;^4.9-MII1OY3#][e36>4[LV\V;X0T[(ANSDXQE/[OK6JGFaU/9Q91N+be
@(_TB(8F:62e]&B#D(D#d=\RXSH:;T&;F;\:4S=agDNYIBMRRDV_P28FNM_V:,3)
](8CA^I>/ENfAEYO@6GfS4Lg>g_DbgNCKJ&gA6VHMH?^\?MA9)V-[1CJ&M.@2ZTA
1e1#dLUc&<YG9-.K>-[BQf@@5-2BC#ee;A+Z[2IP_\1Cb1aCfU6OFBQ+=_[Yec[F
C3-CH_V+#IA^D8f\H94FG<Y_YNFGTS>9E:@1T1_4W>P(A:QFb3(2(4=&K,>R1<Ye
OPKZ\SBb3F2aS]Cc/>e3VDKT:_7DJO5=7KE6B7g0KAP+.E#74V/SfNf#b:9^VF.d
;:[C77JHW/WEc[U5BL6W:5LCAVOYL:dTdPXM\7?;8gBQCH<823ZAa19FO0BK_d3@
fc.Na6b:+gWMC<a:&;IH;DeaQSe::C:ce^SCH1dU4,W>c3FNDUaOgI(FS@PK7AFG
eX>]b<FE3aBcd.N/4<B+IDWB8^@2^NP_?=aa_7Jf?OWY?6+BaP\.aPH?&V>/dMO2
C?ebDVK<,R;99e)58I>1=-LXA-b6.A9(28?bKMJ4S7A7A(2I)+K^a>)#Z+HAY?QF
8[(SO&>+K>O^Y;XB;+K5c-?0SYD-UR/\d./K5.aSDQEM1JXRI+-MWSO.;PZL):(;
N(>bNOb16A;,C]8W;.WaQ8N&X]gaRK)X0[EF<eRQBVOcg_4XS]F)>2_AVbe.GYaD
W(f2Dc@E=O/.fL:aT&XeX+4.L<0+,BB=,[.D?__UR#,eL[AN_;5PH^9cc.=<fJ?L
2K372+d4))8CZT.C&Ig[a?KZ,J@J4+XF)(5=)0aWd[eFNOg^_UG,Z6MYI;G=Y)?D
&N3\T8:=J3=H^V(:1?BN4/cOfZ563@ZTH:EE[?_]NTRVW=b)1I2OEU2B)->MJ_^W
XG.b1f++\b-<.aGSPa]#3E@)A--C=VDaf.O#\5PZ)\I&ddBeaWbHA6?&>MU3@4P:
P0^8[F_;Y./2]L<J?3_.7P96)[?3e&6ce2;B1<+6WQEVa1-5-N5F-2U/W7F/bDfR
8Y]CITNXSNWUc,1?,,c66D53H@Vb8PX9T(@&c/0b3JQFO.QO[XHDXgO7d.c:FP4C
<DgJg/P&e;c-#WG8@X8S+cC9g>CA4_acC]aMO6EY@P92\MdfZLQ3K@a_&.2J9BSR
E#A6I<dFg4a\J>b3OKgZ.gPFEad53?[SP.F:RCQWMF;bC6a13LFY:bf(^)I/aBN-
<512aRP>@Z.H./YG8H7Tc5E2bA5&3@-9,D7M^?HL(Q9KN0(9Y0L1;8F?2OUB<7W4
4CcF5VRA./]Ie+OTZN.C\8S1=dV#Q[,+DTMD7Z=a2Ug[+@_g6dJDRF42IUAg5+TK
50dQJUHac,b.4]f24;4^D4,&/^(X[GRB8Og&).I[CL0Kd:SgI=+;QAH4[+_EX.7X
bAO9PIf[4C:4ZV#.K+HEB5,2f.[&7JQ)_]FBZ@A6CDL,CCJ8WNXe=S+57,)BM\D3
(X)X2>FWGLR1g4RW21d5U?c/_d1DPI?1UY?Aa41#?RTcFeLe7KX+1?\?Y6KY7+K^
8gWeB#06g2aCd6=,fYC<Q_OL33cT9M@-cX:MGN1#ae57d+YE<8=PdDH-:cH\&B,.
afRCXY-PMB/EIf/8d,F-_:SB8/8&MXRcE:b(2@G/:]H7a9I\#<&dadC7;IOXI5L/
_R.@aF])E798>T>2GA5/&ZeT?Qc4#Cb8ERG.W<8ELN?@N@R/DXSY,HYEEN/5SH:X
>W6^#AJ71/aD386A[.SR?dJRZL>+b=9\;\OK+Y-JN.8S;<P7La:G99I)6M74BD,E
C]d:Q/UJJKL#Y[YNO<cQdVV^&TJO3XF?MB[5XQ[ceEW6cXK)(+6O3Ug@FMWd0L/-
&3\O>Q+VWae.X20T9R5/]M-WIUbUT(YV/8X]S_+<..7f&44QYbc:=D2Gb7DB\F^0
YFFC:7>Y(]d[;[E0>Ub(@>Y;<=,&IG;_4K492QcfCG@QO[=-J.a(K1&O\&0\W2X:
1-_V(47N)QFPE74^RLVUC[\4\aW10=KM5QdU(0#.)8R8TM6@9VHLA>7b.VQQNR;U
a)aBcT2Cg_>JR_4&^GY>1\6;MZP@I)CK?JGS.FNE(5YO=OeNN\c@L.06_O-:T?33
1F(,-A0RD+D-03e:U#d)1(T8PKcE^)/S1G/U7_#C)_TS+QLK=Qe2<cD6-YU_G_U6
(E.JLDF,8,N<#d92@B93PNFHE]&f=+&C(#b5G8Z]=G6S44B^85;T)Q^O#42E&DL7
R2O6TZbL3Z0SK:GO+fH9>gg2V80^dIfE&/PX/^E,eXLM.Q6S[@c#4;f2ce#f@#1\
6DOQ#(Ee_,1KefP@=96\f>dEZgMK)a]dP)<c:A>MX@.F5d_R/aaQ8g#K^fR>E2HU
-RSQIH9EZOe8U=V#SeOQFdc6Q\R_2?1H4MO=c+OHVg(T_Y7A/)F+0L;6eEcb+]NJ
aMV\9@#L,D_D3[P:VH5Ba]B=]/&^5DF:V+YY@L2VG9S7KUb[MV9(d]8aUcX6<f(-
ND00QGg]d,_^QVT(-.RZ3:gHN;_;W3fdS5AGMQ1S&A+98&E=Y562(ZL[Z1LfZdf4
)@8bP>@VRS+D6;V:^K;_fc<?WRDUE2(-C5OUFDdSYc[a4bELXNFJGER9BR0^OXB)
KYd-P?]M[[dL[O@^EZ_D^7cB947ZGAFbJ<X(&)/KZBJ=K>bVPFPf6-BdN0C9HGQM
J_WM,TS.PU:?TfWd3PDKQZJ2J<3OZ7[_=SJ?]/UJKRd.L#\=-C1?c-g\]5(2+^_K
\2J[#Ue&9ZP,T\ScgIZK1[B6S,A,O/I&VdEQ8T@_EDC@[K<Kg@6QOOW7OM8,[4,9
;4e\W^&3fOGQWXXUY,;#W<0Z_]]6<0XA/X(80fK1_+8<692d]&W9(Fb3>G/\[a--
X&\eAEGNMSeH:@Q:=AUVa[8Z2KG22._\[HR;,2NOH?Hd^J@<:WD>Z35VQbc<096c
;R/=/0f4@VE>c=GX\1W(aI9Y[WUdJ4@T0=2UIITa9GA()c9=0_+:)C>M(R3;e,5N
_T1<N5d&=YF5Z#;,D@^d+0(B#.F^U+C57,3bXLa+CZWFYQeR;@c1-@(S?Y>KA&-a
BM]_.MB+NA#C.JgGC/4]+<e-]gg.@5CXML]^>+=aS3N(LMg\)(D,)/O</LD+4YFf
2TG+BJX[f<;1_2(G2gC47PgYcB^e]I-;S@8<T#E:Y+PULQ8KD1V-aQ2>(5F#[c=T
.:&1O5Z^CSI]IB8>F5N25^GN^f/LRM<eKFKG?eB&<ge8)W/GMf_1aQd,4#eJ,TY<
2)X>eJcM5d=dc+/:<g/J+./@47Wgg.6RPT]@Kb-OdZ5_RU#>D?aFa@6TM5AN:V6D
=9NJ^#_dO8^\cWPN/b2ZNYNB1\>.(;()^<(G.Df)3cObN#4SO\.3+ULRe^eU,8dY
T/)5,a1?\c>e68F#ZZJ9OJHZ)#@?[5/f<9UPARfM)RPN,<\_V7WMLd>CXe[I5J@:
4>f-;E,]0GT/<^+gJ13X#;KLUQ(8&GFN8.GeG6J.&U<C18P+DXTYUg+gD80]ecF\
I/M5?E9Z6915>#)SfRY:fa7#38RU)S/)aH_U5:?BT.TVXeR5:]-gE3/]M)>Rd9gP
B#\JT8b&+eT-,#PQOAJK@=W[eD4@#0N;OF0dH#1J1IEX(=I3bLc@#Z.E?IN/)M90
fddF^+(8807Q@Z>AYFe/1N\TUNXY7;;\YK-g87#GZM84+]4F;WV\VeTRLB:2Ua+6
@(>YI)bL&Y>]YE.2N(-4ZH\g=/KgU\J^3Q9L#R,UPc^VQ-Zg+_TJJ(X&0+6d[DG&
/OfD-+)fB+RS+ab1/^@]^C:7;_W1Q6,DJe)&gb+Q8S?S1-[=Y#^TI]dESW=ZM#[>
7B?[e,ACSe4Y04<YN+Cb:)>\CF8EdVIB(YGZ6F]94T^:^7PGO-:0c@Q?P^C&,7J+
eI]DB)N1-8=#\P(B@5FBE/Q5[I6..Y)CA1=_,O:IgG;-V/bQH,Og@HeY>b+D[c\@
RMPb0H,41c6AB^RO+I@,WQI5HU[dJO.6UITLN,JL\R?eU2:Xb+7WJ8/a^/6S[<9^
+PN5I0&Qb6#g<YUBb?[W2@g(S\S7S;cZRe33CR3aXd<C&Da@Rc2U<M_,P?FA2d)M
a];M]b<299?[?D<H\MaYGQ<f;QP?Jge_,=LKeY3>=N6Df(Zc:L_1dO?E)82_33XI
H>;B#cTPUP>Y9Eg)VdY-@a>1L-EMVaOP^97PAW]\3NV/BGVU]L8P([b=84I]JKf]
5:^HBK7]LBVTLT=C5[K8Z4,U])?VR)682AcZYMA#9d9[cL42d_:?f#RaM69L]La)
[Y>fWI5EY3=;R813-D(eA&0M-&cZGO=^(5;-[1N]HKVQZ)KI3>(<-C^2V=eCaBWN
Z<^88d15&QQDC]^241c6ecR8JCFGQcfK6K<GZMX\N^\NG0:4Z.=>V#\VKKfMb(28
XYd?,<1GAeX9CXVegY0@:Cf7eSg[Q=_D#>;NB,-dF0=3U.5U@,/E5e1J9)P<J0JS
,ge3fF+Q73I.F/e,.L9WCWG)XS(]7_=gZR/25FVW2=8.F=X^3FC03.49.Q:CbK5f
0+G+E[\<@HQeYM=,+[QeG-?DO+a1fV5[W=_4aPeK9NWeP22cc/_>DZ;PRd4X::R7
,?)[U,3G)g.^K8R[;TT2>KQ7f87-1TR<Zc(T(OPRR8ZAU[\:RHKgDU1Pf&e<)fQP
d,>#V[5XZgSIQgT28O@?74e]Z^0#EM0;eH8:0>[/8G/R+Rb0P7CT]H9;+J^:bQ7^
WXT.QK,KW=#.65]+@92>P:KZ2-gG2\7>)<SN>Z&Hb1AadZ2\FQcYL@S@4UR4OCMJ
;^HLKc?OIeA,>P+[>_;1\ZURP9:@_>d#6H6H1\?22)BCeR/P-dCX7<+GOaJC.1[[
;TST[?HG2>]6:KL[7+1VV\aVbTbM4K=Q8M^cWe](L8+1_:^8-?<b+0CS7g-FDO_W
9b5(+;C?G#<F@cf;Le[3:g;71SFQ#dK^(H6d6MB\\g)WW@01J1X0WcH;d/UN@A>a
CHUI(JESeIe+.PK#?@CZ<(^C-b[\6Pa<,_AB+@1_8-]36F49Q1g0?NVDC9dMMaQ>
=4+;#NfOY8ZD1\1faM=BL47A4+)eJSS-[>\D4b_aMeT6DV421F0W6MOUN0R9<:H4
G/NQg;QY?H<<UR36Y-BJ^.JIQE6)VF8,Xa48Z?&R\eRc[X1gde,bA&^9c+UdcU>U
c+V:-#FI0QBFEA5B19R=GO@5?Z]+@9P0PfTRMYREd?&JKOJM\#XMA+gQI\e.&=],
T>REH0].g\Ce]#=IL1:PM<fZcZ/.D/SgKC1_YE91E29S.@c\HTbS0GWZ//W9g7]&
;3;;VE5&#RR<X-:D8WNC3IUFUU13U():?<eONL[U4d@cO=^SAJde_5ef;BL),(Nb
NfJ,O3);U4O]2:-)CT27RA<P^X.5\dF]F>9I7N#6VVV+MgBKAW@=/@>NM//f@B^^
fQRc.8Xb)ANDOO-@afYXb+Z4FPAD,N@^X>?SA(4@8MA;M3QV?+:SYIG\<,#LPf[f
@#Ve:+2/)ID1J)Q#Fb=CMbK]f_ZR<d.N;54bE@RT6R[SMHE#_5N?,3R#H1>ADL^S
4MZA1GZa6e8;BYO_L+Gd\IX8bf(NY5#E5.,_FH3VS<J:.^8Y;\K._La,8.:WaNOe
\-F_(:/Z8PWYE:B\U<ID]K]U:I]7NTJcWH1KTCe,BX#ee?.9WNMbE<\/;7P[//V&
RR^EfQ]).-[8/fGU3)U(JRJ75BW0gbHe>gM]X>[V1#TV9):=[0_3@N0>TC[O,fZe
eYb]JPHV>IaUQ<3N)Fg@;C^+ECRII#cg4R8X8R+--]7aLP#6C<7W[_7&\S[E<+F]
1B2G#&JF9XV_AJXg=-[@;O4@#G^/Sf@/H:O7gDXFf#ZAcGaK-AT31>8<1C9&GdWD
@+aGZN1]fD=:b/bY]Lc2S=?bWU1E\gOG/.-df,CN_4YZ7B^3F\+b5TgB3g4D+R9]
PM=&_0T4&]Yad\1G042EJ;^&066G],]PLac<<.9KZ_#7\Z>C>IMS4Y^5-\5bHZ=H
M2M/3degSDd=_Pa/X^N8WD9FUdPLJc_d>9TY>Y+XLGX1RKaB3N[JZbcXL9gME[A\
X3W(NMNC&M9CaB4O6#],_,R()>@DC@TR&EG)@:26GFHCdC-6dK^U8(DE9D39T[&I
FV[3cLZ5HYV3cJE+.\H5]U76TA/(@d;fR6</Nb>ea]AZ;6OTKE<ZUB0(&T-3WID7
K7J@8F.5Mf;,MF@X<eW/MbS502fLV][2-&RCMf51?8Ha,R[f+\FgVN?0e@OY)FGc
],DgW1LKe0V@(YC0W]>YSC:ag]K=[TJ.Y5aNLag9:D4_:_7M=X\AXP4QS;1aHC(J
^\JV.>,-QBY+4L,MdNaT=MOZ;AJ&bRY2IGF2NTAgTRSOea3MYL<Q#TV[^H:I80e@
,=J1BY9/:4TU9K[9.MU^4M-?4CE:Q,B[9:TUTb&TCNb83</1?HeQ#Zg.dbOW=>Q8
abG)X2TVd):KaJC.7I7]VV4/66da;]YI-8Y:[)L]f:U3N4@95.D(aQ5Q6;7fIOaY
X4<Xe<T4GPb.@7RQ<aW?6YDeKf/?_4D@#I4.1)FO28N#4?WOS9&dD2SOcH]V7)5I
fI[T7S^V9c[=7_:N^9ND00b^?14QPfS0fCAQQ57YfL.AAM\\].BFc>9E^d^6;&_.
V>fA3O-)0@S4>KW\f9R8g,9<-FW+_QOYVa548<S]\N.N6:=[24Q7\Kf31#1FN_G+
;1Z/.<[\B,GII]O:3b)Z/EDY3&<C5#AMCO9LM7I]SVPd4NUT,69b:D09EITA^R6L
NW@VfL\QdD3&._g0>5L\<X>K3707Lb]Kg))9XQ2S6MWVS]MF15=R&5T-_?Y-f^Yf
@OOHTX(U<Y6U<8W<N(14&1-_5A:b+,.<3F)_O2Q?@800;aAV?;1/:?B8e_COU:2@
@82e:M7F#,2Z2,K83YEWQdR:9^M.H)d]cbTQSN(W^P81PMZX8T&8@F8TJ+)dW_09
U@9XB\:]OddVTPd;:=]L/Dc\0R2X+b)A9)H(APJ[X>J@719M8I_36>#/C0D2<\MM
dR^8M/K+a[cM#_5?@K#?.:]98\WGC[3W/2@<1b^9]SBc,EL8P8aOef@;:G\RG.b+
IE?I>RTUUP&\bNPgOU\(.IbZ?O[&X&=#5--Y1__8&+G5\\B\Hea[bDGB>O@V_9FP
dEg<3?gQMR]2>+?K=081D_.;R4Ig;79WSa;]IA<:+W(GVba7?8#V3LR]LK=a_Te]
3?(R\Z2X02/H6#\PH-2]8<B(cD7:81WUK,>[HK^Zc(3aP4.OBVJ(g?3fM:)^49T+
?FD@KF+7?CU^#6I]B2RgC699]+#7,&:/><^@5.b65f#XS^-^fg,d_K)I;4DTE7^/
AVg9>]([4&T.#Q>V^_#_P<Z5=>V(.GOT>2@)-ZN-L>d:?>EB6BHWNPA?U0-:R2UL
QT34TUFe0+4&_Q;HT(?JdNc+I2ADIbR=bD17O:K0Tb-LeR)^.Mc,FdNgMWTIDS=1
M1M1>C;^^fX9MKYNMR0#b1XMSP6f6<71H\RD<+Tb;AL7E_8(&LOUXLWJf.]K;fUY
XL+2&a?7E496&b]6YCQa<3>X_9;(<Z2U-7HbK3LI]#QQS(3__^D9LeW[KB^8T8?[
2_9G+@gZC.TPN>TKCX:LAMMZ=.CVEHPb\M:)R],SB@cII3_W7::PI(^Q:.)3[ZP[
E3LJ^_b(Qe<aF]MC-f>-\A;QO)/MM9Mb27T_2M4Q\cg7AS1S?FeP[)&dQM02(_C0
?eM\<aU4.A3AY-<=^cFf.fK#c9.A5A+.()c=Zg^HOf-3@IIb3HI;P)_8L]/>J57-
.Z>7GCB-_c2fVE/f=OATN[:Bd=##gWa>:.J]>.OYgU(.0Q_[QO=#afOKYF\&#46,
,?KX)Z3AE+52EU##6b<[V0]IP-23T\4gI/+IG^V_62aV1J-:4_-+8\1)aA-D1;\Y
JIOJYR<TCYDBPRGOYPG[L(FRI1aY#HCAC3>\D,W=5L.<0)fT+34c&J&],(fN9f]d
_fM;FPdU274_)Gg>O1U9=VXRW@eP812-UWYLg8C:e[/?98QP.f\4O^eX29W?N[+=
H>3[UPVTFEdEDB(^?/CNW8^G&c=(EH?_Y4&#fTgE1f1(+6beaBcFKd#^CK.4<V6,
Nd6Z-;g-aH?A:O#KfGKVe<B++G6SZgY_E>9TfBAbRgf[1TYFWUMI8IHMYUB:NZ;Q
(@IS/>,U8f\JE33BQ?OU/+(gL,V6gcMF.;Q>QRG0RSE[<<X?4L>OB#W1G3_KWJ63
UORSN,cCNRH::&^Q;ZV8+ADX&0S-\JbGT)Z@S(;>-1C#Z/BaWP<6Z(H(0;7XgJF(
_(]f.8[Ld/f1LR;Q8&C:3?XA4=gKQ:;SRY[9bbMg&eL-[S,T&#@RT6,P<OgaX5(,
1I^XR[OT5=9G@=5)8A[bW/V[Y6:[&6Z7:.MEgWAP6XG)ZSQ3PaKE3D@3A#)?&YC@
#)gL:X=QVN&5e3&A&I@AZK[?S1_/4+D9J0>..?VSSWW<?Hf25WSP5(FUb1L<I]43
FA6K9+QYJE-2P]E-[@1+<T7S]b_10PQKcEE&APVENCaMCKdJFWYg[0@M1ISLNNB9
d#CC_]cAaW<6FS3Yc)GGbOCL<eP6d5VH+IV?;0.D/[,VYM=(M1KQcM80(gOSI]#A
/1_aCe>.23DD1YX7f^L+De\5>4YeAFb[;CK>U[BVdB6J6:NGed<9<K];dAY6IOPZ
2bS6MEX1D8I+4/058A)3P71M\-TP<74-GeRR0.C-aZYVKH;22<g+2dEKB#U8JM08
[A_#]c6ZF=6::1Q)CXSReK_/_(ZRJ=D+_(##ADM)Yc&d9gB6F?ZZda;7a:[Q,I@8
D_//U(IK<[6@9gXcP]K6QF3YTX_&da2eC=)+Q.+SE)gKZP3HV?KSVF/O^]X^^Jgb
4D4@SA.)aP0P=YbTC;W[c>:-<HVQ4UEIN,)6IE3fK4WC5TBSOaU1LJ&ERUQAVL7L
NbgY6,1IBf5Da8A&B?S;AfSNI,JBgLZ^HWbe+ZLYMM9ZPS0eYMQDQ-)4=,H2;F@-
3@JS_d4T)[M;Hb^#@3W30?_(eg[4U.L+eg:dSOJ@FLR;0Z;\g59W@@IbcaI415>Y
16#X4@@)#7[R9[-]IBGf8KN_;AZHcEU56c<MBGU4g,^YBaV@_E77;TV686O;fdHb
O?2.RAC2JZ9JQ4\0@UaEA2CUPMFTg.=?I=Z)3d;S<XU=&>G,5>b9K=?,,_ScCT=3
V7\Y.[O_E0e16XG6-2GXA&R[YVJ.R6&,UY][2&4?U_XZN=aXMS@;M:a=ESDb=3;Y
8?R#CEW<P5#PD]).8(EdU8Q+SWJX5HDRM9S;?>AI?9&5._(8N:VC\,6Ef#)<U5g0
8CMf_+O0?d]6S]C<>+e/FN:YU7gLKTT:NfUW)R3Mc9LeXT#.Y8RYQQa-#77CI5gT
.aIS)RKeM@(I64\EDBQa))ZSe^^ZMGgaY_e2;#S=D7AW6?+^T@@W46_RO5S?]/C0
>D+-08D9G<dVJET887gfL-3E:>H=(3fVf@DD.>\;L4<4)(>C+O)<TbU?+ZDeY-8,
8UKNU\0X2S/A&4[1D^Z+.0=a1NCPT0NTVecFX]T\])G<9b66U]5J0SY47DX#_S<M
11b7IDMA/gO-:YCcMQ^F;D<SCV@.45T[\QW(Q9_baZ5/UIAW#AP_B,60H/eME51Q
[38OgP?g=O&J(e]4.22;?NTfCI8<[9G<SE91Tg-GS@++1M1R>7DH6)<HD8&#)A+B
&A[IbI^2<JAEc?7B9J:&f(I[B-/9V-ZI+8#=Y-GAT>Q&Q1NU/Y7V7C2d[U\O=D#:
R:V9]?3Z6)_1?2WMNU16e<-/MT9E,Zc;/P/fT#R:M:2bKbD6gW5I;=T.[RX<#_OK
_;6<(7_M:=:19\I30Eb=8\d.5-BVb:Vc^:WQI#eI:>G9K6+f21H:GbN[DP0d^C6V
c:0B/N?g)]gQIFg_?9_1;6XR)FI5<(03+RZ.eQ88_<W-E@&JT;Tg.RQgI&PM0Q3F
0G-E#+1LK@U=9QDK_-[F]dN16?ZI@ZYJ=,^Tg9,7Qd?3S(=7Oa==R(3]C91_W)K4
-#VX5PEWJ:\-X,:K(1NH.[Y=4)B_/fKQOf>OYH>c:]bJHBGTE;@EN5&1FA<L?7f>
)7UNfZ^ZIcBa)WDELUE;RLNXM9)gO&d&ZTF3VcV[P51O\A7TEYXbP)=BNMK3[6KY
bZ>.2MH_+:.<S9XIK[-5Z4CKA2TFWJDg,aNJ:4RT0R[bZLQ&U,TC3-d_],7RWCK+
/?,)@+]@[OFR-Q)^#(Fe1L2\G+&PZGNRE>a1gW:e]6\\>V=GFM(P,+\4+LX-A]48
DMXNN(QS8Z>_O,e[AL7?JJG_g2>[S2+#I&_G:7f.M+?AI+2]9dBfBI.P:Yd5<MYA
9^OZ[/\ddC4.<2>JV05X1f68^=4S7NdNBKW=1gKO&M[F,#6G5^S3>aFb>17/LHaC
gK1.F8fI>X]F84<55CbP\.XTCAMeHDINPL)DcKfG3@8#HWa6ZX?G1>Ta2MH2=&;M
2WG_0S8B-@Y9QH2@<D7Y.)aTg:dV)2CUUg2cRTe\1KEV^aRNcBeQH7[1Z&FJ[&-<
0eY[\RC0X7ISbdKgb7Pf.DJ;[TT/3DG\VO4<FAf4f=>O);cLC8XQO[Gd9AH^S2(U
SW,H(f0+W;[03R@&I1f:Q3+bK<13CZc\2+P:>?g\R?bGTRY(,AeJ:a.M&GG@Nf./
<:TaeC?Gefg@H;b?4TO=WJ1^CD7RW?C/.;_4fM\,0;1a4Z\M?BZLK-HR@_0(D^[g
EK_<RT89S8#3fc7J<fODfN\]fb[a+0[L[YAF_Y/YY,@?UfP1@MO5T<fcg_RSb,0c
E8V5Y>KP<;]Z.E99FGfUHH=8]cKdg2?KbC[X<f;^CMX&DLA^ZfII5@QZaab5L0]M
^cJMIWS);TDb<TH,_[2Ke@ZK&1cbMHYGX)SG7^\A&1&L91)&J+bO.RYQT@2GB@c\
T\(c=J5EF9=YfF-.2E.^\Z+R=-]\&EMV-NFb2DS\>T)\-+89Bge,<OMe0(XJ;f/U
c?HJG[?VRL>)O4GXc:a2+-UMJ(12\;3Pg;@G1gYaTI>;9_9eCBe=9.N:[1P<\Sf&
7=8I+9T5A7P[TRU0MVBg2+]KS6J;eS?XCCbXMYUQ4-NMWAMdN[g=++YSNcRX0KI<
d.>[B<G;Y[1K_DSND)<ZN-2YLBCdd^7P_ebU\@1(RNf/b]^_;1LAGK^1=_4-?V/F
NEJ8=@K806F&Uf53OYBf^c>^6THRX#Z2.9JMeN/C91+bd+BWZ;@cEe&O253fD:-3
)b6_ZD??221OCKQA9Q7ZdVE_+:IL=Cf^fOK7\Q\e9W=fZ,KYLAMf8U91TQ+#.V)9
HHJ.D0UH/cTR/1-aXGfR=#g<?daIHH&[CZ[Xd:5@2RSILH(J2KGBXT_feT-VVcPK
FO2SDH45I:O1dLDNV?\@eac7M9XQ<^(.Wf)E9)\B^6^K>BDE3(IUXeS:g:8Ya9R+
MPQ;VR6KM&#1Y7);0E8TV2g1@82\^Md1^8;HM,.8]D.^?#,^\gf][PY9JDWAWI>Z
VB&;?,.FJWY[=6b7^AL)-0J4GNRK-c>S?=8=\Zg?]a14I<0)Z44,C:WW5FTd=bY[
RKZP@Q]>cI42J/(D1P;FD6W?\.46UH,\&c=W-\5RRAKPQRD83FYP?+T^FdQ:eO+#
9a3^?b:[MVT4MTOJ,S&/A-6+1Hfa[fY6\c6BSG8[7(NN=761V5IO1DC,H1c8XOV#
>I.FN4\bT0a@F1d19ef2_,;)TKOO/+)HWT4YU0,UN14TcK86#(V5&cNB]YK,=g<;
>fXE@&0N7X.Y\,TR?#O[VO,TL\dA[>W><Cc[ARd\5DT37bN7<2U2EB6J)[#1&TTM
TBb/DM6D:?_T06:W5]2_9_M_I-R4OQ0&G48R)&P0C#C:+A5<&cVa^@8T8M[1cQ_;
/NdGZLYYd<&:Xe9aY?ZZ<+C-;TOe)a^]W#^-b/O:/Lbc8H848WQO=L(+f4,+Ma4[
^?1E5CKgZFdP,.Ad\?7Q+bVW=56(T1J/2[:WT#.50FA2\MPVGZRO@\<K=_bC1>cJ
7>9>AT<^\L#)Ne]?0(L>CK]V.\GBf2c[PY9B<4P8eg4;XPOG)fZ4MF]0BBbd#SDc
H,F^FWBJCJ8]:XRCfMU7UX^a?d\H-55Q:G?dD79XY2=?KUZU]5M=N?TLdSSF#Lb2
X3S-:NH3LNE&#X27V;>XZGVM48S3;YeU&,+\4E:/A3E)-16f3fW?.]64a1cW[]/a
W<Lb3&LM9HU+.#c)-CQ+13?E_2J8LZ@_bf<e[M4?&<dCX<3K4e?XdRgEGVO[d2JL
-.FG]Od[b7d8,(2=95>WZ[GL,P:=9\VDW(EZXbYHEH.C\\U2;/21I)9SKI)?6+TD
7,JPS+fb6ReTfXQRH6_264+0E^YEM9JU7(OY]:^2I>8[CB)Ec35.GK_E<N5B7/FC
)]gS;Nd[B)-W3^QP/0+gVE9-H#D8b;#8/>W)Ff#a>PGR(-:RS@B:+-/@O[O]YeY_
D;F8XSMZH.CVVaPB60@8[YDAS+W8W8/W<F?=&O5^MGc93Xf?<H\\fJT+c/eQ@_55
ZN+1S6]4G1P-/5OB^TYWE\:)NbBJf(H@)IeAQ1)95@E\Q\^=C]Q&TI+c#5.E5657
Gf@_^/4Uf?&RF?]B6[ZcYQbWS7>QeB;0AQ5+\);2GH,+Z^25TZc\[6f_=)70<&IV
/X_1+@:ad6/3<]?3Xc_@G1-I(@^dE.V[#+CfU4O<J+6e:ce_L<\e+7-gFQ9SD?22
_0E^dIK<+@,a,/J+e?gN)&(&<aHGe[Wdg18e4Qa&(52/(e)Cc<]@76G/3AXE@\?;
&+f_/(#0/ON#]JgAXIBJT<EggCOQ,&K)H5MHE1R^?]Be)&]9L6LALJK(J@E.W#,Y
\2Xf\4Tf\)ac4_,d7>;A0&MA=]2cQ5<@-S;83ON?UaB7@Pf@e26GW:EGJP[Rd]]3
KK+:5-)\cY]dRZaPC5+.G7aF77T_5agJD#.a1Ke8SgC?6Q]#[JS74YJN^bL#R@J#
@LWV08(GYKSL^53Z6LNR2eW(8Jd-/HR+=+<V)X:/I6\B=^IZQS/#a&,9J=38.eD.
>?I39>K)A^=HgT;SP0F7X1@_>K)BJEFFJE-c@3Q#_,?U92&0DFBT6Pe;P);RNb\g
3-e8E:4+,1@,TOQ^#_2LFMfG^6R\>5^GU@ARMg\.5&M<EV=d?VEVW+;SFHNa:/6L
UD[_?b2MZK\83XZI>4:TP^IYe++KG-fU7DT=H92BE23(B(MRKMWPKM&[)(e)_FMY
@.M8P3W4-^4dCC452XUHKI&aDL@CJea.bgGd[gR^GOd?ea4]a&1R>X[9-B<G:dV>
fG@4gfF?JBO8a<5PM-LAcd.W#]^cV-Y\We/MG]A8R&L-[&P^HXc#_]bJGG63F4].
fgdSTV.?_H>cJ93HL,/)K^4YY7)>V9N6Y[-g0<P_1/H2LR(1E,7U?49&RPUALR#7
_Z+ABb<Kaa<L#HeOf1:27F3:1:DQB7[&2FI/^^XI]_BC>Uc6M2[_2[,bUfYTT=-;
J-]9)[:VI^+L30dY[J(H9.d]M7b7T0X;fcSR:1S@38)\7,Q]1a0>8C8)UPU)5&K?
e&ga1WS+6VN:c/B7e=[E-_(e9aX;eMc3.@3/DC-F/<6#6V1FXGWd9+0dc6\;2>_E
:O7bTaEZDO7NU;b)3/SR1g1.UdJM@\PR:F[IHV1UB^NJ0EB_??A\gM53#UeUG]ac
MNT#\P,-NGM+2<@0(=AZC[3Xcb:Z@Z:=IJd6FA#<3600/8E-K8O\?4RZ4Y7?XZb-
)Me^PT1E6W)MSc=Yd&?e6B94NVN\T6W1-=:29\X[7(]S:9d1]D_T[fB]\[UeXf+X
D[/\L2NRb8YG4-3,_FYTUXb<0#YA1c/8#NDO-O<Z@#HPE353.?R(\31#YO(XN+f^
W8a2C-:_T#g39XU>TE3<&D1bUde>H+.CZK=>WeRYJQWaf521[MK(A7;/#e_V:BeG
IJ_U#Hb18KR4]JHFRRZ?JE,P;gLd<3Y3_0.G]^;51bS]#KfYP7FN<&&\]X9Gae7U
.RZ(fR]J;77Fg@ZWORRO<g8.@:fe,ffUY0:Q<HNZEOIVcad+OD=2<)-.S65.G7H#
L/>W8?c60<:d#NU4d1=)Ab5)(2C^M^c_D^XCM:WJ1a+KD0fa46SEV-EB):PMG7dT
QO&9Tg87:8Ve]/eSXFOAXa6?08.]4B(G5U=.8,_LL6YLY2)TQVOHNEXRUbCB9a.G
c.DDgGb__IF5X3MJLb[aU_E@g,)W.FFLcg3d+dA,a@g2\.6S]@c#&2(J0&D-(5AK
3J6C&]?JJ3^N_W<XL;\TXTd_[=9S;,gQVeWVSXM0e^ZfIgY#(_fQ[0+.9[?THVI\
E?7Nf9M,_Qd=Lc:6JYg:7WUd;?PDZL>,@<#_4S5,:LI&]>V_Z304?)Nc0TE/Q<^D
&^BM/?E^95e@_gN:Bb\UQ2EU92ZbQa&Qe769-?6TgD4f5X_5<EBf]F=V+HE)X=L:
)4.+VM#,?2Ce3W\?^g1H=L0JgY6<de):FcKZA=_O1\9LZY>^^Ne4.E=ZNSEaZ;\=
,5&5)R@944@J<?.B7H_JZ[C?V/<49QAXRN2f.T8[IRL^0QOFcMP4Q-9d5D_UbJ1^
-8@&H&c2(,)MGE@[W/G7BA<7Z5Y=QV6;^[I#Zac\gWI-@I^J<C2>8/5G8eS,dVcA
(CR8&S@I>JJ]2d=O]SKJ\Ve]OAA,+;3(_KMLA?fRgFdKOQ;YJ_W&B7T+C4B3<cP)
V@US[3=DGI:R9^Ygf^X4dE\]eVOG<9.[bg)IF8.G8A9W?CV^6-/>^MV6;HTS,?=]
>+IX(VPFK_0CMGOBRLLU^I)UC+7YT2M()R?3WSZ>5DFEU>F:OZ6\@SEJ5]NIC&Sg
N-HH\d@?gOY?eXGQQBP/Gc<G<R_X^AH6CC2RaVCK<e/^Nabf[4.YTL?ZV>4-?HSD
]fKRKDX5bY4]ZeD5fO.[P,_#8&a]#IABX92?6X]>=;a2OfOaU6OVA;dH4OO#,#8X
a#C=-,5:&a;dDbN\eYE+J9&?9g@X44RLgBX:Z\AKT/F0:PC-\/FR&/-f_CTZZ)bf
(UWY@,X=,TbD/cI_JT+J9RZ65Ic8^QKM737Rg7\IFVYd0>a8T]]9OSfE:Kc8[@08
43eJg28D4G_R(M:a7#)/=2R5:#6Q9;<bd5UG[3JP70(6@#\V\;ab_C#DC_bd&>])
)G>OT_\+106S=c[aC\TA87T#0/,>E\J9[:JYEE[1ON3aFP09/N36K#)).ESUA>D&
.ZQ:ROI+\d=3)+gQFf\DLI#7bNS^[)S>IYBTMB>42]1.eVedB@Ig?X^Ye_H9,N?;
[+\f<+c3T<(9(G[A,PZZ4IKJe1/E9GT7FX[SR[-e.(O;e=6O7TMBPU6deT54IC2D
[048/cZ2W<2[S_I,SD)<>b1V>ZAFTLKQ^BO?@0P&.f:#4af5XX,=N<KRJJN/^3N_
.CFT6.-8&_d@#aL;[R&3(;ZWbDg>BOXV#_bKMMLJ/0B71<JX87E[Q:7FYIV&93]R
8POb#X[e2U-MSS7\(VdG]g<4TLSb#1-PgY/=K@BP&Gca.-H0862?J7&]VbSR))^R
DM]7E+QGC0,G9BL[E]EUNR<=4S&I3#LCPHG//E7.)a-5a/K?^g12RR+1fY9b\_8X
Ie&LR?=_B[?NB.77Z(Hd467(C:b=N/2.FDdO@,@C@(]-68V]WRA^c3/##4Da:Z[<
EF1;?G?.ZEf;#Z7cJ^/NH+d^1GH@Cd[R<eeMQ?E>T@W,^&MJ?8BN9QfF(VJBeCM8
W:A8g(22J)+VKbbPE9[V\UR,-\ZT(5(ZdL?b&.O09d]PL60]^f--eGWFW4#/@\Jb
2Y5,A22B,0Y^:Y=?JgH>86/LVN<VB\++##(H5V@R(U+egb,cS<e^#1]+;#g^bf(a
2SB6-FA:GB.45@KZ-/@9K/(?GgL/)8W+a:/RW@A5\]O&\@:6/g);H(b_/?f43N.+
9c2g\]HGZ6EAA[#YW+fC)UaM/F5UA?=[=8S(V:Z0-G@2KMW9Ac1.R[(:Z>DMLP15
\1Q2T\][WLFL0-MJ:3=)c7-YQ+B-HZ#L4/<LbM@Mf,RE<T1TP[gK(AEgd>BUAPCP
A23UAE0AJ=S9[_2_9eSSLBd#V<d=AFfO)3]T=>LSSUNd@:_IX4VGgH)&(_THQ#D0
Y:VX0T;@3eaW:TbKJd1E6:1-X=bT/KBOUJcJa;g>UO+V>I?6,=(/UQ?g2^;]@LQ=
_a\/TR9:(VV5]#H@<Be(R&>J(2:.\B8d/@/)O@,+RN@K\X4Z(,ET+TNK0?/HB#Y&
b3fcJ+X7YR3V3L^?#<?=44>50K<Z7H.f0OM=AUaES#J\EX(U80\3BTgae=@E-[6?
.LY7XAc<V-)>G0[OK2)@]U+A_-D4M8O(07@\Zc:dA>c;U1a+EJ<:3\GKZ?>]fAE9
e)?^LARP0:Uc6SMM>852FD]4FJ,g^_CYP.eUJ#S.;,.65(USFbM5;]/<[CVBBc^&
g>R<BLb8J=VFKOY/G@T2P>EP9KNW>\9A+D=RF)fL-.?(.PZ:;FgK,?:?MTKd3SgY
>fUDgJ1CLE#8==KT__L]JLJN_?b[=6.YYfcbdEDeC+A0/WG=NG^GTDA+>(Ga(_7)
,8T=PJ>gfV):+\7LB9U102E6[Ed]VbC5\NffeTY,W0e.R<Zb,KgJ2@.15>e#TH)J
A7D\K[IR0071,V)fTH\(U(8dJ=.;4(CH>\#90O=YbL8aS,M:TSW<KB:9L9cRXZ^E
F[-)-+7H]UbVE06b2M>SISKHO.8#W,X],^aD==<><]^H:24G>R^,\MbF+AE,C^56
J-0S(dBg^GHYeH\9N1]?/;?91DSRHN?,Le,FI7.4N;R_,C>I;D,gYW4d2QPA,a#b
b-)XE7cg8(5Oe>>C1L?MN]]4&UUJGgJLV[IH=[PCKV7?>BdX,X0V^MGVU9e&L6W]
:SX+,S47\^@73L_KRg7G:=3@5\5=FKdW^)/EU(]-U,fR?e&#;ZFEQ-V&1^1Q=2K&
5#C+Q.eBDg>4=C_R<DRGR4J6COMQIPKb@N2ZHOA>NgHEPU4SWI:6f.3\TTe#QT(J
/]dRQU+R\_5,QL<X&EO=e4J/;,_/4e4Dg#OE7D=e);:&_\>E\ZS2,K5F5?4aNBGL
Yd@]^WJ.H&_#,cYRJ:]<^&cXM082[8><)V&,[<cB6DU:5TMC&E[?)bYYT4d\BTH(
aN-gc^gGY0#KR1=JKE+BE?eC6/D7(2MaJ\3/NAH5]_+ZbA<f\&OXT@.GgTN=;OYc
f5MR2X-A3JTeS8V]R1N02#LUPK?S&a52WN1(.fB_Rf[Dc?EgfM+O4]+I;P6?V3WS
c^Z>e4Y]F<KL#FeGc5\MCEH>-+L-WZ#I:CfM_/RW<CP.88)B<06W7AP^9[#A^LF]
UP^:f1UF>?>EAZDI[--5@Hd0-e(TU[MHMRB\\-=JP[+41J]L&-.F7G=7)GfN27?H
=,5+WTg:+PISGO2EI@[8g3_/C:Jb#Z+K;&d28#20Nca#OWFB&+HISMRIH_0(Rd#4
[Q=BLQH^PI^&C8&CVIO-.@+AH0P,aP?WE/GU3&8:GDb8NT2N077\240P#eD&H&ME
JW:I4c/VTIe,Z,6&U-GBg<_=G:H:Y.JYVgHJL3J)d\QK]4Q>gZ1\CK.F2aE=Y;K)
QKVNd79^G-&?IVfD?W7X1=N\\gf4fE?BBZ,C)N7._K-[3P^(DZA)fe67NU#&M3,3
e4JB)#3W5Y].9<GJDVg5f@>YWbS?7bcX=OaHS^c)?-^PTEXB8>d#?38:05Z@Q,#O
cZI]MZ;Mf8>,U>SFANH^(879\O_HB+,):$
`endprotected


`endif // GUARD_SVT_TRANSACTION_REPORT_SV

















