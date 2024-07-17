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
/>gUX]R,&877YS06PKTGNX2a?BU),GbHWBCR(>8>8S??^39((-)g&(73XRY#T0I&
ReK().6^<O:=V,f.N^d-_eL?)XJD5/VIT4c]^4Xd+<U4]d6FE[KNK7&ITILP-?,H
#>4<PfG9&cgC.TT-\9,STEQS9(S89Bd:,b3HBHcGC^U\LA8g+S2aUK<7CVf+^BG1
H7MBA^a0K#.<1a(deI1[C4Y7b0TMO-d64VF96McES=ICIG)4+7LBQALS:MO9,N8Y
7(4Md5_M+,Ba@-\FL@8,Tg0dCeSAbDQ,,NPgeV)[,ZC3#JB83BK,E,O^T5[a,J5f
&?#O[3bLSSCaX8DT=+;:O5D]/#U;LRU+HJFg[[@dd+9T]>g7//FPLL0-Yf++QeI&
#:RZ&1Q=T:#S>U)g9fTCd-;D[VQH[(:LfB,5,2_c;eHD1/+D,U?H:,dU:HIf,VEU
<FeD?+QdW;aPZJ(D8NF-^YIM^6NOd0DRZAU\MY^+K6Q@@INVJY)Hg)/827,Zd#G<
M_N#)b#F#UgU_./G+@[@D_&EXB,e<Z:YVS0]<d(aT6:#\CfNe?)(.2D,NJ[gD@:N
J/SVZ(+B;CLTO30=#^CB(1IL)6L]M-f[T\M32YQO@G3aRL#R>PP6-#16d&2JcXRJ
\Z2dGRD+dGG-8]=SUI5)X1IL1$
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
dbAP^=-(ODg&+42:OI\;Df?Ve8L:C<)GdGR9U>ZZI?_?(+QUP^5^4(J,cf+^a:)6
2g+=V]6U&,PI3#Re;S]?AM+K@1b5W=f:aY+<:K>5HR:-9b:](5)]3U.ePcgC@5QI
RMBS]51308]I>F[4<^ZaMbXG7)K/g?e1b5&[HCQFD&@P@Z.0XN&N\4JBI36Z63:\
_b)R3QYJf6F<cL]N-[;V)BYOGDC?Ma?3g^ZcWJ^DP]UC@36/DZJ&J&ZC0caY@6RO
f/OL/^eI=^10U44W2B64R=>aR:_4H/eM.56N>0&X?c8Ga8?C_D6f/V8fNdRA5)&_
YHP3()4RJV;a0Y?[:EVg;]b;[>\fd\F_>&C?T/(Y=VdZ?9<BBNUL:;0#STGZ#UVY
8X&T&]WZF5ZGYWQJg=\eYE;C_N;4_O666W2\Ie>,81U1bZ:d:6DLRbUG0,C<>T+3
aIIQ1F;UE<66AdH[IP4c\K()MY/>()\XgTR-+6O=<H\/,]Ca.CQd^VUS(.OD,3fR
Y.c@C;C@A5g?V,#Yd/L@F;\16>MGf;O7MNCFY#@,4N_3d_N>7EVA5G8]e9O_ADTE
;;/WG\H2#(g^JS5FX2FXL>U?GW,PD<=_1>N=)Be/FQ-5P<]<#(V8eVfcVW3E-X4,
Jg:Q2MH9KRE>GgTX@SJXd@H7Zc&-309EY)(1;CE.CG,GTN9064KHFI:IS/Y4b+3;
>9=fa5OU0HXHQI>9HWJ7EYA/W]bQL&[Z[>J#Ba./9W^.7>/-fKM6C8,80.Ta=)7Z
A=_]AKf-_cE-1X1F)#:7agG\fA&B(]LW3ObfN2=UJ?>8=dE4F\IKWR9)L#US#J<2
7,,fQ.3(111BJEJ)KU#Ma@O8.C>4DH.B8SKD(F]&g3I0=1(CVN6ab.\?&/V;L\,&
OQE8P=Vec>8:B\g8N.3a\(B?\OWEIQ^F@b9?.I9C2fQL+X.O;RET&]Z@2FXFVA3-
0G^/^+#TI0TE(?BSAAd<HX+S?S]VSOWbR\c;WA;QeN6^?^VAge5JVJA_)>(/D-VM
aQ.?;fFM@TC[\ID[=2RXT415E5J_YA;5WZZ))E)Ye2)]I-)5UR.06ZdU1KX,V9Q>
NUJ,&2(\dE&L)aE\Ff^IHTN#8^J]5\/#XB8#][6-5N_CE78ZG]YRf?GYPFY.c.V>
cad(DDXICXTGde+bMSI,CG++?VZRY[g:e?7#?fJ&Ba@1[_gWQ7[7JWM0c4aaaL-)
G;T^TM492D8eVJaFcGJZgT:<OM6OR]4A)AQf9><ZNM_7Y0,_c?(.IM]6]?fLUT#@
Md?Y<MbM)5JKJ5]W5WEE,)54L,BSK>&Z?7WN-FTg3W<6+e]K0HZFWe+Qe1TRfd(\
&-1.b+7Sa9+LA^>1(+KdTF+(-D/-0MSWge^\c4=1RBDaT]UHT+??TIUaDR&8(&,Y
T709TM)L&I.Z/E:Y,[,deX,AZ-eM8+VQ,ES[\0geN<\@=CB8Wf/?M5,M/UF6[\M3
AHJ?^:e3,OK/d/4GN@N76VdN?+bO@;R<X1DYU]ad#6LSIE,<[A<a6F_aSRX70,JP
;d4,G=C;K)YA3Tc<E7,SYKf^BT5@d_DR>C&78<]XGI^Zd0R9]HXePJ/<6O@]WLS&
(-c6Qd+-dTU9@IB3T_Z^bF3W:7-=83QCZW55Q<&CKQ+J&OSd2@GTTcSW;@F\5#:0
&;#;5-dID<V?LJP/X-DI)=D;/;e-f(?.2dH_<.>VcVaX4XgFcF_RW[:5OR#,<0EC
JG+J<E,U;A9b9]Q,fMa<AV(dKL?Hc\VYbOZZ]G)eHJ>:5QgMLFgP9,:TM<<46?gE
.ET3D&IQY<&/63@UOC2T200TAXX]+&[E,40<f7FKM1RN0/H49gbPBODED[&ZTO7>
6(&K:O)4B#<BZZ6+U8)B[Z/a6K>Zc-#8(#,I0c5/EU>EU7ZVF.AGU[C#.7/D,c8,
6_=ITKD&a=^QED0=,LSU9gMbLXgP#P>a6f,Ua\bCZc+G8Y3+=.1_5:)6@b:=TW[M
[Qg,B:PM34U/.2Da;YH\Ga[(3P92(.BZ.P.)@KLK9ELL.D7V6?-e3+@R+ceIedEP
PHTEA)E=b/?JUcYEYB\L#H(XOfM:#Y9WB.&/SgLM<cJ3P18XC#Q_>ZS@J)gcJGJg
G]JK.3:PGgI)H(\JOD,0;G/.HSAJ6JfKPegD&UFS9MZ>D#c<HfbRFH,a(>dgU_6@
A:3^34?;SHV2,Ab-M4ZAPTSO-LfX6R#7bI2,ZPYAWK8F92d][aFUA]WP;^81F/OM
^1VZCe]@Y(DEQ^V8e8J^1U.gN_=Da>8-\F4GL[10K3+-\aFRJ&Tb,@,@O+80#D2Z
@HZ+YJ@]@/^,RgKT0.\=?8UFG>PaM?SZg#\&UGF.ZeS_E6H+]K908=5aH-XeYWf-
E),4dBSCP+XR,gK8^b)8cVAD?S9_G-02aIWRR_^/T]g3@]CHeL1O;bdGD##]BJEZ
QH/Fg8VU/N?Vf2YJ(9#]]09S>Rg:&+I^a2H\):eCVbL@AM>L@&D0UbEWBMa0+<X;
Y:09JY>XQb[ecY1_43Y7ZFPcc[S.a^:aXV3,0EX/DYHffC[(Y4VZE\+\NMd\(#K]
[O#]R<)Zf>b^\@8:TUFJf2E&^\+2D@<I:>XRY[0;<_>4MR?JNO).a)UG)_MBZA-[
/#I.gQ1B5\,J_EDf7[[^85)<Y;DATW,fURXOC12D3aUF/+PaFPaAeV[U)/.4;e>7
LVK]g0(A]6UEP:#A9aB@+134,^>6B1eMEI:S)<SRDZXJ^gK7OAJGHZCZGD3IRMC?
eQ_E>3A1H6NKJ-1:7dA+&A9=N;1baY6#HP9L0Q4^YeAIT_D<W)6CU3HCJgeCfg9.
XbdP8gLa[#TF.\A\X):]ZXfRY-I?CFI?S9L(IDHcUN)KW4fMWZ67:e@SN^QZ-OV0
M6B4])&=eFFT\A\<7QO:#5#HR21]dD5Bf]<^I_PFG;#X_T)U&/DDZNUI/I^dWDD/
O]^-^Xaf9F^TMfgPO7-c3Wb<JSJXRYUM#3YN_,_5B4]Y10@J1GHffK]DVRN1FC27
14O@OUc5#TQ]L&>1Ic()E0RW3f:7;\=KP^FET]QYFa9+@1\He24EcaP@)6H5HN50
_WG^:g[&_+;&[A]7_?4gLK&YAgF\\.9.ZE?T(T68e;13T2@4R2])0MZ@MTaHRe4.
=I+Z3@></?51gZ^VYA.?<MP0;HCV_<]HY?A_^WN33)^/f>IQL6_c5DE3&<Q55YWL
#6/I?9.80-KEO(b^3b0eE]cNHCWO7_P1VBJ25FYff/JR<RX?Z/dWS-AXS+g]=G0V
W1]O3=J:]#E0.\]4XO45I4&bVD2^,#9W/T\N<M09BRHJ.^a<@#3K&LFK.23WG_N)
@=Q95Kc)U.Y>Z\J]]M4MgIB0_7.IAE.b1)NJRXb4fBa_eSJJC[46/@PTHTMI3>SC
O8CdR:GP^Q[Mg7X/Da5#,R.<@Y+@ZAO;+R=2>H=M4X)(XO)366Z3:cRb-FVIU-3_
N.730K_C0F&b5&3cbM^F@CGNR4-GLe507D,B,1\(#9/,EQcMcc;]/WCg6@dE.L0\
-,:C,2VB[SG_K39AM;+@R9IX<;&,)EIKc6^+fC:c>50H?6.0a=)ge;P[c=+1=CI3
+1,BDc>Fa5g3f+DN].QX8H5S4.DeZ3VWDVLIN4MQCV]6/7XF6ZfAVLI+PO#@YOT-
O5\5FeMgNf;8+J->J?Q#>^XeKSB;&__PT.UP0Ja>XC9dTGZVgL>T5V](3Z<B;ONP
<&?[FH,A?A:04gb&A&1R,cJXN>?F:\JbI9>V+Sa&P:N7IaH,0^[\b)F-BN5\P,P=
A?f,,LRD;OEB9+&^,UA6W>RX5T.g/9T_65FQfWbdT2W3;?>ZS01CTba:e^4-\@?0
+9K\HN#^1Y[]OaZY?94/e)7a2ECRLWPVAda?(<QS\Z5RXAffPO^/f[[f85BbB&b[
0aR++/:S\OWAUT:_5Y5Cg]@4WJXTLS<]g4\BJe]fEeCaS6^J^KcZUI1B7-Q>32>d
g&P8IR]eZAUb.06aI]fZ9aM2CTE[D)3cH7aNO&9^/KX@HV91UY2G2f((/98H>+5E
XS_&EU)+@-ZD7LLY:dHN_CHFAfgO,a[6:+cCW7:\Za(1VaOQ(@^BIG^K2GF(6c<I
5G:8.gA+=))5B6X-6(P/_IH[?4g<(d/D>O-@H2,?SeO?/&,\-cK9[4c68Z89M5QM
E=11\7bX-.2J?X.1@8VT4KHN,JF9bI:(N#?)H<cJIGcd1-gL@2R6L3-JP&WLcV7V
QE\TJ7c^HQcK#S9-L15H5NX+e[47>C&;TLVMVOaZ,;D2;3^<\VY&cDRYaF<X)(6S
086M03eQG);\[dU8F.VgUW..&(M^Y\SS/YDIDUXZJ@dWV[1U<\\+G&,-HJT)GC5]
)RAKC.L^@.T@g6M^a[RV<fH?1V5II.>8(.@SBaKaGRZb8PLRGdP]4ISBY@WeIYD#
M@(gAB1\X5S370X3-Vd]225-FLWf]8?e2BP78?d5&G0CbJ[>?f.FBB@B5^3M&;L[
68OR/9_/64ATQP<,8M)+ZbG+NF]eAU1S-ANMU=Z\VLV^T,+4[KI@\-g^AO4+:-;O
)FDZ[?cE:>GD4deRI\947)Ob_KgSB,HLVV+1HI6J#eOP0<@J_3/6KB@23a)[YO]O
^6Dg=G+(3NX^ZM1e,.ML(]9X=P)QT9\ICP4B4:]EL68:[_UG3I##1^7T)f-]?E&(
?YPMZ<+&EW#KgaAe3_3/.@?K[4SXKV(+/]+8fKX)a#-NdC4;RAV;4NFD[KSP^)KG
]H=1H/WPG-^A+fPBDR==Gb)PNAP^S#USZVKeG(c0:?8b@IR)+F0fFSAb(J#1^HVQ
Y8G./:\_d1&3_Z/ebKE1Z8Oe+IPC2YNa;dOTW=JU@R;G&(eCQW&-P<5#GY<gTdCS
T0C./9GG1#_#6OaDYZUAC)+9S@5>.^Z<=>2D.bG&#@E<VK&2]:UFUR(2+#5NWMU[
VRc828bWI0Z\_<PN)P7[@P5/_M67[=_cA;7]^#.5VRfCU7^b8U)\<I=R=(5L15>f
NS,_UC3IN4?RT5bO8S503gc#(DNQ8H\)S8VA&E6g-,53Q)WTV#fag#C&&ZB)9SF#
2ALD_dFJXWBUbC]B93(CIQO1II.^La[W#A7TOc?VA?d]f+I1D.G>TM0-]H6-?UKG
9>Bee(_RB_#:D_T_#TDYHS<D)e7?e[V>4^DfeOZE.7J,YGGK5G_7IML;Sb?eXZNg
f0:@1Jg#CY?Mg/AVbJae3c0@_W5DQg7:6BZGZUXZaX3K=QFKcTeV2-?3#c+?)M8B
YTJ9\c\34E&a#AM3#U0XFPI+R59:Q=ZRDT\)5MBWI]gX0@2N+:;NL\P.\S0_>\M8
@.]e,XVB?2<CUS)2KZE]#Q9[A;#aDFAgQ-Zb5Ta=S21U-V.Jaff^2\Ta<.1#+:d=
S32H24Ye\WLaE=)_FTM<4Dd7M.ScC2ZF.E&5B_+E,,LBdC^a2>M,F9\:PI0_A>CL
[E?<?e,66?L#FM:3.M9TD;,,,)H\F<-AN+DJceJLXZVH-^HbbIX51aa6,,D9JLA:
Z<GaJ7JTBbZc]W(/D\Z=a[0NQI/ZV=6-<W]G4[<:O_F0]:.GP#0Pf5b:[SA+4X43
EfA-;_:GE006gW]fDC[>.HN,If>bR_fd<YDCPY;@XWZ#LaDFHVU71&fOI5D9>LVG
F:(7S55AS8FI,K(?IS^@d#6g[DM_H;8A1I63agYXe?&dcU(^?1.,R3RKLV#TTT&7
TaOU,&+4g@bW0dDT<.=f7Ic(eN9EW??E=4.,SJ(+N8FKC/;\eY#?O93(^\+/WG#0
;+H+)V28<,b&bFTCc[6@dd?BIF(1H1)B7ESEOQaBTZK:U2/LeHdN.9HRVWSVJ[>4
PA5LTe.Ze5a_(Qb:E9OPIS)&;Z-[C_QY&#?Ee,^??Pc)(.YL?KCCMFOBcRb23eWY
P?TB-DII5IAZO[-0+)DKCdVCLgCZ2R]]P>)V=0_bbId)&R)O]P@8#Q^BaNF\:M#e
#^?LN&XTSZ9eXY03\O;\:NQX-e^^5[D99[:3Z,W.C&TF=VeGE8JGLIdLg;6)FGf<
LH(68cDA:f&96fV1,X7a8&=1L,_\O>^cWSLgI?d.dL??7Yba(:fK()M@8O\[LZJa
;aN@C)M?;bSW.GE6K>VP==_.9fF2&FV/=K6cUH1YY-[XCgLU)7dS2H)WeV^+fCbF
c+12M@E1.,^>ISE7B96CYX1&;&(L5e/_<a@E+2SaS&7#b->:8TJK/R4JZ:?<(WBQ
O)#1_(19<5gXUcCY2AA3aOG-A&Ja&78/L>=BUG>1O5L_+#=b[S.E3)S,Y-Q2b7H@
:W^6aOR62K7RUL3V,bM:&@;=b(Lg;^/BdTM_&&<XMUWc-VN/4Z>X5R<\M5@:P9DL
fG?(8EQ2GQ?45JVC=N[6b6<D4?B/F2cZV^:YMe7d];UURb>fK00&2R8\2c3=T[af
DT?49cD.TQBLB@eB_8eJ?_#GF,-gC\HKG5C8ALUfaCC7DD]FM(W\KFGa@0,d+ED]
^<7Zc\Z=>71J>H8e3M88TYR,Ve\aZ4UWZ&7;T9R^bV;@V+AH\,AR4D27).fbDb,L
6f0,=<eTCR4-2>U=<<6..ebZ[.U]6=4TJKLON[MBCND:ISY4_2aIUTB3Fc)3/d+N
&P0gRaI2[feJCAT-0,CBKC89@Ibbg[ZJ5L:/S80GSJ_M2SWacWg#]c?=3g)8EcLV
c;063ATF_bg0RR7Ac<K-bS5228eF=N7I:41R=/-/_K664f4X&d7,DJ5NHNFO4/LJ
GN(?M<.gLR7O6U]A]6?MYIKHL88OKFA9>HFWA2^dc+--=AK;ceM.&WI&DJ5<eERM
8(D[]Y?/@U,DSXJc4HHK37cA\&AgV37,P[(UEAE00]0GN\U,W#)OB&fJK04&@@LB
Eg]d.ddK8=;0c_MS\Z3S>J])I;QA21);GQ7Z_^OP(<4X[#FN:)^6XV91J@B<^W4d
_>I#=F/AcXcG??eEf7?/JdG11CCALUP-NJX@034_0]fT&VA+c@(K?]4@>.3;OG2>
c-efa>A8P@CD[[V.=O\dU#=e<#;[./4@;beXH\\7F:dIT.L]&F.+>a0Oc9X)M,&V
N_V/IXFT5T1>16W6)@dLVYb@FS6H>867,gL+C\Eb\33U@;,Yf,]\J5VCNfK/28<)
BA/3T0F?&=Db0^6.#N#>Q76+4KKFBV-^6.:6fbN]\<RJ\]1+0O5e3HEN3ZIRf(U]
YRU[HQB03TbU7^dT-SJf1bF6L^,9N8.^b>:Mca,c(.P_&DQbIE<8HIf7CO91UWfD
aJ<+0(Sg]INea9TR^[#96(Lc^cMe5&,U&b?\Z01Q)_:Y5^<dE_Sa5I_):6(2Y_;O
b,<BD8V.[Jf+W?20),^#MVSJ<[=SeV.IWE;(fZFNF>Jb,eW+Ha9)K;B?RA+A.WZ-
3Cb^?8#Ke1:b2>7?7P21GD(<&b-ME>:7DcXG[)6OZ3K+bg@=H3],4<458N9,/3J<
<7:3HVDM^&,>#eU\+ZB9VaZ7gHNP7<\&00aU:\]E/.>,7TW@]\07SK(PbKUW&<Xg
,C0B:PdOWQ)SDNHH@R]/Mc([#ZMZ.Vd4NY#L_KaYBQ,QeQF(/)M6/??Q>6gP)[=:
U]>Dc/0F-0fCI9ZX4IY\SJ3/]-M7/-+?_;7Z<8CUbCUZI82O<c]TGCd_5Pb1FJ1e
CBT5\/ad.@@f;#_F>XA;OS7]FMM]e\K1==GcU0PC1A=g[Q1+EBS5+ebIHMQRB,g4
1XN[#0cYM+aZ0/CE/aCFR)+5If7#7K#3^L;KX<#e5K<P2;7c64.G[C,K:_+XJ:BK
<CJ/A^Ze.8E-F_10eLHGX&76][WICZO?6JL:&+B[Y@UVEF]J&TN3</A^WKNU,YFg
4ZQ]_Mg^#DX8ZW@0)5-@fX?V#L60ZDN#)D?@@\7H]R#UXT3JP</gG+P3(1gIFe:3
XWG7SD_a1Lfc7S7A1DX4<g+M9NA<X\4;fD4&@QUQ#Md@LKE7RJV:ba=DaJVF_IV]
[D<IB0f<AC.&<(M7\;,:]HYSSCfRKA?1O^T>3M)@2g.G8fT4DQT&5R6O?F)_E@W=
5P(Y-_4cNSe#I/\]^d08SH_Te2\2-J.fgf.cgPC,aWe8IcF_bS9bCgO6(ZI82@@(
HSbSJI+TW>9eP=<FWMb.)<>5T@?@eg_1N53dZgKSI#\2Xg=4F<WNN+[5[MabW@W1
(6K.I,FEd9883+S2;=Mg@C4dS:HA6ggNXAE:?ZU;9MD:Nf5DVGJF@R^ff;#B:bL6
I;@^-Ng4F:cA)ES0X^-M9[D7D1_e1Z2K7da)]NUf0&=NId@d-[:[O&F6J.[M9DL5
^a#_IE4^=e+P,Z#[K?.S<_DK0+&OW?agg+F+<.\[E#1Ag\&[aO@HV3KXN,/f+@F)
_b<VD_6415a9=;51gSND>ASA(X5U__)WBR_0e1aJX4BXU,=<ccFRf^eW\L&D;1cZ
54de235U5CF-?UB5_0H?G2J07G-O6G1A?3bPOCJERP=CO/5IAMMH(a\OLf&ZA_;U
;JGI&5D_bL1_ELd\]^WB5b>,V(QaY.X2OKGS1WCRK)]XE0MI6fNZg&MDTHEFC8ea
af<UA<>M/d_AV1JLYBLAPb/1M=cS.6PJA9b.SRcbE+3X1TTXF0,DQ#dBHKGZNL6Y
B_KLA:2LK6U32)1[_3X0a]-U]_+89(Y+.I5:]86^A>;,G?LDPe^c[,C_YG1N:TY,
2F8JTEg5)CMH04UXTJ-MKQd3gC9C/[.TWSVcP?d-,A2Y7dX3)(fS=0==XD)C4MFC
#(Jf92=:W++?6A.F=O#(5e;:4)=f;ARM0_NWK(4?gJ5)YK3O4VAKE0/8?0N1-GfD
_;QWDIT(,b?cGg4W3W0cO6D[ETWIEYRGEe+:eYf;dfC0YO3g/49@cI;@_V\:TY6N
GSdJRABR27RdaG_,;?d7G60I9@JFf<e=?fF52&<HBfGHJ;#NNdJgMBT5PA)TB#O;
VeYgW9aKaLGU>Q\YX7[-e4HT],,&L,W,D4^b<,RDNZ-BK\^U@gd(M_CY.AND403F
cW@;ZU=fF,F359a2))2FQZaPXa,HW6b2+:;)7QH0MGAC+)U9:_[aRVfS?bUO[RLb
NPGFNLLWU6&,=>cG=e+I?4f)/\e1&B#dEf4XKQ)DO)Pe[]=><,7V=a0)0Zf.U48+
W>cUF9)a<K[4POYOGQJ_R#C5S.]I9K?T1>OU9JG;V2]]_>dMW&_B4/;6KQPFe>ZM
F+YC#;5Af#1Y.V0H\eTVXcT^WT]:@GM7W+)0gD#fNLdVYDPQ:aa6ZM>gD/=MJb31
SE#)8RA9=PK].RPaRRQBIFS=1fMWRB:01_U;M+LcT-B]5?DI9Wab[(025GA90U<E
I\HB(&8Je93C:JD/O6^[]@\RVfWVKaD:&Q<1/Ke^U.:_[OXW0[8>;3E[;GJJ4eLc
bJC;c0Z_+)>\Y5A0b;@>Z]NAL-@gNK7CNHHE>+XW>A7XP#_>L91gPb\1ag8^6=K1
I-d,Tb@))P32C4@Q<+Ae+<08g8Y]e>;(0_+1cOM\R=QN@ISCBSV9YH3ZP7_7_WN/
N2,P0Nc-f2LXM#b.4D+KWJYF07gY#\ORPMF,VUCPG7P6FZfD<\Ea<]5g(_Zd9F&V
&KSba)L&(=\9:[g.-^PNE)3H^RV/_#R0,g1dG,RRe(WLd._=0&CX0f+6BRCf)(MY
PS]8aP,@+T?B[S[#bFM7dK>]RYbK(.a5LR1eGN\dgfM;^D(JgM;c6]C1c49cXXXT
8RVKIU;KP9/QUgQVS2:O;gCcO(KM:]S3,ORab1TZJ5;XO+/BS6WaL>dC9G;e&BWa
3QERWUVX)aa69T4(ILT[_I+J1d_EQPVLa[+fMAUU&,a+LbV<fGI/,5/8b>Ke:2TX
SMYN(+M_)9V;b8Mc4ET6>/9\>N>N<)X7L-E2>E\GK68>R;Pc#D1_-&NPc>]GcEPU
CA4/\G:<M8G:_Z1^_RNCFc4+R?WLcaY;&D2&6S2:c4G(DPO<I^=._.?#TAQDXd_>
8-P,YL5S-4F?#VXH<6=T#\Sa3SWNZIcbF.QEeWE(U3QQdA[,Y>F7Q833EP^EH^ZU
:b\f[4cP)g4TXFU,KF51X,J?:I\(MIJ>_RK)aRFS+bKVG_VC-S&cfc#P.;BVCf4+
.,?MGI<cL6B#F-Od=V)TS]QA#4,2-&34-ZPWef4.?>Ae1)L5(LZI#LD0M>4VY8/S
5@@\b8a]X7b9RMfb_+\I+7/(I\7]U#7dK1X=f<L2KD.>fd2_\D_/,WeVB:M@03^&
CFB1c7eQGIF(aSCWGJaU@a;Xc&AU)DVP,NHFD)PD>Y<SS5)YeVdKI,0)7QY[)=Zd
EOZ/V<8cII@S^L^A+>Y858f33V8V9K=T,/T,+8&SM-+@HK)TPO@3FV0e4LSMNAX[
d.)+SQ;\43G)E)RRVCX+T#6H__XWL)Hf=Tg?43<MP6>&.S[16c@bPZ,Z:S)JIc(R
DU,?eANfN?;(SNGK>&S:DG8^YAS.2[#+#=Z:f;/3-&T2L-5\N_K6N@?6EJ5:QH?b
A_<P=2#--_HR5FN]FVAI3\906#,L)[O8NgeP2e07YH5UV?0+C>;\_Rf=O^_HI6-:
9:7/?W,L,L&\G-fW##;:8Wff\^SG:HeZ4+_T7ICH;XWTQZK>C6//]g2ePR_@,Z\Z
CV\8?#=]9DIEI/+WeF3(G&_7DX@DWdVUI@2PZX/.>.D2Acb8+VRVT#&.)-9G.18[
I>V(TK^CS5;R,D:N<+:AgA[EbZYLd>-8@c,Y(\;b#LELWd-;G<0)0a^>CbO@._+K
S2;+4Rc<(D1.QXAccE/Oc2VV#_[e,JT+S9@?)#R532^KPN_9aZ2)/@gYZYe9dUD/
GZUEaV8C68O<82,JN8gb7R5N#E_I]VLW73W.5_Dc4g/P4I00_&--T,.]ZNY6B?[M
?aT>WbH3cBLg[C=:U[BFT98PXULe(\#[G8G0G<Aa=,D<:)@=9(eNL>L14]J=BRFT
a&YdQTM@SW@8G->&?F)P.4Mg[g5)@+Be<>P8SMA57)(WTMg/??40/745_Q:a1F^+
+@#RS]3DdD):MeV6]Fc/)K_Re6eTb.>YQBRb@R)\50d2&0b+UM5T2>f3c#84LPeg
)YBG40SeTZDC1JSR^,F>];#UMZQ2#&N\?B6_RdLa(:9YWWgQ05FMFJ5?VD:+]-AQ
K_(VK4M@?(AEG5RKgTAccX-(NZD>b4a@]MI+PGLZ0J,bOJR<Gb,-0IXcA/8T<K0O
X<HDgA<4g_>a=caW8,JBZ55P/ZL:5@E;LQN5#=ffUb.P?F\0P#aA9GaRZH6\URP_
I+:fW,(6cXIW?0HJe,KGG#>_=]gD#V0Y)=]U4M1HA8aZ012@;:?eR0&5e1U32X-/
@@)AH\G4Q[C56?D()#=EY7ESB@R9C/JF7d>A8GA]JES.>(8V=H4[AcK1JNQ]TI1g
:HO>1]:K_KYOHEd?D&3c<-(:-5&IAf->^<aUX--RY70;:T39@Z@[GMBXJe)&\=R:
4Pcea>@5@U3<7@6@LP2]<BQ[YWc1<8(aBUaV?[JLcCY)>V\6YU>LOJ32TA5d0PP6
_1N_^M9&gIVdG&)F>aK4<=:BY5K7#T9>;_gP_>GX;74Sa74F:J?LNbKVJ3Z7^>7U
VacV@Qf9IAa)A([=6^MOV,K_/XHZ903N;7-9GR^#9J?=a6)#7[V4d9P3/37@K97U
#CCa-JHMBNFSBUO_;?IG;ST02[c7/adZ(Kb](gYbDEO4]4f[c&OUeW3X[9W6=WJ@
f+V8gZ5&[_Jd9WIN^.#/+V/IHg+15HQ]F1eS)5@.Z#W/KHRK=Z/f)G=78^+6B[4(
;5GUUZC:PI10e:WTde:-O;;L\OCafc/5:Fc4@-=XJV<6d4RG?-OfRL,5\69A0@9T
5>[ZWH3_P.fgcJM-+Y&0(<I/Mgc]PaQd0(3SPMP.7U_Vf#g4f^0A4T5Qg8X-?C]R
]H1d_d@=AMAKQ]HCKHJZ1JK6EC&>P&P(<[8X38YKbZ^J:5;<JLA@We]B8]-dKC@0
4VTPGQ=:)dM]\3Had<eC]1,9PW\9]@fK=K<5^->J79>6X3cLZI/IaCV_eZGb-YO>
APB_A[.>/832FS22KH/19K=+D#b\]?I=43aMMZ#OFce@=6MF4+QDFe..YD=W(VXH
AW#-7PE5S_7S?MD0HFA(P0Kb,.M0HHg.^WH^dKV77dN/?cX2Aa&Y0a5KVTL_@SZ&
]G6d,?3)Jgda:&W,2<aA,._&?_[1gg&P92&&S+Q?:DQ=W)5dU\M<0M0C;M(BT-9I
Wf/1P_IJR+/_S.E-+CJJ_gEDM8]b@E14\V1,=I/N(9M0?a8RDM9HD#(Z;_eN1=?(
].KaWgN0\S_PSJI\W7P_@7GgC72JZRWJ^PRaXPeHb1)eB-QQ+3_1EF@8\-R?c/I@
O,;POY:,F)J8FZ&bb5B]X)@CEYTNP05WHI58cEM6CD<BA[E0+FH0B91?3K#S7/,5
B3XcLf.MRb#&GMV#Se&1S-2@-,VWR^F:NF[[\#2D<RUB@:O:8R5\QT;2O>c_X3(^
#VH(SAB=cEX5<d:Ca,aVa35+0[6]:]&4_,/AT_DB0TM9PI4Ke5U;R#ZAD2I3,52U
^P;DB@8\D4N^OOUW=>\66?Lc<(a50HL&J>HA.];-X>gZF6V,97^WYUKA+McMEY@?
QYN:,P(T4&J]AX4OEYcWBTIQ(_G>KKOBT6_Y2ffgEA#b\AfS?8bbF3f\KBVZb4f<
d5#TTS,;fD&K#4WU^6@/&RR^HC4c-cK_e6;(?#X/)O9XFO(3O2IafU6S]22O.06S
VRa0gL&B2X2Pe+cP@Z]^3P4884bQd;BT.TNC#NQ,Lg0>8c6^VaP^+;#9K9/KU4[-
Q83.c]Rf;O;EQA6RCgXBOA_GeHG\b+.Yb@VaIK9,+U+V-dg)T>e2Tg-JW.6F]Q=L
Td)gJcbRPe=..NSFM;Gd9J^eM:V0?1YO8fc/XNdP+L@]f[NgUJ6S==DG-A3+HG:7
RO+Qg5T8fGT1_R;LT.K3W?K\J,JeDRJU.N-?[-6WccV6A>W4E72L3M2b9QYK6KNT
00.,R=2SHNdU46K]&f,M.>IR&0ZEQ_8f0W+4QGP;EO,9X+RLMLBH96gAcL<,]O5C
-<7g#R<IAg?g\52J7[,M/d0<<E-S4=>O5.cH4_10]0[W^Q5&1==)<K41=F?WX1R<
O>Rb8_PCY[+2>)#fS)FA,=9C@4/L=;/D+MU/1ET9Oa5aCG8/SV^2gS+\L;#cG7@2
A]9Ha\:U-51:^[(J1CHfE&FJXR#-K@5_D[#@D[6H#WKE]0(&3R@?/^\)^AD/aC=R
O&1P9d.FEd.W,Y@:F+eaJ^f(,f0^??F:FB32S2\@VRG[WU4aHH)#QA=;)P0SI&Pf
)@YVB_<>6QeFZ@aEf@E9905+FW-S,[@W-Y7[aRf5@WNGN1>O-;f5BYL1da>+6ZG5
Q^;S,5&(_O3)f#4_(.,H+^UIR>a<]@^N,E\/YZH_&(8\#gEW<J8JK^BTWPgUa@#9
RMC[S7N9gLB@8B;Df-3G\M&P<6H-FP])HXK4^\O=;QgFO&D6Z5G9+)JfBbO[5:1V
dg=:-(AOO>eBK0;Qf1Zad-+5NH:8[Z[JM>:4;gRD;Zb.fD8B4:B/fe+,Sd.4DbF]
UUEEGV,LUZ7cJ^:9Q:V5FYY^\)+f/9TNJPE;:A2Z#D63;a>c7Y@]@@a9<41f1-7,
;_&3d(OT>.C5-H;(3\PBO9d=U;WI4?SE(g^d[Z&4,DMV:@C58^Z]JAMJ@LcfE_c4
1U_529DY[VeE=F.+>H/Y7[ZFZ3,S])WcA/Z^e::5DF(Eb44\N3+[E;QXIK;]1;bS
&-J6Q5>P0-e:Y^bM17GFDTL3<GB;H7X&Y-60NGH_NT9aMg??)gGCJd,d\LN:^Nfg
(_Y\c8@FG7<.a-DRB]LB;00:IDVT\K^dQf>R@LcG1(7Q=(e>Ne1)d3M_FE,,9dP.
T_[UJUY_A,\M&^.U3ESDa?6+F0T>a,bMZW^dG<7);I,E1/_]E\@QI;@4=5)<9#b2
KdQ[EJ1+ebSU4B9S?ZKXLVC.;g3G+(f\<,0T]NaKJP-KCG[5^\)W7?d7;PJ<UB[Y
T/.;VR=#d2_SK2CTG0[/&4#U=>S=4\IK_e)Oa)+[C-3#]FAd6<b8>6)GcQJRaHEB
&LINFOdZJC+-N2Q/)M1@QcH24)-E[eb]?#f#?<ELG?VRNXNfQ9a>#3,O9L58L1b)
dSa9P]_K/baMc3=0.\GQ[086:LeRD47-.:-J66H0ET(DS.)(N(bN?LX<K[SY^;Oe
.e.6Pe>D^C5?R4?51KgBbgIWOH/RSXg_gga8#U<\bA^4f37_X]9@:W37,VUKZ3/T
/JE)DO=NfRAVKUS38bG?E\+-N8.XU+eMgY#G1QS,B,Y#a]+<;<e43a0EGe118\Y8
Da?:f(?L=g_:X&aa[=/LW,dfW956XDI>e2+cL@MU_?+#5:aY,:F@PIaA5,CN@6.7
M\M#3GO^2fMDV5f.bLFZE0HJ=H;@F-HD,^#dD:/[[+V#Z]QeJLD42;D+M<F>O;E8
T<;BN2=:\bMO431HOIZ93d];(\<(B)&N??H]GWJ\+/?IAFS[W63)MY=P#b@??BWA
4WX5V8OCZ/[\FY(RL4gUd.ZP\;6@b)+Cb0,eN>^X8Sg:Q?e21G?O==,U-75L.>NT
2H;#Q+M2<LccUM(D@e-bPVD)PZH/W+9Xd/Q/<[UCGE^6P1dEB_<IQ8,;27#K8Vcg
PDAfJ8/CNgMMSMbBJX:#ULUa@E;<8<@aH\(AJ(RDGbfd:(.GJFK2gBeObdQQK?VR
6M[N:_BV#Q&]OSQ=2-^^N__.U[@K@Xc=JYI:0eTKZ;D;;\YT?c@0bXWPb&7AB3@O
:eK2DN0.V[#\\g8f>94HX<KbYe6I<aH5_G:8?=:bIOJK^\Gb+R9,?F&gf,FH9-\+
D[3BKaE&ZdBe)//A:Q);2WD07X+7?-@1<2TR_D)V1=HdaG2&ZBOS&BV#P?TLa4F2
#@B#c@2YSGe67+:0^e>6[W@MFWNbf]ICXX(bG+LXC6SIV,WPOVJB3U]@_G8/TIP8
25Og[^I=GUWS?\NB@UM<@X\1]:1^Ng(X+Z.F59:2:LaV_Z?=g9dR&_-+H&FS<gGa
VccGA[L0,^_;\SY]]L37C7-J[3Y]gacRJ<4\_ST-;_[5c&gQ5-fb&7QRdZ_DCKR:
DGQe4TU3P\3@:ZWB;VUE._:JaSDG_\99gV55PL=ReMWC0=,?(0S-MVYTQ2^47K^>
bOYC0]A6K9M?<GE36&(^6R=@<=c^b,;Jbf/5_YJ&AHUJ)6?)1USQ@ZNR[JaX62FA
D1\g_.6.UIdY=UO1YK,F&a:5QLD^LT3Z0-TS\O3W0;VM,<H81_R0PIM.UTDYba8B
^e1\TXV.MUG(:[R,(D^>.F68PB1M+9VgSe8148d\;:_d>76LN@2>Q+J3Ve6Z5M&J
@5DbXQDCg_V)X:\:55U@1C]BYVGTAV^IPHL9)4S#)B>2^d1OL^-6Lg6,]<J3CU]@
cI7Z@ZIV(,>&R]\)JQL#\9UKfOXT+CLJ+d?=e?2)H,2&<O80(dXT6KP98,8A=3EU
PU_28ANb+TF+35W,^@T;VdTGfBf22c9Z/G6Q_6,#<2UGVb4R67/;E>L4<>LSfO:F
R?dI@EbF56TH:TSW>]cXNfXB7d_XXC<AKYfG1GS:?==?&baD7SH^LY[R@]6UUHTQ
JPTJH@:ebM0\95B=^AD;W.AN;M:;R5WP[Db-JQE,<dDYIA>#I]J>bMHL7.(.RgZa
TC].L\@D7gE1ZL;dIDW]ePS:5&>=(@K1:3A+_2[a3e[ef1S55F8f3@L/1.5[B\O>
J_b+(fS=EDU]_Z8J60aBXdPa;NDQC??]>YZ6D5.UXGVKIO+?^SX=V)W#(0]33/]Q
UL6G\_OV6)3[1RB&;1X)F;4Og:ANI,(F##WW99FC,Ca\OYbB=_YW=McH(XZ;d)J>
/=_f[G?=VK-\^-MPO\<D]@E\5M[6_a,_3]La2Wc,6LBWR3KXYeFeNE.&OHKFX47:
a>Je7_c1WZD1Ic8I.N1>5d6ZMbF<?D@+_^e@0;66N+9\U:KN2Y_N50@D)_>6;P6R
KR.Z7TcV&AKIZU@dIAW/@_&[&Y;&2U+J8@VQI6gTX5=:A9aMK(OS+8;IT893-O5\
[U823gZ(,a0OcRaJa-VS/;?-1D7192ZZaN=PcHQCZUJ._^D\-gf7,MLPJLS]>:dJ
GKLQ=+g\/(#&-70W9:+[\7>;ZS0IFD4c70U6XY=/^d@.I2/QS.d<F\Db@X1K(8a+
e>&N]FA8(QVd6)H@/@\[/J93>GQg0(SPDTI+4W0IJ16RR3?L([X]T90J;J/<1;A_
/MWQ.>V>3a.3MV:N9WMLI6eUMGU(SFZ(KUH2BBcO6MZ99R:bB]B<1<D8H1T/b[^.
e29X3IV1RV_8,WL9-2acc,TC9:OF4#aQ57T)PY(9CI/#acfdC_UD8=0G8[UB>.ca
E.;VR#LQ\N0YT?9_DQ1OOPTfDG)8[AP0GYV+VMH(5gB;5+Z]2gE>LaBEBKSVBMM^
ZN=M467NW26SDGZTE;c&D>KY[=J6QM,B[f-VDZRFLE9?<fgND1:Qfb?AB&NRI1eY
UVX9RLD/WQWSX1EAPO#TX,<gU1#K5;^S^,DKFZ;J;a(AH:<b1d6?SB>gSH^/Af;=
]K[H,0481^_0\_4V;@VN2UMgHY1TF,G0fQeRF_D7LPB;2-SQR[:KN@^\?C^9@OV.
LDMef/eU1XWT;;V\EY5O_NII-@Pg7Q9?S4=TAUACaGC8XCLf([g?5g]:LAO>B18<
:6_3(772Uc@UIT0@K@44WI,?8EDKI4?&c,gZ(P>&JfHcg.Jd(M(CXJ2(O_D?@3@7
85_11JDU_85R=gM7R80[U^\X=M[@QUVT;c0dNR_FcV;(bGTMB?7;E#d84\cIAGF@
./Zb7)Wf-2+P2O-ZU,53FD#G,>U0fgfA<L?_&N4Tg=T+0(>P0,Db,V&Bg[^Z\U-7
7LTX#LL^VN)1R6_1.OaQ,Ng709[[@ONIWWN.cfE&?+E+^)X7]8]#JXbC4<I]H_:W
f2\Y9RPF#b3G1Y5f//,LEL80Rd>HER9_0>BVT_?D&X[W\RDB/I04+8OQ>U=>VMf@
DV.5SXc^9;)f/EW0f^HDLVYJ]g=f/ID5e9=TXF,Ib6OJ[d2Daf.(I0-:\)K_-::>
KE]-O.cWA65A/@VI+2)VA]cD2>XNb59TOHM+U7,cb.7N50YS=;<ATGbZXR=?07]-
YH946,4fE048MOUI&\-^-1/RfJ&E&Zg[A4(d4@@_A)&^0[_ACWbIR>NcOTX>CX1f
>2>V1/3e:6\YG^U&9\:MJ7eKKC,6Sg^^7,XQ_?@f4<-KCHLB8S;2_-67LJWZB,?I
egVMN\T@(@IH1,JAbH0YJ]2=F&L,cJ/2TO_^41GE42P,PbFJN9@\1YC2UPSB_]NR
R[:UO1A8H8L.JB]OGV9_V4bY1TbR+<,a^M,1)UX-).XC+\;#>1XF>]#A(/cSG3,d
+U>\)4J/JK)fSg=eRT.>:V@C<YAL2XV\I:UI880A_5CHb1:<3,d>a]_D2^W2OK3>
,f-EOYHDT;(RO-RUX^31dJM7^Q#eI01E<N7F<-R@(^c=0F?RW.(-^O2808@9-dBQ
e7#]@b<g]dALCI&YU-T-\[PHL@FN3;3bP[d_WOK.4]DE6<K9OR</_+H.QP1C<ZLS
\_g+NY5H4SY#Y0ME(2ZR-F6dVX([LS_2=LSIFbCcQ>:S<M8333H:Rf==];6MA<Z]
2IMaUXA1c8ECCK\I,\bQ55<.=A]CKMKI,H_#M7O^1>W6EJQRUU#IM\X(F7Z\2U0D
^KW8LID/=2Y^0EFbT<Ya&K/Q<7PV5VFE3&b2S:Q6SbJ7((H^9F-U(T6#+gaaR.]F
T:dE_VfdB[>0N2[ffE&?YUacE]DG4A=SNS6HSAF5O;_7Q(GIT=b@:[J5R<S;?+J(
WX8H/#Yc/EFNT&PUd_f]U+)PLVPfe.\H_09GTR+eM,UHNCKN[[gcf\-MR(SWLXM]
MN#b++.^ZO06S+)W?D3Q-b8fgg0OPA>WG7gZU=Ke3#L<\P^[G7A0[8B>;F,=2<g0
D#Z6cA0FELP)_,_([USR./,JWUK[6]T1B0)U&^FI_M-JF[bGMEWRUT&LY<.-fWLd
EN&:B@B_#Eba>?+7MgT.Y>8T:<8/ZM@A2d)ZUbL>I1D]b85EQ3#\Tc?)#H9R;+YT
3#AI<71QOO^6X@->?=N8O&?7@KRU8M/AeYgF7gOPEW0_9Y\<+G+WE?:FS(5^]3bS
KME.4.+cW./:5]8G@\8DW>J/2Yg?BX,9PE=W0&d[4BbI/NNB,3cAWbB7JXO[<AEG
2g(QN?ILB,C425A=GF<5W0f9]X9<@K0B?@D(W^[(1S7&a&FJ+c+L)Y0(^AJc1?Wf
:2B^Cbe@\cI_SaKI/G@I5d2eP.=CB/JgPe=F)cIB+[^+2451Y#fde^gZ2bd^(01d
]?7Bf(0]^KX31J-[T==BP5GCMcPKcV[HL[/C[.^Y^IWcTFZJfRZ6^32d++VS6PT]
4E\91G/AX8M_7^)>O]JKRJUb]ZWdd[KLO#_:cR67&)ZXQDdXBa+OD?abA>)B&<F7
FUXI,?YYJBS?YI1?Q)K;@04)RFN[cOC^K3^(3[IWP];WO&&J/2Q#MeD;6V7DB>Ue
DV3-IC,g<+]328Kg;@8G\B_+X08K+C9&\ddV]2DWZ6A-4JM&\@2eZA6P+eP)+#GZ
5(P/);C;4fbB&T8:ON6N4]9/>6).43@](f&#e&;Kad?UGL-=bdLZQP>[7(R&A@EV
;,MO?0.]5CRK,C]bJ9=Z.Mde\HD<E@6>8-[P)U8<[Ga,S\(O3#:5_YY:6ADK)T@d
[1e\+(3FgB<b(M=O.:d-2,<^2AD/(1BFL]CG8__E9L8^<5W-+#+(d[H#U^8O)e;b
gP/+=#VaE/<V@Y&P)]8KA3]/;++JHGROY>)[e2S<NFUH>A3:HaG=ZgTbJ>5G(&@Z
.dMYU#E.G6862cX>\9S8+9-d1^49bMM)-3<ILU//@B5^)_NV.@V<YF+]QJ=JO9BM
(7PT7FGLC\FJ04-HZ^EA0Z=ABZfUEQC^a_MS-XI3T2f7[.D1)]D&V#b8;fFc@8)b
C,:<=NY)2]8Y/d2f7E)6>QEFY2+Q#D,<)JXF(B2UCcVF3OC?RHHK)E<F]:XX:?<.
ADAg/-d:6S[5L/VN/c5\_@]\?@[5Ke:,5U6+N;]H4-:CX2RMc1fb>0QUOL)/PaSY
W4bcc5(>_a,QdH]0F;,P(&GEC>]DbFZJ,e+I^aLG^IXG-GW>fQ7gPWf-dD=15)N2
J-ePMagD]Z[2J__<A4BaB+,dM(SR^1C?N^:?M=5=WHDNbdP6/_<5@O7@Og^1-_Q2
<6=JMPP]7@bPAT-)CER2Z.N5bb0<(TSD/JRUff>_7)Z\0?)?YTV7Ke9SX+,)<bX=
aP:GbJ411g4U<94G&Q9=Pd\MbD=#aa&ed4^8Q53WZa_?^7c>d(GWUM\PM5NRCM-e
dTHR,e=]#g]?CJ5AUgQL\NeIS?/Id4>.I+A4AQ>X_>OP&Z?D=[M)2cD^4c_S+\(1
]EW,E#BD]ILP1IC9^;)=_0JPR:D5]bMDF7cN]&887ETS/D7UP9D(FNf<Tg[?K9ZC
_fU7G7Q0a[1>323+e\HGH?S=QgL=N,,#PT:cE=dW_VG2OQ,_<dQ[gT5]WUR59IF/
M\4ER\FFc\?/4e-dUg=-7cS=A]+OW7F<38.LgOGfGCWOc-OI:fdS/KSb[0<f<B9c
L3dGS-]-]M<.D+>\-M(HS7ZbH>5J]g]=4O;WP2^Q(RU((JaM==C@.-]ea_E@Pg5S
e11^e38CX9NF1K5IU-A#b:HV1=:=:\)F9(J<,a;>9961AGSAYA:#KLA99)_-D+0/
Y4c;88I,Q==B8I/TA/=L]M]fJLe[^6M1UK[d1YbNbF^FeCd)WD-g^BREZ++JRU9b
V8^T@8@\_N]HDZJfBXR<gK@I^_[]adR=TI/eVZ9Y]e8J:YM31S=-@C0#(1;UAI3^
IS8=WVRIO_1aPTHPVDf.AYBZbNXUNe6_-[T\WQ--fA<ZW7@6NW(b\Z\2SH#dLeBg
C0abQ^RW;</GV9=+8?fWTC7ed;XK1::U=9]N<<=4/F(U/YP,&83G\Bc6X_):G2Sd
N.aA_Y2OPPb00da[_NXISNE+2,&egdX#ZP<M.<=CC&Mg7,P,<\aa6^;R.B=IFOde
D3J:BYC69+C1<Z/^5M=,8YN2UAMR:KN4Ufd:eWGR]1R_I(W5Q7f\)#U^eD3VB__T
Rb/#5_<Q;(e/?XFB.(,35&R8Hb8PCO,\??OeU>4:0=,be?K3JFXHT>9+Z?fD(PSH
9AbZe.XS8Z-^ILIYV>KD;1>\)S3NNL1@<+JTWF8_G25a6@cc2J-(Q,]3.bC-,:ZU
<Je25g:I(>^FEWR9?_2;O#)6?,GEP&=<26A[@LK>B4e,SG6DQaE8N<]UVGUC(S:Z
V4Bb3SB8@LfgJOH.Q0];[Z/QH#?7fMJ/9<LDJ,(WU8GTC\g8164UP8P>f[;BbGb#
<O[(X\D&73HDZ,B<T<,\c.I0Z1[Aa08A/C^)?dHV>DcE37(Y?Z4\bd/fDTT6Rf0Q
eSI84)PT5XU()Z1_O[DSJeJ1A2/@VGB8WIP,G9O8ZgP:;WY\,9N1K1OM&EX\00,E
,3B@:dQC>EIMP-eR,\gG]2HMQ>PH)(aF0AY5#8PQH(9_D4c<)XJJ4>c8ZgL<8=G^
Wcg(V7af&SJ2#WF<C>3)L..9?/bGKDgUDB^.a:(D)]LeX_)/T,DZQ(gF#266\91R
A&IND4aB&P^LfP4dRF\?W/cJ<g_1;a],(D^EU2cF??P4.BT+4g7^>bAD=ZP6ObKK
B77Q,^bRUbG&0K-Yc@OY;WF)R?H#-;EO_QEcdM_MR.4e0K:\3E83G@]L#bF\L,ZK
(HER]E>7S4-J<0A#B7Y:35,2a38[6L3411VPB6;F>eEOZ;cGfEKRC\-2Hb&J;eb?
8g53JQ;Wa9NA9e\;#^C_0^UC=C0AX;OA(CSS9\<II6\@b=U)]]\IL#:YG5JX?K+X
?,>f&21;_)]P7H>U&;\QFOTQ]eIbT4McLLKTJNeL^dCTaT3/;XLB<9>1J?D/ZT&F
LT\[YdH3PPP@:=,5Rb&\eS&b)a4C_XYHbBI:@DYD5]46BDf#<\@dH.4/-MFdLMRH
fO.U_L1UA2;QMa/1E:.2R9ID:ODNVNf(ISO?#,&5CQa<Gbfa[IXg/#dD=<Q.K+e[
P?9:NQ-9Pga?/H1#5LIb72)UUQUJAG)&d?F.X-aM>F]f:Pg+<C.?OGAW;),NBe3]
WON]bJ.[&PMg1Z_8b3Ue:\d&#I2D.?,V9FOIP.fPfMMZdY0\@We#XbU]^+8>+<:9
^/:7,S&d[2&C=2U8G,cS=a;5I;F_,g29_9=1^Sc(D7-)-?IJ7TKed#WQ=Q[)K8V;
L7ZX:^L;E>3,[0LQ@^P>Q<F:&,LeIF_)#X0[TOVQ/[4\W;e_>\=W.fP42+<;b&70
SI2PcIMOO1+6DT/TP^>Nf4eaS5:PcI8fbA04TJ,Ta+OPf0<@:+gXTY6g.2H\:N6A
6#g4@:gT7ecg?/2VZB&<[bRfZD@B+,CD#T7X5/Pe;YY118R,+)[Xg-7gZcJD6Le1
Cc@)Ta@_e)ECUR1T2+2UG2^\aF.;[+<5\=1JMZbG:>K;10D;XdGE=;:>^5M#W4\\
AH/NX3ZDX3Ma0)f>V#3-XXSg)6PV)^4,=^DM6ac7[JJ8LNS;>?J,I-:DO95TP2Y/
ZT#W;gT9BD@LA#\UBNAc51bYaEXd,=4&<98W.8)7VK8JH0=F]B3LT<&P\.ac&b&9
H[U7))?)=7[G4RFf+SK2GEF?MM&MH>F6.Z\QG,:GMW=JWQPWT#b14.\7?K6bNJgN
3Zcd4L@+T\XXG<X(<+>B<=AG>PYBg_F6#41,OBAUN](I@BQV[A>LL=e.9e7TaVZ#
-PIWVaB0DV.AT1+5XcNe-bCfMW^R,QFCCGE9Q7TdP8[,B&\L?#\g;WcTY]<1/C2]
eQ=&:RX+\41[_@(FGD<RcDR(55GfD5GS^B]78PD_;U[9ICNcAP4VAUB:R28IK-QB
M\2M4I:56<R5W\-be8Y7.-LTeV[dD_@c+bb=-I+-a]@Lga@bKCIfC]+FcZBE6M6I
^,,VfC[?aZ\77,4I]VD?H^C:c-fd63AHC8<KdDANU=,G&<<I(7S@PWAF29NcaJZO
6R&?_FE5M6_WDcFKbBbX_4+_7IRRfX[aB^,,YEAg1P)#f5INBZY[?<-Q/P0f/2K/
H-@H)=&JI]6.+4]cQ7A5/g+]Eb>FafDX/?T+2L.45+JEYE3d,^.8D>e@D:@c>e(b
\IVYR:MRN^+0A6NI:2-b6U894LAdUP)RUfD/cPPeaNAfINH:^d-KPD[7>XfO<1LX
VYc3AU&]7RK3JMGf?ZS3:gT?;7:QGc?DR^(?:4X:FCQcG3;YEKZe2&;AYdI#^0_>
SUFZbd&(4(G6:GaKGf0=f-;#+)38d[R>B0@L>3_-[WO0X1MG8\b3B9D[K>;Y:JT.
@.FM&;2Q\YH+E-BW>+&F][eINA/<8AUc?)2;AP);16>4Z:d>c2OW3]V7HTFJC)GO
+ON3.AP+FXH-]7CYU@]L3NT-^@&(P<C2Md6cIW3SU3/4VT0K)WQKD?&>L9Meea[(
.7UKUZ2,IR5JObG>cKRAL<?,f((TI-EJ3.>-68e_3:Z2B>PC/>f_=;IaO^/HJDLJ
8M2N>;[M(_#IDSULD+)#JJD6V0e7W8_M.W>KSE)?G+3YYea3?gP-BCH0,X&^UV&9
9eDd@8Y]^JB+Ne14S6?C:dHB#)^H/ED5e>S^a(_@Z?]\7^\HZZ#Y#\g0S,D_H-9:
G#^G_;/a_\:J3bReZ8QaOc6./Z0<5gX:(Xb\3EN+>b;4?,V\aOceKage^D2>5?J/
8a.77439@,]g&&@J7S]A1>IEY/A4ba_U(>G6e36e6HE#.C#KH7.(<>;PDS?C[0V;
@J0M<d6UcHQA5.^c3WX=E8T3WN((V:_&N(Z-eV)Z3dBBd/7.KfOcBMT))MDS@[,Z
\&VeA1<BgUO#BHA.F^;GGc0B]b^U9RZ-YM_1==Ad41YSc<.67KI3WTXg/ZYM4OG]
3H5a3;2C4c+P2cY]bSYf=[7DIKI/FJIC815)5[VV/aKgI-9UA[Z(Y>BG_aC,f^N<
1TVXE\_AAS[?^\G;W<?MQZF2L2GL7^AUS;&BJXCLH=,7:eC/bM4,e-+D,a_WESB\
<bY=.)U=F;TXfOVU.LCW&Z;c0NFQ18#A2&Sg]6[cJQ-0dUQGS,gF>Ad9Y_SC9TMP
<@90D6G@19E[2g@MY54P/1E?;//NA,K4_:+YCSO7dc2-X=T0UZQe3cD:89)C2([4
W6_B,;,1QH+a;FAM(GG4^eI)HQ&O=]_#O,N6A9T5+GMeVX)aK6E9&QeKJZ_LI6S5
Z[LT@&\66QPX[a35d@TefKYG[PVVMV<3e=^Af(QG=aH6a[bdU5T64+9FAM_eP:8+
8^-<,94HOKQY#Icd>#Z.4+L7S[V.3Z3)S=GebaP4f0bV8PD8^#,L[Y0A#.H1W+2I
5H1N.__6ePC:?ZCGCe,2XZ)#2MTN/Q[_ECF<?KD-^?@cS+S4ZgU7BKX7e4JU<6VH
9LHF(IXQG7M)FVKVfDFDAWB7/U.&VXTW>S0FfXR,4;UT.#<NB&;9\I6EeT:4T>-g
8=a6b+,8C[Fg5A6NJD,,aOU_C>@AP=RbP)]@,W/E5PJGD:ZD1JcS[b;TZ]G63N#:
LHCK&2Y3J6]BB2R27GeXSABKOL[PT;NSB]@IY@ADQ(0;aDR6,04.8eJ79abeP2aY
V,.UF&2.?(;\Z9;V14XEWL,^HH7^PYBVC(\f0-.&WC1C1-D?E>.19C3GAcf2=]-\
I954/K,S=8A#,KEI\(#CYK<IGRN22T#WBC1L4c[?WD,NE2BRA[R&bRM[+Q,e_7-F
#@X9T#AAf_W)X<B\U]1VC0.cF1P:5+D+1Z.Q+;5P1-4=eBIa,D,8QE6G;AFGZH0]
L?-,f[SK>1[Y7eP,4.]9BM<P&#86(R0YSE[#TbQ3KD6.-@dd9+K=,<,R7[<\\,cL
.S2g47>KKL_^]3R8_;ES3c;3+?W_[-c\@28EDJD<LZQg@:9-g3P&6gfHd.:IILHc
-M7I<\E^.V_DCOL2/IFH2&G)Qb3POJ,Y.9A5d/T#M)[?)?,Eb1,IcU&?A5E(-\@#
1VR.IWI@]6b),^0ebddW?<S/e#cK]Z419O<7,g/H6]2VH)e9(R6E:^QMBJ1?(g2B
;[gXJOc:bf507C\]EZ2.b2efdQVIEd+>B5-&BDS[eCcdP=UR7\,G0S#e)2(_C5a;
\H[^eJXSb)?B]Y/MOB[]NLf>SDYOe\Q<#Q3Q3PF0fHgWQ<Rg=.\-N6(\VJeIKOK=
1]gIWX9C+_@<_2fIG)IA.AOa0UB8>5BNR&c:,=F_,[>NA<6aS/#BU59XScS/(G0Z
OH>dZ[,[H\HfT=]B7>[BF#e\c9<DF3#PE58MfbaNCS#Q5=-S;@G,NG>UbU=W&WHW
#_\\XDfZ1b78.[#F7Z]4921FMPdM5S\1@]Z[cQ:9CgOR10.MGF8IY=9;T0fBTH-b
O.0[-/a4dd(I1fX_<@?__70-S1^/)02b_^CI\:PXRPEU#,KJ;BDZK,1098E;]RI^
,&7Hc4<RcR<Q8RT9&a4F@[?(E3+Fa0>GMAdLSWHdbZ.:?LW<^;MPW/LA-MU(.c/Y
>Mab\99S?CO@?^G1;8-M]N3=D@YI2Hf=V(]DMY=UTLQQ]#dW34M.GT(<E(Q/7I9?
6#Q#YN?:\4[F4eBV7):BB1fU;@:=Q4TP]Q,_,6J21913[aXTN1N7D1ZKd(H(M+O(
Y+(I@IFA]G7,TNYedKCCH^,8R(@d^J&VA/4&N-MJ&/ZA^/?V9NT\c@;.O:3Y[9aL
+6SD6fb&T3R@?f8Eb6F3WLVJ::&.<+4XbbK?(QX/8?b@.UZFJUBU5;50_0W4@dA<
S(-.79#HgEcK+I-ZG_AC7bb/=\IXXc<=B6G.Fgb_+4+5-OXX\)0&L+NQRTI;I[d3
U.WUL\/Ic](d3XFO&:.IN22bM\eIaZ74G3\EB\J^[6=DO6<#/H#OZH8HOY-;ZE3F
R=R-,_97_JC+^H2.;GA=-b7aV:g3L6)WT+W8U)[fK#gY0-6KGYVT\Xec27CCN)Ie
/53\NZN28+4:eWFc/0>-XR6:)KBe>@=JKZ9]bR^Z-K>0.a8gT3Z3UZK-ELb^3)g5
]D8,/dP#XN9g7RI6<B+1S:&/Dcc1T;XE(1U&DgQTT?\W]/BQINMJI<7EA^.JU[;#
,RC>e.gXVVAIUB[:,&RUeY>_Pa14ESeT[2(e-76X7C,WPNdO/d-<3=WNK[Y9.>&7
?+g]WB\L[.BUJ-51PRdL#Se^A[If>66UHcC9/5)d9MH<TBWR.^4;I=U=XSa#I(-R
)7,#bR/>:(J@.R+=EeJ]7<Q9,59I#>683ee@7))W1^+QA3[GOfFJb6&g?IPOf>(R
<-[;JXZ^247bF0:-;_S5<^QR]_@\O8FA#_&8eRXCf]U1I1\@_=dA@VW[>(,ENSDX
X1^GLJSd/T4]C_P]MB<cYF61/TT<Q9Y83LF1c9@ZgP3J06V/bZ8F-)JJ3?HUF6Pa
D8:,1b+L?&2K/dfbNJ;RBN&BP_b/<=P/\BV@G+1cXJ<1:P5IMX=S6OF)HKPF6>M[
R9/.VR(GIQ:,>HC)Pd/)bX;K,Ad+.9WVObE\BP2LLAf2Q+&4.>=1C5R#+=P9;H.+
(0bL^NJNbLI#YCW4HT&L\R1PDMf<gc2(K/eb1@5DLREN_>FBR7V:JP#T8<eD/,5^
R6=:O2/5TBOMd#e_VdG8N9O=aCCI-aCbGM>GJL<BaD=P;.R/WO06YY3@ac)N)-/Y
E35/)g-(=K#R<F<O__0ZN@EUOJKF964R-F^ZFH/)(I<?7BL(^/cR&@P5#5(d6V-;
Y@Z)bS?1F#53[3XKVO4O]70\^EYOH)OdD+B8>A6X::?f7bNAAIKJ]/^/0<^EC_)G
_OUJ(8g:4AF21+E<#B@MWD;:#U4Z@0MKGTJ/3<0J+AW^eK=S6K6Hg)7H?75G5:QG
/:((cd_V2d8E+:.LZ/8T&a:H5-SY:L0B?<E44Je6^W3QC_3IGbOXS2ZRPB=dF^#0
7<3IQQ=BJI/CP<:;?9PAEBLfec+0EWPfK(I;>b5Ia?<b9^-Q4G@W-^\\GD;(JM_b
G?UZbKRbJdITG:K_YRZKU7JJ-9[[E9P4-f/[SCgdA_7[[-/P(SC[Ydc5=@T69eDK
3/_WA59V<fUd\M+/62I88LHIA:8F]A-]4+61C0G7?F)7;?50ScR?^1cY-_/@2ZH-
FY/KJMbP_X)2HXcHBef-UeH<44<I.WagNED=-gb<.RfKBHBg4bQ3Y-Z8gS[Z\<YU
3_[+;<MHeQ3IB^2=\@f2T&4_UNdG\1C[Te4UQ)fUA3FIa?RDSNK.,T?bMV=-f+dN
@cK:aV#H:bBUG>7S7MP@B?,KUXOM(4O;&5XX;3X5BP+9Na^A.TS=8a#P0#Be#0&D
b]2TU^QQQ;9K_4#[QL3@[#W\JIE7]UTVg]SK((&e_X?Y173#d.Y0@N)V4.WCMQ+#
5;a:QBF]PG>C7>O8Q7_LS,NPAN01[T&-UBE+/]_d#5_NLS1K-<LQ>0#/MMJ?IZHW
]fO2FFe-442/A4DO;I5g18GMBXA-3P&,0):XB8ZA;G&M;cYZLZ&X&;f@W_,EVK6=
[V3V[0#^Vf#a/QL/-Q-><HL2=OS4I^T<ES_Y]aF#<#S?Z+RIbbbeX,<)DM2=HD2B
g@I:Y9BBJdY8L[8J.<_M839DRDe\aBS&,OR(<&Y]dDdfCKHA8G0R0gd>eI.B@>G;
R[--dREYF7b(6(Y6F.AU,T1D6.#,>ZBZ<#M69\9<R4JgIU657>6B0J+.39P=6CNS
\g((R>@[C+C(+OOWW7)#SLD?WU2EPP0S>&17LREV_&/1L7=>B=O?>-\;SR&6MW_:
(>]B00=J_:-,LA2&G#MV9U).9^X,=1-R,.fH:RFJ<e/Z[14@@BU)Zd3cg/SSUC?c
QE&d=X-0EdAgCaL@0WQg<ReBR],(fO4QF2C1SbY6R>U=(@&EM2Q3d^S;acS5-2((
,/SS7^\5.5a0@#6/1J@W@@.@T3MZ]<Z@YOP,HTAIdDKG&I4Y:(;M)6F]//.:LU=_
JTFTBb4<eJ#3-.3H:7NL([X5+aY^5PeSA4N3JZ-BB=5dd\Z[E@VDA.6db;:#[;YZ
-ECV@M50P/D4RRbA@1>HC@6&8P?8bAS\70&._UHILL,8aS\28,eS\.=AJ,@c6A(;
M9^R09HG\8Z@9B/fLGU#F5Y=+D&(F4+ITb5M/PeeeJ]NB34)W4HI\69R<H]#>8/5
Sd1(^,J,D@7+ZXRTQF_&D5==RgGU&FR?-Ra]^)V:3#Z.;fU#E8B(I9GE0V[deVTR
H/C33[P1\JMJR8Xa;N#Ad(234.bbKQIDZaV\(KZB>90Xc&fSEBGN[9_f+NR[>,f3
QbQfI&W>8cgI\82@1XR_AA_aJP]Q]29PN8_OB^6TLgdVecY2(JOH3cf5AW_K\OJ+
V.U^,>V@^ca1JBXMTG2@KA0/(a_W8([K[3_G-?.aTB,]V0YTcT_WaXM6d,6S)FGe
+([Sc)[O;)GE/N@5g\SHY9WB]ZY9F4ecB8g-R(T0dZcIA4>&)AE5?.5^^XW)fd).
R@Nb#W\YJcc1LY97c2OW03:S/KT(d[5#^6g;ecV1)9V7Y/_ZfD4[=G/39H?g:7S>
fTZ]5Ze[Z);UTN3.QA.^f1f>,dY08IMRfMJCf0.R8PBGD3KEOFW2g-ERF^HDg_3P
;W2E==KUPCgCMBP\f^78<WQV,8UT0DS>-JHJ#e^5[61B+U@PNF(4=P_)/IH;:N^=
-0JSZ)55S4P<8672_.9_\#:^SR^J(QX\.4ZI7=N;25H]>Y2J:S6\2(&=O^E7FY(,
aXd_OS4O3b^:>TZ508ICN^+#fFW.BaAEG0GW_aJHZD\<Uf&425?9QHZ5B(;cdAQE
[^LV8J]F1UdU&0\-1f<cQUf+Ug#dC3<+:$
`endprotected


`endif // GUARD_SVT_TRANSACTION_REPORT_SV

















