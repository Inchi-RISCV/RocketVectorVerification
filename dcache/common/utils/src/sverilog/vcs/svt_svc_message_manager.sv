//=======================================================================
// COPYRIGHT (C) 2013-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_SVC_MESSAGE_MANAGER_SV
`define GUARD_SVT_SVC_MESSAGE_MANAGER_SV

`ifndef __SVDOC__
// SVDOC can't handle this many parameters to a macro...

/**
 * This macro basically just deals with the optional id value and then redirects things to the svt_message_manager macro.
 * This macro basically just drops the optional id value if it is encountered. It also only passes along the 0th arg and
 * the first 19 of 20 'other' args if no optional id value is encountered.
 */
`define SVT_SVC_MESSAGE_MANAGER_REPORT_MESSAGE(dbglvl,id_or_format,format_or_arg0=0,arg1=0,arg2=0,arg3=0,arg4=0,arg5=0,arg6=0,arg7=0,arg8=0,arg9=0,arg10=0,arg11=0,arg12=0,arg13=0,arg14=0,arg15=0,arg16=0,arg17=0,arg18=0,arg19=0,arg20=0) \
  do begin \
    bit has_obj_id; \
    has_obj_id = !svt_message_manager::is_string_var($typename(id_or_format)); \
    if (has_obj_id) begin \
      int message_id; \
      string f_or_arg0_str; \
      message_id = id_or_format; \
      f_or_arg0_str = $sformatf("%0s", format_or_arg0); \
      /* No SVC clients current rely on this feature, and its expensive, so skip it */ \
      /* If and when clients need it, they should just call sformatf at the source */ \
      /* svt_message_manager::replace_percent_m(f_or_arg0_str, DISPLAY_NAME); */ \
      `SVT_MESSAGE_MANAGER_REPORT_ID_MESSAGE(DISPLAY_NAME,`SVT_SVC_MESSAGE_MANAGER_SHARED_MSG_MGR_NAME,dbglvl,-1,f_or_arg0_str,message_id,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20); \
    end else begin \
      string id_or_f_str; \
      id_or_f_str = $sformatf("%0s", id_or_format); \
      /* No SVC clients current rely on this feature, and its expensive, so skip it */ \
      /* If and when clients need it, they should just call sformatf at the source */ \
      /* svt_message_manager::replace_percent_m(id_or_f_str, DISPLAY_NAME); */ \
`ifdef QUESTA \
      /* Questa works way too hard to try and look for format mismatches during compilation, etc. For */ \
      /* example it appears to assume 'has_obj_id' is '0', and execute the compile checking as if all */ \
      /* messages are non-ID messages. Which means ID messages are checked relative to the non-ID block. */ \
      /* This results in the ID 'format' argument being processed as the second $sformatf field. For some */ \
      /* reason Questa actually sees the argument placeholders (e.g., %0d) in this second $sformatf field, */ \
      /* and complains if there aren't subsequent arguments for all of the format argument placeholders. */ \
      /* To get past this we send the 'format_or_arg0' value into the macro selectively based */ \
      /* on the 'has_obj_id' setting. This is enough to get Questa to skip the type checking. */ \
      `SVT_MESSAGE_MANAGER_REPORT_MESSAGE(DISPLAY_NAME,`SVT_SVC_MESSAGE_MANAGER_SHARED_MSG_MGR_NAME,dbglvl,-1,id_or_f_str,(has_obj_id)?0:format_or_arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19); \
`else \
      `SVT_MESSAGE_MANAGER_REPORT_MESSAGE(DISPLAY_NAME,`SVT_SVC_MESSAGE_MANAGER_SHARED_MSG_MGR_NAME,dbglvl,-1,id_or_f_str,format_or_arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19); \
`endif \
    end \
  end while (0)

`endif

`define SVT_SVC_MESSAGE_MANAGER_LOG_ERR           0  // ERROR - big problem.
`define SVT_SVC_MESSAGE_MANAGER_LOG_WARN          1  // WARNINGS - some kind of problem.
`define SVT_SVC_MESSAGE_MANAGER_LOG_NOTE          2  // Notice - something that may be an issue, but not illegal
`define SVT_SVC_MESSAGE_MANAGER_LOG_INFO          3  // Informational
`define SVT_SVC_MESSAGE_MANAGER_LOG_TRANSACT      4  // Transaction level
`define SVT_SVC_MESSAGE_MANAGER_LOG_FRAME         5  // Frame level messages
`define SVT_SVC_MESSAGE_MANAGER_LOG_DWORD         6  // DWORD / PRIM debug-level messages
`define SVT_SVC_MESSAGE_MANAGER_LOG_DEBUG         7  // debug-level messages

`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_NO_TIMESTAMP   32'h0000_0100 /* Don't display the timestamp */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_NO_LOG_LEVEL   32'h0000_0200 /* Don't display the Log Level */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_NO_PREFIX      32'h0000_0300 /* Neither Timestamp nor Log Level are displayed */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_NO_NEWLINE     32'h0000_0400 /* Neither Timestamp nor Log Level are displayed */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_TRANSACTION    32'h0000_0800 /* This is a transaction msglog, write to trace file, ignoring log level */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_START_BUFFER   32'h0000_2000 /* Start Buffered Message */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_FLUSH_BUFFER   32'h0000_4000 /* Flush Buffered Message */
`define SVT_SVC_MESSAGE_MANAGER_LOG_OPT_MASK           32'h0000_FF00

`define SVT_SVC_MESSAGE_MANAGER_SHARED_MSG_MGR_NAME "shared_svc_msg_mgr"

`ifndef SVT_INCLUDE_SVC_MESSAGING
`define SVT_SVC_MESSAGE_MANAGER_USE_SVT_MESSAGING_EXCLUSIVELY
`endif

`ifdef SVT_SVC_MESSAGE_MANAGER_USE_SVC_MESSAGING_EXCLUSIVELY
`define SVT_SVC_MESSAGE_MANAGER_USE_SVC_FOR_LINE_OPT
`endif

// Unset the macro if enabled for unit testing so that the additional methods
// are tested
`ifdef SVT_SVC_MESSAGE_MANAGER_UNIT_TESTING
`undef SVT_SVC_MESSAGE_MANAGER_USE_SVT_MESSAGING_EXCLUSIVELY
`endif

// =============================================================================
/**
 * This class provides access to the methodology specific reporting facility.
 * The class provides SVC specific interpretations of the reporting capabilities,
 * and provides support for SVC specific methods.
 */
class svt_svc_message_manager extends svt_message_manager;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  /** Used to build up messages across report_message calls. */
  protected string buffered_message = "";

  /** Used to watch for client_verbosity (i.e., without OPT bits) conflicts between buffered messages. */
  protected int buffered_client_verbosity = -1;

  /** Used to watch for client_severity conflicts between buffered messages. */
  protected int buffered_client_severity = -1;

  /** Used to watch for message_id conflicts between buffered messages. */
  protected int buffered_message_id = -1;

  /** Retains the source filename for buffered messages. */
  protected string buffered_filename = "";

  /** Retains the source line number for buffered messages. */
  protected int buffered_line = 0;

  /**
   * Used to indicate that the manager is currently buffering a message. Note that we cannot rely on
   * the len method on the buffered_message field as we may be buffering but currently have an empty
   * message.
   */
  protected bit buffer_is_active = 0;

  /**
   * Indicates whether we are at the beginning of a new line in the output. This is initialized to 0 to
   * that the first line of any output buffer appears on the same line as the prefix.
   */
  protected bit buffered_line_begin = 0;

  /** Flag to indicate whether or not to extract method from SVC message
   * string.  This can be set by individual titles in extensions of 
   * this class.
   */
`ifdef SVT_SVC_MESSAGE_MANAGER_EXTRACT_MESSAGE_ID
  protected bit svc_message_manager_extract_message_id = 1;
`else
  protected bit svc_message_manager_extract_message_id = 0;
`endif
  

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Static default svt_svc_message_manager which can be used when no preferred svt_svc_message_manager is
   * available.
   */
`ifdef SVT_VMM_TECHNOLOGY
  static svt_svc_message_manager shared_svc_msg_mgr = new(`SVT_SVC_MESSAGE_MANAGER_SHARED_MSG_MGR_NAME);
`else
  static svt_svc_message_manager shared_svc_msg_mgr = new(`SVT_SVC_MESSAGE_MANAGER_SHARED_MSG_MGR_NAME, `SVT_XVM(root)::get());
`endif

  /**
   * Identifies svt_svc_message_manager which has an active message buffered. Message managers setting
   * up their own buffers must make sure active buffers are cleared before initiating their own buffer
   * activities.
   */
  static svt_svc_message_manager active_svc_msg_mgr = null;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new SVC Message Manager instance.
   *
   * @param name Name associated with the message manager, used to add the message manager to the preferred_msg_mgr array.
   * @param log The log associated with this message manager resource.
   */
  extern function new(string name = "", vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new SVC Message Manager instance.
   *
   * @param name Name associated with the message manager, used to add the message manager to the preferred_msg_mgr array.
   * @param reporter The reporter associated with this message manager resource.
   */
  extern function new(string name = "", `SVT_XVM(report_object) reporter = null);
`endif

  //----------------------------------------------------------------------------
  /**
   * Method used to report information to the transcript.
   *
   * @param client_verbosity Client specified verbosity which helps define the output level.
   * @param client_severity Client specified severity which helps define the output level.
   * @param message Text to be reported.
   * @param message_id Optional ID associated with the text to be reported.
   * @param filename Optional argument identifying the source file for the message.
   * @param line Optional argument identifying the source line number for the message. 
   */
  extern virtual function void report_message(int client_verbosity, int client_severity, string message, int message_id = -1,
                                              string filename = "", int line = 0);

`ifndef SVT_SVC_MESSAGE_MANAGER_USE_SVT_MESSAGING_EXCLUSIVELY
  //----------------------------------------------------------------------------
  /**
   * Method used to get the current client specified verbosity level. Useful for controlling output generation.
   *
   * @return The current client specified verbosity level associated with this message manager.
   */
  extern virtual function int get_client_verbosity_level();
`endif

  //----------------------------------------------------------------------------
  /**
   * Method used to get the current client specified verbosity via a local message manager.
   * 
   * If the supplied message manager is non-null then this method obtains the verbosity
   * level through that. If the supplied message manager is null then a message
   * manager is first obtained using find_message_manager, and then the verbosity level is
   * obtained through that.
   * 
   * The message manager that is used is returned through the provided msg_mgr argument, which
   * is a ref argument. This can then be used to update the local reference so that the lookup
   * does not need to be performed again.
   *
   * @param msg_mgr Reference to the local message manager
   * @param pref_mgr_id ID of the preferred message manager
   * @param def_mgr_id ID of the default message manager
   * @return The current client specified verbosity level associated with the local message manager.
   */
  extern static function int localized_get_client_verbosity_level(ref svt_svc_message_manager msg_mgr, input string pref_mgr_id, string def_mgr_id);

  //----------------------------------------------------------------------------
  /**
   * Method used to convert from client technology verbosity/severity to methodology verbosity/severity.
   *
   * @param client_verbosity Client specified verbosity value that is to be converted.
   * @param client_severity Client specified severity value that is to be converted.
   * @param methodology_verbosity The methodology verbosity value corresponding to the client provided technology verbosity.
   * @param methodology_severity The methodology severity value corresponding to the client provided technology severity.
   * @param include_prefix Indicates whether the resulting message should include a prefix.
   * @param include_newline Indicates whether the resulting message should be preceded by a carriage return.
   */
  extern virtual function void get_methodology_verbosity(int client_verbosity, int client_severity,
                                                         ref int methodology_verbosity, ref int methodology_severity,
                                                         ref bit include_prefix, ref bit include_newline);

  //----------------------------------------------------------------------------
  /**
   * Method used to convert from methodology verbosity/severity to client technology verbosity/severity.
   *
   * @param methodology_verbosity Methodology verbosity value that is to be converted.
   * @param methodology_severity Methodology severity value that is to be converted.
   * @param client_verbosity The client verbosity value corresponding to the methodology verbosity.
   * @param client_severity The client severity value corresponding to the methodology severity.
   */
  extern virtual function void get_client_verbosity(int methodology_verbosity, int methodology_severity, ref int client_verbosity, ref int client_severity);

  //----------------------------------------------------------------------------
  /**
   * Method used to remove client specific text or add methodology specific text to an 'in process' display message.
   *
   * @param client_message Client provided message which is to be converted to a methodology message.
   *
   * @return Message after it has been converted to the current methodology.
   */
  extern virtual function string get_methodology_message(string client_message);

  //----------------------------------------------------------------------------
  /**
   * Method used to remove client specific text or add methodology specific text to an 'in process' display message,
   * and also to pull out the messageID if provided in the message.
   *
   * @param client_message Client provided message which is to be converted to a methodology message.
   * @param message_id The ID extracted from the client message.
   * @param message The final message extracted from the client message.
   */
  extern virtual function void get_methodology_id_and_message(string client_message, ref string message_id, ref string message);

  //----------------------------------------------------------------------------
  /** Utility used to flush the current buffer contents. */
  extern virtual function void flush_buffer();

  //----------------------------------------------------------------------------
  /**
   * Method used to push a message to the transcript immediately.
   *
   * @param client_verbosity Client specified verbosity which helps define the output level.
   * @param client_severity Client specified severity which helps define the output level.
   * @param message Text to be reported.
   * @param message_id ID associated with the text to be reported.
   * @param filename Optional argument identifying the source file for the message.
   * @param line Optional argument identifying the source line number for the message. 
   */
  extern virtual function void flush_message(int client_verbosity, int client_severity, string message, int message_id,
                                             string filename = "", int line = 0);

  //----------------------------------------------------------------------------
  /**
   * Utility method that can be used to decide if the client verbosity can be supported.
   *
   * @param client_verbosity Client specified verbosity value that is to be evaluated.
   *
   * @return Indicates whether the client_verbosity corresponds to a support verbosity level (1) or not (0).
   */
  extern static function bit is_supported_client_verbosity(int client_verbosity);

`ifndef SVT_SVC_MESSAGE_MANAGER_USE_SVT_MESSAGING_EXCLUSIVELY
  //----------------------------------------------------------------------------
  /**
   * Method used to redirect a message back to the $msglog utility.
   *
   * @param client_verbosity Client specified verbosity which helps define the output level.
   * @param message Text to be reported.
   * @param message_id Optional ID associated with the text to be reported.
   */
  extern virtual function void msglog(int client_verbosity, string message, int message_id = -1);
`endif

  // ---------------------------------------------------------------------------

endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
2#,/X\@HS;\VcW3NdN12aR:Z=6-4ITL#ZF>[d/7O<X1+G;gA(E(/0(2&GaW2M+BE
WZdg]:84ORK&14Ua@DNQ854OA3<3e[W<FQd<O7-<MeA7KVWBELR_L@(cga0UA.D/
BO,0JX^)UgWZXg>/BG+I0O5aCJH=ZRS^Z&e.8^3MH)bS[Z1Z-;+#T?TfBB2]g[^V
]XDEBBg<ZAVedK:c#W;KWL3A2)HXX_:0ZW>_K/D=Ia:,\39]gC7c-N:9(B+gFRM+
e;7.C@b>1109EE1=;QY+\fAfM_O5U2e,^;S?YCJ2eJB[6JWQ55];-UVSd1]I(=YG
B#eWS3aeE64Ad\1gdPV5RA:UWTc9SW<@:dQdC27KW-,QLUVLd^=Rf[OUTM74.I#>
aVF?AR^&baAXQ[#Y[DfIVG\feU4d1ESa7E,5)D@HgebfW>D0Hb[1(>93)LO[DHcZ
5.M7)0/f5D+KH]X1N[U\./_Y=</QLZ12^#/DSC#:;5CJ+-JCOb@XO2CCLg/D;LK6
ALeZ<O]f>(MeW20-;bNM?T^VY@QEO.9#g:06b;<Q\L&GTgPbXdUScOSVMB9bI(5:
D_8Y\/ga-SXDL6P/K4L,S:g_S@WgL1S^.&Z6.dgOW\B[C6SBP#XMQ)bEZNAb9(a0
\2M^^0L(7dSVE=S44UJcKe[C3L?+1(cZ2<KYdR(/;egK:/Z^M#IDPL/WYGX1[@>H
>)7QE<?8&],99R/-G8#2R5SA].^/S:7_1<X:;f?D+\9&+G#?6Y1HH2#B#-7+Ic-M
R1,CP-YI3RBa@^LUH\?(/?&J2^YTHUDdW<MHb)?UTAf#27\@_TNZLb>T6CG;-PNg
d58[10Q>SJZLYM0M]EWeWETG?WH9HT[_dR[:&WYL;7[(X?Ie3cGS(YWTCW1/D)7J
LL147\&ad@4IOXEa0R^(PA8Fb_A52)Ee:VR:>#6]#R1_^eAN5H1]d:d=GfELcPM5
G&MeAG39^PR(@JLeCAP=TXZCR9OQ+(1PXO.EKXLGXC<eaaE-+B3U1R,8D\B4CC3M
EMO]ANdGT@99DL^2<bY?M-POE.[6,7g>&Ya5S>__9F5+&L6QPX21&Q]AOZ5(7E]Z
HV[_JXe0[UZB5=INbXK;LDB8d/:eZJOC&S@BCG^gV\JH10Da&3@9I;.A4J98Ac1:
<@eeT^;0)]@3/@[M7((eL^O)5_3MFP#9VZCcdK5I<C)gCe3;,)SQ;0Y@Dd_)a)U?
0+TV.O.D^dG_69?.U0<CA/_+6/BQJ#9;#YQLBI(B7;GeXKMF3+f;a(<1).W@VXQA
1]UB/WC=\@2^9N3^0FCb[e4D@:YM<1UN@8F)S@7R&+V\L[G6F;Qf4Z[gEHLN]WOa
@1Ke#PKM0WJ&AQcIe+7R>27,NUPVVTFD9.>Q&;Q\IT?>G:=Vb8&J1KM3_+LZ@/L&
8-YNX?J75OGM8gR,J=5DB2PE@fd2UC9I)EQEK1&:M>H;OW?H_O4E8)<1eR62d996
MIDN>U7A(E8.A3I4(W&[4--a\Ob_4H535L8K[S2+ffPD&(:4\_]I;29L/gB[J=+-
:M5<+HJA=WU6[U[^8LT,#0N.5<^/16f650_\I8UOE;BS.UBEQI8NJW_60NQ])@WB
W>Hc>dTXR34<07]+ZQ/FC4:Q-]gP],DDZCAf(3()RX@Y[IJ]C9\/7OZWe2(]0;dC
=7L>(CC;@V@E8b\\N;C+ab0GVOf.5=.V.?5//b2QJZa>R17Bd<#;+NG-NX)Mb&[:
\c/X?3DVC&+bTAIa@eG3)c[<)a)=25/]5?/9/KFR@(MZZOdG/KA]bGAPD4\d7QfV
7WfT=dA+8bW4Y-RMT_1ZT+7_I\aQU>f9GP>#gU<e2H.=5<U>C_E.\EH^Hc#+P9cK
Q+.FccS8FPa1<KE:MVS[>OeL.Z81)eJI:EHWaV:gNY).=E#b+ILF5A:?:ag1&UcF
^gG..Y?+</=C/&W_Z[473O3+\X>Y7AM_788#FdU:UX]dGaC8_bRg250NAg)d)O2[
,KK.M<+>D)>NXCE=A3MCO:8>PIB\g<O^04(>cIW[b>D5H3Q1>+KZPXZ3/L/HC86N
aOcM5EB3RW,EAF0bLD[:b@Q9/cP(AI=6#2?D-),H4X@Wd7W@&a1cQZHZXNaW08EY
2b^DF07I1M<C:-##NV=a8aZ:3SKP&fe;L,ebI0AQ-[;B\-SRWLZ_Kee&SIUF^</D
S6LTC\WEeTHSdC7K=>/HNV3&I->:eTLf@TR\)<d>:2WZe2e)NYD=SG/<&0#NAX[@
c[:BFGeVe.9^f^V7dLZ2Z(JUe/_KH-[cI^>G&ab-=KTeK?782B6IBT^,Tg(7KLHW
-I=a2GW4^eE)TKP.T08KKC(UM-KU[70R9G\d[17J;3\PK<0K;B?SK<H-)=93M4]b
LQ9@+F5RCF&KT6>.W3DO2LVfR#>_>-:8f[MDa=VHNIcM+YW=eSaVf:B.gPG3AB5C
[EM?dUM0JF8UNbdTPb][RS<O2+K3PM#\Ofd.d#O1C_M>cE0aNAIb-@D/,29V5JKR
>]L7Q[?@HZ<J;C?b-I)W)]UUWU?9B#>eCe);8BRUX\[QNQ0JS?K538DDL<8-&:9<
[UZaES2b0PSAVg2?F-)f-JU&#Ldaa]gEWJ80D.Ff)AgZ/KO1gFT?9IS_E+(AaI-Y
g8Z[=&&\KDXeKH^I>N2P1I4SH?5Fefg5bZ4A&TA/X-PSVB](;1U_2dMA?(O=^,2Y
)ZM=@XQ>J^22/fYKSKCbPN(0^.CSK3N+#/-7c=0[ZUS2GPa6=::<OXY#PLA5H?VO
\)3I:(WRd_GcB&JGPDMC[f+;&(7.S]2SB_UBg]Rb#H^QPLD6)g;^VF[LQ/,:UIW\
SFS/gV49F1F8F.R@TJBGVbHa-3@E5[.<f/4]URe9;V-QBG6819W497URBNBK[4Nc
&8JdA8^<XU6FaO1=L>A0,K7a:-C0BSGDP=2.(XaBe7Y[cS&S&(KC49?_g=,8UK#N
1LWT;50&@e\ZP-^^#2)a@DadfPVMH#A4LXU)J@3T@F0W36S^L=fC8FMWS&N66-(c
^f]I^aR(N=C14de)]FfM_30-5d0M6M5:&4_T)4g(6]4<MEccVK@D?WZZgQIA>b6C
/X(c+F5eG5K/VCfVY3EeDEK.\JDM=#^/LHK/GCZ>0,a2XF1P=_.T<6PY:W&;^3c=
Y.CbBeUW86^FM0)3A[QeOL,>&O6JfZ<B<CX77JQ]9BAKaHVa[LS-UWb=cUI,=A53
c^(?M(3d@<AP2LI,,PK6L&fW]0MaRWLD]eb/+&65HD7)Z]TFEYMD1<@1GWJ6g[<H
QFW^Q14Z04_6]YLF/g83L3<(1fCbH8K\D,[;OL\.FZ<O9X^MUdV7(1\-S73\V>UP
XFc+8\BL1H2CA=KKF2Ua.X,:TIS3N+O+M_PYZf[\#6=<C6;5T)6A?W9g--M]]M9)
GLD0Y0+]=Z7C;/<gYBbX)d5,?/._\8WWdUe3f0Y[G>0V/L5S?<M3C2Sa[+1b0@-c
3ZLf<-UOB=0M#YL3ZDI)U&G[\+gUR3QW6@+;4WHUN-g&^(S:,Ba(S8O0V59?VAgc
=RA/(c<>bNdJ@ACUF#9-NP?#@7OJ/)AQ]NIJO;Sb.ZBMJP/G6=;G)__<_:)B^VgL
2X7Y[U2UGDN<[gHJRB]+J)c3IHGTY1]SbHQ\MIF3\U,-16Yd+bZ(Z\S@G#1B[f;Y
+cY8]M+ZW[^3_Hg^b76#eHRHRU&90Na:#Ae&7(P4_gRPg(>2IT\-S93,a?HUb7)[
P]RNb8PJ-D\6T]gV8;B,2@.aUZWL6+L87S:PcbF/:fTCY+M(7M+(IYM_)3Z&caf?
1V-W?GH;FE53M+SD5=DSfF(L/Ue5dKK167<)@OJc]C-(MK#B/WSJeLTT,#cc59N<
=TK17WWAceP\e0;e=Fg65QR1a>K;.C6>JV&48)AWc9[4Y=/EW&B:bUHJ0UYY\H//
<D<(<>Q.1)@_cZ?>/;=cN2,S^U2=S>g7^WUT83bCa5@.BIH^54KXG[DO,?bB8.[=
5DV&;YSRQ1T5Bf4R@)RI^HTd+aT-,;E:.RB.JRfPWI?cK&gGO7;N3KA?D7+6KN[T
A<e6Q#TZ52^[7_#)ALI6Y6A:-F([@DGP;4[.(8eF;FLP=N4E8Q#e45?-MLFZU[6Y
.GAeGC]/_0(CBZZ67@BD4J]E9T)bWa--6(8.I\IOaH&eII,)eRJI&7g80;KMZg?@
/(O\K\L3aZ/(degJ#ARKZ.;F[X(/U3[>O2X>LUK,0A0S\-V.S2=GgY8:L5?_5K]U
d<L+d+XH7OQ(.U0.N0)>@bM3;:<>+J_A<F(SF5E_1WT7AG8K5?IJV/+#12669]g\
VaE]Na(fEM]Db:4/])b[Sc)2Sa@T)^fcV\^0bJKC<5<MbR3cIP.(TF8+TMXcSM2b
B-G>XeZeX>?bc.\d:MH^&H@ZWMM9B0Z6A_g@7BQRKHWZ<U_MF[:gRC=&+dWc6E1B
e=ACddNE^gae;08^a,4YY]=MadW#B-c3]R]PN;HTB])@X^LVEAVD4ae)aW=-JD1;
R8@Rb0A32J#bg;Q3UD(E)6-2a_)RG?&ZMG/8]?JT?G4O&VOJIRZAYc,(f\aH8#KU
7-#HS/eWR(2O7AO)CJ:-Q0;=:DGHU#.eC\@b9#4WHB48PF<YTFK32?W?89:A@=.[
f48dCK-U??&:[1P5Q\Y_3G>JX(42He4=)QW+#AEbQC)HJW;:Z<HBU6FZ&PWO#RE6
0a<#Y\e+]c)bL]7&:U_AG^B)L+<U<cd8\9T(KO#6<-O,fPbH8/I;Pa4Qf36377T=
d0>?C3#f&(FAdQ+R)2ZH.[?JJECb#OLF&OM4^-+59-Q.@Sa_][YH]Y,g=T<CH]TL
A2cAZ-NW\EW)9]^1P86FcP#^Z7c.BZL0-PFJ]P7P/OQ\+M@T3>cV9^Tbd@/3ISVB
Z7H^E>,<_gU3eXP[bG2_F-V6J9R41TV]A#JA?UW&&Y9S)@CW^<UCM[3HZTKCd)&Y
#CF;:CX0b?T1R+feM8Y\H=e^#0PgI:A#D@T5E;LUW3[FMI+1XA/]d4O.,1/?e,/]
@O)_(72==PJ(MTPPG9_=Y&0/C^KNbW&(^g_+<>a3&2X#e#&UC_4(UIbgbRMf0f<<
_&&T6DC1b3MD&gHg2AE,)9H>?]E:.83Q<SZ8):ecggbK)6a,NV#GZJeHGUN+6#Kf
B=0X-U,Q]0&@1_U[N)dJ+BaO9/(B/Na:ZNDeBG.ZJ:NJg^0IXcDb:cK+4-SdU&P:
2MUFCSVSO3\NYO)-bBGRH#/Qd7:A-VU^W.&NFb9>?AI<Wa0S??P?f)Q:?#DZG)5.
L:0.SU)(g5/9W2)^9GS8R-A97ISGe_)<=b]6<M-JX@.13Z@11b[]:bEG,6:g?FAD
+\>][QI@(3e]gBWFQC=aLPP3e/9D?F@1WcF4T^91U4SA>DA<9J8R39;Z)KcBMD52
Y^-B)QEY()I#D.GV1MU7e?B2?D::;Ec&(;PY=,HMM+DJD^Y7^Cd>f+O5[g<)_MU-
9/E?Y5=gVL)W#e9LL2F;fQ^#<.L<1Ad^>B?PHZF:)@ANJMYFG5,R84>I#R]/EH2O
ZO@RC^OK]9O+-]EM4BER&SA9B(b-/J;ee\0PRMX8d>A7CbN1^c.)TZ3C\YI7M]b1
R@\G&_d=]-\,+OFJIg[FQN\gH2=C.G_<K[gJcXc_dX6YVT&cCUd[&Q>AR;INH(9D
>.0U.H)XGR<Q:M<GX)@3NT=R_06?RJA=<:S0TVbA[=AE/1Obc@gE6PK(F,RZSXRC
LPUeTdgU+BC.beFL)5I:Q<#ZF+)T>WUR<T<S@eRDR+MV)@Hf5UOKBDSLK1U.3da:
.+2H8S_C1J;Q>B]-)RB3M)R>Y>_(L\UeBD[/Z.?c[3@,(=+;_a)?e;,E@6D&(1Lg
JIab:98;gBA>01;VI;bTR:;5:\B.Pb4OOY3^:K4a>53YGA]?&3;V-;@WNOQf;9A/
fGFP7UTP&g0<.fH_G8@S^#L9e:;.-c6VTDV0eUF8Dd(LfTVc@V>@F\RJc3(K^]FT
_9.eREM)L^Oc:R5aAKD:63T4?->1T>0>-2E?M&M30K;9Vf>b[JeCXHa-A=8a\W>9
@<VPSWc0)Z<<Dg7?C8W?:F(+CY-[(_\.@Gef<H#:@SHA4<,T;874D/U-Da2c\(]-
1#KK<^O>SX:K0XV?.fJZA2F=AaWO].WbTG,AO2.?>E.VBdD\MANZ5;1_H]=GRR>G
fZ9babA1ffM+MM.cY\&dbM.3,d=(?2CCV6UU\Hf_[JS2GL>^QNE-?F0+/TEbaWXF
8B#8Q+b4+K9[f2_cB1SC]^=DR.WQ\KEXb;CQM)8>R(4e=/9?2FSC6-c9U&E(Y0FP
7fb,W\Q-[QX/E^07O><TQI)4LS->=c-<,DeE2\[#HK-gN]L(GD2BR;3f4\]04^IR
faUB+<=PaOS,^0Ab_\.9GB,BR96#7QT3aU&,K3IIRIf/D-(-5@,@JcCP>BN;_JHB
(4cA)EBRX)(PA<8B,CH(L[#2d](ZF-1CCde]275.f#)9Hc#1)c;\MW.LfcM=H(g6
&MS)31fJ(MFW>R-a_eQYc9IDVf/.G6.^0]^[+\b/W7?_FZ6HD@QB7H6d]FL_AG?a
D3&eB&7FBELe/fI<1+I/A=eBE4)F1W99c-/A=SD.5U,+JS_1ZDP,VH,;G-e=NQID
Q,FXAG=aIDfH4_<ARfZ\+bKYXd?e];7DdADadAARMSQf#@eM.?RI]]I1W&3NZ,SJ
]4G?C<Z2aK,0g.18,JZ9#DW_HdAVAVR)VGg?2[:56;L/=?gO+S8/(8#<If_Z3b(O
<.3]#8S-&EdU#F6]cG?N889/-.FfV=G@U.^[UC.U4JSYMBVc9X8aI7e7[E4A7;/M
7K?UF[JI?\YH\#H3RTeKAL@3e:,MU3N+B0aO&GM+[YeJE,VSN:=/&^R6D&G[_<J.
8bU/MSE^QRg7Q?V=Y9I6\2S)TAfNfICceT3+e/Xf6fQIgcQ]WB_OGFbEC.7MO64?
,6)-)Wa)(P4ZOE_MTbQ8@PB8eW#74/X++fDF0<(RS(3RRCB8X<#7O-HDY[MPH36N
2L?3K2UD6>O=QYJ7^Kb+[Zc:-K_&.Y6REC</_3_R9eO/45QOe3,_0/g;T_;W3P.M
])NQUKaa7FDa)FKeLd3bINd2AK/G+1;IS(N6ZNG_WPgC[MF6@dDZ;NR1Og[<a(^5
&A9,\O?A0[H)O9:@OOC93BbO.B_>S;F_TI_g.Kg4Cd4e8Qd^648DD:\;dJC<dS7W
1[228\GKOKVG6,F22gS.]gF3,V3U20d-cYGV09:SBF.BCOc(@>,C5IL[@)[ZQ7[=
>+Z13O]eB@5Xe:+bcYI7N2g(=OIG??WU_3Qg]aM37U\.f<A.R@<1S^6L:\QJ?QUU
gG);2@.a0Wc;FA.;RZ:3=A;X]+L,a.e7+da[c59eEB@AIZIY\QGX9S+/;-8?.ST6
TN>?(\Y\b,](QQ(.\?9-4?OM6R11@[0]8DKJ9-8S=3BVe#K8XRIXb)L0>;10a[J2
.7&FPfXDGJf+0[=H+BXC&Tc/3dgBD_?HWT6Ma32)1@R/:/R<:UOKAUVT_TXH6^DB
#\^ZOFa]L5eY35\1-,D=(^d@C0ET:A^2^W4\2UI=28]@^1]O6)CW@f3MddV\S[Vg
b&B+L.Bb]aSWC4XOL^HF2JJQ1ACZ+e,FI]O@FX)B51Z,,Y[f-5gZVQPEL4ab8_c@
HSCQ=XKR/4,;NNaLI4HM?gP+AFd?B/4HJN8;R6SAO7KdY#8+P:8IZ7O1]>N3Y#@2
YMfGU?fA>f,VWe3?/[(#P;,g^LOSU&0V\O^DCC0163L9#[&IEW0)PFF-/\W_&?/Z
DbX29&e6-TB&+ObMM9MS<U.?I3DL,Ic2.JE]5Fc_3+]6U2YB1+F)(b;JIV\UD1E:
)/IN1,5^bWK5.:PG-2[^-2Z.V]+7[5ebX5]?e5/-QbKD(bC6C_2eK1T+1ZHO+6R;
K#-M:6C>JP/5Ja0=AP@bVdU5?7C#ZS]g#G-0A,g1A8SH?50]H7&SWU@HN)d(:S5)
\EZa+/<9Q<N9>&T-LC_FL53O<5^.>dU-SRe7\)SZ3U[Mf+FF@e<H^47M5HIH,,26
H3cO<7dICHW.:6K,F6.4A9#>GV2Cfbbg;<Y#Z#@gJ<a,gfZZSg&MI0=;-I<<,[_Y
F(Ga@E_XCDN-&7a?N7A_NgFVSFW?9=+<0FcSg@?Bd9I5&I6;>9gI4SQ79g9H=FG#
GKW55R^DY)\,Tc#MIJ-D)1)E1;QL?EGF9[T=1>1Z0THcd.cQXf[8UNBIN(T8TM2U
,gNEDHPH1Ka(-LY3\eUPb+@LLc6,D-eL/<9NBcN^YfP,7=ETI]]A(Q0=LX&F9CFE
GHe#Ug45AP][W32?QI:K<DO).711gK3V;\P9.--Z>Tf64XY[a)a+M))JZc1KHCTH
2;STdFOY>C&)O=ERYKbXN,)A\RC^D(QZIP)L&;d,:W(/-1HBgV^;IEIb7>aEEQ=T
dGBE,K_FSN,a5JS4d5YM,E9U-NId^,9D@P.A@/-5UNKM9KN^AOSe,S@7bOH-HOGe
g#^&L34dH2/Ef38SVO/>2>ZM.EELWXW7fBU;a18<9[A>7Y#LU.d0E@aPJUgBX\aO
Q/d;fMIB\]\,>480;4E09aHMTP[LNP=cHJR0YQ6M]@fY=(G\8,1-+E>F:].LOZ2,
X+9E9bUC^RK8RAI8+2-&36WYY+FcCJUU0\871CTYL1QS7)VB.S7)I&-;3&dF=MeP
CeRW1Pd7@Bg23/;^P7)>TC==Q_5EQ7@44-TSI/L4[Q]B8QSXD;UU>e@\#P7K7N.g
/aRFH&RS&Uf+7=&B#ca_A@Ng8))4<)6^<PQ>L2OO<(K2;9.4]3TB@RcdWgf5NL_1
4Yd>dCg-DY-]+Y0U/O8Occ&9U5Q>cJ.G(Nc@VK[W2A_Q,DYW0)\X)L.7U>Qg^4PH
(eP@6TceW;#&(UdeY5Y]C(IKJTOQ(QNA0-H7bMK_J:.J[545MPR7;&O(@D_=?e8W
8Z)&;38EI6P@B9)2.Pa456Cg](X_,L]aEH[V@V>(Yd+IMU/C-G//Y#3RTPLYTR?3
#:73YZ-,XER+3FV<.+].Y@f))K/cHS+@/XJW3SQPQ&6#9Te7LMbUE3X#7_6QdC.,
I>d#Ka\))VWL_<+)#AF/P2=\UL#Ve]W047KGI(I7>c7D-]H.Eg5@7D=B9/fdF9=9
+#:UNW0ZW6f(]A:(PS6M+LZ5_fYSCUG@]<Z3>N&ZKB])H:)c1_TKQZ/g2fHW&e.\
#CN>-f-Tg<.PJgbIB5^KFW_aD5_6/@HXQUILG1(^T2W^5TAHQ>ASB<Q<7,f\^.9(
W[^5O1I1Xbf0T88)F,C@0&^Y#;IVe]T;8_5A/S8ZKFQ6L<\RfI)YR.5cI>A.7676
5OJYgHf[668Z2L)\:4WM_(g4c0+HBE8AI=A,KLGaRD_]C7EIC^-OLQ<cMLG8E6HG
bf/\eH6CA4KF=/Q[Og.ML(GB+e,7/G=e#2VVJ;NI9#d?9H..-6Q]SaBaWYT7J1RG
O3)YQE^[W^FeZ(29&5<8EODSSY4^@RL[YP.>HMZ2M3QD&ADe2)A-F@f]N(A#]IC)
/&Q;I-5]=d(/#aJ2/M?Ca152b4db&b<+Ra?CDS&cPRT_1b1=LJV[2<Z)?86_?;?U
J3-D.C3dTNg(aIJ>KZ?8ad6DNP6(I6B2a(1ScRLN5fg[Q#3X:7,X?EVUBLBN2[=I
64#&TS+.7-GQ_?_)d],aZ/^[MZDUfbPI8EOd>5<\N(5^#A/PJL,D>VO&A+02?N30
fg])UJ576WR1-BLAfc1GRTI;cQ;)6-VX<XD5/HM\P,7^g@Aa4<0+<)<9=C8dVA]?
(_/SDEU7E:Hg875<bg6J3EE-6>^Y#RX-<]]PgVEXOMc5];1(7G121fAIV,a9IUcQ
Ca=D&1\:/YSC/+?UAL:gG_0HUM87]5B07KW?4e73VG#9+0d(ZcQRg1@PXd4J&4^7
GZJFaEA\G7dMRZO4NZRVB(=?3-;+T)+C=CPZ5cC-3\e2I45+6H0;+9M:]Y;0J1G@
_KPP[6BY]RVNeSV(<[TER+EN_J98fa-D1g;]g3]Kb:#1RX+S:cE#YHQ>(C5++LK/
e=MO:W,XcW-HK)XW&9H3AHc-W:8\V0&D2WDcaa)/X-a,;6_[S2V/U:/7WFOL/BN#
Z_+aV5d_^c#<)<TI)?XY+QUO\Jb\:(QgRV5Mb,@\RN@.DOAD4BWE5YQ)_I+20R81
6d8&V_&T>2^8dCRN2;FT(=1WE@N7@)P4A;8:4OI^e+V,RSBKK=f@.UETH)(e5LG<
U9PGbSJK5)(0C+KK>b\JD:b4X.fgd\_f:R7_:bD)MKF#5;..G82YJa3)+WV/N5d+
bF;gG3^\S3JP.T,)]<P=;.fH<Q&S4>:NHcUb(_YVeQCU2VIgYg)3FEgZ#RD[ePIY
)X90>(AF=ZVY)#a_M\NI&&Vg[RRG9.fK:8,ggM(4?V6D7WF4^a?.QB6AE.6=MbbB
T;^<g?;WPHB-3g.Z=g)5fM<D0dN2/eR@:>XYZ#R\<bdAC\Hea3K^8^fAcWH]P834
=Z=<X8D=1GNC2W<(&2eXb=0\3_,0d+?CGQ,JDZd</R##)dN]-7#-,b63NRCPfXMJ
GSQI)F<a]WB1H#dF(2(1Z20Qdb.H.S.&#PMWED;:2.WcL(8dZ23B?2X=cR+72(ZL
I:EJWT?#U5B-@TI7@MG?1<Rb2()g^N+J@=aS/>L5-_Q:B<;]Q]#MXg@1UV,R;R,3
,8EYGg9U8HJ=B-MOK;]_C:H7;SW:JY]_QUbWPbF3TFELdSA?C0:,.9<,dMYH/,.7
N.=<H_>TL1T@S&c)A1UC8MT(/6_]:Ze+64:7M,(bI<F(&NU[S:_g&3A&Q;)89)=]
\FUTRS+.YgC2FQ51;TU-T:/2Z97g>9JI+>J4VAga[c#&F>S&g(La,VgT9J8gPJ4+
DLc4C^X,cNQ(NXfd\&FPgOZS3MLDdTIK?]6:HO)UXO[V4.e8>^K<ba]JQ[Udd8F4
56dJC>#E.54Z-VY.+KA/J1LFPBTH1/80,YaF\?-&?Ea4-O(]a1UKdd/+YPSIHM_0
66INK;6e9=KBRWZMg@7?#)./7b#Qa<TITe\2^+A23g(MO8a9b=L<b>2&F2P@NNAU
W==OSV,TX0SC-E1Y@L=XgHU6-T,7TM#97;J)_5?)J.[:1(U]YG:1@D9HRR<f37@O
I/((:<QG.Y?2I590WBR8&OZ719W:8dYU=Y=4ER4#YTMDZ-\WJE8JAKd2]CEb[#&V
-cHJ6WLV0]2gS)ZU-A\WVL@Jb657ICPIC0Ia/Z-b5OXVe0MT98]>@\0Hd2?/?Ee\
VS0?[M0W.a3Ng=DL)>K:8IZSfebgcYQKc\4;cJHGP6aEKR7-=]PPZeYeT#E8JM\#
KD--]W_;,]e,@#OL7bP\3LfcGU]5X9@<)6H1-eQg]W&_8.R>HPLWA2;6A_L:MR>I
-NT0-W&DX/b<(Z\,,TRP>g^-eNZ-@W=SAf>OT=,^&MFO[6?bGD0V=bBF>]QT;;_[
La^K?P6K6Ca@4OSEY0.BZg7fA3]>6LRYI;PUPC?Ef)-V/:ESNAOb&C?,8P-3UPc_
BM<E#Z1]eK>bP[[NKFQcH9+aVa<R(f;gX.>;P8/^.ORDH9;bCOZ/3]2KVR=f)715
,QG4.9\UONOCPaQ#6fQ3B<0:ZW,(X.F^J5I5cb<TBPQ+;W4F=2-1TQd6/-Q0aT45
J/.Ee;O,(#V)Oa-b?SN2C>V@VMH)[D],+?ZD7^M>V;1&:>)308U\1/O3UK4&>;SO
.?Q\#4aASXRYeVBQ0<LRa,eBZ3R_(K[CYf?]@0L+OHL]e#@&51RJ?S6&eNH<O1PO
91L05VU/L4CKO.K@GOgKZ;\LA#5a0A(Eb=MXFC4Q[6E]K(#8=PL-6b/7Q&L[VK47
f(>L0_1/8]YdVSP2/7A1?/\IFVOc4(ScEdeU,@)1GWDc(XN2ZBgP;N#ag8+KSJGf
X6R5U)bR<_N]N(&Y<YS^:9;V:UKEMEa]C<2P451=<<7^-fY\_=/MY?e:>/_UJ71Y
fJ=3XDWZK\Xf8Dc;\4_MH.d3Y[b3=AcZOO;,RB()3KRS^9TZ+O0F,^LM[V,K<<<P
MZ62;:2:bZ3+YGKL9Ab)U>O_G_=B+V5aT-J@HIaeETf@8/\NQZT@B@@LPX8?dDbU
=\\9PMV^?Uaa]AbX=RB[AR#\.GY9OH4HGJQ\@FO1@S0A0XK2EME\C=Q2[(0E+<J[
,KPBB-_a+,Yab.b&HRg1?14:#/X/>SDLWR7PZ&\)UMAIa^GR01f2/[O.OICd[O\M
VE:g&/9,JHf^Wg]+C?NfV:]IK3KY]#d@/WVU?92R6\\7aVP+f9=D&F&R(BC@HdYf
C9764A\[X]G:<OBBdXg0/d7/S3g@1&D4>E,1\2O6.F\gb1Q#N<6O;Z<KZI;aS_RP
UV/eAVI8:gYPDGN:.Z8:]>4;If2ec-521WEa2/IM03VZB4S^)+T=E)IcQTLNMBV&
Q.edLN:E041Q>6fG<f,\9A?O1Za4&T.FS_QN5b<SV)C5\=#QaU3f.@fb0N-2He65
cGXP[T[W?+XCY0&c>d7D/CH-:4,b6\M?_LM-PV8:.a;8,aIWC<Fbf,.Yg^_NMN>&
NW^+&X0\T_\d2:98R9^,CDfe-BOdU]Q;N7Y#IGf6M\H[5gR;OPSBg,7R/+:.(SN^
+a.bB7<?P@cgO+0K?fB[Zg/P[+W_VV(+2b:QN@7(&:#aDD2GGY_;?1\S5J766]ba
cCJJbScE/<V>+;\:;VMAaM:2O6bcdEV]J:_/:O[9WC@FLRO60SK_b)2]66,@=c1_
8)B&+cEQ@RR/(6a90[[T(Z2-/MeN=9Z=ERD/4ca9&b\07YZR?(H#5=X\1&dSVSYf
-F749g\ZXIKfS>P++EIG:<5X=.C6YR07d1bM4BM:^SaCDI_T59OFZUD?)g]<)7T^
,C\_6:[S4+F[E3F6^E-WA^bR-9NW>#\_-1/aK=[b0C/HC#=70e49(b:[<g1;.0=?
Gf<]#+F5dM##C&C#4NCR(5O#2RVY,[46d6F(:R]&5(E[C/Vb(&\:LA]R>YYPSA2N
gbbf4##SW0.;X7Z?A4e,9\c.:ONKDR;H^[0FPS7Vf;V2B,Ue?WN\5JQ[P9(N[^:I
fK?T,c+Pc-ZJ3c,.IaM(-9I+&;dfP(FgUQN6g\/e<gS73GY?1K5aV:d.721d1f\&
S\Fe).O/)JN=0;05NeWCV\O:a=K>LV-SGH9A21d+#(7W&+3,#((b67Jc3(L_AIX<
^;C\(RPCHG^8JWP1\E^>C:/:-.=&<(L/bWC\.02S_a/[8]L0G+4:87]593LIMJWb
AO((PJHJ7)3[Pa.gW(BY>Xd.#:NX=P>-I;b,4PDZe]FHJ8:P_E7LBE_6>\+6+f^U
L?#C-RXW(:5ePFC-5-P-gNCE442J53<S](U@YJ,g.S^\8Z5F.3I2bff^QaKH#THL
d6X]9@00]KcVL(]+V=43Y_fXQ_/.IG-?(>X5/d^PI&-+b/T-IIC?F@E)fbUBERH^
>C3+=Q9F.H[HbKd\LAMS97^AR-fU4ZQ.TaNJ\3MRc=;??Y.,/?4^X;f#4g9_8]>=
W_,DB_a8IF?&M)722U9,I.()fX@NZgU<b>/[J^-BHS:1=H?T/cf<4Z]@\\<+1SG+
5eXXU=Ta7?f)M0dW>#@L<<R^+]>Z@,a,e&.Z.E5[@B3;5?QL._X=>3A(S1;1N:3I
#U;H]MCQ4]Da#M4.95@X@J_[M81@XVO^\&3J75:aSVGXfM:/:@B9>>4]3<8R)4/Y
2\[_6,1aA48)AeXBT8(6[>D.#UY>(BZ6B1?AdbMG]gAbN0X]1ac;TQVeceN.IB:[
GbD2=C2:TS6ZZd[:,9>#I&_KSNMBe&-(_0)5-4H6]a@FUYB[QF0:-D?(JJNBS44&
#DL>D-)1>[;P&faKBTaP&7S^L4<NAO&^+dUf&W&aDL:FAXM_0O]E5N<_ZP\MP1a9
DIDUZ;Z5B<6;_5#ML[#.9MM\TU1E/9/=]eZLd)fK/FP7TT-MW_1d6\,fM]Y/>J+?
V52W=)DC?6#P]Z_I<)E[4gC<AC#A:O&Q>FCRR^7XO6O).d(IG8=.7EbJ@)H0K?Pg
N;\4WXEd3]PGbA)1>:T;N0@6J[_M]d0?MI>#FgY@,D54aJ@;K2/YLGbJJ5>XfE9:
IIMJD7:/X)-e_QK40AR3B1/]?:C\)+VHWIWbI\=Q/#7ZXYX?,P^M@bIT)CI5\=G:
=81MaF/O>HgDTTF=fM_U99>IaA@cf5I8T&9G=R\^T[dWe06RDI:07W=/c>M-O^?S
+JPQVL2Da&N<8M9BCFGW./&^//ce+HL]M=3R+#IB\9[bI>5(R<>-XO3c6Ve<G7/5
O.G03TWQWJ<S3A)bO_fVD@_Z[K^C#Aa><89FA7E)BM.Pa<\eFU?b9<#._DL8]0Pf
d?/4_3W>agJ-9cP/M#Z?CIVAAO0b9dUMW4FeSP&<_]HPOea6),bA7J0TDO;U:CH/
2.4Idg763J>2BEg+T7)b?KHC:C\4-#?]N57U1.S2T+][6Q/)NJH3#;U&g&8GM]E?
NMA<0IM^T\71WN(XYe7)[Rf3FVLC^UX(N&S5\-A>;,?940E0,PeXXZ<-OP^cW/K<
_:aPC]CKgf&O_9?f]P_ZP/cJN+3J_^c/:1+K4ITVC,-ZS[aC1Z0)KD-SW=2TX:,K
I>J/#(C2<EO6WHU,.?aH<VK2b)GGY5Ne>J3C>)FL7F]d6<T=QR@1F>BG&>bDR-(G
,U+;NL&Y7F@HZKX94Z7cKX6M)BR&V<-._M/FHB_D]dNJ/6-U>4ZO<+-A7E>GR8YF
LJT#ga]U_5dP[b:Z]7F^c/XbC?S,b3c5D6\aQE^X\64&&L6#8Rd0(Q83JB@;&.@F
a5UG+)Ib3)0F_]8Q_./Ed-WSP&</#VQ?Y]b3^MJ76^Bc/UF.(Y8^G^S0<g50_O18
OIG+5:W([/8_RQ9-B(ZaPVFK(NeA2:]3bPMT6G+0gD^.[bEe4V)O_U4YUa2HF4KG
XNcV3Ef3gg-4P-09RBT/5\V6T3a;I6d@WP\X:EM:+SSQQQ&>WCO[FOaC^[Y?53X-
59:M&g;TTXN&PS-=;[Q8V<))KNK63?)7cTe5-\HNfHf:##b-<cBT[bJT<HM#7K4I
.dGHg)A(2Z<)QQ^S8Q?OR>F7Ndg6eEY)gW7Z-#4gW2^Y&N[BA12Jg]0GJ.I:XUZH
V[=4d]LLV+,aA7A]/SZ(]U(4b=.KBfTeI/>;b/LE75\CF/-LDbX@BAcfgAICVWZ.
;H,K8cD6dT8g+C^7+,/H4<..F)O)C;aE[T&Y-J62]SOIM0,R-3d;Z+F&52gO-Y\\
7X\V\.ON@<VMR2;,YLY7I7)/6#RUKFH/^1QT@\71[CMBB1]_[e(B5@&QS1LW[D&U
#^.(AJNc:b5F=IQ@9/8+/9bZ&RCZFCYF_A&O/6N1L+5LBAEAL72Q5e<cP4G^J(L=
PNZ::_bC4/TZD]\I,.03]+]-O3OPXP&b,A#MX[3)RfV-.#]6@f\29\@9,NN-JDdU
eg>/6HCg7&\V8?8>#+D;9=dfJ+RKg^11\,eB:Z[YI)9Se#;@\MI&96HF0e&#K^BX
d/L\6^bR1.[&2+]RM3>XBd17\>UMEY)KCE5;QBg\^)QD4RQ4fYV5KM6Bg;J/S192
OX=9?HY&V]_-\I_S:B@K-Y;9,c4:13;ZVQH:NbJ\]N[^^(1HUX[\66:5RA?b:FQ,
:QRK<]IZ^BfJdB_N?O233@H:HSSHcBgHNUeS44W:R+GU1HVP7gIY7ZK]e2-H8,[S
=2g&@F]#USb;,TD12K?W?Y73:U7L@K.K]RZ/0daNf;82CK_;S;eT@;H;<JeD&(ET
@Q.WJ3]g5@2@&bC]63LZ]:TFS6a?3DTFG-HZca5b0JcEbDC-;/?]?MYYP-ID[](1
We(Xb>Z[B;8NWM:G+ZOK(D,UW6M@DV[D_5R(B8<f?g3QE)T7:g&25fe3-\Q?)C8d
_Q7R_71,U#CKR\6>^Dg-7@Tgb944eG/OG8/GO+VWe;8LH6aH>T4T7@Ub@?BK]-We
Q/5Q;a:f\:_eE)H/(4-cWbKSc7.?=-0W]1/>Gcb3.2A&R6XHX[;ZBDPPX=ZU(5Mb
,U?\@B-2K=_Da>HRRaZ)11Rg2+241P:FaU\#M,WLBZQ<e=F2NRX01><6Z=e0^769
;KHT9>JJK3[+1))#^?=e)=G;83Y0=_.DW2YIK,(B4BKM?3UQDc5)#1E/?RS>5:S?
:HNDgR/-,UVK?LJcc(2[c6VLRM_Z:]LKdSMdM:?MQ)^0OS\)G>D.<)g#62,BC#^&
LeY7PN<JT2&Ag-NZgTJX-)bfQ7Q[RT?K]G@DVF-O#E]ZUQ<&>JPbKU58?bBbA.c-
9e=b1-4+A)JDW_d;C>K#[7@K9^:N,)G=D(dE/]5>;a+EV[H=BB1D:[#<6S9W9f@]
UC9^(-Z1WQe)[45E:I+ZB#1+CJ@G<B-BS,K1;<47R>(P1AKaAETV]O+LGX?Rf-@N
Z8U/J/@H26H^VbWd3Ub03^11eY^9))Z@+Kc21XaS,4L?YZS\XO:@_ZLAgT2IINS:
[<;A,:W;04,IH8&@EJ68.E_F_V>>3S=:,]Re>L)Q=Z,f2)=K(&.&_UZ]77B3B))@
KO_L^<>3_b;ZMCA#-FINYXca2KDZ7^L<IQ#:KGJf0I8,IG^1B8)IONZWL+3W.::K
D?9.(XePMBZYC^(M@&eW>6TVCSZ/fADYf6:C4FY^,?c>d.C7I4f8BU,[ZVGL9TD3
B&)d3TZ-CK)cV2RD-c/c]15R:#cBY/5TP-5AW4[/(,Q,(gFf)=]2R1_Q#^SIY4)3
^>(8DU4Y0J(&c4f+P&)D4RJeUEM^U\E2#bGbg69A&8.KK:<?O]\M&TKJ\N2;dP+N
SCO7;LGFdHc.<4FZX]9AdKF>O4:(2T/P;93:WE,a91N,;Za?RWeLPg9BPfEN(@78
TQQJU-C>G0I2gVWcBA3AD[Z1Zg@8+;/IC,dd#Q67N,[V[,+&\JP5HZ.HN.WVbQ5C
cXfc\WTSV_P([L>;1X&0Oc-cD)3:fC&_^=fLAe/?3_aT+#.R4;.CH3.22^Q[JebK
U6.BSg>fQ0W]+8,c@0PAG)=)#D#dLUX->W/<]=9e-]NPA3J)YKW]A9GK_&BH,5c.
QP:N\&c8fUMDgeaR:\<@FV>[1J.gLEJ3]B#/<,#+JF3=;bJQ&@7(aTa)ZFA#Z?SL
L6dGQ?5IZ>GBCDbX+gBK^D5;O4R2O2S(3JG@_Tf#RFRCY0)g#F/JY:Z-TETe^&@V
&#<6gZ/CDdQD2A;^#Q]NL90e>68/YMLFP^dL>_VS/1RZF]9DG>OWJR/NRF.B#D:A
@18E/;9a9CH@KH=G@Nc#W=0:/;1)b:WNLBd?74Y5ddEJR=SBB8.gU-)PO32-X/.f
5Q#)A_JG[@+&dWZOEWCQd@99V:,6MUNeZ4dcRBN_4M2[IY?/+YbF&)NP^HOE&>69
f)2&+a)_fY\8.+O#b1XJ1_F>W-YRd6QSH92<??b6B31?Z:0[EZPce)eaE9.H=&Ff
L4J<Xe59K)V[TBOY?=FF9-Y(?D13O)YB10\/E?5BR9@;N>dZC945B7=C9^(Y<(K#
X3(BF+2;TY1GT5cC15N5/\(d54.7\8\J>EJ5,6UC-]M7QQBGY5Y4T55T1(W3#(fJ
86K@[AX?g7/.RN?3WF@fGc\SW889]@Y9?02?,B>_8]#ZR&_f;&I_PNP3.GMPJGBB
R1@\^IV.6WaZ)5f>2,DJV-E>_VWH_268d>4OcQ(F;LV526Tb^O3.<>81S.0E(g?\
SE_^T40]g1H&M&R9ENBZg9)+11GJLCSge]F5@N]X+e_^7&3GF\cfRL(<&7+cTLJM
b29,;)K;C?U#6A^5=DDI(PK,P]DI4PVR)L6I5TG3I;bVN,R)dC#GRcJA)+g\L/U.
@:.IJ;TXV]5aEZbgW6G3,>g7Y6RR-/?SJ/ELC7c,N0_+ODSGaf&V1+ORMgXB482Z
IIXHbV.,L>>R3)6aJ\[aHI]7,&D0>#L)<R=_LF4+YRANFK>ANb58BQJ2<BR>K0,G
D1<Pde@EN\X+.Q=-_bX9VH[BH.ETMN)V_f>A-:?4PM2>a+K@)\;LRJX4bX.?6a,K
K>72fQgMbaQ=7].LReH08^JF0<+>,-aCfJ2->P_^P(eb#5bJ@T&_)Qa;^3L/Kf=T
_B&O6G?FPU_#4A;Q^8XTO>a;=^e1E3?-+S6@7_Ec0VBOKL-B6;f-aHQYJ.)7\]>?
KG5X3OT)U(J#WS1W)ge&NS_ZCN&/gI(5]051LRe:g.GYFT2_IJ3JQH#&5W[=K20(
d49SVe+YB;YfU\EP6a<QfRRW=[CO^PNeZ4Q#1bH7WUZ_^TCCdE&I?N#BB\J1bRX[
,BI2ER^;HE2P5Q6&.,Je2LO/07-04)EbG0N\LQQUYSPS[S:+S6AM8=UgVg6aV1JP
?UO7&Y#NF0-0QDebRA+4MX#S.?O:aJ8C_#PF87E_F(bE1\,UMDSDbQdJ,,&e@<;=
2]8()V_0RM@]f\6MTc2__\#/3-MHCeQK^:gSF?NW46BUBVV:@\dIGQa>0E_CV05G
G400c^7Fc0ADZGP@?Y@?6LOP(H6>@-GY31TF)@,&\)1A351\aXO^--3=-,Mb@)=c
2U;:D>T^K;B><PA&BY>3JM;;JN;CUV?7SWW60]0.0-MMDPFOdeFg_7e\H_0<D=WC
V^&>/>L]-?;,&P(B-OFTHd.VEX:(Cf_].F>fF&N-EgCK8T_5RZNHaS<JfDcIP?OZ
6@SK-_H^Q9Y7ZC&Ac5f>2TcE>2Q0P3UBNB4Z)aEg75XB:=YeN/3;B)T]9SS<4D<L
bc87f=f?eX.B(RWVWY5D&U\d/>8GG\=)X;MbBV+^/EHC,gb9_=2SHU3:&]dgOX:N
W.1]#-Y#:_O-Y\=LQ)9UgE^e04,W+[e0=DOGR_U/-JY_X=.EKe[Ta#deF+CU@NPX
G)D9;)?=,Z;R^+J5FGIU[ebHaTJR^a2\06B.D@YQRFa-XE=+C^LRe46#>1RBeXW+
5fMaddKd/]dbV[(LF9CKO??=)\L?T/(bBEL(D@]gSKgC/CA^E3BN^Mb56D4gV^9>
I&PH/H5g9EU3e4ABTN0=VPf0ZH)@HWB)540^+NY>e;C>-0H;b]>W)#]X:(e3]6@4
_TRgMHD=NY?J1B\-J9Xaa0-YN;HH@>T5RYW^A-f0e1LVU,SeH@.M(ef?^c4dN,Z)
(L<JHH?_2&Daa\PZTA2gGIZ5]caSG2CV6(SPc#U?Ea4(4_;]_,E1<<B5[KPaIcS^
DX<XHD2L?D<@#GHKG@--F@/XHH0C=+R?AO-OGc0(Pge=/[&W\53g,//3cFCB@NEX
A,[1FOA.Y)9H-FZM=Tc1:6NN3U1W2KV+8H4XO+YH)OA7dS[,;c1Y[/TD)RG2,9@(
Hc3;JP9-dV[g+[WL?.IJ7@^;LT^I\\J?T4TLcdA)LJZ-:-KRbQ\gQWV0K9.<2<C/
aHaLOG?)-D=E71?b2(RE6Q8?MXUW]\YSg_<Yc9J[#63RJ:_X[RDe;VG4IUKJ_Q=3
eW<?F]Q66NT5U6UEU9GEV7I3&V+fVLAJfKUY:MDOR:Z9\f?6Tf6QALceQ9+)WOS.
^RR_R9WHa=T:40J0I=>a0/NJ&deE59T80V#OC9DZf@RcNZ/d>=A+4Ycf0NAYQ-ZF
9+f/Y1&V#RCCG_^:0LVEA#?->,J7290;?W=Q9WA?B^>3-8&N(K@@R-,JE)7G5(XE
:Q)H479JJ]BEK4dg15UBfAbJK2V.W[778Q6(YAI>W5>C/c@S.D?U-.?IUc&cMM6a
\GCE?QeE#XZE8.8#01L\RZ,]cTa>APQKN:T>/PCERG+QZW6--MWY&2X3QfHQNfVZ
MZ)4+1NN\,3^XQ5f\P)=7C7;=2=K9;EXT@M_RB4IMDJFF>P)YVOJ?3fCL6HfBNA^
_;&4V?BTWa></?-9MRf-#&ZOaC9Ra\-#(.F_Ja<?WN.8NX/b:F/R5J[WSeUD\K44
]HX#M0O0&?5/-,+c5RN#Yg.)LBP)Z7CL_]NUQf6-aX5^GUDQLT52\Z1P+)>IIH>?
]ZGY/[_>b&;MR&Y(JA77VB5)#;@6[d@f/8#6<>Uc+N4F<ZT+EA-QSc5Z(WBNSNbf
HLOT14W#0A]9Y9N=N;J&?RKa1@DO+9PJ>FD(7IP<F)S(;E7:K5cPff3<H:H#EHX3
9U-T(SfdQ9<462]=2:IUc()4D&LF>;)@gdMgI+?6>,MWfR#IAc^DQZ:2YAc>OfOR
MaPQfN6,1\ARFENfJ3Yf5gKXIG8W^Oa0;Mb&L7;6A8Z1EOf@B.&.SB30#-X:P[X(
U?RWXg]CVSe?_;0UeS1OE--QF=XKG]LF9-C^d>7/O3DRI.60U#bW+_F1.^CHUb09
Q-eSJb@75gf(c/PRPB2(O,1fa5S.VM3^L2/^RM4NM>I6U&JD3L/#@b+4==AZ6QZ:
7L+H.KASX6ZY<cB-?U5Y4M(TYLL7fA?0=VeUC,7]dB[6JE-g_:eTQJ^^\bM=AP]F
>C8UE[+K(2VOEE_1U8HU4^(C(AW?8IU3ebV^Nc_=+B4F<Bb5VOKJdP_\?(P>e74b
,7CeA1CXH6OY3b(RT5/KIN:K&X]eW4&)DO40=3=ZK&>TaSB]AcG6_BOO5VH;/(>a
KW[/>++CWaEDLNUWAU3/d,GJ5>@K\SWVObbeUWbGAL2FM<WL-V)e<:<+Y6^Y@f93
9gW>IA2;;A\JLN,#JR#<ZS+\a.]GeK3SfMLEM)ZM8ATd4.OH^:.Gf1B):)ge)[D\
KFd-GfXU:bBHa2_L&AX[[fCK\HVP+J<#H@:f7WK,<Z.O&[1gQe#f0\e^B#&^(2T9
X]Qad:.3A^=FG<G&U[J3Zgf0\I2XH[<.TCbc)[<OYVO7f7B-EU.feXPWB7a;_?Xb
K@GPIA:e59G_2=^L,ST/8^=4EG]R#4\FX&&LREc\<e6MZdZZ&LeWGTS?V,38V3FG
Ee5)[fO6GN)DF1bfJ+VL&[g#J(OX/f+:W<VOV2Z0-VN_-bP)Y+IKCHOM4X/6\DMc
A1M5F@5?(->W-)1<&[-(THAe7LSeYWOONZLRABP&DI<Y.ZG6f\-UJKJUM@A6A[>O
F1V6T15CW)Lf7cG#>X@7RBPOgZHH0(KeKdXga<):_4Nd_TVUI1_JJ\2Ff)JE=,W2
C-V6OKR)<HAKE<9RR.J+Pf0>.aX#Y=5^@6(G9_OYUg:<^N[3#C+G-AT3H>-^_[9N
X(2RVUUbL[1e5=KU_6:D?._VF7QK+25YaCOgXC[6PK+a3c+AQ&&LF^D#.)gG?fDX
HDN8V43)e\E=&TK,bY)9IeS]WEN)H(K8)2K>K1L\dH+F6KaB&2&W>#K1OT_6(Q.7
^[A^)F@GZ0UAZ_J[#2ba,]cN8RC;b#U_(VJ.M?@D_BU5ZfOI9P6C?J7VMVI4a_NL
==#.Cc90,e4D?Cb)Q2L&eM13B#)FN+OGK<AcgYRZC[9RQX#0;Pb6GE=?)5NK5&dF
81(:,HSZHaR4-D+;_]4F#dQD(16a[F1R:<7<Q-6KaS5Z.8J31-?\I4dbA&/368dI
b,6SbOLH9H6-:PRY_4^0SG3W[=\JZOU_EBA3P?#C#<Fe^Z1117(1PBJZ?\b)9KLH
M-d6g>9bXYD>U;Fc,]Db)0@]09e[363W1L.YV,4E6<&B&d;c=R4D:(Ie,VfDgW8)
F@C&HVDL,U0Ke?X8?,/-#80IJWKTffP7Z<Lbga[8C/WLJD5e+6&ag.IFJ1N>fM5d
@UGSEMV+[e[8f8LSTYb6MXOKIX4P:AR;6>,G_fd4F03]K>RZYWUK3QA1bET,Ib-A
?/)-.#<M?<5\<T=:dA^bD7\Og8@VfC+DPU=:H:NNg#O-I\-@:D?W5HW,1TL+.Qg&
WQ8_6(H@c\MI_^\?SHX2Rg[O3gR7X<@.Lc>b[=-JB;[T/IR,eLJ?b:M/[b6cGQC9
aRaQ0C-D)?(VM;9J6a-c4Y-cf#@R1I8g<8d1;2:XL[1H_;d9&/]PDe^A>SB]3FO)
deQ9.=+)><&7A9<G/RfCJ]a8XIC^(gW8+aKXe98eBO)IM@G5TAOU92B1?SGg:5b#
4d+<8.&2#OMW;DLfY0;]XN)FEOH+K<KLQJ(=9?Re_0IRV:JC[Zb&OOI99;P9POZ9
XLg8:<G-5<a>L(1f_Be=4N?>c]F<7,8)fMU]Yb>.\OT&>fWST/#g_NQBe&J8PPcc
0XL-116V].X?)6[_^I=;_MY\bAU91\LRU2H<)QV(X@8dQK;O=\g0K[^3&DZKI]1C
)>>CDcD&M.C9cH1H)A1=0e,7/^182^Od=bafaL=Xb5gIY\&JP00ZP[H,]@;(4KQe
Q22eGaJ;[#f?V1I<LIJ^5S6:<gbV9d9E?_VV,RDB>KRE)[)8ea5O29ESGa3;b6L.
O@G+CJ\5SP8&O)g+=ZL<46D0)Q.PF@T#<3;25B(E(0S4//G4gCQNR+.0L95HNbgZ
K>6?QUDK;WPc#NHI.Y4BCB2@:F9UJZ6=@9^[U?B/;J0LfF:0/3A10_J?&5P./:4f
1:^]>O-Y:V8-CJJ^G:O[BAg^]--0U9aN5_03,P0:>GP6A,>O.QNAQ_\>KNLW<Y+^
?2-LS57Q8X7>;;06+e&^Q<I?CB5M],J]]1#Aa;&Z3T[B=55d;:(:E#,f&6TedWSN
IM-[g@XCK-g6bWR=9Q&9=7ZH56@O)7&_W7XQPGQc@(O34d7]E6-1-8.)eEOeU^3c
,9.GIa#E</TUPGX]dK-;:MAATCcUQ^6_)\49Y4C+5@O5\4SGd<]JEZY_bcd+\80.
:E.P6=:HKNDTS\A5H3#G^HBTY<=_cf9PI_c\_76bBR2@/Bg22S<+/3L_:;Q13W[^
ST,>V#L6<NO?-17IR9eSVMgXQD;/L<>(1d/7HN?F::f&F<A]UI80)QDTf(M3KTS8
e&&1XU7?AC@Z@]#^fdF-FaZ<15A>VD<=8d#L=#/QVbQg0f+\BB4=\=0AKa.[5(:/
_-;2F;<eE4=7a=5Kc9e@UV@[M<-XOWT2+ATQFb-d;I\Z>VEL?QSJ(9252DJ9N[8/
^,:U[MK9D0&+ggUKIHMI>\;G,dZD^L+-I(+cU-\)FA=PHM-W5]78XMSXV+H/aW9;
B:;2@dZe,LKUAU-7JcT/f8b(<bKDN)gX<);7[?-_2g\^R#17a>\;UM=#H\eI&Z<\
Z,.#;/a98O7CPfRO^2KW)W4Zd\NTf0=f.?2_2V5[Q=>fL2WbSUa&47OR?eJcX7.<
_7ZPF&5]_1\HYJV4(c+P_Ye26,\Q5Y+PYLURUD65/#1dZ-6+#6=3<9^aIJb;gH]<
^)Ogec0I=[S4);H<&]-[V&NN7CQFeD5fe#,5g4J7-^<4DbgGNIF)X[4<N1.<;1\W
?e#IJM@Je1((e:GA2+5L-a<[[\:2-f:V:XaaD#?1ZDB7g>XR1Q+[d5QTe/[E(E;T
eS3aNPb6((+_fZ7IH.9g[6;6DG41?bgb=>&@I)^A)FPg^X,gW>d_X]#a?dFJXK])
X-##_HFg=AR#+Z56B&_Z\Qa7;Na&5c5=d\eUe3^ZK3Y:6g+2NLPfH1VRZF@NQ21)
Ja>Le7.VCCMCP)3.QPd>ZF94BW<2?8VE73Z==,8^:U+(K&F.BfJ-54P?.:fZdP+T
DS\#LZR1J-J-/cU\H:^Y]9)NDS\(,<TCACUG<aR(,Y/0&0^fL-1BL.,D+1-5@L/E
RB02@/I,A=E;dF=9.^KGQ#1b9HC]JN/:_KGT^]fT,)OPE\T_Q-5EPT5CZ[K<0GPV
=Ie]bXGEVQ2I>G:J.[9:^\B.Hb#C@2+?=S1cI.=T[P1XA_;NZ5(K&e:4<#6#_338
^3TG>KEeJH6WLe=Fg@7VRY0FH]ARX,D.Y[(9(S[6/]/CZJ#8P-IaF3BLa1\/FS\[
@/EgYf=,10NN0M4SK2^NFGI?MWYDGNbE75\eeD(Ma?V8FBVQE2P?U:>K_5N6^(#g
B_#<QINZK3gbBQ-O8]X.3.,I(T>UE;B50H5_:>^6e/P.&8.d_94S3E14_9JE5aSb
,H<)7WfB]NaK<G89BZY9M3_F3S\4TYSOJ@,c)4G.)#&X<fW1^)&@AERMY2g2G3ae
<>5Z1F,)<?F;1(2J,ZA>4=bHG8ZLQMeQ@b@=4gPB[:9&+2;OH=JdJ?6V?..>\E/.
.#UD&OF[OQK50Z7g[+8?-ZFHM>gEQMQ8g+:8JVPM\[G-15bg)P/WBB1^ReY28>AL
QB^LJ#@QT)UK=L_B=\)FB??8aKBP:U3Ab&54&Q>1\J7^8JH0@88K^a(;:2A#[G;7
cJg;IX(BKCd]9>._>#(B;6T#43.>ED=gDUNIRE,WL4]V6+?Y&]P1gW#dD]>/&GgM
WCE](=:aM:?g9)I4dC\V@EE)gH5-@2QV0]U0>@=Q8F6P;=AL?ACNQDW-K.>2\MS<
VGZdbM.755;S,5)4=F+^J,3@+X]/QQd>:PXd.bESEe#?;7S-0&/+]C=\Z<T)YEN\
Sb&4+6AL=BYK_);8\f@VZ0e+ADdE(,E(^TaTBQD-S>TSc+Gf3NU=)>(#8cPfYd#>
+YTXZ+&2F<.+ZU:/MGYdZ596B;MO:A?<,T-,AZ..T7VbNa::?g@S0<I]_6XCf[Ag
#9J480L]ML5+D.#c0MMf2+ad\@@,1J)7N.>KT=.@[SSYe;#@3T&HBJ,:QUTF.J=J
MKA64=#7^0+5X\)E#)AdJE39P&XMF1dfXaa]fYF,>&-_2Eg9O[./\_FG,)@3N.c8
WS5,IP[HV_^LD,8VGN^(66\1dLg,g54RfBBD4ZcI#4251H/2M<6a^ZMFeQ=T1Qa-
=6a[W7G7Z1[2-[UN4<#,N?&,Bf?A]He3HEXaW@PaASOOe713G@#6<#Xg&(Kb[JRU
#C74EO,HW>&F,-,T2,4O3&#?TW8[.N8K/G=Y:AR2<3cXJ\/GS^>Me0P,Y,ON^PP^
5(YAE3Gd3cA,c2ZA<[N=(MPR9C>/+=R<;64D@^5fRTYUO._AZLM[Y4(4+A6:?H>?
9K?bN;LF?712C&K6S?JHI_TdGEB_2?FENEe@COT_//.:S<H#5L[0JE4<-_5S=[&M
35Z:^/3cCBPIW#e.M<EQ]dXPeR@__1R#,9?X1?]H</.]USZ;?R_3-)<E0g<IJQBb
EG-JDUIKd/VM32H7>2aDNL1cE)bM?K3-7_QZ#+W(a965CfGa;>U^A,J^#(+]dIZ3
@H(:AIY=V^/?ISD^Lab.A9ScRJ:6+4S(#]J:ETI-OQ9^^\7F@/BMH4eXGYY<PTAQ
1Oc-\L9MD4_7DR51P)^>PX@f8R^K5EXe)#E_2B@>,(FK1&8>P+A6X\\Hg(1CP1GH
.4Q9S&TB9_]U=BeUD;363JCO_bHA&A<DK0XWO[-)(9#86)7L#E:5XAg-e8e@N<73
K>XbdYZ_d2#3+Y;;36gd;7,_@?OXUFR+F]=A)&UVVEQb-63E;O9]#?Q?gMaO;O+F
BA2PLFP:#P)Ne6P#Q5AVSc=EQ8(XZ@BQ6X,5a;aOO>:?@BeSCcXG?LT4Jd<3+[.8
,KS^Y/&-QAT+9EY-RZFa_IL9A]<CJSfg]>6O2G/CcMLMd#_6)^eBX:^+[T68e>X=
7B@5RE&[+1Bf)A_NI_@Ae^WXfGH#;\)02FDNVUJAQXb/)_ee^GaK+=^g2[a2O7;.
4Mgc\&P3e8(e=?\:@BX3T+B-McG4-H5=CCD(TSIYU_Y_fG+1\cZ_:?3:/2G#1Bd(
S(Ad.;??>EU^1])>D\RX[5.3JH0(2aPC(/B\\>,KC2TJ^:JW:]QYSGTGY<fS_H(J
[)26)Mg80bUIcVcK07g,Y3U^FWPM03M=&d]6S351PY8O7MD[cc^X/cfDXOT=>#>T
=TaHO\3GUPXGac^.\NT)Qe<)We(dTD^MGdNb.3a&DI>Z=Ud(LOBQCdHTBcMX+2C4
))d:AQfKeR-D95d#dK>2.HW[f\N4^(4BZX+MdMKR#)[egR_=-N9cZ;2[IT@E+Q^Y
g#H)2KbK.d2Wg^[SdIY/BYfQSY_BDFGD=8.70?.7W9V[J:AO\d?@\/aRe3DS&b>J
SB59+[OLcKZ/P3Da&cE=D[CE(Lf]g,BfX5TE+A7N&FDKKH/>#GWTJ6+GV1>HO1;-
>6Y9H\O#<,-\+47C7Sc[_:bU\(Nc?=c9B[?,_H.C\gIR1,>dQ^9&Wab3;I0X#@L3
^B/QPXR8,7<ge^RG7NV__2aJKYU0;U_7ULF]#^Pg;3.dY#\1XX4:SY397>\Y?L+Q
EBP&?LWCfJdPNA7a1eXXe)PgKJ8BT_)2764MXAQ>,g#RC@g[KM./,4\V@,;2G9+X
_9I49JL^-8QQ\OM[9XfXRg/aYgedOgOO#8,IdKRSd=OYRO1)cWef\N\VL$
`endprotected


///////////
// NOTE: After encountering encryption problems with this on some simulator versions, leaving this unencrypted
///////////

`ifndef SVT_SVC_MESSAGE_MANAGER_USE_SVT_MESSAGING_EXCLUSIVELY
//------------------------------------------------------------------------------
function void svt_svc_message_manager::msglog(int client_verbosity, string message, int message_id = -1);
`ifdef VIP_INTERNAL_BUILD
`ifndef SVT_SVC_MESSAGE_MANAGER_USE_SVC_MESSAGING_EXCLUSIVELY
    // If not relying on SVC messaging, should never have to reroute messages to $msglog
`ifdef VCS
    $stack;
`endif
    `svt_warning("msglog", $sformatf("Message manager '%0s' rerouting message '%0s' to $msglog.", this.get_name(), message));
`endif
`endif
  if (message_id == -1) begin
`ifndef SVT_SVC_MESSAGE_MANAGER_UNIT_TESTING
    $msglog(client_verbosity, message);
`endif
  end else begin
    // Need to type the message_id based on the simulator we are working in.
    // Styled after the original SVC message IDs, which are module parameters.
`ifdef VCS
    bit [31:0] sim_message_id = message_id;
`elsif QUESTA
    reg [31:0] sim_message_id = message_id;
`elsif INCA
    logic [31:0] sim_message_id = message_id;
`endif
`ifndef SVT_SVC_MESSAGE_MANAGER_UNIT_TESTING
    $msglog(client_verbosity, sim_message_id, message);
`endif
  end
endfunction
`endif

`endif // GUARD_SVT_SVC_MESSAGE_MANAGER_SV
